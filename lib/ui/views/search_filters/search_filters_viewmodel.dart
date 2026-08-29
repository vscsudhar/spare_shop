import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:stacked/stacked.dart';

class SearchFiltersViewModel extends FutureViewModel<void> with NavigationMixin {
  final _productService = locator<ProductService>();

  int get currentTabIndex => 1;

  final TextEditingController searchController = TextEditingController();

  VehicleModel? get selectedVehicle => currentSelectedVehicle;

  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  String? _selectedBrand;
  String? get selectedBrand => _selectedBrand;

  double _maxPriceLimit = 50000;
  double get maxPriceLimit => _maxPriceLimit;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  List<ProductModel> _allProducts = [];
  List<VehicleModel> _allVehicles = [];

  List<ProductModel> get filteredProducts {
    final query = searchController.text.trim().toLowerCase();

    return _allProducts.where((product) {
      // 1. Query filter
      if (query.isNotEmpty && !product.name.toLowerCase().contains(query)) {
        return false;
      }

      // 2. Vehicle compatibility brand filter
      if (selectedVehicle != null) {
        if (!isProductCompatibleWithSelectedVehicleBrand(product)) {
          return false;
        }
      }

      // 3. Category filter
      if (_selectedCategoryId != null &&
          product.categoryId != _selectedCategoryId) {
        return false;
      }

      // 4. Price filter
      if (product.price > _maxPriceLimit) {
        return false;
      }

      return true;
    }).toList();
  }

  bool isProductCompatibleWithSelectedVehicleBrand(ProductModel product) {
    if (selectedVehicle == null) return true;

    // 1. Direct ID match
    if (product.compatibleVehicleIds.contains(selectedVehicle!.id)) {
      return true;
    }

    // 2. Universal fitment
    if (product.fitmentBadge?.toLowerCase().contains('universal') ?? false) {
      return true;
    }

    // 3. Brand match check
    final selectedBrand = selectedVehicle!.brand.toLowerCase();
    for (final vehicleId in product.compatibleVehicleIds) {
      final vehicle = _allVehicles.firstWhere(
        (v) => v.id == vehicleId,
        orElse: () => const VehicleModel(
            id: '', brand: '', name: '', year: '', type: VehicleType.petrol),
      );
      if (vehicle.brand.toLowerCase() == selectedBrand) {
        return true;
      }
    }

    // 4. Keyword search fallback check
    final nameLower = product.name.toLowerCase();
    final descLower = product.description.toLowerCase();
    if (nameLower.contains(selectedBrand) || descLower.contains(selectedBrand)) {
      return true;
    }

    return false;
  }

  @override
  Future<void> futureToRun() async {
    await loadData();
  }

  Future<void> loadData() async {
    setBusy(true);
    try {
      _categories = await _productService.getCategories();
      _allProducts = await _productService.getProducts();
      _allVehicles = await _productService.getVehicleModels();
    } catch (e) {
      print('Error loading search data: $e');
    } finally {
      setBusy(false);
    }
  }

  void onSearchChanged(String val) {
    notifyListeners();
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void selectBrand(String? brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  void setMaxPrice(double price) {
    _maxPriceLimit = price;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategoryId = null;
    _selectedBrand = null;
    _maxPriceLimit = 50000;
    searchController.clear();
    notifyListeners();
  }

  void openProductDetails(ProductModel product) {
    goToProductDetails(product: product);
  }

  void onTabSelected(int index) {
    navigateToTab(index, currentIndex: currentTabIndex);
  }

  void openVehicleSelector() async {
    await goToVehicleSelector();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
