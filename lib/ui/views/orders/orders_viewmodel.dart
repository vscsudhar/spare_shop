import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/order_service.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class OrdersViewModel extends FutureViewModel<void> with NavigationMixin {
  final _orderService = locator<OrderService>();

  List<ShopOrder> _orders = [];
  OrderStatusFilter _selectedStatus = OrderStatusFilter.all;

  AppTab get currentTab => AppTab.orders;
  OrderStatusFilter get selectedStatus => _selectedStatus;

  List<ShopOrder> get filteredOrders {
    if (_selectedStatus == OrderStatusFilter.all) {
      return List.unmodifiable(_orders);
    }

    return _orders
        .where((order) => order.status == _selectedStatus)
        .toList(growable: false);
  }

  bool _initialized = false;

  @override
  Future<void> futureToRun() async {
    if (_initialized) return;
    _initialized = true;
    await loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final list = await _orderService.getMyOrders();
      _orders = list.map((order) {
        OrderStatusFilter filterStatus = OrderStatusFilter.processing;
        if (order.status == OrderStatus.shipped) {
          filterStatus = OrderStatusFilter.shipped;
        } else if (order.status == OrderStatus.delivered) {
          filterStatus = OrderStatusFilter.delivered;
        } else if (order.status == OrderStatus.cancelled) {
          filterStatus = OrderStatusFilter.cancelled;
        }

        final date = order.date;
        final dateStr =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        final itemsCount =
            order.items.fold<int>(0, (sum, i) => sum + i.quantity);

        final orderNum = order.orderNumber.isNotEmpty
            ? order.orderNumber
            : (order.id.isNotEmpty
                ? 'ORD-${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0).toUpperCase()}'
                : 'ORD-UNKNOWN');

        return ShopOrder(
          id: order.id,
          orderNumber: orderNum,
          dateLabel: dateStr,
          itemCountLabel: '$itemsCount item${itemsCount != 1 ? 's' : ''}',
          total: order.total,
          status: filterStatus,
        );
      }).toList();
      rebuildUi();
    } catch (_) {}
  }

  void selectStatus(OrderStatusFilter status) {
    _selectedStatus = status;
    rebuildUi();
  }

  Future<void> viewOrderDetails(ShopOrder order) async {
    await goToOrderTracking(orderId: order.id);
  }

  Future<void> onTabSelected(AppTab tab) async {
    int index = 0;
    if (tab == AppTab.wishlist) index = 1;
    if (tab == AppTab.cart) index = 3;
    if (tab == AppTab.profile) index = 4;
    await navigateToTab(index, currentIndex: 2);
  }
}
