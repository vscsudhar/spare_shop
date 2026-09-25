import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked_services/stacked_services.dart';

// 1. Primary Action Button
class PrimaryActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double height;

  const PrimaryActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kcVoltSpareEVGreen,
          foregroundColor: kcVoltSpareDark,
          disabledBackgroundColor: kcVoltSpareEVGreen.withValues(alpha: 0.5),
          disabledForegroundColor: kcVoltSpareDark.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: kcVoltSpareDark,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

// 2. Secondary Action Button
class SecondaryActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  const SecondaryActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kcVoltSpareBorder, width: 1.5),
          foregroundColor: kcVoltSpareTextPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: kcVoltSpareTextSecondary),
              const SizedBox(width: 8),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}

// 3. VoltSpare AppBar
class VoltSpareAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const VoltSpareAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktopOrTablet =
            sizingInformation.isDesktop || sizingInformation.isTablet;

        if (isDesktopOrTablet) {
          final tLower = title.toLowerCase();
          return AppBar(
            backgroundColor: kcVoltSpareWhite,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: MaxContentWidth(
              maxWidth: 1200,
              child: Row(
                children: [
                  const Icon(Icons.electric_bolt_rounded,
                      color: kcVoltSpareEVGreen),
                  const SizedBox(width: 8),
                  const Text(
                    'VoltSpare',
                    style: TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 40),
                  _desktopNavLink(
                      context,
                      'Home',
                      tLower == 'voltspare' ||
                          tLower == 'home' ||
                          tLower == 'product details',
                      0),
                  _desktopNavLink(
                      context,
                      'Search',
                      tLower.contains('search') || tLower.contains('filter'),
                      1),
                  _desktopNavLink(
                      context,
                      'Requests',
                      tLower.contains('request') ||
                          tLower.contains('chat') ||
                          tLower.contains('quotation'),
                      2),
                  _desktopNavLink(
                      context,
                      'Cart',
                      tLower.contains('cart') ||
                          tLower.contains('checkout') ||
                          tLower.contains('payment'),
                      3),
                  _desktopNavLink(
                      context,
                      'Profile',
                      tLower.contains('profile') ||
                          tLower.contains('account') ||
                          tLower.contains('vehicle'),
                      4),
                  if (actions != null && actions!.isNotEmpty) ...[
                    const Spacer(),
                    ...actions!,
                  ],
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: kcVoltSpareBorder.withValues(alpha: 0.5),
                height: 1.0,
              ),
            ),
          );
        }

        return AppBar(
          backgroundColor: kcVoltSpareWhite,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: showBackButton,
          title: Text(
            title,
            style: const TextStyle(
              color: kcVoltSpareTextPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: kcVoltSpareTextPrimary,
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null,
          actions: actions,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: kcVoltSpareBorder.withValues(alpha: 0.5),
              height: 1.0,
            ),
          ),
        );
      },
    );
  }

  Widget _desktopNavLink(
      BuildContext context, String label, bool isActive, int tabIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {
          if (isActive) return;
          final navigationService = locator<NavigationService>();
          switch (tabIndex) {
            case 0:
              navigationService.replaceWith(Routes.homeView);
              break;
            case 1:
              navigationService.replaceWith(Routes.searchFiltersView);
              break;
            case 2:
              navigationService.replaceWith(Routes.myRareRequestsView);
              break;
            case 3:
              navigationService.replaceWith(Routes.cartView);
              break;
            case 4:
              navigationService.replaceWith(Routes.accountVehiclesView);
              break;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? kcVoltSpareEVGreen : kcVoltSpareTextSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Container(
                width: 16,
                height: 2,
                color: kcVoltSpareEVGreen,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// 4. VoltSpare Bottom Navigation
class VoltSpareBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const VoltSpareBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kcVoltSpareWhite,
        border: Border(
          top: BorderSide(
            color: kcVoltSpareBorder.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: kcVoltSpareWhite,
        selectedItemColor: kcVoltSpareEVGreen,
        unselectedItemColor: kcVoltSpareTextSecondary,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// 5. App Search Field
class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;

  const AppSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search spare parts...',
    this.onChanged,
    this.onClear,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted?.call(),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded, color: kcLightGrey),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, color: kcLightGrey),
                onPressed: () {
                  controller.clear();
                  onClear?.call();
                },
              )
            : null,
        filled: true,
        fillColor: kcVoltSpareWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kcVoltSpareBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kcVoltSpareBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kcVoltSpareEVGreen, width: 1.5),
        ),
      ),
    );
  }
}

// 6. Vehicle Summary Card
class VehicleSummaryCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback? onChangePressed;

  const VehicleSummaryCard({
    super.key,
    required this.vehicle,
    this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEv = vehicle.type == VehicleType.ev;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcVoltSpareDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEv
                  ? kcVoltSpareEVGreen.withValues(alpha: 0.1)
                  : Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEv ? Icons.electric_bolt_rounded : Icons.two_wheeler_rounded,
              color: isEv ? kcVoltSpareEVGreen : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isEv ? kcVoltSpareEVGreen : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isEv ? 'EV' : 'PETROL',
                        style: TextStyle(
                          color: isEv ? kcVoltSpareDark : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vehicle.year,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.brand} ${vehicle.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (onChangePressed != null)
            TextButton(
              onPressed: onChangePressed,
              child: const Text(
                'Change',
                style: TextStyle(
                  color: kcVoltSpareEVGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 7. Vehicle Type Card
class VehicleTypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleTypeCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? kcVoltSpareDark : kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kcVoltSpareDark : kcVoltSpareBorder,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: kcVoltSpareDark.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareTextPrimary,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? kcVoltSpareWhite : kcVoltSpareTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. Vehicle Brand Card
class VehicleBrandCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleBrandCard({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? kcVoltSpareEVGreen.withValues(alpha: 0.15)
              : kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareBorder,
            width: 1.5,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// 9. Category Card
class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? kcVoltSpareDark : kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kcVoltSpareDark : kcVoltSpareBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 20,
              color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareTextSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? kcVoltSpareWhite : kcVoltSpareTextPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 10. Product Fitment Badge
class ProductFitmentBadge extends StatelessWidget {
  final String text;
  final bool isFit;

  const ProductFitmentBadge({
    super.key,
    required this.text,
    this.isFit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFit
            ? kcVoltSpareEVGreen.withValues(alpha: 0.12)
            : kcWarningColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFit ? Icons.check_circle_rounded : Icons.warning_rounded,
            color: isFit ? kcSuccessColor : kcWarningColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isFit ? kcSuccessColor : kcWarningColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// 11. Product Price Widget
class ProductPriceWidget extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;

  const ProductPriceWidget({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '\u20B9${price.toStringAsFixed(0)}',
          style: TextStyle(
            color: kcVoltSpareTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        if (originalPrice != null) ...[
          const SizedBox(width: 6),
          Text(
            '\u20B9${originalPrice!.toStringAsFixed(0)}',
            style: TextStyle(
              color: kcVoltSpareTextSecondary,
              decoration: TextDecoration.lineThrough,
              fontSize: fontSize * 0.75,
            ),
          ),
        ]
      ],
    );
  }
}

// 12. Product Card (Grid layout)
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback? onFavoriteToggle;
  final bool showFavorite;
  final bool isWishlistPage;
  final bool isLoadingFavorite;
  final bool showWishlistButton;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    this.onFavoriteToggle,
    this.showFavorite = true,
    this.isWishlistPage = false,
    this.isLoadingFavorite = false,
    this.showWishlistButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool shouldShowFav = showFavorite ||
        showWishlistButton ||
        isWishlistPage ||
        onFavoriteToggle != null;
    final bool isWishlisted = isWishlistPage ||
        product.isWishlist ||
        locator<WishlistService>().isProductWishlisted(product.id);
    final int? discountPercent = (product.originalPrice != null &&
            product.originalPrice! > product.price &&
            product.originalPrice! > 0)
        ? (((product.originalPrice! - product.price) / product.originalPrice!) *
                100)
            .round()
        : null;
    final bool isStockManaged = product.stockManaged;
    final bool isOutOfStock =
        isStockManaged && (product.stockCount == null || product.stockCount! <= 0);
    final bool isOnDemand = !isStockManaged;

    final String availabilityLabel = isOutOfStock
        ? 'Out of Stock'
        : (isOnDemand ? 'Available on Order' : 'In Stock');

    final Color badgeColor = isOutOfStock
        ? Colors.red
        : (isOnDemand ? const Color(0xFF0284C7) : const Color(0xFF10B981));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kcVoltSpareBorder.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Placeholder/Asset with optional Favorite button and Discount badge
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: kcSurfaceVariantColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    alignment: Alignment.center,
                    child: product.imageAsset != null &&
                            product.imageAsset!.startsWith('http')
                        ? Image.network(
                            product.imageAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.settings_suggest_rounded,
                              size: 40,
                              color: kcVoltSpareDark.withValues(alpha: 0.3),
                            ),
                          )
                        : Icon(
                            Icons.settings_suggest_rounded,
                            size: 40,
                            color: kcVoltSpareDark.withValues(alpha: 0.3),
                          ),
                  ),
                  if (discountPercent != null && discountPercent > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: kcVoltSpareEVGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$discountPercent% OFF',
                          style: const TextStyle(
                            color: kcVoltSpareDark,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (shouldShowFav)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          onTap: isLoadingFavorite ? null : onFavoriteToggle,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: isLoadingFavorite
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  )
                                : Icon(
                                    isWishlisted
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    size: 16,
                                    color: isWishlisted
                                        ? Colors.red
                                        : kcVoltSpareTextSecondary,
                                  ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.fitmentBadge != null) ...[
                    ProductFitmentBadge(text: product.fitmentBadge!),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        availabilityLabel,
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          color: kcStarColor, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          color: kcVoltSpareTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: ProductPriceWidget(
                            price: product.price,
                            originalPrice: product.originalPrice,
                            fontSize: 14),
                      ),
                      InkWell(
                        onTap: isOutOfStock ? null : onAddToCart,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isOutOfStock
                                ? Colors.grey.shade300
                                : kcVoltSpareDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add_shopping_cart_rounded,
                            color: isOutOfStock
                                ? Colors.grey.shade500
                                : kcVoltSpareEVGreen,
                            size: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 12b. Wishlist Product Card (Reusable wrapper)
class WishlistProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;
  final VoidCallback? onAddToCart;

  const WishlistProductCard({
    super.key,
    required this.product,
    this.isLoading = false,
    required this.onTap,
    required this.onWishlistTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      product: product,
      onTap: onTap,
      onAddToCart: onAddToCart ?? () {},
      onFavoriteToggle: onWishlistTap,
      showFavorite: true,
      isWishlistPage: true,
      isLoadingFavorite: isLoading,
    );
  }
}

// 13. Product List Tile (Horizontal layout)
class ProductListTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const ProductListTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kcVoltSpareBorder.withValues(alpha: 0.8)),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kcSurfaceVariantColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.settings_suggest_rounded,
                size: 30,
                color: kcVoltSpareDark.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.fitmentBadge != null) ...[
                    ProductFitmentBadge(text: product.fitmentBadge!),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ProductPriceWidget(
                      price: product.price,
                      originalPrice: product.originalPrice,
                      fontSize: 14),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: kcLightGrey),
          ],
        ),
      ),
    );
  }
}

// 14. Quantity Selector
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kcVoltSpareOffWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kcVoltSpareBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_rounded, size: 16),
            onPressed: onDecrement,
            visualDensity: VisualDensity.compact,
            color: kcVoltSpareTextPrimary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kcVoltSpareTextPrimary,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 16),
            onPressed: onIncrement,
            visualDensity: VisualDensity.compact,
            color: kcVoltSpareTextPrimary,
          ),
        ],
      ),
    );
  }
}

// 15. Cart Item Card
class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kcVoltSpareWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kcVoltSpareBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: kcSurfaceVariantColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.build_circle_outlined,
              color: kcVoltSpareDark.withValues(alpha: 0.3),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kcVoltSpareTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                if (item.product.fitmentBadge != null) ...[
                  ProductFitmentBadge(text: item.product.fitmentBadge!),
                  const SizedBox(height: 6),
                ],
                ProductPriceWidget(price: item.product.price, fontSize: 13),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: kcErrorColor, size: 18),
                onPressed: onRemove,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 4),
              QuantitySelector(
                quantity: item.quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 16. Price Summary Card
class PriceSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double gst;
  final double total;

  const PriceSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.gst,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcVoltSpareWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kcVoltSpareBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: kcVoltSpareTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow('Subtotal', subtotal),
          const SizedBox(height: 8),
          _summaryRow('Delivery Fee', deliveryFee),
          const SizedBox(height: 8),
          _summaryRow('GST (18%)', gst),
          const Divider(height: 24, color: kcVoltSpareBorder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kcVoltSpareTextPrimary,
                ),
              ),
              Text(
                '\u20B9${total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: kcVoltSpareEVGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(color: kcVoltSpareTextSecondary, fontSize: 13)),
        Text('\u20B9${val.toStringAsFixed(0)}',
            style:
                const TextStyle(color: kcVoltSpareTextPrimary, fontSize: 13)),
      ],
    );
  }
}

// 17. Address Card
class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressCard({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? kcVoltSpareEVGreen.withValues(alpha: 0.05)
              : kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? kcVoltSpareEVGreen : kcLightGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kcVoltSpareTextPrimary,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kcVoltSpareDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                                color: kcVoltSpareEVGreen,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.addressLine,
                    style: const TextStyle(
                        color: kcVoltSpareTextSecondary,
                        fontSize: 12,
                        height: 1.3),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.phone,
                    style: const TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 18. Delivery Option Card
class DeliveryOptionCard extends StatelessWidget {
  final String title;
  final String duration;
  final double price;
  final bool isSelected;
  final VoidCallback onTap;

  const DeliveryOptionCard({
    super.key,
    required this.title,
    required this.duration,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? kcVoltSpareEVGreen.withValues(alpha: 0.05)
              : kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? kcVoltSpareEVGreen : kcLightGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kcVoltSpareTextPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: const TextStyle(
                        color: kcVoltSpareTextSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              price == 0 ? 'Free' : '\u20B9${price.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 19. Payment Method Tile
class PaymentMethodTile extends StatelessWidget {
  final PaymentOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? kcVoltSpareEVGreen.withValues(alpha: 0.05)
              : kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              option.icon,
              color: isSelected ? kcVoltSpareEVGreen : kcVoltSpareTextSecondary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kcVoltSpareTextPrimary),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? kcVoltSpareEVGreen : kcLightGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// 20. Order Tracking Timeline
class OrderTrackingTimeline extends StatelessWidget {
  final List<OrderTrackingStepModel> steps;

  const OrderTrackingTimeline({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: step.isCompleted
                        ? kcVoltSpareEVGreen
                        : step.isCurrent
                            ? kcVoltSpareDark
                            : kcVoltSpareOffWhite,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: step.isCompleted
                          ? kcVoltSpareEVGreen
                          : step.isCurrent
                              ? kcVoltSpareDark
                              : kcVoltSpareBorder,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    step.isCompleted
                        ? Icons.check_rounded
                        : Icons.circle_rounded,
                    size: 12,
                    color: step.isCompleted
                        ? kcVoltSpareDark
                        : step.isCurrent
                            ? kcVoltSpareEVGreen
                            : kcVoltSpareBorder,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2.5,
                    height: 50,
                    color: step.isCompleted
                        ? kcVoltSpareEVGreen
                        : kcVoltSpareBorder,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: step.isCurrent
                          ? kcVoltSpareEVGreen
                          : kcVoltSpareTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: const TextStyle(
                        color: kcVoltSpareTextSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.timeString,
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary.withValues(alpha: 0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

// 21. Request Status Chip
class RareRequestStatusChip extends StatelessWidget {
  final RareRequestStatus status;

  const RareRequestStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case RareRequestStatus.submitted:
        color = kcWarningColor;
        label = 'Submitted';
        break;
      case RareRequestStatus.searching:
        color = kcInfoColor;
        label = 'Searching';
        break;
      case RareRequestStatus.found:
      case RareRequestStatus.quotationSent:
      case RareRequestStatus.negotiation:
        color = kcInfoColor;
        label = 'Quotation Offered';
        break;
      case RareRequestStatus.approved:
      case RareRequestStatus.convertedToOrder:
        color = kcSuccessColor;
        label = 'Approved / Ordered';
        break;
      case RareRequestStatus.cancelled:
        color = kcErrorColor;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

// 22. Chat Message Bubble
class ChatMessageBubble extends StatelessWidget {
  final RareChatMessageModel message;

  const ChatMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == RareChatSender.customer;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, top: 4),
        padding: const EdgeInsets.all(14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? kcVoltSpareDark : kcVoltSpareWhite,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          border: isMe ? null : Border.all(color: kcVoltSpareBorder),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: isMe ? kcVoltSpareWhite : kcVoltSpareTextPrimary,
            fontSize: 14,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}

// 23. Uploaded Product Image Card
class UploadedProductImageCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRemove;

  const UploadedProductImageCard({
    super.key,
    required this.imagePath,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: kcVoltSpareOffWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kcVoltSpareBorder),
          ),
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_rounded, color: kcLightGrey),
              SizedBox(height: 4),
              Text(
                'Photo.jpg',
                style: TextStyle(fontSize: 10, color: kcLightGrey),
              ),
            ],
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: kcErrorColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 14),
            ),
          ),
        )
      ],
    );
  }
}

// 24. Quotation Card
class QuotationCard extends StatelessWidget {
  final RareQuotationModel quotation;
  final VoidCallback onApprove;
  final VoidCallback onCancel;

  const QuotationCard({
    super.key,
    required this.quotation,
    required this.onApprove,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcVoltSpareWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kcVoltSpareEVGreen, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.request_quote_rounded,
                  color: kcVoltSpareEVGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'VoltSpare Special Quotation',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: kcVoltSpareTextPrimary),
              ),
            ],
          ),
          const Divider(height: 24, color: kcVoltSpareBorder),
          Text(
            quotation.partName,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: kcVoltSpareTextPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Offer Price',
                  style:
                      TextStyle(color: kcVoltSpareTextSecondary, fontSize: 13)),
              Text(
                '\u20B9${quotation.price.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kcVoltSpareTextPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Delivery',
                  style:
                      TextStyle(color: kcVoltSpareTextSecondary, fontSize: 13)),
              Text(
                quotation.deliveryTimeline,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: kcVoltSpareEVGreen),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryActionButton(
                  label: 'Reject',
                  onPressed: onCancel,
                  height: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcVoltSpareDark,
                      foregroundColor: kcVoltSpareEVGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Approve & Buy',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// 25. Empty State Widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: kcVoltSpareOffWhite,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: kcLightGrey),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: kcVoltSpareTextPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: kcVoltSpareTextSecondary, fontSize: 13, height: 1.3),
            ),
            if (buttonLabel != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: PrimaryActionButton(
                  label: buttonLabel!,
                  onPressed: onButtonPressed,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

// 26. Loading Overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kcVoltSpareWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: kcVoltSpareEVGreen,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kcVoltSpareTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
