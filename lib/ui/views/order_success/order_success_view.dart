import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'order_success_viewmodel.dart';

class OrderSuccessView extends StackedView<OrderSuccessViewModel> {
  const OrderSuccessView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OrderSuccessViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: kcVoltSpareEVGreen.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: kcVoltSpareEVGreen,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Message
                  const Text(
                    'Order Placed Successfully!',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your payment has been successfully processed and your order has been sent to our packaging facility. You will receive SMS updates shortly.',
                    style: TextStyle(
                      color: kcVoltSpareTextSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Actions
                  PrimaryActionButton(
                    label: 'Track Order',
                    onPressed: viewModel.viewOrderTracking,
                  ),
                  const SizedBox(height: 16),
                  SecondaryActionButton(
                    label: 'Continue Shopping',
                    onPressed: viewModel.continueShopping,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  OrderSuccessViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OrderSuccessViewModel();
}
