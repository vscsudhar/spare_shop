import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/order_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/views/checkout/checkout_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PaymentViewModel extends FutureViewModel<void> with NavigationMixin {
  final _cartService = locator<CartService>();
  final _orderService = locator<OrderService>();

  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  double get subtotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get deliveryFee => subtotal == 0 || subtotal > 1500 ? 0.0 : 150.0;

  double get total => subtotal + deliveryFee;

  List<PaymentOptionModel> get options => mockPaymentOptions;

  PaymentOptionModel? _selectedOption = mockPaymentOptions[0];
  PaymentOptionModel? get selectedOption => _selectedOption;

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

  void selectOption(PaymentOptionModel option) {
    _selectedOption = option;
    notifyListeners();
  }

  Future<void> completePayment() async {
    if (_selectedOption == null ||
        _items.isEmpty ||
        currentSelectedAddress == null) {
      return;
    }

    setBusy(true);
    try {
      await _orderService.placeOrder(
        addressId: currentSelectedAddress!.id,
        paymentMethod: _selectedOption!.name.toLowerCase().contains('cash')
            ? 'cod'
            : 'online',
      );
      await _cartService.clearCart();
      setBusy(false);
      goToOrderSuccess();
    } catch (_) {
      setBusy(false);
    }
  }

  @override
  void goBack() {
    navigationService.back();
  }
}
