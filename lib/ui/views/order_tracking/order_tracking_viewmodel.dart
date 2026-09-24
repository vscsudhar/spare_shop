import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/order_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class OrderTrackingViewModel extends BaseViewModel with NavigationMixin {
  final _orderService = locator<OrderService>();

  OrderModel? _order;
  bool _isLoading = true;
  String? _errorMessage;

  OrderModel get order =>
      _order ??
      (mockOrderList.isNotEmpty
          ? mockOrderList.last
          : OrderModel(
              id: 'ord_preview',
              orderNumber: 'ORD-LIVE',
              date: DateTime.now(),
              status: OrderStatus.processing,
              items: const [],
              total: 0.0,
              address: mockAddresses[0],
              paymentMethod: 'Cash on Delivery',
            ));

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> init({String? orderId, OrderModel? initialOrder}) async {
    if (initialOrder != null) {
      _order = initialOrder;
      _isLoading = false;
      rebuildUi();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    rebuildUi();

    try {
      if (orderId != null && orderId.isNotEmpty) {
        _order = await _orderService.getMyOrderById(orderId);
      } else {
        final orders = await _orderService.getMyOrders();
        if (orders.isNotEmpty) {
          _order = orders.first;
        }
      }
    } catch (e) {
      _errorMessage = 'Could not load live order tracking: $e';
    } finally {
      _isLoading = false;
      rebuildUi();
    }
  }

  String get formattedOrderDate {
    final d = order.date;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[d.month - 1];
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final amPm = d.hour >= 12 ? 'PM' : 'AM';
    final minute = d.minute.toString().padLeft(2, '0');
    return '${d.day.toString().padLeft(2, '0')} $month ${d.year}, ${hour.toString().padLeft(2, '0')}:$minute $amPm';
  }

  String get statusBadgeText {
    switch (order.status) {
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get estimatedDeliveryText {
    if (order.status == OrderStatus.delivered) {
      return 'Delivered successfully';
    }
    if (order.status == OrderStatus.cancelled) {
      return 'Order cancelled';
    }
    final estDate = order.date.add(const Duration(days: 2));
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return 'Estimated Delivery: ${weekdays[estDate.weekday - 1]}, ${estDate.day} ${months[estDate.month - 1]} by 6:00 PM';
  }

  List<OrderTrackingStepModel> get trackingSteps {
    final isCancelled = order.status == OrderStatus.cancelled;
    final isDelivered = order.status == OrderStatus.delivered;
    final isShipped = order.status == OrderStatus.shipped || isDelivered;
    final isProcessing =
        order.status == OrderStatus.processing || isShipped || isDelivered;

    if (isCancelled) {
      return [
        OrderTrackingStepModel(
          title: 'Order Placed',
          description: 'Your order was submitted.',
          timeString: formattedOrderDate,
          isCompleted: true,
          isCurrent: false,
        ),
        const OrderTrackingStepModel(
          title: 'Order Cancelled',
          description: 'This order has been cancelled and refunded if prepaid.',
          timeString: 'Cancelled',
          isCompleted: true,
          isCurrent: true,
        ),
      ];
    }

    final placedTime = formattedOrderDate;

    return [
      OrderTrackingStepModel(
        title: 'Order Placed & Verified',
        description:
            'Order #${order.orderNumber} placed via ${order.paymentMethod}.',
        timeString: placedTime,
        isCompleted: true,
        isCurrent: order.status == OrderStatus.processing,
      ),
      OrderTrackingStepModel(
        title: 'Packed & Hub Assigned',
        description: order.locationName != null && order.locationName!.isNotEmpty
            ? 'Processed at ${order.locationName} Hub for dispatch.'
            : 'Packed and verified by VoltSpare fulfillment center.',
        timeString: isProcessing ? 'Completed' : 'In Progress',
        isCompleted: isProcessing,
        isCurrent: order.status == OrderStatus.processing,
      ),
      OrderTrackingStepModel(
        title: 'In Transit / Dispatched',
        description: isShipped
            ? 'Package is on the way to your shipping address.'
            : 'Awaiting dispatch from local hub.',
        timeString: isShipped ? 'On the way' : 'Pending',
        isCompleted: isShipped,
        isCurrent: order.status == OrderStatus.shipped,
      ),
      OrderTrackingStepModel(
        title: 'Delivered',
        description: isDelivered
            ? 'Delivered to ${order.address.name} at ${order.address.city ?? "Destination"}.'
            : 'Package will be handed over to recipient.',
        timeString: isDelivered ? 'Delivered' : 'Estimated soon',
        isCompleted: isDelivered,
        isCurrent: isDelivered,
      ),
    ];
  }

  void goHome() {
    clearStackAndShowHome();
  }
}
