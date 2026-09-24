import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'order_tracking_viewmodel.dart';

class OrderTrackingView extends StackedView<OrderTrackingViewModel> {
  final String? orderId;
  final OrderModel? order;

  const OrderTrackingView({
    Key? key,
    this.orderId,
    this.order,
  }) : super(key: key);

  @override
  void onViewModelReady(OrderTrackingViewModel viewModel) {
    viewModel.init(orderId: orderId, initialOrder: order);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    OrderTrackingViewModel viewModel,
    Widget? child,
  ) {
    if (viewModel.isLoading) {
      return Scaffold(
        backgroundColor: kcVoltSpareOffWhite,
        appBar: VoltSpareAppBar(
          title: 'Track Order',
          showBackButton: true,
          onBackPressed: viewModel.goHome,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: kcVoltSpareDark,
          ),
        ),
      );
    }

    final order = viewModel.order;

    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: 'Track Order',
        showBackButton: true,
        onBackPressed: viewModel.goHome,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header Card
                  _buildHeaderCard(context, viewModel, order),
                  const SizedBox(height: 20),

                  // Shipping & Delivery Details Card
                  _buildDeliveryAddressCard(order),
                  const SizedBox(height: 20),

                  // Order Items & Pricing Breakdown Card
                  _buildOrderItemsCard(order),
                  const SizedBox(height: 24),

                  // Tracking Steps Timeline
                  const Text(
                    'Tracking Status',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeline(viewModel),

                  const SizedBox(height: 32),

                  PrimaryActionButton(
                    label: 'Back to Home',
                    onPressed: viewModel.goHome,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    OrderTrackingViewModel viewModel,
    OrderModel order,
  ) {
    Color badgeBgColor = kcVoltSpareEVGreen.withValues(alpha: 0.2);
    Color badgeTextColor = kcVoltSpareEVGreen;

    if (order.status == OrderStatus.cancelled) {
      badgeBgColor = Colors.redAccent.withValues(alpha: 0.2);
      badgeTextColor = Colors.redAccent;
    } else if (order.status == OrderStatus.processing) {
      badgeBgColor = Colors.amber.withValues(alpha: 0.2);
      badgeTextColor = Colors.amber.shade300;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kcVoltSpareDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.formattedOrderDate,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  viewModel.statusBadgeText,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: kcVoltSpareEVGreen,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  viewModel.estimatedDeliveryText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddressCard(OrderModel order) {
    final addr = order.address;
    final fullStreet = [
      if (addr.addressLine1 != null && addr.addressLine1!.isNotEmpty)
        addr.addressLine1
      else if (addr.addressLine.isNotEmpty)
        addr.addressLine,
      if (addr.addressLine2 != null && addr.addressLine2!.isNotEmpty)
        addr.addressLine2,
    ].join(', ');

    final cityStatePin = [
      if (addr.city != null && addr.city!.isNotEmpty) addr.city,
      if (addr.state != null && addr.state!.isNotEmpty) addr.state,
      if (addr.postalCode != null && addr.postalCode!.isNotEmpty)
        'PIN: ${addr.postalCode}',
    ].join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kcVoltSpareBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_rounded, color: kcPrimaryColor, size: 18),
              SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: TextStyle(
                  color: kcVoltSpareTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            addr.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: kcVoltSpareDark,
            ),
          ),
          if (fullStreet.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              fullStreet,
              style: const TextStyle(
                color: kcVoltSpareTextSecondary,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ],
          if (cityStatePin.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              cityStatePin,
              style: const TextStyle(
                color: kcVoltSpareTextSecondary,
                fontSize: 13,
              ),
            ),
          ],
          if (addr.phone.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.phone_outlined,
                    size: 14, color: kcVoltSpareTextSecondary),
                const SizedBox(width: 6),
                Text(
                  'Phone: ${addr.phone}',
                  style: const TextStyle(
                    color: kcVoltSpareTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (order.locationName != null && order.locationName!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kcVoltSpareOffWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kcVoltSpareBorder.withValues(alpha: 0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storefront_rounded,
                      size: 14, color: kcVoltSpareDark),
                  const SizedBox(width: 6),
                  Text(
                    'Fulfilled by: ${order.locationName}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kcVoltSpareDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kcVoltSpareBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: kcPrimaryColor, size: 18),
              SizedBox(width: 8),
              Text(
                'Order Items',
                style: TextStyle(
                  color: kcVoltSpareTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (order.items.isEmpty)
            const Text(
              'No item details available.',
              style: TextStyle(color: kcVoltSpareTextSecondary, fontSize: 13),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final item = order.items[index];
                final itemPrice = item.product.price;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: kcVoltSpareOffWhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.build_circle_outlined,
                          color: kcVoltSpareTextSecondary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: kcVoltSpareDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Qty: ${item.quantity} × ₹${itemPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: kcVoltSpareTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${(itemPrice * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: kcVoltSpareDark,
                      ),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Price summary rows
          _buildSummaryRow(
            'Subtotal',
            '₹${(order.subTotal > 0 ? order.subTotal : order.total).toStringAsFixed(2)}',
          ),
          if (order.taxAmount > 0) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
                'GST & Taxes (18%)', '₹${order.taxAmount.toStringAsFixed(2)}'),
          ],
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Delivery Charges',
            order.deliveryFee == 0
                ? 'FREE'
                : '₹${order.deliveryFee.toStringAsFixed(2)}',
            isGreen: order.deliveryFee == 0,
          ),
          if (order.discountAmount > 0) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'Coupon Discount',
              '-₹${order.discountAmount.toStringAsFixed(2)}',
              isGreen: true,
            ),
          ],
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount Paid',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: kcVoltSpareDark,
                ),
              ),
              Text(
                '₹${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kcVoltSpareEVGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kcVoltSpareTextSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isGreen ? kcVoltSpareEVGreen : kcVoltSpareDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(OrderTrackingViewModel viewModel) {
    final steps = viewModel.trackingSteps;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isCompleted = step.isCompleted;
        final isCurrent = step.isCurrent;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: dot & line
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? kcVoltSpareEVGreen
                        : (isCurrent ? Colors.amber : Colors.grey[200]),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? kcVoltSpareEVGreen
                          : (isCurrent ? Colors.amber : kcVoltSpareBorder),
                      width: 2.5,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2.0,
                    height: 52,
                    color: isCompleted ? kcVoltSpareEVGreen : kcVoltSpareBorder,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Right column: details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          color: isCompleted || isCurrent
                              ? kcVoltSpareDark
                              : kcVoltSpareTextSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (step.timeString.isNotEmpty)
                        Text(
                          step.timeString,
                          style: TextStyle(
                            color: isCompleted
                                ? kcVoltSpareEVGreen
                                : kcVoltSpareTextSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: const TextStyle(
                      color: kcVoltSpareTextSecondary,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  OrderTrackingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OrderTrackingViewModel();
}
