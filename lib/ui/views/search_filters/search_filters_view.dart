import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'search_filters_viewmodel.dart';

import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';

class SearchFiltersView extends StackedView<SearchFiltersViewModel> {
  const SearchFiltersView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SearchFiltersViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;

        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'Search & Filters',
            showBackButton: false,
            actions: [
              TextButton(
                onPressed: viewModel.clearFilters,
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    color: kcVoltSpareEVGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 1200,
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Sidebar for Filters on Desktop
                        SizedBox(
                          width: 300,
                          child: Card(
                            color: kcVoltSpareWhite,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: _buildFiltersColumn(context, viewModel),
                            ),
                          ),
                        ),
                        // Right side Grid for Results
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSearchHeader(viewModel),
                                const SizedBox(height: 20),
                                Expanded(
                                    child: _buildResultsGrid(viewModel, true)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          _buildSearchHeader(viewModel),
                          const SizedBox(height: 12),
                          // Horizontal Category Chips on Mobile
                          _buildHorizontalMobileFilters(viewModel),
                          const SizedBox(height: 16),
                          Expanded(child: _buildResultsGrid(viewModel, false)),
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

  Widget _buildSearchHeader(SearchFiltersViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: AppSearchField(
            controller: viewModel.searchController,
            hintText: 'Search matching spare parts...',
            onChanged: viewModel.onSearchChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalMobileFilters(SearchFiltersViewModel viewModel) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Vehicle Chip
          if (viewModel.selectedVehicle != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                    '${viewModel.selectedVehicle!.brand} ${viewModel.selectedVehicle!.name}'),
                selected: true,
                onSelected: (_) => viewModel.openVehicleSelector(),
                selectedColor: kcVoltSpareEVGreen.withValues(alpha: 0.12),
                checkmarkColor: kcVoltSpareEVGreen,
                labelStyle: const TextStyle(
                    color: kcVoltSpareEVGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),

          // Category chips
          ...viewModel.categories.map((cat) {
            final isSelected = viewModel.selectedCategoryId == cat.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat.name),
                selected: isSelected,
                onSelected: (val) {
                  viewModel.selectCategory(val ? cat.id : null);
                },
                selectedColor: kcVoltSpareEVGreen.withValues(alpha: 0.12),
                checkmarkColor: kcVoltSpareEVGreen,
                labelStyle: TextStyle(
                  color:
                      isSelected ? kcVoltSpareEVGreen : kcVoltSpareTextPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFiltersColumn(
      BuildContext context, SearchFiltersViewModel viewModel) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Text(
          'Filters',
          style: TextStyle(
            color: kcVoltSpareTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 24),

        // Vehicle Section
        const Text(
          'Target Vehicle',
          style: TextStyle(
            color: kcVoltSpareTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        if (viewModel.selectedVehicle != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kcVoltSpareOffWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${viewModel.selectedVehicle!.brand} ${viewModel.selectedVehicle!.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: viewModel.openVehicleSelector,
                  child: const Text('Change',
                      style:
                          TextStyle(color: kcVoltSpareEVGreen, fontSize: 12)),
                )
              ],
            ),
          ),

        const SizedBox(height: 24),

        // Category Section
        const Text(
          'Categories',
          style: TextStyle(
            color: kcVoltSpareTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        ...viewModel.categories.map((cat) {
          final isSelected = viewModel.selectedCategoryId == cat.id;
          return RadioListTile<String?>(
            title: Text(cat.name, style: const TextStyle(fontSize: 13)),
            value: cat.id,
            groupValue: viewModel.selectedCategoryId,
            activeColor: kcVoltSpareEVGreen,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) {
              viewModel.selectCategory(val);
            },
          );
        }),

        const SizedBox(height: 24),

        // Price limit section
        const Text(
          'Max Price Limit',
          style: TextStyle(
            color: kcVoltSpareTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: viewModel.maxPriceLimit,
          min: 100,
          max: 50000,
          activeColor: kcVoltSpareEVGreen,
          inactiveColor: kcVoltSpareBorder,
          onChanged: (val) => viewModel.setMaxPrice(val),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('₹100',
                style:
                    TextStyle(color: kcVoltSpareTextSecondary, fontSize: 12)),
            Text(
              '₹${viewModel.maxPriceLimit.toInt()}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kcVoltSpareEVGreen,
                  fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultsGrid(SearchFiltersViewModel viewModel, bool isDesktop) {
    if (viewModel.isBusy) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kcVoltSpareEVGreen),
        ),
      );
    }

    final products = viewModel.filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: kcLightGrey,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'No spare parts found',
              style: TextStyle(
                color: kcVoltSpareTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try adjusting your search terms or filters',
              style: TextStyle(
                color: kcVoltSpareTextSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: viewModel.clearFilters,
              style: ElevatedButton.styleFrom(
                  backgroundColor: kcVoltSpareDark,
                  foregroundColor: Colors.white),
              child: const Text('Reset Search'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => viewModel.openProductDetails(product),
          onAddToCart: () {
            // Direct to Cart
            viewModel.goToCart();
          },
        );
      },
    );
  }

  @override
  SearchFiltersViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SearchFiltersViewModel();
}
