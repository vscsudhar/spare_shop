import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class RareProductRequestViewModel extends BaseViewModel with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();

  final TextEditingController customerNameController =
      TextEditingController(text: 'Suresh Kumar');
  final TextEditingController phoneController =
      TextEditingController(text: '+91 98765 43210');

  VehicleType _vehicleType = VehicleType.ev;
  VehicleType get vehicleType => _vehicleType;

  final TextEditingController brandController =
      TextEditingController(text: 'Ather');
  final TextEditingController modelController =
      TextEditingController(text: '450X');
  final TextEditingController yearController =
      TextEditingController(text: '2023');

  final TextEditingController partNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  int _quantity = 1;
  int get quantity => _quantity;

  String _urgency = 'Normal';
  String get urgency => _urgency;

  final List<String> _uploadedImages = [];
  List<String> get uploadedImages => _uploadedImages;

  void setVehicleType(VehicleType type) {
    _vehicleType = type;
    notifyListeners();
  }

  void setUrgency(String val) {
    _urgency = val;
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void addSimulatedPhoto() {
    _uploadedImages.add(
        'https://voltspare.com/placeholder_part_${_uploadedImages.length + 1}.jpg');
    notifyListeners();
  }

  void removePhoto(int index) {
    _uploadedImages.removeAt(index);
    notifyListeners();
  }

  bool get canSubmit {
    final hasDesc = descriptionController.text.trim().isNotEmpty;
    final hasImage = _uploadedImages.isNotEmpty;
    return hasDesc || hasImage;
  }

  Future<void> submitRequest([BuildContext? context]) async {
    if (!canSubmit) return;
    if (context != null) {
      final isAuth = await ensureAuthenticated(context,
          featureName: 'Rare Product Requests');
      if (!isAuth) return;
    }

    setBusy(true);
    try {
      final double? budget = double.tryParse(budgetController.text);
      final request = await _rareRequestService.createRequest(
        title: partNameController.text.trim().isEmpty
            ? 'Rare Spare Part'
            : partNameController.text.trim(),
        description: descriptionController.text.trim(),
        quantity: _quantity,
        urgency: _urgency,
        budget: budget,
        brand: brandController.text.trim(),
        modelName: modelController.text.trim(),
        year: yearController.text.trim(),
        vehicleType: _vehicleType == VehicleType.ev ? 'ev' : 'petrol',
      );

      setBusy(false);

      // Pop the request creation screen returning true to indicate success
      navigationService.back(result: true);

      // Navigate to the chat quotation screen
      goToRequestChatQuotation(requestId: request.id);
    } catch (_) {
      setBusy(false);
    }
  }

  @override
  void goBack() {
    clearStackAndShowHome();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    phoneController.dispose();
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    partNameController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
