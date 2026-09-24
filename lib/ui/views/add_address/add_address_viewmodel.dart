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
  final postalCodeController = TextEditingController();

  // Location Coordinate Picked from Map
  double _latitude = 11.0123; // Default Coimbatore Lat
  double _longitude = 76.9567; // Default Coimbatore Lng

  double get latitude => _latitude;
  double get longitude => _longitude;

  bool _isMapMoved = false;
  bool get isMapMoved => _isMapMoved;

  String? _locationName;
  String? get locationName => _locationName;

  double? _distanceFromLocationKm;
  double? get distanceFromLocationKm => _distanceFromLocationKm;

  String? _locationId;
  String? get locationId => _locationId;

  AddAddressViewModel({this.addressToEdit}) {
    if (addressToEdit != null) {
      labelController.text = addressToEdit!.name;
      phoneController.text = addressToEdit!.phone;
      _locationId = addressToEdit!.locationId;
      _locationName = addressToEdit!.locationName;
      _distanceFromLocationKm = addressToEdit!.distanceFromLocationKm;

      if (addressToEdit!.latitude != null &&
          addressToEdit!.longitude != null) {
        _latitude = addressToEdit!.latitude!;
        _longitude = addressToEdit!.longitude!;
        _isMapMoved = true;
      }

      if (addressToEdit!.addressLine1 != null &&
          addressToEdit!.addressLine1!.isNotEmpty) {
        doorNoController.text = addressToEdit!.addressLine1!;
        talukController.text = addressToEdit!.addressLine2 ?? '';
        districtController.text = addressToEdit!.city ?? '';
        stateController.text = addressToEdit!.state ?? 'Tamil Nadu';
        postalCodeController.text = addressToEdit!.postalCode ?? '';
      } else {
        // Legacy fallback from addressLine
        final addressLine = addressToEdit!.addressLine;
        final coordRegex = RegExp(r'\(Lat:\s*([0-9.-]+),\s*Lng:\s*([0-9.-]+)\)');
        final match = coordRegex.firstMatch(addressLine);
        if (match != null) {
          _latitude = double.tryParse(match.group(1) ?? '') ?? _latitude;
          _longitude = double.tryParse(match.group(2) ?? '') ?? _longitude;
          _isMapMoved = true;
        }

        final cleanAddressLine = addressLine.replaceAll(coordRegex, '').trim();
        final parts = cleanAddressLine.split(',').map((e) => e.trim()).toList();

        if (parts.isNotEmpty) doorNoController.text = parts[0];
        if (parts.length > 1) talukController.text = parts[1];
        if (parts.length > 2) districtController.text = parts[2];
        if (parts.length > 3) stateController.text = parts[3];
        if (parts.length > 4 && !parts[4].contains('Lng:')) {
          postalCodeController.text = parts[4];
        }
      }

      // Sanitize legacy dirty state/postalCode
      if (stateController.text.contains('(Lat:')) {
        stateController.text = stateController.text.split('(Lat:')[0].trim();
      }
      if (postalCodeController.text.contains('Lng:')) {
        postalCodeController.text = '';
      }
    } else {
      stateController.text = 'Tamil Nadu'; // Pre-fill default state
      districtController.text = 'Coimbatore'; // Pre-fill default district
      postalCodeController.text = '641001';
    }
  }

  void updateLocation(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    _isMapMoved = true;
    notifyListeners();
  }

  void onAreaSelected(String taluk, String district, String state, [String? postalCode]) {
    talukController.text = taluk;
    districtController.text = district;
    stateController.text = state;
    if (postalCode != null && postalCode.isNotEmpty && !postalCode.contains('Lng:')) {
      postalCodeController.text = postalCode;
    }
    notifyListeners();
  }

  Future<void> saveAddress() async {
    final label = labelController.text.trim();
    final phone = phoneController.text.trim();
    final doorNo = doorNoController.text.trim();
    final taluk = talukController.text.trim();
    final district = districtController.text.trim();
    var state = stateController.text.trim();
    var postalCode = postalCodeController.text.trim();

    if (state.contains('(Lat:')) {
      state = state.split('(Lat:')[0].trim();
    }
    if (state.isEmpty) state = 'Tamil Nadu';

    if (postalCode.contains('Lng:') || postalCode.contains('Lat:')) {
      postalCode = '641001';
    }
    postalCode = postalCode.replaceAll(RegExp(r'[^0-9a-zA-Z -]'), '').trim();
    if (postalCode.isEmpty) postalCode = '641001';

    if (label.isEmpty ||
        phone.isEmpty ||
        doorNo.isEmpty ||
        taluk.isEmpty ||
        district.isEmpty) {
      return;
    }

    setBusy(true);

    final cleanParts = [
      doorNo,
      taluk,
      district,
      state,
      postalCode,
    ];
    final addressLineText = cleanParts.join(', ');

    final addressModel = AddressModel(
      id: addressToEdit?.id ?? '',
      name: label,
      phone: phone,
      addressLine: addressLineText,
      addressLine1: doorNo,
      addressLine2: taluk,
      city: district,
      state: state,
      postalCode: postalCode,
      country: 'India',
      isDefault: addressToEdit?.isDefault ?? false,
      latitude: latitude,
      longitude: longitude,
      locationId: _locationId,
      locationName: _locationName,
      distanceFromLocationKm: _distanceFromLocationKm,
    );

    try {
      AddressModel savedAddress;
      if (addressToEdit == null) {
        savedAddress = await _addressService.addAddress(addressModel);
      } else {
        savedAddress = await _addressService.updateAddress(
            addressToEdit!.id, addressModel);
      }
      _locationId = savedAddress.locationId;
      _locationName = savedAddress.locationName;
      _distanceFromLocationKm = savedAddress.distanceFromLocationKm;

      setBusy(false);
      navigationService.back(result: true);
    } catch (_) {
      setBusy(false);
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
    postalCodeController.dispose();
    super.dispose();
  }
}
