import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends FutureViewModel<void> with NavigationMixin {
  final _productService = locator<ProductService>();
  final searchController = TextEditingController();

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
  List<ProductModel> get allProducts {
    if (selectedVehicle == null) return _allProducts;
    final filtered = _allProducts
        .where(isProductCompatibleWithSelectedVehicleBrand)
        .toList();
    return filtered.isNotEmpty ? filtered : _allProducts;
  }

  List<VehicleModel> _allVehicles = [];

  List<ProductModel> get compatibleProducts {
    if (selectedVehicle == null) return _allProducts;

    final filtered = _allProducts.where((product) {
      return product.compatibleVehicleIds.contains(selectedVehicle!.id) ||
          (product.fitmentBadge?.toLowerCase().contains('universal') ?? false);
    }).toList();
    return filtered.isNotEmpty ? filtered : _allProducts;
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
    _featuredProducts = _featuredProducts
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
      _featuredProducts = await _productService.getProducts(featured: true);
      _allProducts = await _productService.getProducts();
      _allVehicles = await _productService.getVehicleModels();

      for (final p in [..._featuredProducts, ..._allProducts]) {
        if (p.isWishlist && !_wishlistService.isProductWishlisted(p.id)) {
          _wishlistService.addToWishlist(p.id);
        }
      }
      _onWishlistChanged();
    } catch (e) {
      print('Error loading home data: $e');
    }
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

  Future<void> addToCart(ProductModel product, [BuildContext? context]) async {
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Cart & Checkout');
      if (!isAuth) return;
    }
    goToProductDetails(product: product);
  }

  Future<void> onTabSelected(int index, [BuildContext? context]) async {
    if (index == 2 && context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Rare Requests');
      if (!isAuth) return;
    }
    if (index == 3 && context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Cart & Checkout');
      if (!isAuth) return;
    }
    if (index == 4 && context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Profile & Account');
      if (!isAuth) return;
    }
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

  Future<void> openRareRequest([BuildContext? context]) async {
    if (context != null) {
      final isAuth = await ensureAuthenticated(context,
          featureName: 'Rare Product Requests');
      if (!isAuth) return;
    }
    goToRareProductRequest();
  }

  Future<void> refresh() async {
    await loadData();
    rebuildUi();
  }

  @override
  void dispose() {
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    searchController.dispose();
    super.dispose();
  }
}
