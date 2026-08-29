import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class OrderTrackingViewModel extends BaseViewModel with NavigationMixin {
  OrderModel get order {
    if (mockOrderList.isNotEmpty) {
      return mockOrderList.last;
    }

    // Fallback dummy order for tracking preview
    return OrderModel(
      id: 'ord_preview',
      orderNumber: 'VS-98746352',
      date: DateTime.now().subtract(const Duration(hours: 4)),
      status: OrderStatus.processing,
      items: [
        CartItemModel(
          id: 'item_1',
          product: mockProducts[2], // Ola Brake Pad
          quantity: 1,
        )
      ],
      total: mockProducts[2].price,
      address: mockAddresses[0],
      paymentMethod: 'UPI (Google Pay)',
    );
  }

  List<OrderTrackingStepModel> get trackingSteps => mockTrackingSteps;

  void goHome() {
    clearStackAndShowHome();
  }
}
