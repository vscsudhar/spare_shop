import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'order_tracking_viewmodel.dart';

import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';

class OrderTrackingView extends StackedView<OrderTrackingViewModel> {
  const OrderTrackingView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OrderTrackingViewModel viewModel,
    Widget? child,
  ) {
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
              constraints: const BoxConstraints(maxWidth: 550),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order header card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kcVoltSpareDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.orderNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    kcVoltSpareEVGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'In Transit',
                                style: TextStyle(
                                    color: kcVoltSpareEVGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Estimated Delivery: Tomorrow, 6:00 PM',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Shipping details card
                  const Text(
                    'Delivery Details',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kcVoltSpareWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kcVoltSpareBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.address.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          order.address.addressLine,
                          style: const TextStyle(
                              color: kcVoltSpareTextSecondary,
                              fontSize: 12,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

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

                  const SizedBox(height: 40),

                  PrimaryActionButton(
                    label: 'Go back to Home',
                    onPressed: viewModel.goHome,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: dot & line
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isCompleted ? kcVoltSpareEVGreen : kcLightGrey,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isCompleted ? kcVoltSpareEVGreen : kcVoltSpareBorder,
                      width: 2.0,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2.0,
                    height: 50,
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
                  Text(
                    step.title,
                    style: TextStyle(
                      color: isCompleted
                          ? kcVoltSpareTextPrimary
                          : kcVoltSpareTextSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
                  if (step.timeString.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      step.timeString,
                      style: const TextStyle(
                        color: kcVoltSpareTextSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
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
