import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> navigateToTab(
  NavigationService navigationService,
  AppTab tab,
) {
  switch (tab) {
    case AppTab.home:
      return navigationService.replaceWithHomeView();
    case AppTab.wishlist:
      return navigationService.replaceWithWishlistView();
    case AppTab.cart:
      return navigationService.replaceWithCartView();
    case AppTab.orders:
      return navigationService.replaceWithOrdersView();
    case AppTab.profile:
      return navigationService.replaceWithProfileView();
  }
}
