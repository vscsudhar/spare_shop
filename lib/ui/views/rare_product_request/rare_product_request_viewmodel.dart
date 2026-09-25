import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/core/services/upload_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class RareProductRequestViewModel extends BaseViewModel with NavigationMixin {
  final _rareRequestService = locator<RareRequestService>();
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  final _uploadService = locator<UploadService>();

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  VehicleType _vehicleType = VehicleType.ev;
  VehicleType get vehicleType => _vehicleType;

  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final TextEditingController partNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  int _quantity = 1;
  int get quantity => _quantity;

  String _urgency = 'Normal';
  String get urgency => _urgency;

  final List<XFile> _pickedXFiles = [];
  final List<String> _uploadedImages = [];
  List<String> get uploadedImages => _uploadedImages;

  Future<void> init() async {
    // 1. Fetch live authenticated user name and phone
    try {
      final name = await _tokenService.getUserName();
      final phone = await _tokenService.getUserPhone();

      if (name != null && name.trim().isNotEmpty) {
        customerNameController.text = name.trim();
      }
      if (phone != null && phone.trim().isNotEmpty) {
        phoneController.text = phone.trim();
      }

      final profile = await _authService.getProfile();
      if (profile != null) {
        if (profile['name'] != null &&
            profile['name'].toString().trim().isNotEmpty) {
          customerNameController.text = profile['name'].toString().trim();
        }
        if (profile['phone'] != null &&
            profile['phone'].toString().trim().isNotEmpty) {
          phoneController.text = profile['phone'].toString().trim();
        }
      }
    } catch (_) {}

    // 2. Pre-fill vehicle details from active/selected vehicle if available
    final veh = currentSelectedVehicle;
    if (veh != null) {
      brandController.text = veh.brand;
      modelController.text = veh.name;
      yearController.text = veh.year;
      _vehicleType = veh.type;
    } else {
      brandController.text = 'Ather';
      modelController.text = '450X';
      yearController.text = '2023';
      _vehicleType = VehicleType.ev;
    }

    notifyListeners();
  }

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

  Future<void> pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        _pickedXFiles.add(picked);
        _uploadedImages.add(picked.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
  }

  Future<void> pickFromCamera() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) {
        _pickedXFiles.add(picked);
        _uploadedImages.add(picked.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error capturing photo from camera: $e');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _uploadedImages.length) {
      _uploadedImages.removeAt(index);
      if (index < _pickedXFiles.length) {
        _pickedXFiles.removeAt(index);
      }
      notifyListeners();
    }
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
      String finalCustomerName = customerNameController.text.trim();
      String finalPhone = phoneController.text.trim();

      if (finalCustomerName.isEmpty) {
        finalCustomerName = (await _tokenService.getUserName()) ?? '';
      }
      if (finalPhone.isEmpty) {
        finalPhone = (await _tokenService.getUserPhone()) ?? '';
      }

      final request = await _rareRequestService.createRequest(
        title: partNameController.text.trim().isEmpty
            ? 'Rare Spare Part'
            : partNameController.text.trim(),
        description: descriptionController.text.trim(),
        quantity: _quantity,
        urgency: _urgency,
        brand: brandController.text.trim(),
        modelName: modelController.text.trim(),
        year: yearController.text.trim(),
        vehicleType: _vehicleType == VehicleType.ev ? 'ev' : 'petrol',
        customerName: finalCustomerName,
        phone: finalPhone,
      );

      // Upload any captured/picked images to the created request
      if (_pickedXFiles.isNotEmpty) {
        try {
          await _uploadService.uploadImages(request.id, _pickedXFiles);
        } catch (e) {
          debugPrint('Error uploading request images: $e');
        }
      }

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
    notesController.dispose();
    super.dispose();
  }
}
