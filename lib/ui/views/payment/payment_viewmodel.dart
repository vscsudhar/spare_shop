import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/delivery_charge_service.dart';
import 'package:spare_shop/core/services/order_service.dart';
import 'package:spare_shop/ui/common/delivery_charge_models.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/views/checkout/checkout_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PaymentViewModel extends FutureViewModel<void> with NavigationMixin {
  final _cartService = locator<CartService>();
  final _orderService = locator<OrderService>();
  final _deliveryService = locator<DeliveryChargeService>();

  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  List<DeliveryChargeModel> _deliveryTiers = [];

  double get subtotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get deliveryFee =>
      _deliveryService.calculateFee(subtotal, _deliveryTiers);

  double get total => subtotal + deliveryFee;

  bool get isFreeDelivery => deliveryFee == 0.0 && subtotal > 0;

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
      _deliveryTiers = await _deliveryService.getDeliveryCharges(
        locationId: currentSelectedAddress?.locationId,
      );
      rebuildUi();
    } catch (_) {}
  }

  void selectOption(PaymentOptionModel option) {
    _selectedOption = option;
    notifyListeners();
  }

  Future<void> completePayment() async {
    if (isBusy) return;
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
