import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/delivery_charge_service.dart';
import 'package:spare_shop/ui/common/delivery_charge_models.dart';
import 'package:spare_shop/ui/common/delivery_estimator.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class CartViewModel extends FutureViewModel<void> with NavigationMixin {
  final _cartService = locator<CartService>();
  final _deliveryService = locator<DeliveryChargeService>();

  int get currentTabIndex => 3;

  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  List<DeliveryChargeModel> _deliveryTiers = [];
  List<DeliveryChargeModel> get deliveryTiers => _deliveryTiers;

  CartDeliverySummary get deliverySummary =>
      DeliveryEstimator.getCartDeliverySummary(_items);

  double get subtotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get deliveryFee =>
      _deliveryService.calculateFee(subtotal, _deliveryTiers);

  double? get freeDeliveryThreshold =>
      _deliveryService.getFreeDeliveryThreshold(_deliveryTiers);

  double get amountNeededForFreeDelivery {
    final threshold = freeDeliveryThreshold;
    if (threshold == null || subtotal >= threshold) return 0.0;
    return threshold - subtotal;
  }

  bool get isFreeDelivery => deliveryFee == 0.0 && subtotal > 0;

  double get total => subtotal + deliveryFee;

  @override
  Future<void> futureToRun() async {
    await loadCart();
  }

  Future<void> loadCart() async {
    try {
      _items = await _cartService.getCart();
      _deliveryTiers = await _deliveryService.getDeliveryCharges();
      rebuildUi();
    } catch (_) {}
  }

  bool canIncreaseItemQuantity(CartItemModel item) {
    if (!item.product.stockManaged || item.product.stockCount == null) {
      return true;
    }
    return item.quantity < item.product.stockCount!;
  }

  Future<void> increaseQuantity(String id) async {
    final itemIndex = _items.indexWhere((element) => element.id == id);
    if (itemIndex == -1) return;

    final item = _items[itemIndex];
    if (item.product.stockManaged && item.product.stockCount != null) {
      if (item.quantity >= item.product.stockCount!) {
        // Stock quantity limit reached for stock-managed item
        return;
      }
    }

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

  Future<void> proceedToCheckout([BuildContext? context]) async {
    if (_items.isEmpty) return;
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Checkout & Payment');
      if (!isAuth) return;
    }
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
