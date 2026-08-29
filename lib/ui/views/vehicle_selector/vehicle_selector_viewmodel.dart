import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class VehicleSelectorViewModel extends BaseViewModel with NavigationMixin {
  final _tokenService = locator<TokenService>();

  List<VehicleModel> get vehicles => userVehicles;
  VehicleModel? get selectedVehicle => currentSelectedVehicle;

  void selectPrimaryVehicle(VehicleModel vehicle) async {
    currentSelectedVehicle = vehicle;
    final email = await _tokenService.getUserEmail();
    if (email != null) {
      await _tokenService.saveSelectedVehicle(email, vehicle);
    }
    notifyListeners();
  }

  void addVehicle() {
    goToChooseVehicleType();
  }

  void goBackHome() {
    clearStackAndShowHome();
  }
}
