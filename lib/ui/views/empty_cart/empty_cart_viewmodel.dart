import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:stacked/stacked.dart';

class EmptyCartViewModel extends BaseViewModel with NavigationMixin {
  AppTab get currentTab => AppTab.cart;

  Future<void> navigateToHome() async {
    await replaceWithHome();
  }

  Future<void> onTabSelected(AppTab tab) async {
    if (tab == currentTab) {
      await navigateToHome();
      return;
    }

    int index = 0;
    if (tab == AppTab.wishlist) index = 1;
    if (tab == AppTab.cart) index = 3;
    if (tab == AppTab.profile) index = 4;
    await navigateToTab(index, currentIndex: 3);
  }
}
