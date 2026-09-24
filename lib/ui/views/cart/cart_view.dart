import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/delivery_estimator.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'cart_viewmodel.dart';

class CartView extends StackedView<CartViewModel> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CartViewModel viewModel,
    Widget? child,
  ) {
    final isEmpty = viewModel.items.isEmpty;

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;

        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'My Cart',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 1200,
              child: isEmpty
                  ? _buildEmptyState(viewModel)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Side: Cart Items
                                Expanded(
                                  flex: 7,
                                  child: _buildCartItemsList(viewModel),
                                ),
                                const SizedBox(width: 24),
                                // Right Side: Summary
                                SizedBox(
                                  width: 380,
                                  child: _buildSummaryCard(context, viewModel),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                // Cart Items list
                                Expanded(child: _buildCartItemsList(viewModel)),
                                const SizedBox(height: 16),
                                // Bottom Summary
                                _buildSummaryCard(context, viewModel),
                              ],
                            ),
                    ),
            ),
          ),
          bottomNavigationBar: isDesktop || sizingInformation.isTablet
              ? null
              : VoltSpareBottomNavigation(
                  selectedIndex: viewModel.currentTabIndex,
                  onTap: viewModel.onTabSelected,
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(CartViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: kcLightGrey,
              size: 72,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: kcVoltSpareTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Looks like you haven\'t added any spare parts yet.',
              style: TextStyle(
                color: kcVoltSpareTextSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: viewModel.goBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: kcVoltSpareDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              child: const Text('Browse Products',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemsList(CartViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.items.length,
      itemBuilder: (context, index) {
        final item = viewModel.items[index];
        return _buildCartItemCard(viewModel, item);
      },
    );
  }

  Widget _buildCartItemCard(CartViewModel viewModel, CartItemModel item) {
    final estimate = DeliveryEstimator.getEstimate(item.product);
    final canIncrease = viewModel.canIncreaseItemQuantity(item);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcVoltSpareWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kcVoltSpareBorder),
      ),
      child: Row(
        children: [
          // Left: Mini icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: kcVoltSpareOffWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings_suggest_rounded,
                color: kcVoltSpareEVGreen, size: 24),
          ),
          const SizedBox(width: 14),
          // Middle: details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    color: kcVoltSpareTextPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${item.product.price.toInt()} each · Fitment: ${item.product.fitmentBadge}',
                  style: const TextStyle(
                    color: kcVoltSpareTextSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      estimate.type == DeliveryType.twoDays
                          ? Icons.schedule_rounded
                          : (estimate.type == DeliveryType.sameDay
                              ? Icons.bolt_rounded
                              : Icons.local_shipping_outlined),
                      size: 13,
                      color: estimate.type == DeliveryType.twoDays
                          ? Colors.blue.shade700
                          : kcVoltSpareEVGreen,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        estimate.title,
                        style: TextStyle(
                          color: estimate.type == DeliveryType.twoDays
                              ? Colors.blue.shade700
                              : kcVoltSpareEVGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Right: Quantity selector & Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => viewModel.removeItem(item.id),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _quantityButton(
                    Icons.remove,
                    () => viewModel.decreaseQuantity(item.id),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  _quantityButton(
                    Icons.add,
                    () => viewModel.increaseQuantity(item.id),
                    enabled: canIncrease,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed,
      {bool enabled = true}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: enabled ? kcVoltSpareOffWhite : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: enabled ? kcVoltSpareBorder : Colors.grey.shade300,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 12,
          color: enabled ? kcVoltSpareDark : Colors.grey.shade400,
        ),
        padding: EdgeInsets.zero,
        onPressed: enabled ? onPressed : null,
      ),
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, CartViewModel viewModel) {
    return Card(
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
            if (viewModel.amountNeededForFreeDelivery > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: kcVoltSpareEVGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kcVoltSpareEVGreen.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, color: kcVoltSpareEVGreen, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Add ₹${viewModel.amountNeededForFreeDelivery.toInt()} more for FREE Delivery',
                        style: const TextStyle(
                          color: kcVoltSpareEVGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            _summaryRow('Subtotal', '₹${viewModel.subtotal.toInt()}'),
            const SizedBox(height: 10),
            _summaryRow(
              'Delivery Fee',
              viewModel.deliveryFee == 0
                  ? 'FREE'
                  : '₹${viewModel.deliveryFee.toInt()}',
              isGreen: viewModel.deliveryFee == 0,
            ),
            const SizedBox(height: 10),
            _summaryRow(
              'Delivery Estimate',
              viewModel.deliverySummary.summaryLabel,
              isGreen: viewModel.deliverySummary.slowestDeliveryType ==
                  DeliveryType.sameDay,
            ),
            if (viewModel.deliverySummary.secondaryNote != null) ...[
              const SizedBox(height: 4),
              Text(
                viewModel.deliverySummary.secondaryNote!,
                style: const TextStyle(
                  fontSize: 11,
                  color: kcVoltSpareTextSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(color: kcVoltSpareBorder),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
              label: 'Proceed to Checkout',
              onPressed: viewModel.items.isNotEmpty
                  ? () => viewModel.proceedToCheckout(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false}) {
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
  CartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CartViewModel();
}
