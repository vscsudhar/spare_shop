// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i31;
import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart' as _i32;
import 'package:spare_shop/ui/views/account_vehicles/account_vehicles_view.dart'
    as _i22;
import 'package:spare_shop/ui/views/add_address/add_address_view.dart' as _i30;
import 'package:spare_shop/ui/views/cart/cart_view.dart' as _i7;
import 'package:spare_shop/ui/views/checkout/checkout_view.dart' as _i11;
import 'package:spare_shop/ui/views/choose_vehicle_type/choose_vehicle_type_view.dart'
    as _i14;
import 'package:spare_shop/ui/views/create_account/create_account_view.dart'
    as _i4;
import 'package:spare_shop/ui/views/customer_quotation/customer_quotation_view.dart'
    as _i29;
import 'package:spare_shop/ui/views/empty_cart/empty_cart_view.dart' as _i12;
import 'package:spare_shop/ui/views/home/home_view.dart' as _i5;
import 'package:spare_shop/ui/views/login/login_view.dart' as _i3;
import 'package:spare_shop/ui/views/my_rare_requests/my_rare_requests_view.dart'
    as _i27;
import 'package:spare_shop/ui/views/order_success/order_success_view.dart'
    as _i20;
import 'package:spare_shop/ui/views/order_tracking/order_tracking_view.dart'
    as _i21;
import 'package:spare_shop/ui/views/orders/orders_view.dart' as _i9;
import 'package:spare_shop/ui/views/payment/payment_view.dart' as _i19;
import 'package:spare_shop/ui/views/product_details/product_details_view.dart'
    as _i6;
import 'package:spare_shop/ui/views/profile/profile_view.dart' as _i10;
import 'package:spare_shop/ui/views/quotation_approved/quotation_approved_view.dart'
    as _i25;
import 'package:spare_shop/ui/views/rare_product_request/rare_product_request_view.dart'
    as _i23;
import 'package:spare_shop/ui/views/rare_request_detail/rare_request_detail_view.dart'
    as _i28;
import 'package:spare_shop/ui/views/request_cancelled/request_cancelled_view.dart'
    as _i26;
import 'package:spare_shop/ui/views/request_chat_quotation/request_chat_quotation_view.dart'
    as _i24;
import 'package:spare_shop/ui/views/search_filters/search_filters_view.dart'
    as _i17;
import 'package:spare_shop/ui/views/select_ev/select_ev_view.dart' as _i15;
import 'package:spare_shop/ui/views/select_petrol_bike/select_petrol_bike_view.dart'
    as _i16;
import 'package:spare_shop/ui/views/sign_in_otp/sign_in_otp_view.dart' as _i13;
import 'package:spare_shop/ui/views/startup/startup_view.dart' as _i2;
import 'package:spare_shop/ui/views/vehicle_selector/vehicle_selector_view.dart'
    as _i18;
import 'package:spare_shop/ui/views/wishlist/wishlist_view.dart' as _i8;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i33;

class Routes {
  static const startupView = '/';

  static const loginView = '/login';

  static const createAccountView = '/create-account';

  static const homeView = '/home';

  static const productDetailsView = '/product-details';

  static const cartView = '/cart';

  static const wishlistView = '/wishlist';

  static const ordersView = '/orders';

  static const profileView = '/profile';

  static const checkoutView = '/checkout';

  static const emptyCartView = '/empty-cart';

  static const signInOtpView = '/sign-in-otp-view';

  static const chooseVehicleTypeView = '/choose-vehicle-type-view';

  static const selectEvView = '/select-ev-view';

  static const selectPetrolBikeView = '/select-petrol-bike-view';

  static const searchFiltersView = '/search-filters-view';

  static const vehicleSelectorView = '/vehicle-selector-view';

  static const paymentView = '/payment-view';

  static const orderSuccessView = '/order-success-view';

  static const orderTrackingView = '/order-tracking-view';

  static const accountVehiclesView = '/account-vehicles-view';

  static const rareProductRequestView = '/rare-product-request-view';

  static const requestChatQuotationView = '/request-chat-quotation-view';

  static const quotationApprovedView = '/quotation-approved-view';

  static const requestCancelledView = '/request-cancelled-view';

  static const myRareRequestsView = '/my-rare-requests-view';

  static const rareRequestDetailView = '/rare-request-detail-view';

  static const customerQuotationView = '/customer-quotation-view';

  static const addAddressView = '/add-address-view';

  static const all = <String>{
    startupView,
    loginView,
    createAccountView,
    homeView,
    productDetailsView,
    cartView,
    wishlistView,
    ordersView,
    profileView,
    checkoutView,
    emptyCartView,
    signInOtpView,
    chooseVehicleTypeView,
    selectEvView,
    selectPetrolBikeView,
    searchFiltersView,
    vehicleSelectorView,
    paymentView,
    orderSuccessView,
    orderTrackingView,
    accountVehiclesView,
    rareProductRequestView,
    requestChatQuotationView,
    quotationApprovedView,
    requestCancelledView,
    myRareRequestsView,
    rareRequestDetailView,
    customerQuotationView,
    addAddressView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i3.LoginView,
    ),
    _i1.RouteDef(
      Routes.createAccountView,
      page: _i4.CreateAccountView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i5.HomeView,
    ),
    _i1.RouteDef(
      Routes.productDetailsView,
      page: _i6.ProductDetailsView,
    ),
    _i1.RouteDef(
      Routes.cartView,
      page: _i7.CartView,
    ),
    _i1.RouteDef(
      Routes.wishlistView,
      page: _i8.WishlistView,
    ),
    _i1.RouteDef(
      Routes.ordersView,
      page: _i9.OrdersView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i10.ProfileView,
    ),
    _i1.RouteDef(
      Routes.checkoutView,
      page: _i11.CheckoutView,
    ),
    _i1.RouteDef(
      Routes.emptyCartView,
      page: _i12.EmptyCartView,
    ),
    _i1.RouteDef(
      Routes.signInOtpView,
      page: _i13.SignInOtpView,
    ),
    _i1.RouteDef(
      Routes.chooseVehicleTypeView,
      page: _i14.ChooseVehicleTypeView,
    ),
    _i1.RouteDef(
      Routes.selectEvView,
      page: _i15.SelectEvView,
    ),
    _i1.RouteDef(
      Routes.selectPetrolBikeView,
      page: _i16.SelectPetrolBikeView,
    ),
    _i1.RouteDef(
      Routes.searchFiltersView,
      page: _i17.SearchFiltersView,
    ),
    _i1.RouteDef(
      Routes.vehicleSelectorView,
      page: _i18.VehicleSelectorView,
    ),
    _i1.RouteDef(
      Routes.paymentView,
      page: _i19.PaymentView,
    ),
    _i1.RouteDef(
      Routes.orderSuccessView,
      page: _i20.OrderSuccessView,
    ),
    _i1.RouteDef(
      Routes.orderTrackingView,
      page: _i21.OrderTrackingView,
    ),
    _i1.RouteDef(
      Routes.accountVehiclesView,
      page: _i22.AccountVehiclesView,
    ),
    _i1.RouteDef(
      Routes.rareProductRequestView,
      page: _i23.RareProductRequestView,
    ),
    _i1.RouteDef(
      Routes.requestChatQuotationView,
      page: _i24.RequestChatQuotationView,
    ),
    _i1.RouteDef(
      Routes.quotationApprovedView,
      page: _i25.QuotationApprovedView,
    ),
    _i1.RouteDef(
      Routes.requestCancelledView,
      page: _i26.RequestCancelledView,
    ),
    _i1.RouteDef(
      Routes.myRareRequestsView,
      page: _i27.MyRareRequestsView,
    ),
    _i1.RouteDef(
      Routes.rareRequestDetailView,
      page: _i28.RareRequestDetailView,
    ),
    _i1.RouteDef(
      Routes.customerQuotationView,
      page: _i29.CustomerQuotationView,
    ),
    _i1.RouteDef(
      Routes.addAddressView,
      page: _i30.AddAddressView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => const StartupViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.StartupView(key: args.key),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.LoginView(key: args.key),
        settings: data,
      );
    },
    _i4.CreateAccountView: (data) {
      final args = data.getArgs<CreateAccountViewArguments>(
        orElse: () => const CreateAccountViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.CreateAccountView(key: args.key),
        settings: data,
      );
    },
    _i5.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.HomeView(key: args.key),
        settings: data,
      );
    },
    _i6.ProductDetailsView: (data) {
      final args = data.getArgs<ProductDetailsViewArguments>(nullOk: false);
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i6.ProductDetailsView(key: args.key, product: args.product),
        settings: data,
      );
    },
    _i7.CartView: (data) {
      final args = data.getArgs<CartViewArguments>(
        orElse: () => const CartViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.CartView(key: args.key),
        settings: data,
      );
    },
    _i8.WishlistView: (data) {
      final args = data.getArgs<WishlistViewArguments>(
        orElse: () => const WishlistViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.WishlistView(key: args.key),
        settings: data,
      );
    },
    _i9.OrdersView: (data) {
      final args = data.getArgs<OrdersViewArguments>(
        orElse: () => const OrdersViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.OrdersView(key: args.key),
        settings: data,
      );
    },
    _i10.ProfileView: (data) {
      final args = data.getArgs<ProfileViewArguments>(
        orElse: () => const ProfileViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i10.ProfileView(key: args.key),
        settings: data,
      );
    },
    _i11.CheckoutView: (data) {
      final args = data.getArgs<CheckoutViewArguments>(
        orElse: () => const CheckoutViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.CheckoutView(key: args.key),
        settings: data,
      );
    },
    _i12.EmptyCartView: (data) {
      final args = data.getArgs<EmptyCartViewArguments>(
        orElse: () => const EmptyCartViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.EmptyCartView(key: args.key),
        settings: data,
      );
    },
    _i13.SignInOtpView: (data) {
      final args = data.getArgs<SignInOtpViewArguments>(
        orElse: () => const SignInOtpViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i13.SignInOtpView(key: args.key),
        settings: data,
      );
    },
    _i14.ChooseVehicleTypeView: (data) {
      final args = data.getArgs<ChooseVehicleTypeViewArguments>(
        orElse: () => const ChooseVehicleTypeViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i14.ChooseVehicleTypeView(key: args.key),
        settings: data,
      );
    },
    _i15.SelectEvView: (data) {
      final args = data.getArgs<SelectEvViewArguments>(
        orElse: () => const SelectEvViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.SelectEvView(key: args.key),
        settings: data,
      );
    },
    _i16.SelectPetrolBikeView: (data) {
      final args = data.getArgs<SelectPetrolBikeViewArguments>(
        orElse: () => const SelectPetrolBikeViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i16.SelectPetrolBikeView(key: args.key),
        settings: data,
      );
    },
    _i17.SearchFiltersView: (data) {
      final args = data.getArgs<SearchFiltersViewArguments>(
        orElse: () => const SearchFiltersViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i17.SearchFiltersView(key: args.key),
        settings: data,
      );
    },
    _i18.VehicleSelectorView: (data) {
      final args = data.getArgs<VehicleSelectorViewArguments>(
        orElse: () => const VehicleSelectorViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i18.VehicleSelectorView(key: args.key),
        settings: data,
      );
    },
    _i19.PaymentView: (data) {
      final args = data.getArgs<PaymentViewArguments>(
        orElse: () => const PaymentViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.PaymentView(key: args.key),
        settings: data,
      );
    },
    _i20.OrderSuccessView: (data) {
      final args = data.getArgs<OrderSuccessViewArguments>(
        orElse: () => const OrderSuccessViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i20.OrderSuccessView(key: args.key),
        settings: data,
      );
    },
    _i21.OrderTrackingView: (data) {
      final args = data.getArgs<OrderTrackingViewArguments>(
        orElse: () => const OrderTrackingViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i21.OrderTrackingView(key: args.key),
        settings: data,
      );
    },
    _i22.AccountVehiclesView: (data) {
      final args = data.getArgs<AccountVehiclesViewArguments>(
        orElse: () => const AccountVehiclesViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i22.AccountVehiclesView(key: args.key),
        settings: data,
      );
    },
    _i23.RareProductRequestView: (data) {
      final args = data.getArgs<RareProductRequestViewArguments>(
        orElse: () => const RareProductRequestViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i23.RareProductRequestView(key: args.key),
        settings: data,
      );
    },
    _i24.RequestChatQuotationView: (data) {
      final args =
          data.getArgs<RequestChatQuotationViewArguments>(nullOk: false);
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i24.RequestChatQuotationView(
            key: args.key, requestId: args.requestId),
        settings: data,
      );
    },
    _i25.QuotationApprovedView: (data) {
      final args = data.getArgs<QuotationApprovedViewArguments>(nullOk: false);
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i25.QuotationApprovedView(
            key: args.key, requestId: args.requestId),
        settings: data,
      );
    },
    _i26.RequestCancelledView: (data) {
      final args = data.getArgs<RequestCancelledViewArguments>(nullOk: false);
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i26.RequestCancelledView(key: args.key, requestId: args.requestId),
        settings: data,
      );
    },
    _i27.MyRareRequestsView: (data) {
      final args = data.getArgs<MyRareRequestsViewArguments>(
        orElse: () => const MyRareRequestsViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i27.MyRareRequestsView(key: args.key),
        settings: data,
      );
    },
    _i28.RareRequestDetailView: (data) {
      final args = data.getArgs<RareRequestDetailViewArguments>(nullOk: false);
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i28.RareRequestDetailView(
            key: args.key, requestId: args.requestId),
        settings: data,
      );
    },
    _i29.CustomerQuotationView: (data) {
      final args = data.getArgs<CustomerQuotationViewArguments>(nullOk: false);
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) => _i29.CustomerQuotationView(
            key: args.key,
            requestId: args.requestId,
            quotationId: args.quotationId),
        settings: data,
      );
    },
    _i30.AddAddressView: (data) {
      final args = data.getArgs<AddAddressViewArguments>(
        orElse: () => const AddAddressViewArguments(),
      );
      return _i31.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i30.AddAddressView(key: args.key, address: args.address),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class StartupViewArguments {
  const StartupViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StartupViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CreateAccountViewArguments {
  const CreateAccountViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CreateAccountViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class HomeViewArguments {
  const HomeViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ProductDetailsViewArguments {
  const ProductDetailsViewArguments({
    this.key,
    required this.product,
  });

  final _i31.Key? key;

  final _i32.ProductModel product;

  @override
  String toString() {
    return '{"key": "$key", "product": "$product"}';
  }

  @override
  bool operator ==(covariant ProductDetailsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.product == product;
  }

  @override
  int get hashCode {
    return key.hashCode ^ product.hashCode;
  }
}

class CartViewArguments {
  const CartViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CartViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class WishlistViewArguments {
  const WishlistViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant WishlistViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OrdersViewArguments {
  const OrdersViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant OrdersViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ProfileViewArguments {
  const ProfileViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CheckoutViewArguments {
  const CheckoutViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CheckoutViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class EmptyCartViewArguments {
  const EmptyCartViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant EmptyCartViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class SignInOtpViewArguments {
  const SignInOtpViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SignInOtpViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ChooseVehicleTypeViewArguments {
  const ChooseVehicleTypeViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ChooseVehicleTypeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class SelectEvViewArguments {
  const SelectEvViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SelectEvViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class SelectPetrolBikeViewArguments {
  const SelectPetrolBikeViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SelectPetrolBikeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class SearchFiltersViewArguments {
  const SearchFiltersViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SearchFiltersViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class VehicleSelectorViewArguments {
  const VehicleSelectorViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant VehicleSelectorViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class PaymentViewArguments {
  const PaymentViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant PaymentViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OrderSuccessViewArguments {
  const OrderSuccessViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant OrderSuccessViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class OrderTrackingViewArguments {
  const OrderTrackingViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant OrderTrackingViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AccountVehiclesViewArguments {
  const AccountVehiclesViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant AccountVehiclesViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class RareProductRequestViewArguments {
  const RareProductRequestViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant RareProductRequestViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class RequestChatQuotationViewArguments {
  const RequestChatQuotationViewArguments({
    this.key,
    required this.requestId,
  });

  final _i31.Key? key;

  final String requestId;

  @override
  String toString() {
    return '{"key": "$key", "requestId": "$requestId"}';
  }

  @override
  bool operator ==(covariant RequestChatQuotationViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.requestId == requestId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ requestId.hashCode;
  }
}

class QuotationApprovedViewArguments {
  const QuotationApprovedViewArguments({
    this.key,
    required this.requestId,
  });

  final _i31.Key? key;

  final String requestId;

  @override
  String toString() {
    return '{"key": "$key", "requestId": "$requestId"}';
  }

  @override
  bool operator ==(covariant QuotationApprovedViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.requestId == requestId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ requestId.hashCode;
  }
}

class RequestCancelledViewArguments {
  const RequestCancelledViewArguments({
    this.key,
    required this.requestId,
  });

  final _i31.Key? key;

  final String requestId;

  @override
  String toString() {
    return '{"key": "$key", "requestId": "$requestId"}';
  }

  @override
  bool operator ==(covariant RequestCancelledViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.requestId == requestId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ requestId.hashCode;
  }
}

class MyRareRequestsViewArguments {
  const MyRareRequestsViewArguments({this.key});

  final _i31.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant MyRareRequestsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class RareRequestDetailViewArguments {
  const RareRequestDetailViewArguments({
    this.key,
    required this.requestId,
  });

  final _i31.Key? key;

  final String requestId;

  @override
  String toString() {
    return '{"key": "$key", "requestId": "$requestId"}';
  }

  @override
  bool operator ==(covariant RareRequestDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.requestId == requestId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ requestId.hashCode;
  }
}

class CustomerQuotationViewArguments {
  const CustomerQuotationViewArguments({
    this.key,
    required this.requestId,
    required this.quotationId,
  });

  final _i31.Key? key;

  final String requestId;

  final String quotationId;

  @override
  String toString() {
    return '{"key": "$key", "requestId": "$requestId", "quotationId": "$quotationId"}';
  }

  @override
  bool operator ==(covariant CustomerQuotationViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.requestId == requestId &&
        other.quotationId == quotationId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ requestId.hashCode ^ quotationId.hashCode;
  }
}

class AddAddressViewArguments {
  const AddAddressViewArguments({
    this.key,
    this.address,
  });

  final _i31.Key? key;

  final _i32.AddressModel? address;

  @override
  String toString() {
    return '{"key": "$key", "address": "$address"}';
  }

  @override
  bool operator ==(covariant AddAddressViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.address == address;
  }

  @override
  int get hashCode {
    return key.hashCode ^ address.hashCode;
  }
}

extension NavigatorStateExtension on _i33.NavigationService {
  Future<dynamic> navigateToStartupView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateAccountView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.createAccountView,
        arguments: CreateAccountViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProductDetailsView({
    _i31.Key? key,
    required _i32.ProductModel product,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.productDetailsView,
        arguments: ProductDetailsViewArguments(key: key, product: product),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCartView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.cartView,
        arguments: CartViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToWishlistView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.wishlistView,
        arguments: WishlistViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrdersView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.ordersView,
        arguments: OrdersViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.profileView,
        arguments: ProfileViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCheckoutView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.checkoutView,
        arguments: CheckoutViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEmptyCartView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.emptyCartView,
        arguments: EmptyCartViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignInOtpView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.signInOtpView,
        arguments: SignInOtpViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChooseVehicleTypeView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.chooseVehicleTypeView,
        arguments: ChooseVehicleTypeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSelectEvView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.selectEvView,
        arguments: SelectEvViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSelectPetrolBikeView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.selectPetrolBikeView,
        arguments: SelectPetrolBikeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSearchFiltersView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.searchFiltersView,
        arguments: SearchFiltersViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToVehicleSelectorView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.vehicleSelectorView,
        arguments: VehicleSelectorViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPaymentView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.paymentView,
        arguments: PaymentViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderSuccessView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderSuccessView,
        arguments: OrderSuccessViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOrderTrackingView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.orderTrackingView,
        arguments: OrderTrackingViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAccountVehiclesView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.accountVehiclesView,
        arguments: AccountVehiclesViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRareProductRequestView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.rareProductRequestView,
        arguments: RareProductRequestViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRequestChatQuotationView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.requestChatQuotationView,
        arguments:
            RequestChatQuotationViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToQuotationApprovedView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.quotationApprovedView,
        arguments:
            QuotationApprovedViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRequestCancelledView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.requestCancelledView,
        arguments:
            RequestCancelledViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMyRareRequestsView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.myRareRequestsView,
        arguments: MyRareRequestsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRareRequestDetailView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.rareRequestDetailView,
        arguments:
            RareRequestDetailViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCustomerQuotationView({
    _i31.Key? key,
    required String requestId,
    required String quotationId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.customerQuotationView,
        arguments: CustomerQuotationViewArguments(
            key: key, requestId: requestId, quotationId: quotationId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddAddressView({
    _i31.Key? key,
    _i32.AddressModel? address,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addAddressView,
        arguments: AddAddressViewArguments(key: key, address: address),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.startupView,
        arguments: StartupViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateAccountView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.createAccountView,
        arguments: CreateAccountViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.homeView,
        arguments: HomeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProductDetailsView({
    _i31.Key? key,
    required _i32.ProductModel product,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.productDetailsView,
        arguments: ProductDetailsViewArguments(key: key, product: product),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCartView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.cartView,
        arguments: CartViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithWishlistView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.wishlistView,
        arguments: WishlistViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrdersView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.ordersView,
        arguments: OrdersViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.profileView,
        arguments: ProfileViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCheckoutView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.checkoutView,
        arguments: CheckoutViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEmptyCartView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.emptyCartView,
        arguments: EmptyCartViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignInOtpView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.signInOtpView,
        arguments: SignInOtpViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithChooseVehicleTypeView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.chooseVehicleTypeView,
        arguments: ChooseVehicleTypeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSelectEvView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.selectEvView,
        arguments: SelectEvViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSelectPetrolBikeView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.selectPetrolBikeView,
        arguments: SelectPetrolBikeViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSearchFiltersView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.searchFiltersView,
        arguments: SearchFiltersViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithVehicleSelectorView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.vehicleSelectorView,
        arguments: VehicleSelectorViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithPaymentView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.paymentView,
        arguments: PaymentViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderSuccessView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderSuccessView,
        arguments: OrderSuccessViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOrderTrackingView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.orderTrackingView,
        arguments: OrderTrackingViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAccountVehiclesView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.accountVehiclesView,
        arguments: AccountVehiclesViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRareProductRequestView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.rareProductRequestView,
        arguments: RareProductRequestViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRequestChatQuotationView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.requestChatQuotationView,
        arguments:
            RequestChatQuotationViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithQuotationApprovedView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.quotationApprovedView,
        arguments:
            QuotationApprovedViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRequestCancelledView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.requestCancelledView,
        arguments:
            RequestCancelledViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMyRareRequestsView({
    _i31.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.myRareRequestsView,
        arguments: MyRareRequestsViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRareRequestDetailView({
    _i31.Key? key,
    required String requestId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.rareRequestDetailView,
        arguments:
            RareRequestDetailViewArguments(key: key, requestId: requestId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCustomerQuotationView({
    _i31.Key? key,
    required String requestId,
    required String quotationId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.customerQuotationView,
        arguments: CustomerQuotationViewArguments(
            key: key, requestId: requestId, quotationId: quotationId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddAddressView({
    _i31.Key? key,
    _i32.AddressModel? address,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addAddressView,
        arguments: AddAddressViewArguments(key: key, address: address),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
