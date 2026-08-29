import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:spare_shop/ui/widgets/common/shop_components.dart';
import 'package:stacked/stacked.dart';

import 'wishlist_viewmodel.dart';

class WishlistView extends StackedView<WishlistViewModel> {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    WishlistViewModel viewModel,
    Widget? child,
  ) {
    return ShopResponsiveScaffold(
      currentTab: viewModel.currentTab,
      onTabSelected: viewModel.onTabSelected,
      bodyBuilder: (context, sizingInformation) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = responsiveGridCount(
              availableWidth: constraints.maxWidth,
              minItemWidth: sizingInformation.isDesktop ? 210 : 160,
              spacing: 16,
              maxColumns: sizingInformation.isDesktop ? 5 : 3,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsivePageHeader(
                  title: 'My Wishlist',
                  sizingInformation: sizingInformation,
                  onBack: viewModel.goBack,
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: viewModel.products.isEmpty
                      ? EmptyStateWidget(
                          title: 'Wishlist is empty',
                          description:
                              'Save products you love here and come back to them anytime.',
                          buttonLabel: 'Browse Products',
                          onPressed: () => viewModel.onTabSelected(AppTab.home),
                        )
                      : GridView.builder(
                          itemCount: viewModel.products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio:
                                sizingInformation.isDesktop ? 0.8 : 0.74,
                          ),
                          itemBuilder: (context, index) {
                            final product = viewModel.products[index];
                            return ProductCard(
                              product: product,
                              showFavorite: true,
                              onTap: () =>
                                  viewModel.openProductDetails(product),
                              onFavoriteToggle: () =>
                                  viewModel.toggleFavorite(product.id),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  WishlistViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      WishlistViewModel();
}
