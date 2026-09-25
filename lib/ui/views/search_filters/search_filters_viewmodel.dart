import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:stacked/stacked.dart';

class SearchFiltersViewModel extends FutureViewModel<void>
    with NavigationMixin {
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

  void init({String? initialCategoryId, String? initialQuery}) {
    if (initialCategoryId != null && initialCategoryId.isNotEmpty) {
      _selectedCategoryId = initialCategoryId;
    }
    if (initialQuery != null && initialQuery.isNotEmpty) {
      searchController.text = initialQuery;
    }
    notifyListeners();
  }

  List<ProductModel> get filteredProducts {
    final query = searchController.text.trim().toLowerCase();

    return _allProducts.where((product) {
      // 1. Query filter (matches name, description, brand, fitment, or category name!)
      if (query.isNotEmpty) {
        final categoryName = _categories
            .firstWhere(
              (c) => c.id == product.categoryId,
              orElse: () =>
                  const CategoryModel(id: '', name: '', icon: Icons.category),
            )
            .name
            .toLowerCase();

        final nameMatch = product.name.toLowerCase().contains(query);
        final descMatch = product.description.toLowerCase().contains(query);
        final catMatch = categoryName.contains(query);
        final fitmentMatch =
            product.fitmentBadge?.toLowerCase().contains(query) ?? false;

        if (!nameMatch && !descMatch && !catMatch && !fitmentMatch) {
          return false;
        }
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
    if (nameLower.contains(selectedBrand) ||
        descLower.contains(selectedBrand)) {
      return true;
    }

    return false;
  }

  final _wishlistService = locator<WishlistService>();

  void _onWishlistChanged() {
    final wishlistedIds = _wishlistService.wishlistedProductIds;
    _allProducts = _allProducts
        .map((p) => p.copyWith(isWishlist: wishlistedIds.contains(p.id)))
        .toList();
    rebuildUi();
  }

  @override
  Future<void> futureToRun() async {
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    _wishlistService.wishlistedProductIdsNotifier
        .addListener(_onWishlistChanged);
    await loadData();
  }

  Future<void> loadData() async {
    try {
      _categories = await _productService.getCategories();
      _allProducts = await _productService.getProducts();
      _allVehicles = await _productService.getVehicleModels();
    } catch (e) {
      print('Error loading search data: $e');
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

  bool isWishlistLoading(String id) => _wishlistService.isProductLoading(id);

  Future<void> toggleWishlist(ProductModel product,
      [BuildContext? context]) async {
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Wishlist');
      if (!isAuth) return;
    }
    try {
      await _wishlistService.toggleWishlist(product.id);
    } catch (_) {}
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
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    searchController.dispose();
    super.dispose();
  }
}
