import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'wishlist_viewmodel.dart';

class WishlistView extends StackedView<WishlistViewModel> {
  const WishlistView({Key? key}) : super(key: key);

  int getCrossAxisCount(double width) {
    if (width >= 1400) return 5;
    if (width >= 1000) return 4;
    if (width >= 700) return 3;
    return 2;
  }

  @override
  Widget builder(
    BuildContext context,
    WishlistViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'Wishlist',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 1200,
              child: _buildBody(context, viewModel),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    WishlistViewModel viewModel,
  ) {
    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(color: kcVoltSpareEVGreen),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: kcVoltSpareTextSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage.isNotEmpty
                    ? viewModel.errorMessage
                    : 'Failed to load wishlist.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: kcVoltSpareTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: viewModel.refresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcVoltSpareDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5277).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  size: 52,
                  color: Color(0xFFFF5277),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your wishlist is empty',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kcVoltSpareTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Save products you like and find them here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: kcVoltSpareTextSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: viewModel.browseProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcVoltSpareEVGreen,
                  foregroundColor: kcVoltSpareDark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text(
                  'Browse Products',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = getCrossAxisCount(constraints.maxWidth);

        return RefreshIndicator(
          color: kcVoltSpareEVGreen,
          onRefresh: viewModel.refresh,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.70,
            ),
            itemBuilder: (context, index) {
              final product = viewModel.products[index];
              return WishlistProductCard(
                product: product,
                isLoading: viewModel.isProductLoading(product.id),
                onTap: () => viewModel.openProductDetails(product),
                onWishlistTap: () => viewModel.toggleWishlist(product, context),
                onAddToCart: () => viewModel.addToCart(product, context),
              );
            },
          ),
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
