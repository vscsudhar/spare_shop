import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
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

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

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

  void setProduct(ProductModel product) async {
    _product = product;
    _quantity = 1;
    _isFavorite = product.isFavorite;
    notifyListeners();

    try {
      _allProducts = await _productService.getProducts();
      notifyListeners();
    } catch (_) {}
  }

  void selectProduct(ProductModel newProduct) {
    _product = newProduct;
    _quantity = 1;
    _isFavorite = newProduct.isFavorite;
    notifyListeners();
  }

  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    _isFavorite = !_isFavorite;
    rebuildUi();
    try {
      if (_isFavorite) {
        await _wishlistService.addToWishlist(product.id);
      } else {
        await _wishlistService.removeFromWishlist(product.id);
      }
    } catch (_) {}
  }

  Future<void> addToCart() async {
    setBusy(true);
    try {
      await _cartService.addToCart(product.id, _quantity);
      goToCart();
    } catch (_) {
    } finally {
      setBusy(false);
    }
  }

  Future<void> addToCartForProduct(ProductModel p) async {
    try {
      await _cartService.addToCart(p.id, 1);
    } catch (_) {}
    notifyListeners();
  }
}
