import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/delivery_estimator.dart';
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
  void onViewModelReady(ProductDetailsViewModel viewModel) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => viewModel.init(product));
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    ProductDetailsViewModel viewModel,
    Widget? child,
  ) {
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
                icon: viewModel.isWishlistLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kcVoltSpareDark,
                        ),
                      )
                    : Icon(
                        viewModel.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color:
                            viewModel.isFavorite ? Colors.red : kcVoltSpareDark,
                      ),
                onPressed: viewModel.isWishlistLoading
                    ? null
                    : () => viewModel.toggleFavorite(context),
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
                                    _buildPurchaseCard(context, viewModel),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                          _buildSuggestionsSection(context, viewModel),
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
                              _buildSuggestionsSection(context, viewModel),
                            ],
                          ),
                        ),
                        // Mobile bottom buy bar
                        _buildMobilePurchaseBar(context, viewModel),
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

        // Dynamic Delivery info
        _buildDeliveryInfo(context, viewModel),
      ],
    );
  }

  Widget _buildDeliveryInfo(
      BuildContext context, ProductDetailsViewModel viewModel) {
    final estimate = viewModel.deliveryEstimate;
    final isOutOfStock = estimate.type == DeliveryType.outOfStock;
    final isOnDemand = estimate.type == DeliveryType.twoDays;

    final Color statusBg = isOutOfStock
        ? Colors.red.withValues(alpha: 0.1)
        : (isOnDemand
            ? Colors.blue.withValues(alpha: 0.1)
            : kcVoltSpareEVGreen.withValues(alpha: 0.12));
    final Color statusColor = isOutOfStock
        ? Colors.red
        : (isOnDemand ? Colors.blue.shade700 : kcVoltSpareEVGreen);

    IconData deliveryIcon = Icons.bolt_rounded;
    if (estimate.type == DeliveryType.twoDays) {
      deliveryIcon = Icons.schedule_rounded;
    } else if (estimate.type == DeliveryType.nextDay) {
      deliveryIcon = Icons.local_shipping_outlined;
    } else if (isOutOfStock) {
      deliveryIcon = Icons.block_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcVoltSpareWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOutOfStock
              ? Colors.red.withValues(alpha: 0.3)
              : kcVoltSpareBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isOutOfStock) ...[
                      Icon(Icons.check_rounded, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      estimate.availabilityStatus,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (viewModel.product.stockManaged &&
                  viewModel.product.stockCount != null &&
                  viewModel.product.stockCount! > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '(${viewModel.product.stockCount} units available)',
                  style: const TextStyle(
                    color: kcVoltSpareTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                deliveryIcon,
                color: isOutOfStock ? Colors.red : kcVoltSpareEVGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estimate.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isOutOfStock
                            ? Colors.red
                            : kcVoltSpareTextPrimary,
                      ),
                    ),
                    if (estimate.cutoffNote != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        estimate.cutoffNote!,
                        style: TextStyle(
                          color: estimate.type == DeliveryType.sameDay
                              ? kcVoltSpareEVGreen
                              : kcVoltSpareTextSecondary,
                          fontSize: 12,
                          fontWeight: estimate.type == DeliveryType.sameDay
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ] else if (estimate.type == DeliveryType.twoDays) ...[
                      const SizedBox(height: 2),
                      const Text(
                        'Direct from manufacturer/supplier',
                        style: TextStyle(
                          color: kcVoltSpareTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseCard(
      BuildContext context, ProductDetailsViewModel viewModel) {
    final canAdd = viewModel.canAddToCart;

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
                    _quantityButton(
                      Icons.remove,
                      viewModel.decreaseQuantity,
                      enabled: viewModel.quantity > 1 && canAdd,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${viewModel.quantity}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _quantityButton(
                      Icons.add,
                      viewModel.increaseQuantity,
                      enabled: viewModel.canIncreaseQuantity && canAdd,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(width: 40),
            Expanded(
              child: PrimaryActionButton(
                label: canAdd ? 'Add to Cart' : 'Out of Stock',
                onPressed: canAdd ? () => viewModel.addToCart(context) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePurchaseBar(
      BuildContext context, ProductDetailsViewModel viewModel) {
    final canAdd = viewModel.canAddToCart;

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
              _quantityButton(
                Icons.remove,
                viewModel.decreaseQuantity,
                enabled: viewModel.quantity > 1 && canAdd,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${viewModel.quantity}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              _quantityButton(
                Icons.add,
                viewModel.increaseQuantity,
                enabled: viewModel.canIncreaseQuantity && canAdd,
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: PrimaryActionButton(
              label: canAdd ? 'Add to Cart' : 'Out of Stock',
              onPressed: canAdd ? () => viewModel.addToCart(context) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed,
      {bool enabled = true}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: enabled ? kcVoltSpareOffWhite : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: enabled ? kcVoltSpareBorder : Colors.grey.shade300,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 16,
          color: enabled ? kcVoltSpareDark : Colors.grey.shade400,
        ),
        padding: EdgeInsets.zero,
        onPressed: enabled ? onPressed : null,
      ),
    );
  }

  Widget _buildSuggestionsSection(
      BuildContext context, ProductDetailsViewModel viewModel) {
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
                  showFavorite: true,
                  onFavoriteToggle: () => viewModel
                      .toggleWishlistForProduct(suggestion, context),
                  isLoadingFavorite:
                      viewModel.isProductLoading(suggestion.id),
                  onTap: () => viewModel.selectProduct(suggestion),
                  onAddToCart: () =>
                      viewModel.addToCartForProduct(suggestion, context),
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
