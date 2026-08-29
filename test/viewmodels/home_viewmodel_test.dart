import 'package:flutter_test/flutter_test.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/ui/views/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    group('initialState -', () {
      test(
          'When initialized, categories and featuredProducts should not be empty',
          () {
        final model = getModel();
        expect(model.categories.isNotEmpty, true);
        expect(model.featuredProducts.isNotEmpty, true);
      });

      test('When initialized, default vehicle should be Ather 450X', () {
        final model = getModel();
        expect(model.selectedVehicle != null, true);
        expect(model.selectedVehicle!.name, '450X Gen 3');
        expect(model.selectedVehicle!.brand, 'Ather');
      });
    });
  });
}
