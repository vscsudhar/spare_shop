import 'package:flutter/material.dart';
import 'package:spare_shop/ui/widgets/common/shop_components.dart';
import 'package:stacked/stacked.dart';

import 'empty_cart_viewmodel.dart';

class EmptyCartView extends StackedView<EmptyCartViewModel> {
  const EmptyCartView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    EmptyCartViewModel viewModel,
    Widget? child,
  ) {
    return ShopResponsiveScaffold(
      currentTab: viewModel.currentTab,
      onTabSelected: viewModel.onTabSelected,
      bodyBuilder: (context, sizingInformation) {
        return EmptyStateWidget(
          title: 'Your cart is empty',
          description:
              'Looks like you haven\'t added anything to your cart yet.',
          buttonLabel: 'Start Shopping',
          onPressed: viewModel.navigateToHome,
        );
      },
    );
  }

  @override
  EmptyCartViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      EmptyCartViewModel();
}
