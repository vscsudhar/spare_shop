import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/address_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class AddAddressViewModel extends BaseViewModel with NavigationMixin {
  final _addressService = locator<AddressService>();

  final AddressModel? addressToEdit;

  // Form fields
  final labelController = TextEditingController();
  final phoneController = TextEditingController();
  final doorNoController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();

  // Location Coordinate Picked from Map
  double _latitude = 11.0123; // Default Coimbatore Lat
  double _longitude = 76.9567; // Default Coimbatore Lng
  
  double get latitude => _latitude;
  double get longitude => _longitude;

  bool _isMapMoved = false;
  bool get isMapMoved => _isMapMoved;

  AddAddressViewModel({this.addressToEdit}) {
    if (addressToEdit != null) {
      labelController.text = addressToEdit!.name;
      phoneController.text = addressToEdit!.phone;
      
      // Parse addressLine
      final addressLine = addressToEdit!.addressLine;
      
      // Parse coordinates from string if present, e.g., (Lat: 11.0123, Lng: 76.9567)
      final coordRegex = RegExp(r'\(Lat:\s*([0-9.-]+),\s*Lng:\s*([0-9.-]+)\)');
      final match = coordRegex.firstMatch(addressLine);
      if (match != null) {
        _latitude = double.tryParse(match.group(1) ?? '') ?? 11.0123;
        _longitude = double.tryParse(match.group(2) ?? '') ?? 76.9567;
        _isMapMoved = true;
      } else {
        // Fallback to model fields if they are added
        _latitude = addressToEdit!.latitude ?? 11.0123;
        _longitude = addressToEdit!.longitude ?? 76.9567;
      }
      
      // Remove coordinates string for form parsing
      final cleanAddressLine = addressLine.replaceAll(coordRegex, '').trim();
      final parts = cleanAddressLine.split(',').map((e) => e.trim()).toList();
      
      if (parts.isNotEmpty) {
        doorNoController.text = parts[0];
      }
      if (parts.length > 1) {
        talukController.text = parts[1];
      }
      if (parts.length > 2) {
        districtController.text = parts[2];
      }
      if (parts.length > 3) {
        stateController.text = parts.sublist(3).join(', ');
      }
    } else {
      stateController.text = 'Tamil Nadu'; // Pre-fill default state
      districtController.text = 'Coimbatore'; // Pre-fill default district
    }
  }

  void updateLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    _isMapMoved = true;
    notifyListeners();
  }

  void onAreaSelected(String taluk, String district, String state) {
    talukController.text = taluk;
    districtController.text = district;
    stateController.text = state;
    notifyListeners();
  }

  Future<void> saveAddress() async {
    final label = labelController.text.trim();
    final phone = phoneController.text.trim();
    final doorNo = doorNoController.text.trim();
    final taluk = talukController.text.trim();
    final district = districtController.text.trim();
    final state = stateController.text.trim();

    if (label.isEmpty || phone.isEmpty || doorNo.isEmpty || taluk.isEmpty || district.isEmpty || state.isEmpty) {
      // Handled by UI validation
      return;
    }

    setBusy(true);

    // Format address line: Door No & Street, Taluk, District, State (Lat: XX.XXXX, Lng: YY.YYYY)
    final addressLineText = '$doorNo, $taluk, $district, $state (Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)})';

    final addressModel = AddressModel(
      id: addressToEdit?.id ?? '',
      name: label,
      phone: phone,
      addressLine: addressLineText,
      isDefault: addressToEdit?.isDefault ?? false,
      latitude: latitude,
      longitude: longitude,
    );

    try {
      if (addressToEdit == null) {
        await _addressService.addAddress(addressModel);
      } else {
        await _addressService.updateAddress(addressToEdit!.id, addressModel);
      }
      setBusy(false);
      navigationService.back(result: true); // Return true to indicate address saved
    } catch (e) {
      setBusy(false);
      // Let UI show error or print for debugging
      print('Error saving address: $e');
    }
  }

  @override
  void dispose() {
    labelController.dispose();
    phoneController.dispose();
    doorNoController.dispose();
    talukController.dispose();
    districtController.dispose();
    stateController.dispose();
    super.dispose();
  }
}
