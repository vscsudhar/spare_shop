import 'package:flutter_test/flutter_test.dart';
import 'package:spare_shop/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('EmptyCartViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
