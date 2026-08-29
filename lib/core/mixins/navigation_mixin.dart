import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked_services/stacked_services.dart';

mixin NavigationMixin {
  final NavigationService navigationService = locator<NavigationService>();

  void goBack() {
    navigationService.back();
  }

  Future<dynamic>? goToLogin() {
    return navigationService.navigateTo(Routes.loginView);
  }

  Future<dynamic>? goToCreateAccount() {
    return navigationService.navigateTo(Routes.createAccountView);
  }

  Future<dynamic>? goToHome() {
    return navigationService.navigateTo(Routes.homeView);
  }

  Future<dynamic>? goToProductDetails({
    required ProductModel product,
  }) {
    return navigationService.navigateTo(
      Routes.productDetailsView,
      arguments: ProductDetailsViewArguments(product: product),
    );
  }

  Future<dynamic>? goToCart() {
    return navigationService.navigateTo(Routes.cartView);
  }

  Future<dynamic>? goToWishlist() {
    return navigationService.navigateTo(Routes.wishlistView);
  }

  Future<dynamic>? goToOrders() {
    return navigationService.navigateTo(Routes.ordersView);
  }

  Future<dynamic>? goToProfile() {
    return navigationService.navigateTo(Routes.profileView);
  }

  Future<dynamic>? goToCheckout() {
    return navigationService.navigateTo(Routes.checkoutView);
  }

  Future<dynamic>? goToEmptyCart() {
    return navigationService.navigateTo(Routes.emptyCartView);
  }

  Future<dynamic>? replaceWithLogin() {
    return navigationService.replaceWith(Routes.loginView);
  }

  Future<dynamic>? replaceWithHome() {
    return navigationService.replaceWith(Routes.homeView);
  }

  Future<dynamic>? replaceWithCart() {
    return navigationService.replaceWith(Routes.cartView);
  }

  Future<dynamic>? replaceWithWishlist() {
    return navigationService.replaceWith(Routes.wishlistView);
  }

  Future<dynamic>? replaceWithOrders() {
    return navigationService.replaceWith(Routes.ordersView);
  }

  Future<dynamic>? replaceWithProfile() {
    return navigationService.replaceWith(Routes.profileView);
  }

  Future<dynamic>? replaceWithEmptyCart() {
    return navigationService.replaceWith(Routes.emptyCartView);
  }

  Future<dynamic>? clearStackAndShowHome() {
    return navigationService.clearStackAndShow(Routes.homeView);
  }

  Future<dynamic>? clearStackAndShowLogin() {
    return navigationService.clearStackAndShow(Routes.loginView);
  }

  // VoltSpare new view navigation helpers
  Future<dynamic>? goToSignInOtp() {
    return navigationService.navigateTo(Routes.signInOtpView);
  }

  Future<dynamic>? replaceWithSignInOtp() {
    return navigationService.replaceWith(Routes.signInOtpView);
  }

  Future<dynamic>? goToChooseVehicleType() {
    return navigationService.navigateTo(Routes.chooseVehicleTypeView);
  }

  Future<dynamic>? replaceWithChooseVehicleType() {
    return navigationService.replaceWith(Routes.chooseVehicleTypeView);
  }

  Future<dynamic>? goToSelectEv() {
    return navigationService.navigateTo(Routes.selectEvView);
  }

  Future<dynamic>? goToSelectPetrolBike() {
    return navigationService.navigateTo(Routes.selectPetrolBikeView);
  }

  Future<dynamic>? goToSearchFilters() {
    return navigationService.navigateTo(Routes.searchFiltersView);
  }

  Future<dynamic>? goToVehicleSelector() {
    return navigationService.navigateTo(Routes.vehicleSelectorView);
  }

  Future<dynamic>? goToPayment() {
    return navigationService.navigateTo(Routes.paymentView);
  }

  Future<dynamic>? goToOrderSuccess() {
    return navigationService.navigateTo(Routes.orderSuccessView);
  }

  Future<dynamic>? goToOrderTracking() {
    return navigationService.navigateTo(Routes.orderTrackingView);
  }

  Future<dynamic>? goToAccountVehicles() {
    return navigationService.navigateTo(Routes.accountVehiclesView);
  }

  Future<dynamic>? goToRareProductRequest() {
    return navigationService.navigateTo(Routes.rareProductRequestView);
  }

  Future<dynamic>? goToRequestChatQuotation({required String requestId}) {
    return navigationService.navigateTo(
      Routes.requestChatQuotationView,
      arguments: RequestChatQuotationViewArguments(requestId: requestId),
    );
  }

  Future<dynamic>? goToQuotationApproved({required String requestId}) {
    return navigationService.navigateTo(
      Routes.quotationApprovedView,
      arguments: QuotationApprovedViewArguments(requestId: requestId),
    );
  }

  Future<dynamic>? goToRequestCancelled({required String requestId}) {
    return navigationService.navigateTo(
      Routes.requestCancelledView,
      arguments: RequestCancelledViewArguments(requestId: requestId),
    );
  }

  Future<dynamic>? goToMyRareRequests() {
    return navigationService.navigateTo(Routes.myRareRequestsView);
  }

  Future<dynamic>? goToRareRequestDetail({required String requestId}) {
    return navigationService.navigateTo(
      Routes.rareRequestDetailView,
      arguments: RareRequestDetailViewArguments(requestId: requestId),
    );
  }

  Future<dynamic>? goToCustomerQuotation({
    required String requestId,
    required String quotationId,
  }) {
    return navigationService.navigateTo(
      Routes.customerQuotationView,
      arguments: CustomerQuotationViewArguments(
        requestId: requestId,
        quotationId: quotationId,
      ),
    );
  }

  Future<dynamic>? goToAddAddress({AddressModel? address}) {
    return navigationService.navigateTo(
      Routes.addAddressView,
      arguments: AddAddressViewArguments(address: address),
    );
  }

  Future<dynamic> navigateToTab(
    int index, {
    int? currentIndex,
  }) {
    if (currentIndex != null && index == currentIndex) {
      return Future<dynamic>.value();
    }

    switch (index) {
      case 0:
        return navigationService.replaceWith(Routes.homeView) ??
            Future<dynamic>.value();
      case 1:
        return navigationService.replaceWith(Routes.searchFiltersView) ??
            Future<dynamic>.value();
      case 2:
        return navigationService.replaceWith(Routes.myRareRequestsView) ??
            Future<dynamic>.value();
      case 3:
        return navigationService.replaceWith(Routes.cartView) ??
            Future<dynamic>.value();
      case 4:
        return navigationService.replaceWith(Routes.accountVehiclesView) ??
            Future<dynamic>.value();
      default:
        return Future<dynamic>.value();
    }
  }
}
