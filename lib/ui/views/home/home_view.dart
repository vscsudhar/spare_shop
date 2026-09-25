import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmationDialog(context);
        if (shouldExit == true) {
          await SystemNavigator.pop();
        }
      },
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          final isDesktop = sizingInformation.isDesktop;

          return Scaffold(
            backgroundColor: kcVoltSpareOffWhite,
            appBar: const VoltSpareAppBar(
              title: 'VoltSpare',
              showBackButton: false,
            ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 1200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 16),

                    // Vehicle Selector Widget
                    if (viewModel.selectedVehicle != null)
                      VehicleSummaryCard(
                        vehicle: viewModel.selectedVehicle!,
                        onChangePressed: viewModel.selectVehicle,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kcVoltSpareDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'No vehicle selected',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: viewModel.selectVehicle,
                              child: const Text('Add Vehicle'),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Search bar
                    GestureDetector(
                      onTap: viewModel.openSearch,
                      child: AbsorbPointer(
                        child: AppSearchField(
                          controller: viewModel.searchController,
                          hintText: 'Search matching spare parts...',
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Rare request banner
                    _buildRareRequestBanner(context, viewModel),

                    const SizedBox(height: 28),

                    // Categories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(
                            color: kcVoltSpareTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (viewModel.selectedCategoryId != null)
                          TextButton(
                            onPressed: () => viewModel.selectCategory(null),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Show All',
                              style: TextStyle(
                                color: kcVoltSpareEVGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.categories.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            final isAllSelected =
                                viewModel.selectedCategoryId == null;
                            return InkWell(
                              onTap: () => viewModel.selectCategory(null),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isAllSelected
                                      ? kcVoltSpareDark
                                      : kcVoltSpareWhite,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isAllSelected
                                        ? kcVoltSpareDark
                                        : kcVoltSpareBorder,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.grid_view_rounded,
                                      size: 20,
                                      color: isAllSelected
                                          ? kcVoltSpareEVGreen
                                          : kcVoltSpareTextSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'All Parts',
                                      style: TextStyle(
                                        color: isAllSelected
                                            ? Colors.white
                                            : kcVoltSpareTextPrimary,
                                        fontWeight: isAllSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final category = viewModel.categories[index - 1];
                          final isSelected =
                              viewModel.selectedCategoryId == category.id;
                          return CategoryCard(
                            category: category,
                            isSelected: isSelected,
                            onTap: () => viewModel.selectCategory(category.id),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Compatible parts if vehicle is selected
                    if (viewModel.selectedVehicle != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            viewModel.selectedCategoryId != null
                                ? '${viewModel.selectedCategory?.name ?? 'Category'} for ${viewModel.selectedVehicle!.name}'
                                : 'Fits Your ${viewModel.selectedVehicle!.name}',
                            style: const TextStyle(
                              color: kcVoltSpareTextPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      viewModel.compatibleProducts.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                viewModel.selectedCategoryId != null
                                    ? 'No items in "${viewModel.selectedCategory?.name ?? 'this category'}" matching your vehicle.'
                                    : 'No items matching this vehicle yet. Try requesting via Rare Requests.',
                                style: const TextStyle(
                                    color: kcVoltSpareTextSecondary,
                                    fontSize: 13),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.compatibleProducts.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isDesktop ? 4 : 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.72,
                              ),
                              itemBuilder: (context, index) {
                                final product =
                                    viewModel.compatibleProducts[index];
                                return ProductCard(
                                  product: product,
                                  showFavorite: true,
                                  onFavoriteToggle: () =>
                                      viewModel.toggleWishlist(product, context),
                                  isLoadingFavorite: viewModel
                                      .isWishlistLoading(product.id),
                                  onTap: () =>
                                      viewModel.openProductDetails(product),
                                  onAddToCart: () =>
                                      viewModel.addToCart(product, context),
                                );
                              },
                            ),
                      const SizedBox(height: 28),
                    ],

                    // All products / Category products
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.selectedCategoryId != null
                              ? '${viewModel.selectedCategory?.name ?? 'Category'} (${viewModel.allProducts.length})'
                              : 'All Products (${viewModel.allProducts.length})',
                          style: const TextStyle(
                            color: kcVoltSpareTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (viewModel.selectedCategoryId != null)
                          TextButton.icon(
                            onPressed: () => viewModel.openSearch(
                              categoryId: viewModel.selectedCategoryId,
                            ),
                            icon: const Icon(
                              Icons.filter_list_rounded,
                              size: 16,
                              color: kcVoltSpareEVGreen,
                            ),
                            label: const Text(
                              'Filter More',
                              style: TextStyle(
                                color: kcVoltSpareEVGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (viewModel.allProducts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'No products available',
                            style: TextStyle(
                              color: kcVoltSpareTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.allProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final product = viewModel.allProducts[index];
                          return ProductCard(
                            product: product,
                            showFavorite: true,
                            onFavoriteToggle: () =>
                                viewModel.toggleWishlist(product, context),
                            isLoadingFavorite:
                                viewModel.isWishlistLoading(product.id),
                            onTap: () => viewModel.openProductDetails(product),
                            onAddToCart: () =>
                                viewModel.addToCart(product, context),
                          );
                        },
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: isDesktop || sizingInformation.isTablet
              ? null
              : VoltSpareBottomNavigation(
                  selectedIndex: viewModel.currentTabIndex,
                  onTap: (index) => viewModel.onTabSelected(index, context),
                ),
        );
      },
    ),
    );
  }

  Widget _buildRareRequestBanner(
      BuildContext context, HomeViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kcVoltSpareDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Can\'t find a rare spare part?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Request hard-to-find components and chat with our team for custom quotations.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.openRareRequest(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcVoltSpareEVGreen,
                    foregroundColor: kcVoltSpareDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.support_agent_rounded,
            color: kcVoltSpareEVGreen,
            size: 64,
          )
        ],
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFFFFEBEE),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  color: Color(0xFFE53935),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Exit App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: kcVoltSpareTextPrimary,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to close the app?',
            style: TextStyle(
              fontSize: 14,
              color: kcVoltSpareTextSecondary,
              height: 1.4,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: kcVoltSpareTextSecondary,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 0,
              ),
              child: const Text(
                'Exit',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
