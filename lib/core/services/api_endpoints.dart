import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  // Default LAN IP of the development PC for physical devices on the local Wi-Fi network
  static const String defaultLanIp = '192.168.0.174';
  static const String defaultPort = '5000';

  // Optional compile-time environment overrides via --dart-define
  static const String _envHost = String.fromEnvironment('API_HOST');
  static const String _envPort = String.fromEnvironment('API_PORT');
  static const bool _isEmulator =
      bool.fromEnvironment('IS_EMULATOR', defaultValue: false);

  /// Resolves the host IP dynamically based on environment and platform
  static String get hostIp {
    if (_envHost.isNotEmpty) {
      return _envHost;
    }

    if (kIsWeb) {
      return '127.0.0.1';
    }

    try {
      if (Platform.isAndroid) {
        if (_isEmulator) {
          return '10.0.2.2';
        }
        // Physical Android device uses development PC LAN IPv4 address
        return defaultLanIp;
      }

      if (Platform.isIOS) {
        return _isEmulator ? '127.0.0.1' : defaultLanIp;
      }

      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        return '127.0.0.1';
      }
    } catch (_) {
      return defaultLanIp;
    }

    return defaultLanIp;
  }

  static String get port => _envPort.isNotEmpty ? _envPort : defaultPort;

  static String get baseUrl => 'http://$hostIp:$port/api/v1';
  static String get socketUrl => 'http://$hostIp:$port';

  // Authentication
  static const String customerLogin = '/auth/customer/login';
  static const String customerRegister = '/auth/customer/register';
  static const String adminLogin = '/auth/admin/login';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
  static const String me = '/auth/me';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';

  // Catalog
  static const String products = '/products';
  static const String categories = '/categories';
  static const String vehicleBrands = '/vehicle-brands';
  static const String vehicleModels = '/vehicle-models';

  // Sourcing (Rare requests)
  static const String rareRequests = '/rare-requests';
  static const String quotations = '/quotations';
  static const String chat = '/chat';

  // Customer features
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String addresses = '/addresses';
  static const String orders = '/orders';
  static const String checkout = '/checkout';
  static const String deliveryCharges = '/delivery-charges';

  // Admin features
  static const String dashboard = '/admin/dashboard';
  static const String adminOrders = '/admin/orders';
  static const String adminRareRequests = '/admin/rare-requests';
  static const String inventory = '/inventory';
  static const String purchases = '/purchases';
  static const String suppliers = '/suppliers';
  static const String customers = '/customers';
  static const String billing = '/billing';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String notifications = '/notifications';

  // Support Tickets
  static const String supportTickets = '/support-tickets';
  static const String mySupportTickets = '/support-tickets/my';
  static String supportTicketById(String id) => '/support-tickets/$id';
  static String supportTicketMessages(String id) => '/support-tickets/$id/messages';
  static String supportTicketStatus(String id) => '/support-tickets/$id/status';
  static const String adminSupportTickets = '/support-tickets/admin/all';

  // Suggestions
  static const String suggestions = '/suggestions';
  static const String adminSuggestions = '/admin/suggestions';
}
