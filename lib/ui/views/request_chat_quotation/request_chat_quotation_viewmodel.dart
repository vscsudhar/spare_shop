import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/core/services/socket_service.dart';
import 'package:spare_shop/core/services/voltspare_models_extensions.dart';
import 'package:spare_shop/core/services/upload_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class RequestChatQuotationViewModel extends BaseViewModel with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();
  final _socketService = locator<SocketService>();
  final _uploadService = locator<UploadService>();
  final TextEditingController messageController = TextEditingController();
  late String _requestId;
  String get requestId => _requestId;

  RareProductRequestModel? _request;
  RareProductRequestModel? get request => _request;

  List<RareChatMessageModel> _messages = [];
  List<RareChatMessageModel> get messages => _messages;

  void init(String id) async {
    _requestId = id;
    setBusy(true);

    try {
      _request = await _rareRequestService.getRequestById(id);
      _messages = await _rareRequestService.getChatMessages(id);
      rebuildUi();
    } catch (e) {
      print('Error loading chat init data: $e');
    } finally {
      setBusy(false);
    }

    // Connect real-time socket listeners
    _socketService.connect();
    _socketService.joinRequestRoom(id);

    // Emit read receipt for existing messages
    _socketService.emit('rare_chat:read', {'requestId': id});

    _socketService.on('rare_chat:message', (data) {
      if (data != null) {
        try {
          final newMsg = RareChatMessageModelExtension.fromJson(
              Map<String, dynamic>.from(data));
          if (!_messages.any((m) => m.id == newMsg.id)) {
            _messages.add(newMsg);

            // Mark as read immediately since chat view is active
            _socketService.emit('rare_chat:read', {'requestId': _requestId});

            rebuildUi();
          }
        } catch (_) {}
      }
    });

    _socketService.on('rare_chat:read', (data) {
      if (data != null) {
        try {
          final map = Map<String, dynamic>.from(data);
          final readerId = map['userId']?.toString();
          if (readerId != null) {
            bool changed = false;
            for (var msg in _messages) {
              if (!msg.readBy.contains(readerId)) {
                msg.readBy.add(readerId);
                changed = true;
              }
            }
            if (changed) rebuildUi();
          }
        } catch (_) {}
      }
    });

    _socketService.on('rare_chat:received', (data) {
      if (data != null) {
        try {
          final map = Map<String, dynamic>.from(data);
          final msgId = map['messageId']?.toString();
          final receiverId = map['userId']?.toString();
          if (msgId != null && receiverId != null) {
            final index = _messages.indexWhere((m) => m.id == msgId);
            if (index != -1) {
              final msg = _messages[index];
              if (!msg.receivedBy.contains(receiverId)) {
                msg.receivedBy.add(receiverId);
                rebuildUi();
              }
            }
          }
        } catch (_) {}
      }
    });

    _socketService.on('rare_request:updated', (data) {
      if (data != null) {
        try {
          _request = RareProductRequestModelExtension.fromJson(
              Map<String, dynamic>.from(data));
          rebuildUi();
        } catch (_) {}
      }
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = RareChatMessageModel(
      id: tempId,
      message: text,
      sender: RareChatSender.customer,
      timestamp: DateTime.now(),
      messageType: RareChatMessageType.text,
      readBy: [],
      receivedBy: [],
    );

    _messages.add(tempMsg);
    rebuildUi();

    messageController.clear();
    try {
      final newMsg =
          await _rareRequestService.sendChatMessage(_requestId, text);

      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        _messages[index] = newMsg;
      } else if (!_messages.any((m) => m.id == newMsg.id)) {
        _messages.add(newMsg);
      }
      rebuildUi();
    } catch (_) {
      _messages.removeWhere((m) => m.id == tempId);
      rebuildUi();
    }
  }

  Future<void> uploadChatImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final tempId = 'temp_upload_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = RareChatMessageModel(
      id: tempId,
      message: 'Uploading image...',
      sender: RareChatSender.customer,
      timestamp: DateTime.now(),
      messageType: RareChatMessageType.text,
      readBy: [],
      receivedBy: [],
    );

    _messages.add(tempMsg);
    rebuildUi();

    try {
      final urls = await _uploadService.uploadImages(_requestId, [file]);
      _messages.removeWhere((m) => m.id == tempId);

      if (urls.isNotEmpty) {
        final newMsg = await _rareRequestService.sendChatMessage(
          _requestId,
          'Sent reference photo',
          images: urls,
        );

        if (!_messages.any((m) => m.id == newMsg.id)) {
          _messages.add(newMsg);
        }
        rebuildUi();
      }
    } catch (e) {
      _messages.removeWhere((m) => m.id == tempId);
      rebuildUi();
      print('Error uploading chat image: $e');
    }
  }

  void approveQuotation() {
    final q = _request?.quotation;
    if (q == null) return;

    // Auto-approve and navigate to success state
    navigationService.navigateTo(
      Routes.quotationApprovedView,
      arguments: QuotationApprovedViewArguments(requestId: _requestId),
    );
  }

  void cancelQuotation() {
    navigationService.navigateTo(
      Routes.requestCancelledView,
      arguments: RequestCancelledViewArguments(requestId: _requestId),
    );
  }

  void goToQuotationDetail() {
    final q = _request?.quotation;
    if (q != null) {
      goToCustomerQuotation(requestId: _requestId, quotationId: q.id);
    }
  }

  bool _showSummaryDetails = false;
  bool get showSummaryDetails => _showSummaryDetails;

  void toggleSummaryDetails() {
    _showSummaryDetails = !_showSummaryDetails;
    notifyListeners();
  }

  @override
  void dispose() {
    _socketService.leaveRequestRoom(_requestId);
    _socketService.off('rare_chat:message');
    _socketService.off('rare_chat:read');
    _socketService.off('rare_chat:received');
    _socketService.off('rare_request:updated');
    messageController.dispose();
    super.dispose();
  }
}
