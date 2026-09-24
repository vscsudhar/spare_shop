import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';
import 'payment_viewmodel.dart';

class PaymentView extends StackedView<PaymentViewModel> {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PaymentViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;

        final paymentMethodsColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(
                color: kcVoltSpareTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            // Payment options list
            ...viewModel.options.map((option) {
              final isSelected = viewModel.selectedOption?.type == option.type;

              IconData icon = option.icon;
              String description = '';
              if (option.type == PaymentType.upi) {
                description = 'Pay instantly using GPay, PhonePe, Paytm';
              }
              if (option.type == PaymentType.card) {
                description = 'Credit or Debit Card (Visa, Mastercard, RuPay)';
              }
              if (option.type == PaymentType.cod) {
                description = 'Pay cash or scan QR upon delivery';
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: kcVoltSpareWhite,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareBorder,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: RadioListTile<PaymentOptionModel>(
                      title: Text(
                        option.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          description,
                          style: const TextStyle(
                              color: kcVoltSpareTextSecondary, fontSize: 12),
                        ),
                      ),
                      secondary: Icon(icon,
                          color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareDark),
                      value: option,
                      groupValue: viewModel.selectedOption,
                      activeColor: kcVoltSpareEVGreen,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      onChanged: (val) {
                        if (val != null) viewModel.selectOption(val);
                      },
                    ),
                  ),
                ),
              );
            }),
          ],
        );

        final summaryCard = Card(
          color: kcVoltSpareWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: kcVoltSpareBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    color: kcVoltSpareTextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                _billingRow('Subtotal', '₹${viewModel.subtotal.toInt()}'),
                const SizedBox(height: 10),
                _billingRow(
                  'Delivery Fee',
                  viewModel.deliveryFee == 0
                      ? 'FREE'
                      : '₹${viewModel.deliveryFee.toInt()}',
                  isGreen: viewModel.deliveryFee == 0,
                ),
                const SizedBox(height: 16),
                const Divider(color: kcVoltSpareBorder),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Payable',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '₹${viewModel.total.toInt()}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kcVoltSpareTextPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryActionButton(
                  label: viewModel.selectedOption?.type == PaymentType.cod
                      ? 'Place Order (COD)'
                      : 'Pay ₹${viewModel.total.toInt()}',
                  isLoading: viewModel.isBusy,
                  onPressed: viewModel.selectedOption != null &&
                          viewModel.items.isNotEmpty
                      ? viewModel.completePayment
                      : null,
                ),
              ],
            ),
          ),
        );

        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'Payment',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
          ),
          body: SafeArea(
            child: Stack(
              children: [
                MaxContentWidth(
                  maxWidth: 1200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column methods
                              Expanded(
                                flex: 7,
                                child: SingleChildScrollView(
                                    child: paymentMethodsColumn),
                              ),
                              const SizedBox(width: 24),
                              // Right Column summary
                              SizedBox(
                                width: 380,
                                child: summaryCard,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                    child: paymentMethodsColumn),
                              ),
                              const SizedBox(height: 16),
                              summaryCard,
                            ],
                          ),
                  ),
                ),

                // Loading Overlay during mock transaction processing
                if (viewModel.isBusy)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: Card(
                        color: kcVoltSpareWhite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                  color: kcVoltSpareEVGreen),
                              SizedBox(height: 16),
                              Text(
                                'Processing payment...',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Please do not close or refresh this page',
                                style: TextStyle(
                                    color: kcVoltSpareTextSecondary,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _billingRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: kcVoltSpareTextSecondary, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isGreen ? kcVoltSpareEVGreen : kcVoltSpareTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  PaymentViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PaymentViewModel();
}
