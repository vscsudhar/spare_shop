import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:stacked/stacked.dart';

class ChooseVehicleTypeViewModel extends BaseViewModel with NavigationMixin {
  void selectEv() {
    goToSelectEv();
  }

  void selectPetrol() {
    goToSelectPetrolBike();
  }
}
