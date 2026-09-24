import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/address_service.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/delivery_charge_service.dart';
import 'package:spare_shop/ui/common/delivery_charge_models.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

AddressModel? currentSelectedAddress;

class CheckoutViewModel extends FutureViewModel<void> with NavigationMixin {
  final _addressService = locator<AddressService>();
  final _cartService = locator<CartService>();
  final _deliveryService = locator<DeliveryChargeService>();

  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  List<DeliveryChargeModel> _deliveryTiers = [];
  List<DeliveryChargeModel> get deliveryTiers => _deliveryTiers;

  double get subtotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get deliveryFee =>
      _deliveryService.calculateFee(subtotal, _deliveryTiers);

  double get total => subtotal + deliveryFee;

  bool get isFreeDelivery => deliveryFee == 0.0 && subtotal > 0;

  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  AddressModel? _selectedAddress;
  AddressModel? get selectedAddress => _selectedAddress;

  @override
  Future<void> futureToRun() async {
    await loadData();
  }

  Future<void> loadData() async {
    try {
      _items = await _cartService.getCart();
      _addresses = await _addressService.getAddresses();
      if (_addresses.isNotEmpty) {
        _selectedAddress = _addresses.firstWhere((a) => a.isDefault,
            orElse: () => _addresses.first);
      }
      _deliveryTiers = await _deliveryService.getDeliveryCharges(
        locationId: _selectedAddress?.locationId,
      );
      rebuildUi();
    } catch (_) {}
  }

  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void proceedToPayment() {
    if (_selectedAddress == null || _items.isEmpty) return;
    currentSelectedAddress = _selectedAddress;
    goToPayment();
  }

  Future<void> navigateToAddAddress() async {
    final result = await goToAddAddress();
    if (result == true) {
      await loadData();
    }
  }

  @override
  void goBack() {
    navigationService.back();
  }
}
