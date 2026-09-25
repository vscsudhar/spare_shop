import 'package:spare_shop/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:spare_shop/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:spare_shop/ui/views/cart/cart_view.dart';
import 'package:spare_shop/ui/views/checkout/checkout_view.dart';
import 'package:spare_shop/ui/views/create_account/create_account_view.dart';
import 'package:spare_shop/ui/views/empty_cart/empty_cart_view.dart';
import 'package:spare_shop/ui/views/home/home_view.dart';
import 'package:spare_shop/ui/views/login/login_view.dart';
import 'package:spare_shop/ui/views/orders/orders_view.dart';
import 'package:spare_shop/ui/views/product_details/product_details_view.dart';
import 'package:spare_shop/ui/views/profile/profile_view.dart';
import 'package:spare_shop/ui/views/startup/startup_view.dart';
import 'package:spare_shop/ui/views/wishlist/wishlist_view.dart';
import 'package:spare_shop/ui/views/sign_in_otp/sign_in_otp_view.dart';
import 'package:spare_shop/ui/views/choose_vehicle_type/choose_vehicle_type_view.dart';
import 'package:spare_shop/ui/views/select_ev/select_ev_view.dart';
import 'package:spare_shop/ui/views/select_petrol_bike/select_petrol_bike_view.dart';
import 'package:spare_shop/ui/views/search_filters/search_filters_view.dart';
import 'package:spare_shop/ui/views/vehicle_selector/vehicle_selector_view.dart';
import 'package:spare_shop/ui/views/payment/payment_view.dart';
import 'package:spare_shop/ui/views/order_success/order_success_view.dart';
import 'package:spare_shop/ui/views/order_tracking/order_tracking_view.dart';
import 'package:spare_shop/ui/views/account_vehicles/account_vehicles_view.dart';
import 'package:spare_shop/ui/views/rare_product_request/rare_product_request_view.dart';
import 'package:spare_shop/ui/views/request_chat_quotation/request_chat_quotation_view.dart';
import 'package:spare_shop/ui/views/quotation_approved/quotation_approved_view.dart';
import 'package:spare_shop/ui/views/request_cancelled/request_cancelled_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:spare_shop/ui/views/my_rare_requests/my_rare_requests_view.dart';
import 'package:spare_shop/ui/views/rare_request_detail/rare_request_detail_view.dart';
import 'package:spare_shop/ui/views/customer_quotation/customer_quotation_view.dart';
import 'package:spare_shop/ui/views/add_address/add_address_view.dart';
import 'package:spare_shop/core/services/rare_request_mock_service.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/core/services/api_client.dart';
import 'package:spare_shop/core/services/upload_service.dart';
import 'package:spare_shop/core/services/socket_service.dart';
import 'package:spare_shop/core/services/network_info_service.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:spare_shop/core/services/product_service.dart';
import 'package:spare_shop/core/services/cart_service.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/core/services/address_service.dart';
import 'package:spare_shop/core/services/order_service.dart';
import 'package:spare_shop/core/services/rare_request_service.dart';
import 'package:spare_shop/core/services/admin_dashboard_service.dart';
import 'package:spare_shop/core/services/admin_supplier_service.dart';
import 'package:spare_shop/core/services/admin_purchase_service.dart';
import 'package:spare_shop/ui/views/support_tickets/support_tickets_view.dart';
import 'package:spare_shop/ui/views/create_ticket/create_ticket_view.dart';
import 'package:spare_shop/ui/views/ticket_chat/ticket_chat_view.dart';
import 'package:spare_shop/core/services/support_ticket_service.dart';
import 'package:spare_shop/core/services/vehicle_service.dart';
import 'package:spare_shop/core/services/delivery_charge_service.dart';
import 'package:spare_shop/core/services/suggestion_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true, path: '/'),
    MaterialRoute(page: LoginView, path: '/login'),
    MaterialRoute(page: CreateAccountView, path: '/create-account'),
    MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: ProductDetailsView, path: '/product-details'),
    MaterialRoute(page: CartView, path: '/cart'),
    MaterialRoute(page: WishlistView, path: '/wishlist'),
    MaterialRoute(page: OrdersView, path: '/orders'),
    MaterialRoute(page: ProfileView, path: '/profile'),
    MaterialRoute(page: CheckoutView, path: '/checkout'),
    MaterialRoute(page: EmptyCartView, path: '/empty-cart'),
    MaterialRoute(page: SignInOtpView),
    MaterialRoute(page: ChooseVehicleTypeView),
    MaterialRoute(page: SelectEvView),
    MaterialRoute(page: SelectPetrolBikeView),
    MaterialRoute(page: SearchFiltersView),
    MaterialRoute(page: VehicleSelectorView),
    MaterialRoute(page: PaymentView),
    MaterialRoute(page: OrderSuccessView),
    MaterialRoute(page: OrderTrackingView),
    MaterialRoute(page: AccountVehiclesView),
    MaterialRoute(page: RareProductRequestView),
    MaterialRoute(page: RequestChatQuotationView),
    MaterialRoute(page: QuotationApprovedView),
    MaterialRoute(page: RequestCancelledView),
    MaterialRoute(page: MyRareRequestsView),
    MaterialRoute(page: RareRequestDetailView),
    MaterialRoute(page: CustomerQuotationView),
    MaterialRoute(page: AddAddressView),
    MaterialRoute(page: SupportTicketsView),
    MaterialRoute(page: CreateTicketView),
    MaterialRoute(page: TicketChatView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: RareRequestMockService),
    LazySingleton(classType: TokenService),
    LazySingleton(classType: ApiClient),
    LazySingleton(classType: UploadService),
    LazySingleton(classType: SocketService),
    LazySingleton(classType: NetworkInfoService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: ProductService),
    LazySingleton(classType: CartService),
    LazySingleton(classType: WishlistService),
    LazySingleton(classType: AddressService),
    LazySingleton(classType: OrderService),
    LazySingleton(classType: RareRequestService),
    LazySingleton(classType: AdminDashboardService),
    LazySingleton(classType: AdminSupplierService),
    LazySingleton(classType: AdminPurchaseService),
    LazySingleton(classType: VehicleService),
    LazySingleton(classType: SupportTicketService),
    LazySingleton(classType: DeliveryChargeService),
    LazySingleton(classType: SuggestionService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
