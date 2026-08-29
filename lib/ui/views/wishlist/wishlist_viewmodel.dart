import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class WishlistViewModel extends FutureViewModel<void> with NavigationMixin {
  final _wishlistService = locator<WishlistService>();

  List<ShopProduct> _products = [];
  List<ShopProduct> get products => List.unmodifiable(_products);

  AppTab get currentTab => AppTab.wishlist;

  @override
  Future<void> futureToRun() async {
    await loadWishlist();
  }

  Future<void> loadWishlist() async {
    try {
      final list = await _wishlistService.getWishlist();
      _products = list.map((p) => _mapToShopProduct(p)).toList();
      rebuildUi();
    } catch (_) {}
  }

  ShopProduct _mapToShopProduct(ProductModel p) {
    return ShopProduct(
      id: p.id,
      name: p.name,
      price: p.price,
      rating: p.rating,
      visual: ProductVisual.headphones,
      category: ProductCategory.electronics,
      description: p.description,
      originalPrice: p.originalPrice,
      isFavorite: true,
    );
  }

  Future<void> openProductDetails(ShopProduct product) async {
    final p = ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      originalPrice: product.originalPrice ?? product.price,
      rating: product.rating,
      description: product.description,
      categoryId: '',
      compatibleVehicleIds: [],
      fitmentBadge: 'Universal',
      stockCount: 10,
    );
    await goToProductDetails(product: p);
  }

  Future<void> toggleFavorite(String productId) async {
    final index = _products.indexWhere((product) => product.id == productId);
    if (index == -1) return;

    try {
      await _wishlistService.removeFromWishlist(productId);
      _products.removeAt(index);
      rebuildUi();
    } catch (_) {}
  }

  Future<void> onTabSelected(AppTab tab) async {
    int index = 0;
    if (tab == AppTab.wishlist) index = 1;
    if (tab == AppTab.cart) index = 3;
    if (tab == AppTab.profile) index = 4;
    await navigateToTab(index, currentIndex: 1);
  }
}
