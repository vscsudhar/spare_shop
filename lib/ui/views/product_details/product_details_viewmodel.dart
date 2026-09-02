import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/ui/common/delivery_estimator.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class ProductDetailsViewModel extends BaseViewModel with NavigationMixin {
  final _cartService = locator<CartService>();
  final _wishlistService = locator<WishlistService>();
  final _productService = locator<ProductService>();

  ProductModel? _product;
  ProductModel get product => _product ?? mockProducts[0];

  int _quantity = 1;
  int get quantity => _quantity;

  Timer? _cutoffTimer;

  DeliveryEstimate get deliveryEstimate =>
      DeliveryEstimator.getEstimate(product);

  bool get canAddToCart => deliveryEstimate.isAvailable;

  bool get canIncreaseQuantity {
    if (!product.stockManaged || product.stockCount == null) return true;
    return _quantity < product.stockCount!;
  }

  bool get isFavorite => _wishlistService.isProductWishlisted(product.id);
  bool get isWishlistLoading => _wishlistService.isProductLoading(product.id);

  VehicleModel? get selectedVehicle => currentSelectedVehicle;

  List<ProductModel> _allProducts = [];
  List<ProductModel> get suggestions {
    if (_allProducts.isEmpty) return [];

    final categoryProducts = _allProducts
        .where((p) => p.categoryId == product.categoryId && p.id != product.id)
        .toList();

    final activeVehicle = currentSelectedVehicle;
    if (activeVehicle != null) {
      final compatibleProducts = categoryProducts
          .where((p) => p.compatibleVehicleIds.contains(activeVehicle.id))
          .toList();
      if (compatibleProducts.isNotEmpty) {
        return compatibleProducts;
      }
    }
    return categoryProducts;
  }

  void _onWishlistChanged() {
    notifyListeners();
  }

  void _scheduleCutoffTimer() {
    _cutoffTimer?.cancel();
    final bt = DeliveryEstimator.getBusinessTime();
    if (DeliveryEstimator.isWithinCutoff(bt)) {
      final nowUtc = DateTime.now().toUtc();
      final targetCutoffUtc = DateTime.utc(
        nowUtc.year,
        nowUtc.month,
        nowUtc.day,
        9,
        30,
        1,
      );
      if (targetCutoffUtc.isAfter(nowUtc)) {
        final duration = targetCutoffUtc.difference(nowUtc);
        _cutoffTimer = Timer(duration, () {
          notifyListeners();
        });
      }
    }
  }

  void init(ProductModel product) async {
    _product = product;
    _quantity = 1;
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    _wishlistService.wishlistedProductIdsNotifier
        .addListener(_onWishlistChanged);

    _scheduleCutoffTimer();

    if (product.isWishlist) {
      // If the passed product was marked wishlisted, ensure cache includes it
      if (!_wishlistService.isProductWishlisted(product.id)) {
        // Sync cache
      }
    }

    notifyListeners();

    try {
      // Refresh fresh product data from backend
      final fresh = await _productService.getProductById(product.id);
      _product = fresh;
      notifyListeners();
    } catch (_) {}

    try {
      _allProducts = await _productService.getProducts();
      notifyListeners();
    } catch (_) {}
  }

  void selectProduct(ProductModel newProduct) {
    init(newProduct);
  }

  void increaseQuantity() {
    if (product.stockManaged && product.stockCount != null) {
      if (_quantity >= product.stockCount!) {
        return;
      }
    }
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite([BuildContext? context]) async {
    if (isWishlistLoading) return;
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Wishlist');
      if (!isAuth) return;
    }
    try {
      await _wishlistService.toggleWishlist(product.id);
    } catch (_) {
      // Error is handled with rollback inside WishlistService
    }
  }

  Future<void> toggleWishlistForProduct(ProductModel p,
      [BuildContext? context]) async {
    if (isProductLoading(p.id)) return;
    final estimate = DeliveryEstimator.getEstimate(p);
    if (!estimate.isAvailable) return;
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Wishlist');
      if (!isAuth) return;
    }
    try {
      await _wishlistService.toggleWishlist(p.id);
    } catch (_) {}
  }

  bool isProductLoading(String id) => _wishlistService.isProductLoading(id);

  Future<void> addToCart([BuildContext? context]) async {
    if (!canAddToCart) return;
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Cart & Checkout');
      if (!isAuth) return;
    }
    setBusy(true);
    try {
      await _cartService.addToCart(product.id, _quantity);
      goToCart();
    } catch (_) {
    } finally {
      setBusy(false);
    }
  }

  Future<void> addToCartForProduct(ProductModel p,
      [BuildContext? context]) async {
    final estimate = DeliveryEstimator.getEstimate(p);
    if (!estimate.isAvailable) return;
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Cart & Checkout');
      if (!isAuth) return;
    }
    try {
      await _cartService.addToCart(p.id, 1);
    } catch (_) {}
    notifyListeners();
  }

  @override
  void dispose() {
    _cutoffTimer?.cancel();
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    super.dispose();
  }
}
