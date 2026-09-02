import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/shop_components.dart';
import 'package:stacked/stacked.dart';

import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
    Widget? child,
  ) {
    return ShopResponsiveScaffold(
      currentTab: viewModel.currentTab,
      onTabSelected: viewModel.onTabSelected,
      bodyBuilder: (context, sizingInformation) {
        if (sizingInformation.isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 320,
                child: Column(
                  children: [
                    _ProfileHeroCard(viewModel: viewModel),
                    const SizedBox(height: 16),
                    _WishlistProfileCard(viewModel: viewModel),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: SurfaceCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Overview',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Manage orders, saved items, addresses, and account settings from one place.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = viewModel.menuItems[index];
                            return ProfileMenuTile(
                              title: item.title,
                              icon: item.icon,
                              onTap: () =>
                                  viewModel.handleMenuTap(item.title, context),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemCount: viewModel.menuItems.length,
                        ),
                        _buildRecentOrdersSection(context, viewModel),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHeroCard(viewModel: viewModel),
              const SizedBox(height: 16),
              _WishlistProfileCard(viewModel: viewModel),
              const SizedBox(height: 14),
              _SupportTicketsProfileCard(viewModel: viewModel),
              const SizedBox(height: 16),
              SurfaceCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                borderRadius: 28,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = viewModel.menuItems[index];
                    return ProfileMenuTile(
                      title: item.title,
                      icon: item.icon,
                      onTap: () =>
                          viewModel.handleMenuTap(item.title, context),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: viewModel.menuItems.length,
                ),
              ),
              _buildRecentOrdersSection(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentOrdersSection(
      BuildContext context, ProfileViewModel viewModel) {
    if (viewModel.recentOrders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        const Text(
          'Recent Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kcVoltSpareTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.recentOrders.take(3).length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = viewModel.recentOrders[index];
            return OrderCard(
              order: order,
              desktopLayout: false,
              onViewDetails: () => viewModel.viewOrderDetails(order),
            );
          },
        ),
      ],
    );
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();

  @override
  void onViewModelReady(ProfileViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) => viewModel.init());
    super.onViewModelReady(viewModel);
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            decoration: BoxDecoration(
              gradient: kcPrimaryGradient,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.white24,
                  backgroundImage: viewModel.user.imageUrl != null
                      ? (viewModel.user.imageUrl!.startsWith('http')
                              ? NetworkImage(viewModel.user.imageUrl!)
                              : FileImage(File(viewModel.user.imageUrl!)))
                          as ImageProvider?
                      : null,
                  child: viewModel.user.imageUrl == null
                      ? Text(
                          viewModel.user.name.isNotEmpty
                              ? viewModel.user.name.characters.first
                                  .toUpperCase()
                              : 'U',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        )
                      : null,
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.user.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => viewModel.editProfile(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  viewModel.user.email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon:
                  const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
              onPressed: () => viewModel.editProfile(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white24,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistProfileCard extends StatelessWidget {
  const _WishlistProfileCard({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final count = viewModel.wishlistCount;
    final String countLabel =
        count == 1 ? '1 saved item' : '$count saved items';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => viewModel.openWishlist(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFF5277).withValues(alpha: 0.18),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF5277).withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5277), Color(0xFFFF758C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF5277).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wishlist',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kcVoltSpareDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'View your saved products',
                      style: TextStyle(
                        fontSize: 13,
                        color: kcVoltSpareTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      countLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF5277),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 26,
                color: kcVoltSpareDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportTicketsProfileCard extends StatelessWidget {
  const _SupportTicketsProfileCard({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => viewModel.openSupportTickets(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF0070F3).withValues(alpha: 0.18),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0070F3).withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0070F3), Color(0xFF00C6FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0070F3).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support Tickets',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kcVoltSpareDark,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Get help or chat with our team',
                      style: TextStyle(
                        fontSize: 13,
                        color: kcVoltSpareTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 26,
                color: kcVoltSpareDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
