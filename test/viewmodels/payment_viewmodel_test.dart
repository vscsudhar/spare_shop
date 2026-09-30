import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/ui/views/payment/payment_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('PaymentViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    test('goBack calls navigationService.back()', () {
      final model = PaymentViewModel();
      final navigationService = locator<NavigationService>();
      model.goBack();
      verify(navigationService.back()).called(1);
    });
  });
}

