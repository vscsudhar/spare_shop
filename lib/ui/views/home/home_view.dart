import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return ResponsiveBuilder(
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
                          controller: TextEditingController(),
                          hintText: 'Search matching spare parts...',
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Rare request banner
                    _buildRareRequestBanner(context, viewModel),

                    const SizedBox(height: 28),

                    // Categories
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final category = viewModel.categories[index];
                          return CategoryCard(
                            category: category,
                            isSelected: false,
                            onTap: viewModel.openSearch,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Compatible parts if vehicle is selected
                    if (viewModel.selectedVehicle != null) ...[
                      Text(
                        'Fits Your ${viewModel.selectedVehicle!.name}',
                        style: const TextStyle(
                          color: kcVoltSpareTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      viewModel.compatibleProducts.isEmpty
                          ? const Text(
                              'No items matching this vehicle yet. Try requesting via Rare Requests.',
                              style: TextStyle(
                                  color: kcVoltSpareTextSecondary,
                                  fontSize: 13),
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
                                  onTap: () =>
                                      viewModel.openProductDetails(product),
                                  onAddToCart: viewModel.openCartView,
                                );
                              },
                            ),
                      const SizedBox(height: 28),
                    ],

                    // Featured products
                    const Text(
                      'All Products',
                      style: TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.featuredProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 4 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final product = viewModel.featuredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () => viewModel.openProductDetails(product),
                          onAddToCart: viewModel.openCartView,
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
                  onTap: viewModel.onTabSelected,
                ),
        );
      },
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
                  onPressed: viewModel.openRareRequest,
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

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.refresh();
}
