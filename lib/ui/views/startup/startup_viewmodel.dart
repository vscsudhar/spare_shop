import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/core/services/vehicle_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';

class StartupViewModel extends BaseViewModel with NavigationMixin {
  final _tokenService = locator<TokenService>();
  final _vehicleService = locator<VehicleService>();

  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));
    final token = await _tokenService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      final email = await _tokenService.getUserEmail();
      VehicleModel? vehicle;
      if (email != null && email.isNotEmpty) {
        vehicle = await _tokenService.getSelectedVehicle(email);
      }

      if (vehicle == null) {
        try {
          final backendVehicles = await _vehicleService.getVehicles();
          if (backendVehicles.isNotEmpty) {
            vehicle = backendVehicles.first;
            userVehicles = backendVehicles;
            if (email != null && email.isNotEmpty) {
              await _tokenService.saveSelectedVehicle(email, vehicle);
            }
          }
        } catch (_) {}
      }

      if (vehicle != null) {
        currentSelectedVehicle = vehicle;
        if (!userVehicles.any((v) => v.id == vehicle!.id)) {
          userVehicles.add(vehicle);
        }
        await replaceWithHome();
        return;
      }
      await replaceWithChooseVehicleType();
    } else {
      await replaceWithLogin();
    }
  }
}
