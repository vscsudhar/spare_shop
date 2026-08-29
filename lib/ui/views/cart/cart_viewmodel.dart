import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class CartViewModel extends FutureViewModel<void> with NavigationMixin {
  final _cartService = locator<CartService>();

  int get currentTabIndex => 3;

  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  double get subtotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get deliveryFee => subtotal == 0 || subtotal > 1500 ? 0.0 : 150.0;

  double get total => subtotal + deliveryFee;

  @override
  Future<void> futureToRun() async {
    await loadCart();
  }

  Future<void> loadCart() async {
    try {
      _items = await _cartService.getCart();
      rebuildUi();
    } catch (_) {}
  }

  Future<void> increaseQuantity(String id) async {
    final itemIndex = _items.indexWhere((element) => element.id == id);
    if (itemIndex == -1) return;

    final item = _items[itemIndex];
    try {
      _items = await _cartService.updateCartItem(id, item.quantity + 1);
      rebuildUi();
    } catch (_) {}
  }

  Future<void> decreaseQuantity(String id) async {
    final itemIndex = _items.indexWhere((element) => element.id == id);
    if (itemIndex == -1) return;

    final item = _items[itemIndex];
    if (item.quantity <= 1) {
      await removeItem(id);
      return;
    }
    try {
      _items = await _cartService.updateCartItem(id, item.quantity - 1);
      rebuildUi();
    } catch (_) {}
  }

  Future<void> removeItem(String id) async {
    try {
      _items = await _cartService.deleteCartItem(id);
      rebuildUi();
    } catch (_) {}
  }

  void proceedToCheckout() {
    if (_items.isEmpty) return;
    goToCheckout();
  }

  void onTabSelected(int index) {
    navigateToTab(index, currentIndex: currentTabIndex);
  }

  @override
  void goBack() {
    navigationService.back();
  }
}
