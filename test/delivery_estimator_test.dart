import 'package:flutter_test/flutter_test.dart';
import 'package:spare_shop/ui/common/delivery_estimator.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';

void main() {
  group('Phase 23 DeliveryEstimator Tests', () {
    const testDate = 2026;
    const testMonth = 9;
    const testDay = 2;

    // Helper to construct IST test times directly
    DateTime makeIstTime(int hour, int minute, [int second = 0]) {
      return DateTime(testDate, testMonth, testDay, hour, minute, second);
    }

    ProductModel createProduct({
      required String id,
      required String name,
      required bool stockManaged,
      int? stockQuantity,
    }) {
      return ProductModel(
        id: id,
        name: name,
        price: 450.0,
        rating: 4.5,
        description: 'Test product',
        categoryId: 'cat_test',
        stockManaged: stockManaged,
        stockCount: stockQuantity,
      );
    }

    test('TEST 1: stockManaged=true, stockQuantity=10, time=10:00 AM -> In Stock, Same Day Delivery', () {
      final product = createProduct(
        id: 'p1',
        name: 'Brake Shoe',
        stockManaged: true,
        stockQuantity: 10,
      );
      final time = makeIstTime(10, 0); // 10:00 AM
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.availabilityStatus, 'In Stock');
      expect(estimate.title, 'Same Day Delivery');
      expect(estimate.cutoffNote, 'Order before 3:00 PM');
      expect(estimate.type, DeliveryType.sameDay);
      expect(estimate.isAvailable, true);
    });

    test('TEST 2: stockManaged=true, stockQuantity=1, time=2:59 PM -> Same Day Delivery', () {
      final product = createProduct(
        id: 'p2',
        name: 'Brake Shoe',
        stockManaged: true,
        stockQuantity: 1,
      );
      final time = makeIstTime(14, 59); // 2:59 PM
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.title, 'Same Day Delivery');
      expect(estimate.type, DeliveryType.sameDay);
      expect(estimate.isAvailable, true);
    });

    test('TEST 3: stockManaged=true, stockQuantity=5, time=3:00 PM -> Same Day Delivery', () {
      final product = createProduct(
        id: 'p3',
        name: 'Brake Shoe',
        stockManaged: true,
        stockQuantity: 5,
      );
      final time = makeIstTime(15, 0, 0); // 3:00:00 PM exactly
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.title, 'Same Day Delivery');
      expect(estimate.type, DeliveryType.sameDay);
      expect(estimate.isAvailable, true);
    });

    test('TEST 4: stockManaged=true, stockQuantity=5, time=3:01 PM -> Next Day Delivery', () {
      final product = createProduct(
        id: 'p4',
        name: 'Brake Shoe',
        stockManaged: true,
        stockQuantity: 5,
      );
      final time = makeIstTime(15, 1); // 3:01 PM
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.title, 'Next Day Delivery');
      expect(estimate.availabilityStatus, 'In Stock');
      expect(estimate.cutoffNote, 'Same-day cutoff was 3:00 PM');
      expect(estimate.type, DeliveryType.nextDay);
      expect(estimate.isAvailable, true);
    });

    test('TEST 5: stockManaged=true, stockQuantity=5, time=8:00 PM -> Next Day Delivery', () {
      final product = createProduct(
        id: 'p5',
        name: 'Brake Shoe',
        stockManaged: true,
        stockQuantity: 5,
      );
      final time = makeIstTime(20, 0); // 8:00 PM
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.title, 'Next Day Delivery');
      expect(estimate.type, DeliveryType.nextDay);
      expect(estimate.isAvailable, true);
    });

    test('TEST 6: stockManaged=false, stockQuantity=null, time=10:00 AM -> Available on Order, Delivery in 2 Days', () {
      final product = createProduct(
        id: 'p6',
        name: 'Ola Body Panel',
        stockManaged: false,
        stockQuantity: null,
      );
      final time = makeIstTime(10, 0); // 10:00 AM
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.availabilityStatus, 'Available on Order');
      expect(estimate.title, 'Delivery in 2 Days');
      expect(estimate.type, DeliveryType.twoDays);
      expect(estimate.isAvailable, true);
    });

    test('TEST 7: stockManaged=false, stockQuantity=null, time=5:00 PM -> Available on Order, Delivery in 2 Days', () {
      final product = createProduct(
        id: 'p7',
        name: 'Ola Body Panel',
        stockManaged: false,
        stockQuantity: null,
      );
      final time = makeIstTime(17, 0); // 5:00 PM
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.availabilityStatus, 'Available on Order');
      expect(estimate.title, 'Delivery in 2 Days');
      expect(estimate.type, DeliveryType.twoDays);
      expect(estimate.isAvailable, true);
    });

    test('TEST 8: stockManaged=true, stockQuantity=0 -> Out of Stock', () {
      final product = createProduct(
        id: 'p8',
        name: 'Brake Shoe',
        stockManaged: true,
        stockQuantity: 0,
      );
      final time = makeIstTime(10, 0); // 10:00 AM
      final estimate = DeliveryEstimator.getEstimate(
        product,
        businessTime: time,
        isAlreadyBusinessTime: true,
      );

      expect(estimate.availabilityStatus, 'Out of Stock');
      expect(estimate.title, 'Out of Stock');
      expect(estimate.type, DeliveryType.outOfStock);
      expect(estimate.isAvailable, false);
    });

    test('TEST 9: Mixed Cart before 3 PM -> Product A: Same Day, Product B: 2 Days, Cart: Within 2 Days', () {
      final productA = createProduct(
        id: 'prod_a',
        name: 'Product A (Stock)',
        stockManaged: true,
        stockQuantity: 10,
      );
      final productB = createProduct(
        id: 'prod_b',
        name: 'Product B (On-Demand)',
        stockManaged: false,
        stockQuantity: null,
      );

      final time = makeIstTime(11, 0); // 11:00 AM

      final estA = DeliveryEstimator.getEstimate(productA,
          businessTime: time, isAlreadyBusinessTime: true);
      final estB = DeliveryEstimator.getEstimate(productB,
          businessTime: time, isAlreadyBusinessTime: true);

      expect(estA.title, 'Same Day Delivery');
      expect(estB.title, 'Delivery in 2 Days');

      final cartItems = [
        CartItemModel(id: 'c1', product: productA, quantity: 1),
        CartItemModel(id: 'c2', product: productB, quantity: 1),
      ];

      final summary = DeliveryEstimator.getCartDeliverySummary(cartItems,
          businessTime: time, isAlreadyBusinessTime: true);

      expect(summary.summaryLabel,
          'Estimated complete delivery: Within 2 Days');
      expect(summary.isMixed, true);
      expect(summary.secondaryNote, 'Some items will be delivered separately');
    });

    test('TEST 10: Mixed Cart after 3 PM -> Product A: Next Day, Product B: 2 Days, Cart: Within 2 Days', () {
      final productA = createProduct(
        id: 'prod_a',
        name: 'Product A (Stock)',
        stockManaged: true,
        stockQuantity: 10,
      );
      final productB = createProduct(
        id: 'prod_b',
        name: 'Product B (On-Demand)',
        stockManaged: false,
        stockQuantity: null,
      );

      final time = makeIstTime(15, 30); // 3:30 PM (after cutoff)

      final estA = DeliveryEstimator.getEstimate(productA,
          businessTime: time, isAlreadyBusinessTime: true);
      final estB = DeliveryEstimator.getEstimate(productB,
          businessTime: time, isAlreadyBusinessTime: true);

      expect(estA.title, 'Next Day Delivery');
      expect(estB.title, 'Delivery in 2 Days');

      final cartItems = [
        CartItemModel(id: 'c1', product: productA, quantity: 1),
        CartItemModel(id: 'c2', product: productB, quantity: 1),
      ];

      final summary = DeliveryEstimator.getCartDeliverySummary(cartItems,
          businessTime: time, isAlreadyBusinessTime: true);

      expect(summary.summaryLabel,
          'Estimated complete delivery: Within 2 Days');
      expect(summary.isMixed, true);
    });

    test('Quantity limits and getters test', () {
      final stockManaged = createProduct(
        id: 'sm',
        name: 'Stock Managed',
        stockManaged: true,
        stockQuantity: 5,
      );
      expect(stockManaged.isStockManaged, true);
      expect(stockManaged.stockQuantity, 5);
      expect(stockManaged.isInStock, true);

      final outOfStock = createProduct(
        id: 'oos',
        name: 'Out of Stock',
        stockManaged: true,
        stockQuantity: 0,
      );
      expect(outOfStock.isStockManaged, true);
      expect(outOfStock.stockQuantity, 0);
      expect(outOfStock.isInStock, false);

      final onDemand = createProduct(
        id: 'od',
        name: 'On Demand',
        stockManaged: false,
        stockQuantity: null,
      );
      expect(onDemand.isStockManaged, false);
      expect(onDemand.stockQuantity, null);
      expect(onDemand.isInStock, true);
    });
  });
}
