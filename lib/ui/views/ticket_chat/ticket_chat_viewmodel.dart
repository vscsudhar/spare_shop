import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/socket_service.dart';
import 'package:spare_shop/core/services/support_ticket_service.dart';
import 'package:spare_shop/ui/common/support_ticket_models.dart';
import 'package:stacked/stacked.dart';

class TicketChatViewModel extends BaseViewModel with NavigationMixin {
  final _ticketService = locator<SupportTicketService>();
  final _socketService = locator<SocketService>();
  final _picker = ImagePicker();

  SupportTicketModel _ticket;
  SupportTicketModel get ticket => _ticket;

  TicketChatViewModel({required SupportTicketModel initialTicket})
      : _ticket = initialTicket;

  List<TicketMessageModel> _messages = [];
  List<TicketMessageModel> get messages => _messages;

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final List<XFile> _selectedPhotos = [];
  List<XFile> get selectedPhotos => _selectedPhotos;

  bool _isSending = false;
  bool get isSending => _isSending;

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    setBusy(true);
    await loadTicketDetails();
    _setupSocket();
    setBusy(false);
  }

  Future<void> loadTicketDetails() async {
    try {
      final details = await _ticketService.getTicketDetails(_ticket.id);
      if (details['ticket'] is SupportTicketModel) {
        _ticket = details['ticket'] as SupportTicketModel;
      }
      if (details['messages'] is List<TicketMessageModel>) {
        _messages = details['messages'] as List<TicketMessageModel>;
      }
      _scrollToBottom();
    } catch (e) {
      debugPrint('Error loading ticket details: $e');
    }
  }

  void _setupSocket() {
    try {
      _socketService.connect();
      _socketService.joinRoom('support-ticket:${_ticket.id}');
      _socketService.off('support_ticket:message');
      _socketService.off('support_ticket:status_changed');

      _socketService.on('support_ticket:message', (data) {
        if (data != null) {
          try {
            final map = Map<String, dynamic>.from(data as Map);
            final newMsg = TicketMessageModel.fromJson(map);
            final existingIndex = _messages.indexWhere(
                (m) => m.id == newMsg.id || (m.id.startsWith('temp_') && m.message == newMsg.message));
            if (existingIndex != -1) {
              _messages[existingIndex] = newMsg;
            } else {
              _messages.add(newMsg);
            }
            rebuildUi();
            _scrollToBottom();
          } catch (e) {
            debugPrint('Error handling socket support_ticket:message: $e');
          }
        }
      });

      _socketService.on('support_ticket:status_changed', (data) {
        if (data != null) {
          try {
            final map = Map<String, dynamic>.from(data as Map);
            if (map['status'] != null) {
              _ticket = _ticket.copyWith(
                status: TicketStatus.fromString(map['status'].toString()),
              );
              rebuildUi();
            }
          } catch (_) {}
        }
      });
    } catch (_) {}
  }

  Future<void> pickPhoto() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (photo != null) {
        _selectedPhotos.add(photo);
        rebuildUi();
      }
    } catch (e) {
      debugPrint('Error picking chat photo: $e');
    }
  }

  Future<void> capturePhoto() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null) {
        _selectedPhotos.add(photo);
        rebuildUi();
      }
    } catch (e) {
      debugPrint('Error capturing chat photo: $e');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _selectedPhotos.length) {
      _selectedPhotos.removeAt(index);
      rebuildUi();
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty && _selectedPhotos.isEmpty) return;

    final photosToSend = List<XFile>.from(_selectedPhotos);
    final messageText = text.isNotEmpty ? text : 'Attached photo(s)';

    messageController.clear();
    _selectedPhotos.clear();

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = TicketMessageModel(
      id: tempId,
      ticketId: _ticket.id,
      senderId: _ticket.customerId,
      senderName: _ticket.customerName,
      senderRole: 'customer',
      message: messageText,
      attachments: [],
      createdAt: DateTime.now(),
    );

    _messages.add(tempMsg);
    _isSending = true;
    rebuildUi();
    _scrollToBottom();

    try {
      final msg = await _ticketService.sendMessage(
        _ticket.id,
        messageText,
        photos: photosToSend,
      );

      final index = _messages.indexWhere((m) => m.id == tempId || m.id == msg.id);
      if (index != -1) {
        _messages[index] = msg;
      } else if (!_messages.any((m) => m.id == msg.id)) {
        _messages.add(msg);
      }
      _scrollToBottom();
    } catch (e) {
      debugPrint('Error sending message: $e');
      _messages.removeWhere((m) => m.id == tempId);
      messageController.text = text;
      _selectedPhotos.addAll(photosToSend);
    } finally {
      _isSending = false;
      rebuildUi();
    }
  }

  Future<void> markAsResolved() async {
    setBusy(true);
    try {
      final updated = await _ticketService.updateStatus(_ticket.id, 'resolved');
      _ticket = updated;
    } catch (_) {}
    setBusy(false);
  }

  Future<void> reopenTicket() async {
    setBusy(true);
    try {
      final updated = await _ticketService.updateStatus(_ticket.id, 'open');
      _ticket = updated;
    } catch (_) {}
    setBusy(false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    try {
      _socketService.leaveRoom('support-ticket:${_ticket.id}');
    } catch (_) {}
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
