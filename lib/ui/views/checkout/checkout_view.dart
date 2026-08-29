import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'checkout_viewmodel.dart';

class CheckoutView extends StackedView<CheckoutViewModel> {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CheckoutViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;

        final detailsColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Shipping Address',
                  style: TextStyle(
                    color: kcVoltSpareTextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add_circle_outline_rounded,
                      size: 16, color: kcVoltSpareEVGreen),
                  label: const Text(
                    'Add New',
                    style: TextStyle(
                      color: kcVoltSpareEVGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  onPressed: viewModel.navigateToAddAddress,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Addresses List
            ...viewModel.addresses.map((address) {
              final isSelected = viewModel.selectedAddress?.id == address.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: kcVoltSpareWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareBorder,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: RadioListTile<AddressModel>(
                  title: Text(
                    address.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${address.addressLine}\nPhone: ${address.phone}',
                      style: const TextStyle(
                          color: kcVoltSpareTextSecondary,
                          fontSize: 12,
                          height: 1.4),
                    ),
                  ),
                  value: address,
                  groupValue: viewModel.selectedAddress,
                  activeColor: kcVoltSpareEVGreen,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onChanged: (val) {
                    if (val != null) viewModel.selectAddress(val);
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            // Order Items mini summary
            const Text(
              'Items Summary',
              style: TextStyle(
                color: kcVoltSpareTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kcVoltSpareWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kcVoltSpareBorder),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.items.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: kcVoltSpareBorder, height: 20),
                itemBuilder: (context, index) {
                  final item = viewModel.items[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: const TextStyle(
                              fontSize: 13, color: kcVoltSpareTextPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'x${item.quantity}',
                        style: const TextStyle(
                            fontSize: 13, color: kcVoltSpareTextSecondary),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '₹${(item.product.price * item.quantity).toInt()}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
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
                  'Billing Summary',
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
                  'Delivery Charges',
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
                      'Total Amount',
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
                  label: 'Proceed to Payment',
                  onPressed: viewModel.selectedAddress != null &&
                          viewModel.items.isNotEmpty
                      ? viewModel.proceedToPayment
                      : null,
                ),
              ],
            ),
          ),
        );

        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'Checkout',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 1200,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left panel details
                          Expanded(
                            flex: 7,
                            child: SingleChildScrollView(child: detailsColumn),
                          ),
                          const SizedBox(width: 24),
                          // Right panel billing
                          SizedBox(
                            width: 380,
                            child: summaryCard,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(child: detailsColumn),
                          ),
                          const SizedBox(height: 16),
                          summaryCard,
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _billingRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: kcVoltSpareTextSecondary, fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isGreen ? kcVoltSpareEVGreen : kcVoltSpareTextPrimary,
          ),
        ),
      ],
    );
  }

  @override
  CheckoutViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CheckoutViewModel();
}
