import 'package:spare_shop/app/app.locator.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'token_service.dart';
import 'socket_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';

class AuthService {
  final ApiClient _apiClient;
  final TokenService _tokenService;
  final SocketService _socketService;

  AuthService({
    ApiClient? apiClient,
    TokenService? tokenService,
    SocketService? socketService,
  })  : _apiClient = apiClient ?? locator<ApiClient>(),
        _tokenService = tokenService ?? locator<TokenService>(),
        _socketService = socketService ?? locator<SocketService>();

  Future<bool> loginCustomer(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.customerLogin,
      data: {'email': email, 'password': password},
    );
    final data = response.data['data'];
    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];
    final user = data['user'];

    await _tokenService.saveTokens(
        accessToken: accessToken, refreshToken: refreshToken);
    await _tokenService.saveUserRole(user['role']?['name'] ?? 'customer');
    await _tokenService.saveUserEmail(user['email'] ?? '');
    await _tokenService.saveUserName(user['name'] ?? '');
    if (user['phone'] != null) {
      await _tokenService.saveUserPhone(user['phone'].toString());
    }
    if (user['profileImage'] != null) {
      await _tokenService.saveUserImageUrl(user['profileImage'].toString());
    }

    final perms = user['role']?['permissions'] as List<dynamic>? ?? [];
    final permNames =
        perms.map((p) => (p is Map ? p['name'] : p).toString()).toList();
    await _tokenService.saveUserPermissions(permNames);

    return true;
  }

  Future<bool> loginAdmin(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.adminLogin,
      data: {'email': email, 'password': password},
    );
    final data = response.data['data'];
    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];
    final user = data['user'];

    await _tokenService.saveTokens(
        accessToken: accessToken, refreshToken: refreshToken);
    await _tokenService.saveUserRole(user['role']?['name'] ?? 'admin');
    await _tokenService.saveUserEmail(user['email'] ?? '');
    await _tokenService.saveUserName(user['name'] ?? '');
    if (user['phone'] != null) {
      await _tokenService.saveUserPhone(user['phone'].toString());
    }
    if (user['profileImage'] != null) {
      await _tokenService.saveUserImageUrl(user['profileImage'].toString());
    }

    final perms = user['role']?['permissions'] as List<dynamic>? ?? [];
    final permNames =
        perms.map((p) => (p is Map ? p['name'] : p).toString()).toList();
    await _tokenService.saveUserPermissions(permNames);

    return true;
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.me);
      final rawData = response.data['data'];
      Map<String, dynamic>? user;
      if (rawData is Map<String, dynamic>) {
        if (rawData['user'] is Map<String, dynamic>) {
          user = rawData['user'] as Map<String, dynamic>;
        } else {
          user = rawData;
        }
      }
      if (user != null) {
        if (user['name'] != null && user['name'].toString().isNotEmpty) {
          await _tokenService.saveUserName(user['name'].toString());
        }
        if (user['email'] != null && user['email'].toString().isNotEmpty) {
          await _tokenService.saveUserEmail(user['email'].toString());
        }
        if (user['phone'] != null && user['phone'].toString().isNotEmpty) {
          await _tokenService.saveUserPhone(user['phone'].toString());
        }
        if (user['profileImage'] != null &&
            user['profileImage'].toString().isNotEmpty) {
          await _tokenService.saveUserImageUrl(user['profileImage'].toString());
        }
        return user;
      }
    } catch (_) {}
    return null;
  }

  Future<bool> registerCustomer(
      String name, String email, String phone, String password) async {
    await _apiClient.post(
      ApiEndpoints.customerRegister,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return true;
  }

  Future<void> sendOtp(String email) async {
    await _apiClient.post(ApiEndpoints.sendOtp, data: {'email': email});
  }

  Future<void> verifyOtp(String email, String otp) async {
    await _apiClient
        .post(ApiEndpoints.verifyOtp, data: {'identifier': email, 'otp': otp});
  }

  Future<void> logout() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken != null) {
        await _apiClient
            .post(ApiEndpoints.logout, data: {'refreshToken': refreshToken});
      }
    } catch (_) {}
    try {
      _socketService.disconnect();
    } catch (_) {}

    // Reset shareable mock data on logout
    currentSelectedVehicle = mockVehicles[2];
    userVehicles = [mockVehicles[2]];

    await _tokenService.clearTokens();
  }

  Future<void> enterGuestMode() async {
    await _tokenService.setGuestMode(true);
    await _tokenService.getOrCreateGuestDeviceId();
  }

  Future<bool> isGuest() async {
    return _tokenService.isGuestMode();
  }
}
