import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'product_details_viewmodel.dart';

class ProductDetailsView extends StackedView<ProductDetailsViewModel> {
  final ProductModel product;
  const ProductDetailsView({Key? key, required this.product}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProductDetailsViewModel viewModel,
    Widget? child,
  ) {
    viewModel.setProduct(product);

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;

        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'Product Details',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
            actions: [
              IconButton(
                icon: Icon(
                  viewModel.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: viewModel.isFavorite ? Colors.red : kcVoltSpareDark,
                ),
                onPressed: viewModel.toggleFavorite,
              ),
            ],
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 1200,
              child: isDesktop
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left column: Image
                              Expanded(
                                flex: 5,
                                child: Card(
                                  color: kcVoltSpareWhite,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 0,
                                  child: Container(
                                    height: 460,
                                    padding: const EdgeInsets.all(32),
                                    child: Center(
                                        child: _buildProductImage(
                                            viewModel.product)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              // Right column: Info & Add to Cart
                              Expanded(
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildProductInfo(
                                        context, viewModel, viewModel.product),
                                    const SizedBox(height: 32),
                                    _buildPurchaseCard(viewModel),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                          _buildSuggestionsSection(viewModel),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              // Product Image
                              Container(
                                height: 280,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: kcVoltSpareWhite,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Center(
                                    child:
                                        _buildProductImage(viewModel.product)),
                              ),
                              const SizedBox(height: 20),

                              // Product details
                              _buildProductInfo(
                                  context, viewModel, viewModel.product),
                              const SizedBox(height: 32),
                              _buildSuggestionsSection(viewModel),
                            ],
                          ),
                        ),
                        // Mobile bottom buy bar
                        _buildMobilePurchaseBar(viewModel),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(ProductModel product) {
    // Generate a placeholder icon based on category
    IconData icon = Icons.settings_suggest_rounded;
    if (product.categoryId == 'brakes') icon = Icons.album_rounded;
    if (product.categoryId == 'tyres') icon = Icons.circle_outlined;
    if (product.categoryId == 'lights') icon = Icons.lightbulb_rounded;
    if (product.categoryId == 'engine_parts') icon = Icons.build_rounded;
    if (product.categoryId == 'accessories') icon = Icons.electric_bike_rounded;

    return Icon(
      icon,
      color: kcVoltSpareEVGreen,
      size: 140,
    );
  }

  Widget _buildProductInfo(BuildContext context,
      ProductDetailsViewModel viewModel, ProductModel product) {
    final isUniversal = product.fitmentBadge == 'Universal Fit';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fitment Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isUniversal
                ? kcVoltSpareOffWhite
                : kcVoltSpareEVGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            product.fitmentBadge ?? 'Compatible',
            style: TextStyle(
              color:
                  isUniversal ? kcVoltSpareTextSecondary : kcVoltSpareEVGreen,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Title
        Text(
          product.name,
          style: const TextStyle(
            color: kcVoltSpareTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 8),

        // Rating & Review summary
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            Text(
              product.rating.toStringAsFixed(1),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 6),
            const Text(
              '(24 reviews)',
              style: TextStyle(color: kcVoltSpareTextSecondary, fontSize: 13),
            ),
            const Spacer(),
            Text(
              'PN-${product.id.toUpperCase()}',
              style: const TextStyle(
                  color: kcVoltSpareTextSecondary,
                  fontSize: 12,
                  fontFamily: 'monospace'),
            ),
          ],
        ),

        const SizedBox(height: 20),
        const Divider(color: kcVoltSpareBorder),
        const SizedBox(height: 16),

        // Pricing
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '₹${product.price.toInt()}',
              style: const TextStyle(
                color: kcVoltSpareTextPrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (product.originalPrice != null) ...[
              const SizedBox(width: 10),
              Text(
                '₹${product.originalPrice!.toInt()}',
                style: const TextStyle(
                  color: kcVoltSpareTextSecondary,
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '15% OFF',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 24),

        // Description Section
        const Text(
          'Description',
          style: TextStyle(
            color: kcVoltSpareTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: const TextStyle(
            color: kcVoltSpareTextSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        // Fitment details list
        const Text(
          'Compatible Vehicles',
          style: TextStyle(
            color: kcVoltSpareTextPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.compatibleVehicleIds.map((id) {
            // Find vehicle name from mock data
            final vehicle = mockVehicles.firstWhere((v) => v.id == id,
                orElse: () => mockVehicles[0]);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kcVoltSpareWhite,
                border: Border.all(color: kcVoltSpareBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${vehicle.brand} ${vehicle.name}',
                style: const TextStyle(
                    color: kcVoltSpareTextPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Delivery timeline
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kcVoltSpareWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kcVoltSpareBorder),
          ),
          child: const Row(
            children: [
              Icon(Icons.local_shipping_rounded, color: kcVoltSpareEVGreen),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Free Shipping',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Delivered in 3-5 working days',
                      style: TextStyle(
                          color: kcVoltSpareTextSecondary, fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseCard(ProductDetailsViewModel viewModel) {
    return Card(
      color: kcVoltSpareWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kcVoltSpareBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quantity',
                  style: TextStyle(
                      color: kcVoltSpareTextSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _quantityButton(Icons.remove, viewModel.decreaseQuantity),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${viewModel.quantity}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _quantityButton(Icons.add, viewModel.increaseQuantity),
                  ],
                )
              ],
            ),
            const SizedBox(width: 40),
            Expanded(
              child: PrimaryActionButton(
                label: 'Add to Cart',
                onPressed: viewModel.addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePurchaseBar(ProductDetailsViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: kcVoltSpareWhite,
        border: Border(top: BorderSide(color: kcVoltSpareBorder)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              _quantityButton(Icons.remove, viewModel.decreaseQuantity),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${viewModel.quantity}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              _quantityButton(Icons.add, viewModel.increaseQuantity),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: PrimaryActionButton(
              label: 'Add to Cart',
              onPressed: viewModel.addToCart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: kcVoltSpareOffWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kcVoltSpareBorder),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: kcVoltSpareDark),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSuggestionsSection(ProductDetailsViewModel viewModel) {
    final suggestions = viewModel.suggestions;
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final activeVehicle = viewModel.selectedVehicle;
    final String title = activeVehicle != null
        ? 'Spares Compatible with ${activeVehicle.brand} ${activeVehicle.name}'
        : 'More Spares You May Need';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: kcVoltSpareBorder),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            color: kcVoltSpareTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            final crossAxisCount = isWide ? 4 : 2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ProductCard(
                  product: suggestion,
                  onTap: () => viewModel.selectProduct(suggestion),
                  onAddToCart: () => viewModel.addToCartForProduct(suggestion),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  ProductDetailsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProductDetailsViewModel();
}
