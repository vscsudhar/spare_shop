import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:stacked/stacked.dart';

class OrderSuccessViewModel extends BaseViewModel with NavigationMixin {
  void viewOrderTracking() {
    goToOrderTracking();
  }

  void continueShopping() {
    clearStackAndShowHome();
  }
}
