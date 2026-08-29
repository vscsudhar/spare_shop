import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:stacked/stacked.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';

class StartupViewModel extends BaseViewModel with NavigationMixin {
  final _tokenService = locator<TokenService>();

  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));
    final token = await _tokenService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      final email = await _tokenService.getUserEmail();
      if (email != null && email.isNotEmpty) {
        final vehicle = await _tokenService.getSelectedVehicle(email);
        if (vehicle != null) {
          // Initialize mock state with the user's saved vehicle
          currentSelectedVehicle = vehicle;
          userVehicles = [vehicle];
          await replaceWithHome();
          return;
        }
      }
      await replaceWithChooseVehicleType();
    } else {
      await replaceWithLogin();
    }
  }
}
