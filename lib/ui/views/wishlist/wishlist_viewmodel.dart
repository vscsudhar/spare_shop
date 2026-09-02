import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class WishlistViewModel extends FutureViewModel<void> with NavigationMixin {
  final _wishlistService = locator<WishlistService>();
  final _cartService = locator<CartService>();

  List<ProductModel> _products = [];
  List<ProductModel> get products => List.unmodifiable(_products);

  String get errorMessage => modelError?.toString() ?? '';

  bool isProductLoading(String id) => _wishlistService.isProductLoading(id);

  @override
  Future<void> futureToRun() async {
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    _wishlistService.wishlistedProductIdsNotifier
        .addListener(_onWishlistChanged);
    await loadWishlist();
  }

  void _onWishlistChanged() {
    final currentIds = _wishlistService.wishlistedProductIds;
    // Filter out any products that were unwishlisted from outside
    final updated = _products.where((p) => currentIds.contains(p.id)).toList();
    if (updated.length != _products.length) {
      _products = updated;
      rebuildUi();
    }
  }

  Future<void> loadWishlist() async {
    clearErrors();
    try {
      final list = await _wishlistService.getWishlist();
      final mockItems = mockProducts
          .where((p) => _wishlistService.wishlistedProductIds.contains(p.id))
          .toList();
      final all = [
        ...list,
        ...mockItems.where((m) => !list.any((p) => p.id == m.id))
      ];
      _products = all;
    } catch (e) {
      setError('Failed to load wishlist. Please try again.');
    }
  }

  Future<void> refresh() async {
    await loadWishlist();
    rebuildUi();
  }

  Future<void> openProductDetails(ProductModel product) async {
    await goToProductDetails(product: product);
  }

  Future<void> toggleWishlist(ProductModel product,
      [BuildContext? context]) async {
    if (isProductLoading(product.id)) return;
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Wishlist');
      if (!isAuth) return;
    }

    final id = product.id;
    try {
      final isStillWishlisted = await _wishlistService.toggleWishlist(id);
      if (!isStillWishlisted) {
        _products = _products.where((p) => p.id != id).toList();
        rebuildUi();
      }
    } catch (_) {
      // Handled with state rollback inside WishlistService
    }
  }

  Future<void> addToCart(ProductModel product, [BuildContext? context]) async {
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Cart & Checkout');
      if (!isAuth) return;
    }
    try {
      await _cartService.addToCart(product.id, 1);
      goToCart();
    } catch (_) {}
  }

  void browseProducts() {
    clearStackAndShowHome();
  }

  @override
  void dispose() {
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    super.dispose();
  }
}
