import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/support_ticket_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreateTicketViewModel extends BaseViewModel with NavigationMixin {
  final _ticketService = locator<SupportTicketService>();
  final _dialogService = locator<DialogService>();
  final _picker = ImagePicker();

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();

  final List<String> categories = [
    'General',
    'Order Issue',
    'Payment Query',
    'Product Information',
    'Return/Refund',
    'Delivery',
    'Technical Support',
  ];

  String _selectedCategory = 'General';
  String get selectedCategory => _selectedCategory;

  final List<XFile> _selectedPhotos = [];
  List<XFile> get selectedPhotos => _selectedPhotos;

  void selectCategory(String? val) {
    if (val != null) {
      _selectedCategory = val;
      rebuildUi();
    }
  }

  Future<void> pickPhotos() async {
    try {
      final List<XFile> picked = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (picked.isNotEmpty) {
        // Allow up to 5 photos
        final remaining = 5 - _selectedPhotos.length;
        if (remaining > 0) {
          _selectedPhotos.addAll(picked.take(remaining));
          rebuildUi();
        }
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  Future<void> capturePhoto() async {
    try {
      if (_selectedPhotos.length >= 5) return;
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null) {
        _selectedPhotos.add(photo);
        rebuildUi();
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _selectedPhotos.length) {
      _selectedPhotos.removeAt(index);
      rebuildUi();
    }
  }

  Future<void> submitTicket(BuildContext context) async {
    final subject = subjectController.text.trim();
    final description = descriptionController.text.trim();

    if (subject.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a subject for the ticket')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your issue or inquiry')),
      );
      return;
    }

    setBusy(true);
    try {
      final created = await _ticketService.createTicket(
        subject: subject,
        category: _selectedCategory,
        description: description,
        photos: _selectedPhotos,
      );

      setBusy(false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket #${created.ticketNumber} created successfully!'),
            backgroundColor: const Color(0xFF00B156),
          ),
        );
      }

      // Open ticket chat view
      navigationService.replaceWith(
        Routes.ticketChatView,
        arguments: TicketChatViewArguments(ticket: created),
      );
    } catch (e) {
      setBusy(false);
      await _dialogService.showDialog(
        title: 'Submission Failed',
        description: 'Unable to submit support ticket: $e',
      );
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
