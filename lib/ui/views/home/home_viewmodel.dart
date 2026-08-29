import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends FutureViewModel<void> with NavigationMixin {
  final _productService = locator<ProductService>();

  int get currentTabIndex => 0;

  VehicleModel? get selectedVehicle => currentSelectedVehicle;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories {
    if (selectedVehicle == null) return _categories;
    return _categories.where((cat) {
      return _allProducts.any((prod) =>
          prod.categoryId == cat.id &&
          isProductCompatibleWithSelectedVehicleBrand(prod));
    }).toList();
  }

  List<ProductModel> _featuredProducts = [];
  List<ProductModel> get featuredProducts {
    if (selectedVehicle == null) return _featuredProducts;
    return _featuredProducts
        .where(isProductCompatibleWithSelectedVehicleBrand)
        .toList();
  }

  List<ProductModel> _allProducts = [];
  List<VehicleModel> _allVehicles = [];

  List<ProductModel> get compatibleProducts {
    if (selectedVehicle == null) return _allProducts;

    return _allProducts.where((product) {
      return product.compatibleVehicleIds.contains(selectedVehicle!.id) ||
          (product.fitmentBadge?.toLowerCase().contains('universal') ?? false);
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
    try {
      _categories = await _productService.getCategories();
      _featuredProducts = await _productService.getProducts(featured: true);
      _allProducts = await _productService.getProducts();
      _allVehicles = await _productService.getVehicleModels();
      rebuildUi();
    } catch (e) {
      print('Error loading home data: $e');
    }
  }

  void onTabSelected(int index) {
    navigateToTab(index, currentIndex: currentTabIndex);
  }

  void selectVehicle() async {
    await goToVehicleSelector();
    rebuildUi();
  }

  void openSearch() {
    goToSearchFilters();
  }

  void openProductDetails(ProductModel product) {
    goToProductDetails(product: product);
  }

  void openCartView() {
    goToCart();
  }

  void openRareRequest() {
    goToRareProductRequest();
  }

  Future<void> refresh() async {
    await loadData();
  }
}
