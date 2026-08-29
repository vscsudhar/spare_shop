import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/address_service.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

AddressModel? currentSelectedAddress;

class CheckoutViewModel extends FutureViewModel<void> with NavigationMixin {
  final _addressService = locator<AddressService>();
  final _cartService = locator<CartService>();

  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  double get subtotal => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  double get deliveryFee => subtotal == 0 || subtotal > 1500 ? 0.0 : 150.0;

  double get total => subtotal + deliveryFee;

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
