import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:spare_shop/ui/widgets/common/shop_components.dart';
import 'package:stacked/stacked.dart';

import 'orders_viewmodel.dart';

class OrdersView extends StackedView<OrdersViewModel> {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    OrdersViewModel viewModel,
    Widget? child,
  ) {
    return ShopResponsiveScaffold(
      currentTab: viewModel.currentTab,
      onTabSelected: viewModel.onTabSelected,
      bodyBuilder: (context, sizingInformation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsivePageHeader(
              title: 'My Orders',
              sizingInformation: sizingInformation,
              onBack: viewModel.goBack,
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: OrderStatusFilter.values
                    .map(
                      (status) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _OrderStatusFilterButton(
                          label: orderStatusLabel(status),
                          selected: viewModel.selectedStatus == status,
                          onTap: () => viewModel.selectStatus(status),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => OrderCard(
                  order: viewModel.filteredOrders[index],
                  desktopLayout: sizingInformation.isDesktop,
                  onViewDetails: () => viewModel.viewOrderDetails(
                    viewModel.filteredOrders[index],
                  ),
                ),
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: viewModel.filteredOrders.length,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  OrdersViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      OrdersViewModel();
}

class _OrderStatusFilterButton extends StatelessWidget {
  const _OrderStatusFilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kcPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? kcPrimaryColor : kcBorderColor,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? Colors.white : kcDarkGreyColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
