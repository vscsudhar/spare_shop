import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/api_client.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/core/services/vehicle_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class SelectEvViewModel extends BaseViewModel with NavigationMixin {
  final _tokenService = locator<TokenService>();
  final _productService = locator<ProductService>();
  final _vehicleService = locator<VehicleService>();
  final _apiClient = locator<ApiClient>();

  final customBrandController = TextEditingController();
  final customModelController = TextEditingController();

  List<VehicleBrandModel> _brands = [];
  List<VehicleBrandModel> get brands => _brands;

  List<VehicleModel> _allModels = [];

  String? _selectedBrandId;
  String? get selectedBrandId => _selectedBrandId;

  String? _selectedModel;
  String? get selectedModel => _selectedModel;

  String? _selectedYear;
  String? get selectedYear => _selectedYear;

  Future<void> init() async {
    setBusy(true);
    try {
      final backendBrands = await _productService.getVehicleBrands();
      _brands = [
        ...backendBrands,
        const VehicleBrandModel(id: 'other', name: 'Other'),
      ];
      _allModels = await _productService.getVehicleModels();
    } catch (e) {
      print('Error fetching brands/models: $e');
      _brands = [
        const VehicleBrandModel(id: 'other', name: 'Other'),
      ];
    }
    setBusy(false);
  }

  List<String> get modelsForSelectedBrand {
    if (_selectedBrandId == null) return [];
    if (_selectedBrandId == 'other') return ['Other'];

    final brandName = _brands
        .firstWhere((b) => b.id == _selectedBrandId,
            orElse: () => const VehicleBrandModel(id: '', name: ''))
        .name;
    if (brandName.isEmpty) return ['Other'];

    final filtered = _allModels
        .where((m) =>
            m.brand.toLowerCase() == brandName.toLowerCase() &&
            m.type == VehicleType.ev)
        .map((m) => m.name)
        .toList();

    return [...filtered, 'Other'];
  }

  List<String> get years =>
      ['2026', '2025', '2024', '2023', '2022', '2021', '2020'];

  void selectBrand(String brandId) {
    _selectedBrandId = brandId;
    _selectedModel = null;
    _selectedYear = null;
    customBrandController.clear();
    customModelController.clear();
    notifyListeners();
  }

  void selectModel(String model) {
    _selectedModel = model;
    customModelController.clear();
    notifyListeners();
  }

  void selectYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  bool get canSave {
    if (_selectedYear == null) return false;

    if (_selectedBrandId == 'other') {
      if (customBrandController.text.trim().isEmpty) return false;
      if (_selectedModel != 'Other' ||
          customModelController.text.trim().isEmpty) {
        return false;
      }
      return true;
    }

    if (_selectedBrandId != null) {
      if (_selectedModel == 'Other') {
        return customModelController.text.trim().isNotEmpty;
      }
      return _selectedModel != null;
    }

    return false;
  }

  void saveVehicle() async {
    if (!canSave) return;

    setBusy(true);
    try {
      String brandId = _selectedBrandId ?? '';
      String brandName = '';
      String modelName = '';
      String modelId = '';

      if (_selectedBrandId == 'other') {
        final bName = customBrandController.text.trim();
        final brandResponse = await _apiClient.post('/vehicle-brands', data: {
          'name': bName,
          'vehicleTypeName': 'Scooter',
        });
        brandId = brandResponse.data['data']['_id'];
        brandName = brandResponse.data['data']['name'];

        final mName = customModelController.text.trim();
        final modelResponse = await _apiClient.post('/vehicle-models', data: {
          'name': mName,
          'brandId': brandId,
          'type': 'EV',
          'years': [_selectedYear!],
        });
        modelId = modelResponse.data['data']['_id'];
        modelName = modelResponse.data['data']['name'];
      } else {
        brandName = _brands.firstWhere((b) => b.id == _selectedBrandId).name;

        if (_selectedModel == 'Other') {
          final mName = customModelController.text.trim();
          final modelResponse = await _apiClient.post('/vehicle-models', data: {
            'name': mName,
            'brandId': brandId,
            'type': 'EV',
            'years': [_selectedYear!],
          });
          modelId = modelResponse.data['data']['_id'];
          modelName = modelResponse.data['data']['name'];
        } else {
          modelName = _selectedModel!;
          final matchedModel = _allModels.firstWhere(
            (m) =>
                m.name == _selectedModel &&
                m.brand.toLowerCase() == brandName.toLowerCase(),
            orElse: () => const VehicleModel(
                id: '', brand: '', name: '', year: '', type: VehicleType.ev),
          );
          modelId = matchedModel.id.isNotEmpty
              ? matchedModel.id
              : 'veh_${DateTime.now().millisecondsSinceEpoch}';
        }
      }

      final newVehicle = VehicleModel(
        id: modelId,
        brand: brandName,
        name: modelName,
        year: _selectedYear!,
        type: VehicleType.ev,
      );

      VehicleModel savedVehicle = newVehicle;
      try {
        // Save to backend database
        savedVehicle = await _vehicleService.addVehicle(newVehicle);
      } catch (_) {
        // Fallback gracefully if guest or network error
      }

      // Save to global userVehicles state
      userVehicles.add(savedVehicle);
      currentSelectedVehicle = savedVehicle;

      // Save to persistent local storage
      final email = await _tokenService.getUserEmail();
      if (email != null) {
        await _tokenService.saveSelectedVehicle(email, savedVehicle);
      }

      setBusy(false);
      clearStackAndShowHome();
    } catch (_) {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    customBrandController.dispose();
    customModelController.dispose();
    super.dispose();
  }
}
