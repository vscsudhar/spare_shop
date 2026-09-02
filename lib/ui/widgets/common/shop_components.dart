import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:spare_shop/ui/common/ui_helpers.dart';

const double kPagePadding = 20;

String formatPrice(double price) => '\u20B9${price.toStringAsFixed(0)}';

String appTabLabel(AppTab tab) {
  switch (tab) {
    case AppTab.home:
      return 'Home';
    case AppTab.wishlist:
      return 'Wishlist';
    case AppTab.cart:
      return 'Cart';
    case AppTab.orders:
      return 'Orders';
    case AppTab.profile:
      return 'Profile';
  }
}

IconData appTabIcon(AppTab tab) {
  switch (tab) {
    case AppTab.home:
      return Icons.home_outlined;
    case AppTab.wishlist:
      return Icons.favorite_border_rounded;
    case AppTab.cart:
      return Icons.shopping_bag_outlined;
    case AppTab.orders:
      return Icons.receipt_long_outlined;
    case AppTab.profile:
      return Icons.person_outline_rounded;
  }
}

String categoryLabel(ProductCategory category) {
  switch (category) {
    case ProductCategory.electronics:
      return 'Electronics';
    case ProductCategory.fashion:
      return 'Fashion';
    case ProductCategory.beauty:
      return 'Beauty';
    case ProductCategory.home:
      return 'Home';
    case ProductCategory.food:
      return 'Food';
  }
}

IconData categoryIcon(ProductCategory category) {
  switch (category) {
    case ProductCategory.electronics:
      return Icons.devices_other_rounded;
    case ProductCategory.fashion:
      return Icons.checkroom_rounded;
    case ProductCategory.beauty:
      return Icons.spa_outlined;
    case ProductCategory.home:
      return Icons.chair_alt_outlined;
    case ProductCategory.food:
      return Icons.lunch_dining_outlined;
  }
}

String paymentLabel(PaymentMethod method) {
  switch (method) {
    case PaymentMethod.upi:
      return 'UPI';
    case PaymentMethod.card:
      return 'Credit / Debit Card';
    case PaymentMethod.cashOnDelivery:
      return 'Cash on Delivery';
  }
}

Color orderStatusColor(OrderStatusFilter status) {
  switch (status) {
    case OrderStatusFilter.processing:
      return kcWarningColor;
    case OrderStatusFilter.shipped:
      return kcInfoColor;
    case OrderStatusFilter.delivered:
      return kcSuccessColor;
    case OrderStatusFilter.cancelled:
      return kcErrorColor;
    case OrderStatusFilter.all:
      return kcPrimaryColor;
  }
}

String orderStatusLabel(OrderStatusFilter status) {
  switch (status) {
    case OrderStatusFilter.processing:
      return 'Processing';
    case OrderStatusFilter.shipped:
      return 'Shipped';
    case OrderStatusFilter.delivered:
      return 'Delivered';
    case OrderStatusFilter.cancelled:
      return 'Cancelled';
    case OrderStatusFilter.all:
      return 'All';
  }
}

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.height = 56,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        gradient: kcPrimaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x296544F5),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: SizedBox(
        height: height,
        width: expand ? double.infinity : null,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.2,
                  ),
                )
              : Text(label, style: Theme.of(context).textTheme.labelLarge),
        ),
      ),
    );

    return MouseRegion(
      cursor: isLoading || onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(18),
          child: child,
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onPressed == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            color: kcSurfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kcBorderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                horizontalSpaceSmall,
              ],
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        prefixIcon: Icon(prefixIcon, color: kcLightGrey, size: 20),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            color: kcDarkGreyColor,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(
          width: 40,
          child: Align(
            alignment: Alignment.centerRight,
            child: trailing ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class ResponsivePageHeader extends StatelessWidget {
  const ResponsivePageHeader({
    super.key,
    required this.title,
    required this.sizingInformation,
    this.onBack,
    this.trailing,
  });

  final String title;
  final SizingInformation sizingInformation;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    if (!sizingInformation.isDesktop) {
      return AppTopBar(
        title: title,
        onBack: onBack,
        trailing: trailing,
      );
    }

    return Row(
      children: [
        if (onBack != null)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Tooltip(
              message: 'Back',
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              ),
            ),
          ),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class ShopBottomNavigationBar extends StatelessWidget {
  const ShopBottomNavigationBar({
    super.key,
    required this.currentTab,
    required this.onTap,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: kcSurfaceColor,
          border: Border(top: BorderSide(color: kcVeryLightGrey)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: AppTab.values
                .map(
                  (tab) => Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () => onTap(tab),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                appTabIcon(tab),
                                size: 22,
                                color: tab == currentTab
                                    ? kcPrimaryColor
                                    : kcMediumGrey,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appTabLabel(tab),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: tab == currentTab
                                          ? kcPrimaryColor
                                          : kcMediumGrey,
                                      fontWeight: tab == currentTab
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ShopResponsiveScaffold extends StatelessWidget {
  const ShopResponsiveScaffold({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.bodyBuilder,
    this.showMobileNavigation = true,
    this.showDesktopNavigation = true,
    this.maxContentWidth = 1320,
    this.bottomBarBuilder,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation) bodyBuilder;
  final bool showMobileNavigation;
  final bool showDesktopNavigation;
  final double maxContentWidth;
  final Widget Function(
          BuildContext context, SizingInformation sizingInformation)?
      bottomBarBuilder;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          bottomNavigationBar: sizingInformation.isDesktop
              ? null
              : bottomBarBuilder?.call(context, sizingInformation) ??
                  (showMobileNavigation
                      ? ShopBottomNavigationBar(
                          currentTab: currentTab,
                          onTap: onTabSelected,
                        )
                      : null),
          body: SafeArea(
            child: Column(
              children: [
                if (showDesktopNavigation && sizingInformation.isDesktop)
                  _DesktopNavigationHeader(
                    currentTab: currentTab,
                    onTabSelected: onTabSelected,
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: MaxContentWidth(
                      maxWidth: maxContentWidth,
                      child: ResponsivePadding(
                        mobile: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                        tablet: const EdgeInsets.fromLTRB(32, 20, 32, 20),
                        desktop: const EdgeInsets.fromLTRB(40, 28, 40, 28),
                        child: bodyBuilder(context, sizingInformation),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AuthResponsiveScaffold extends StatelessWidget {
  const AuthResponsiveScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formChildren,
    required this.footerPrompt,
    required this.footerActionLabel,
    required this.onFooterAction,
  });

  final String title;
  final String subtitle;
  final List<Widget> formChildren;
  final String footerPrompt;
  final String footerActionLabel;
  final VoidCallback onFooterAction;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final content = _AuthFormPanel(
          title: title,
          subtitle: subtitle,
          formChildren: formChildren,
          footerPrompt: footerPrompt,
          footerActionLabel: footerActionLabel,
          onFooterAction: onFooterAction,
          showIllustrationAbove: !sizingInformation.isDesktop,
        );

        if (sizingInformation.isDesktop) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: MaxContentWidth(
                  maxWidth: 1320,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        const Expanded(
                          child: _AuthDesktopBranding(),
                        ),
                        const SizedBox(width: 36),
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 520),
                                child: content,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: sizingInformation.isTablet ? 560 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    responsiveValue(
                      sizingInformation,
                      mobile: 20,
                      tablet: 28,
                    ),
                    16,
                    responsiveValue(
                      sizingInformation,
                      mobile: 20,
                      tablet: 28,
                    ),
                    24,
                  ),
                  child: content,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 24,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: kcSurfaceColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: kcVeryLightGrey),
      ),
      child: child,
    );
  }
}

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({
    super.key,
    this.height = 240,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: height * 0.08,
            left: height * 0.25,
            right: height * 0.25,
            child: Container(height: 2, color: kcBorderColor),
          ),
          Positioned(
            top: height * 0.08,
            right: height * 0.28,
            child: Container(
              width: height * 0.22,
              height: height * 0.22,
              decoration: const BoxDecoration(
                color: Color(0xFF2D2A43),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: height * 0.26,
            right: height * 0.2,
            child: Container(
              width: height * 0.4,
              height: height * 0.62,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2A43),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Center(
                child: Container(
                  width: height * 0.15,
                  height: height * 0.06,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 1.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.08,
            left: height * 0.23,
            child: Transform.rotate(
              angle: -0.03,
              child: Container(
                width: height * 0.36,
                height: height * 0.11,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2D2A43), width: 3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductArtwork extends StatelessWidget {
  const ProductArtwork({
    super.key,
    required this.visual,
    this.height = 120,
  });

  final ProductVisual visual;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: kcSurfaceVariantColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (visual == ProductVisual.sneakers)
              Positioned(
                bottom: 18,
                child: Container(
                  width: height * 0.6,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3C345A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            Icon(
              _productIcon(visual),
              size: height * 0.48,
              color: const Color(0xFF2B2842),
            ),
            if (visual == ProductVisual.sneakers)
              Positioned(
                top: height * 0.34,
                child: Container(
                  width: height * 0.44,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kcPrimaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            if (visual == ProductVisual.watch)
              Text(
                '12:45',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _productIcon(ProductVisual visual) {
    switch (visual) {
      case ProductVisual.headphones:
        return Icons.headphones_rounded;
      case ProductVisual.watch:
        return Icons.watch_rounded;
      case ProductVisual.sneakers:
        return Icons.shopping_bag_rounded;
      case ProductVisual.camera:
        return Icons.camera_alt_rounded;
      case ProductVisual.backpack:
        return Icons.work_outline_rounded;
      case ProductVisual.sunglasses:
        return Icons.visibility_outlined;
    }
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteToggle,
    this.showFavorite = false,
    this.isCompact = false,
  });

  final ShopProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool showFavorite;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kcSurfaceColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: kcVeryLightGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ProductArtwork(
                    visual: product.visual,
                    height: isCompact ? 104 : 120,
                  ),
                  if (showFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Tooltip(
                        message: product.isFavorite
                            ? 'Remove from wishlist'
                            : 'Add to wishlist',
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: onFavoriteToggle,
                            child: Icon(
                              product.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: kcPrimaryColor,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              verticalSpaceSmall,
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                formatPrice(product.price),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                '\u2605 ${product.rating.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kcStarColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 34 : 50,
      decoration: BoxDecoration(
        color: compact ? kcSurfaceVariantColor : kcSurfaceColor,
        borderRadius: BorderRadius.circular(compact ? 10 : 16),
        border: compact ? null : Border.all(color: kcBorderColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(icon: Icons.remove, onTap: onDecrease),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: compact ? 13 : 15,
                  ),
            ),
          ),
          _StepperButton(icon: Icons.add, onTap: onIncrease),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.entry,
    required this.onDecrease,
    required this.onIncrease,
    required this.onRemove,
    this.showCompactArtwork = false,
  });

  final CartEntry entry;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onRemove;
  final bool showCompactArtwork;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: showCompactArtwork ? 82 : 94,
            child: ProductArtwork(
              visual: entry.product.visual,
              height: showCompactArtwork ? 82 : 94,
            ),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  formatPrice(entry.product.price),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 12),
                QuantitySelector(
                  quantity: entry.quantity,
                  onDecrease: onDecrease,
                  onIncrease: onIncrease,
                  compact: true,
                ),
              ],
            ),
          ),
          Tooltip(
            message: 'Remove',
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline_rounded),
                color: kcLightGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }
}

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({
    super.key,
    required this.status,
  });

  final OrderStatusFilter status;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        orderStatusLabel(status),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onViewDetails,
    this.desktopLayout = false,
  });

  final ShopOrder order;
  final VoidCallback onViewDetails;
  final bool desktopLayout;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: desktopLayout
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${order.orderNumber}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        order.dateLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    order.itemCountLabel,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: OrderStatusChip(status: order.status),
                  ),
                ),
                Expanded(
                  child: Text(
                    formatPrice(order.total),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: onViewDetails,
                    child: Text(
                      'View Details',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: kcPrimaryColor,
                          ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Order ${order.orderNumber}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    OrderStatusChip(status: order.status),
                  ],
                ),
                verticalSpaceSmall,
                Text(
                  order.dateLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      order.itemCountLabel,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    Text(
                      formatPrice(order.total),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: onViewDetails,
                    child: Text(
                      'View Details',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: kcPrimaryColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: kcDarkGreyColor),
              horizontalSpaceMedium,
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: kcMediumGrey),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? kcPrimaryColor : kcLightGrey,
              ),
              horizontalSpaceSmall,
              Expanded(
                child: Text(
                  paymentLabel(method),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                color: kcSurfaceVariantColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_rounded,
                size: 88,
                color: Color(0xFF2D2A43),
              ),
            ),
            verticalSpaceLarge,
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            verticalSpaceSmall,
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            verticalSpaceLarge,
            AppPrimaryButton(
              label: buttonLabel,
              onPressed: onPressed,
              expand: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(icon, size: 16, color: kcDarkGreyColor),
        ),
      ),
    );
  }
}

class _DesktopNavigationHeader extends StatelessWidget {
  const _DesktopNavigationHeader({
    required this.currentTab,
    required this.onTabSelected,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kcSurfaceColor,
        border: Border(bottom: BorderSide(color: kcVeryLightGrey)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: MaxContentWidth(
          maxWidth: 1360,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            child: Row(
              children: [
                Text(
                  'NovaCart',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: kcDarkGreyColor,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(width: 30),
                ...AppTab.values.map(
                  (tab) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _DesktopNavItem(
                      label: appTabLabel(tab),
                      selected: tab == currentTab,
                      onTap: () => onTabSelected(tab),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 220,
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: kcBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kcVeryLightGrey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: kcLightGrey),
                      const SizedBox(width: 10),
                      Text(
                        'Search',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Tooltip(
                  message: 'Profile',
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: kcSurfaceVariantColor,
                    child: Text(
                      'S',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopNavItem extends StatelessWidget {
  const _DesktopNavItem({
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
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? kcPrimaryColor.withValues(alpha: 0.1) : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: selected ? kcPrimaryColor : kcDarkGreyColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}

class _AuthFormPanel extends StatelessWidget {
  const _AuthFormPanel({
    required this.title,
    required this.subtitle,
    required this.formChildren,
    required this.footerPrompt,
    required this.footerActionLabel,
    required this.onFooterAction,
    required this.showIllustrationAbove,
  });

  final String title;
  final String subtitle;
  final List<Widget> formChildren;
  final String footerPrompt;
  final String footerActionLabel;
  final VoidCallback onFooterAction;
  final bool showIllustrationAbove;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIllustrationAbove) ...[
            const AuthIllustration(height: 220),
            const SizedBox(height: 8),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ...formChildren,
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                footerPrompt,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: onFooterAction,
                  child: Text(
                    footerActionLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: kcPrimaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AuthDesktopBranding extends StatelessWidget {
  const _AuthDesktopBranding();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5F2FF), Color(0xFFE8E1FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NovaCart',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 34,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Responsive commerce, one Flutter codebase.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: kcMediumGrey,
                ),
          ),
          const Spacer(),
          const Center(
            child: AuthIllustration(height: 360),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
