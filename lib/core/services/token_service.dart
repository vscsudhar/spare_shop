import 'package:shared_preferences/shared_preferences.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';

class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userRoleKey = 'user_role';
  static const String _userPermissionsKey = 'user_permissions';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _isGuestKey = 'is_guest_mode';
  static const String _guestDeviceIdKey = 'guest_device_id';

  Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setBool(_isGuestKey, false);
  }

  Future<void> setGuestMode(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestKey, isGuest);
  }

  Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool(_isGuestKey) ?? false;
    final token = prefs.getString(_accessTokenKey);
    // If there's a valid access token, not in guest mode
    if (token != null && token.isNotEmpty) {
      return false;
    }
    return isGuest;
  }

  Future<String> getOrCreateGuestDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_guestDeviceIdKey);
    if (id == null || id.isEmpty) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final rand = (100000 + (DateTime.now().microsecond % 900000));
      id = 'guest_dev_${timestamp}_$rand';
      await prefs.setString(_guestDeviceIdKey, id);
    }
    return id;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userPermissionsKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userNameKey);
    await prefs.setBool(_isGuestKey, false);
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  Future<void> saveUserPermissions(List<String> permissions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_userPermissionsKey, permissions);
  }

  Future<List<String>> getUserPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_userPermissionsKey) ?? [];
  }

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<void> saveSelectedVehicle(String email, VehicleModel vehicle) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sel_veh_id_$email', vehicle.id);
    await prefs.setString('sel_veh_brand_$email', vehicle.brand);
    await prefs.setString('sel_veh_name_$email', vehicle.name);
    await prefs.setString('sel_veh_year_$email', vehicle.year);
    await prefs.setString('sel_veh_type_$email',
        vehicle.type == VehicleType.ev ? 'ev' : 'petrol');
    await prefs.setBool('has_selected_vehicle_$email', true);
  }

  Future<void> removeSelectedVehicle(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_selected_vehicle_$email', false);
  }

  Future<VehicleModel?> getSelectedVehicle(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final hasVehicle = prefs.getBool('has_selected_vehicle_$email') ?? false;
    if (!hasVehicle) return null;

    final id = prefs.getString('sel_veh_id_$email') ?? '';
    final brand = prefs.getString('sel_veh_brand_$email') ?? '';
    final name = prefs.getString('sel_veh_name_$email') ?? '';
    final year = prefs.getString('sel_veh_year_$email') ?? '';
    final typeStr = prefs.getString('sel_veh_type_$email') ?? 'ev';
    final type = typeStr == 'ev' ? VehicleType.ev : VehicleType.petrol;

    return VehicleModel(
      id: id,
      brand: brand,
      name: name,
      year: year,
      type: type,
    );
  }

  Future<bool> hasPermission(String permission) async {
    final role = await getUserRole();
    if (role == 'owner') return true; // Owner receives all permissions
    final perms = await getUserPermissions();
    return perms.contains(permission);
  }

  Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', phone);
  }

  Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_phone');
  }

  Future<void> saveUserImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image', url);
  }

  Future<String?> getUserImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_image');
  }
}
