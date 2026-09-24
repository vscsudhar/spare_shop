import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/core/services/vehicle_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class VehicleSelectorViewModel extends BaseViewModel with NavigationMixin {
  final _tokenService = locator<TokenService>();
  final _vehicleService = locator<VehicleService>();

  List<VehicleModel> _vehicles = [];
  List<VehicleModel> get vehicles =>
      _vehicles.isNotEmpty ? _vehicles : userVehicles;
  VehicleModel? get selectedVehicle => currentSelectedVehicle;

  Future<void> init() async {
    setBusy(true);
    try {
      final apiVehicles = await _vehicleService.getVehicles();
      if (apiVehicles.isNotEmpty) {
        _vehicles = apiVehicles;
        userVehicles = apiVehicles;

        final email = await _tokenService.getUserEmail();
        if (email != null) {
          final saved = await _tokenService.getSelectedVehicle(email);
          if (saved != null && _vehicles.any((v) => v.id == saved.id)) {
            currentSelectedVehicle =
                _vehicles.firstWhere((v) => v.id == saved.id);
          } else if (_vehicles.isNotEmpty) {
            currentSelectedVehicle = _vehicles.first;
            await _tokenService.saveSelectedVehicle(email, _vehicles.first);
          }
        }
      } else {
        // If DB has no vehicles yet, check local storage / userVehicles and sync to DB
        final email = await _tokenService.getUserEmail();
        if (email != null) {
          final localVeh = await _tokenService.getSelectedVehicle(email);
          if (localVeh != null && localVeh.name.isNotEmpty) {
            try {
              final synced = await _vehicleService.addVehicle(localVeh);
              _vehicles = [synced];
              userVehicles = [synced];
              currentSelectedVehicle = synced;
              await _tokenService.saveSelectedVehicle(email, synced);
            } catch (_) {
              _vehicles = [localVeh];
            }
          } else if (userVehicles.isNotEmpty &&
              userVehicles.first.name.isNotEmpty) {
            try {
              final synced =
                  await _vehicleService.addVehicle(userVehicles.first);
              _vehicles = [synced];
              userVehicles = [synced];
              currentSelectedVehicle = synced;
              await _tokenService.saveSelectedVehicle(email, synced);
            } catch (_) {
              _vehicles = userVehicles;
            }
          }
        }
      }
    } catch (e) {
      _vehicles = userVehicles;
    } finally {
      setBusy(false);
    }
  }

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
