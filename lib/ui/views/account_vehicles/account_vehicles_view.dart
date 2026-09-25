import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'account_vehicles_viewmodel.dart';

import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';

class AccountVehiclesView extends StackedView<AccountVehiclesViewModel> {
  const AccountVehiclesView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(AccountVehiclesViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) => viewModel.init());
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    AccountVehiclesViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;

        final leftSide = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User profile card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kcVoltSpareWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kcVoltSpareBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: kcVoltSpareEVGreen.withValues(alpha: 0.12),
                    backgroundImage: viewModel.userImageUrl != null
                        ? (viewModel.userImageUrl!.startsWith('http')
                                ? NetworkImage(viewModel.userImageUrl!)
                                : FileImage(File(viewModel.userImageUrl!)))
                            as ImageProvider?
                        : null,
                    child: viewModel.userImageUrl == null
                        ? const Icon(Icons.person_rounded,
                            color: kcVoltSpareEVGreen, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.userName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: kcVoltSpareTextPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          viewModel.userEmail,
                          style: const TextStyle(
                              color: kcVoltSpareTextSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded,
                        color: kcVoltSpareTextPrimary),
                    tooltip: 'Edit Profile',
                    onPressed: () => viewModel.editProfile(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Vehicles Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Vehicles',
                  style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.add,
                          size: 16, color: kcVoltSpareEVGreen),
                      label: const Text('Add',
                          style: TextStyle(
                              color: kcVoltSpareEVGreen,
                              fontWeight: FontWeight.bold)),
                      onPressed: () => _showVehicleDialog(context, viewModel),
                    ),
                    TextButton(
                      onPressed: viewModel.selectVehicle,
                      child: const Text('Manage',
                          style: TextStyle(
                              color: kcVoltSpareEVGreen,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (viewModel.vehicles.isEmpty)
              const Text('No vehicles added yet.')
            else
              ...viewModel.vehicles.map((v) {
                final isSelected = viewModel.selectedVehicle?.id == v.id;
                final isEv = v.type == VehicleType.ev;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? kcVoltSpareEVGreen.withValues(alpha: 0.05)
                        : kcVoltSpareWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: isSelected
                            ? kcVoltSpareEVGreen
                            : kcVoltSpareBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isEv
                            ? Icons.electric_bolt_rounded
                            : Icons.two_wheeler_rounded,
                        color: isEv ? kcVoltSpareEVGreen : kcVoltSpareDark,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${v.brand} ${v.name}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${v.year} · ${isEv ? 'Electric' : 'Petrol'}',
                              style: const TextStyle(
                                  color: kcVoltSpareTextSecondary,
                                  fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: kcVoltSpareEVGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Primary',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            size: 16, color: kcVoltSpareTextSecondary),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            _showVehicleDialog(context, viewModel, v),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 16, color: Colors.redAccent),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        onPressed: () => viewModel.deleteVehicle(v.id),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout_rounded,
                    color: Colors.redAccent, size: 18),
                label: const Text('Logout',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Colors.redAccent.withValues(alpha: 0.35),
                      width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: viewModel.logout,
              ),
            ),
          ],
        );

        final rightSide = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved Addresses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Addresses',
                  style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add,
                      size: 16, color: kcVoltSpareEVGreen),
                  label: const Text('Add',
                      style: TextStyle(
                          color: kcVoltSpareEVGreen,
                          fontWeight: FontWeight.bold)),
                  onPressed: () => viewModel.navigateToAddAddress(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (viewModel.addresses.isEmpty)
              const Text('No saved addresses yet.')
            else
              ...viewModel.addresses.map((addr) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kcVoltSpareWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kcVoltSpareBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              addr.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 16,
                                      color: kcVoltSpareTextSecondary),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () => viewModel
                                      .navigateToAddAddress(address: addr),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      size: 16, color: Colors.redAccent),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      viewModel.deleteAddress(addr.id),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          addr.phone,
                          style: const TextStyle(
                              color: kcVoltSpareTextSecondary, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          addr.addressLine,
                          style: const TextStyle(
                              color: kcVoltSpareTextSecondary,
                              fontSize: 12,
                              height: 1.4),
                        ),
                      ],
                    ),
                  )),

            const SizedBox(height: 24),

            // Wishlist Card
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => viewModel.openWishlist(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: kcVoltSpareWhite,
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
                              viewModel.wishlistCount == 1
                                  ? '1 saved item'
                                  : '${viewModel.wishlistCount} saved items',
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
            ),

            const SizedBox(height: 14),

            // Support Tickets Card
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => viewModel.openSupportTickets(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: kcVoltSpareWhite,
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
                              color: const Color(0xFF0070F3)
                                  .withValues(alpha: 0.3),
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
                              'Need help? Chat with our support team',
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
            ),

            const SizedBox(height: 14),

            // Suggestions & Feedback Card
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showSuggestionDialog(context, viewModel),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: kcVoltSpareWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFF9900).withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9900).withValues(alpha: 0.06),
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
                            colors: [Color(0xFFFF9900), Color(0xFFFFB84D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFFFF9900).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lightbulb_rounded,
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
                              'Suggestions & Feedback',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kcVoltSpareDark,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Share your ideas and feedback with us',
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
            ),

            const SizedBox(height: 14),

            // Order History Card
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: viewModel.toggleOrdersExpanded,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: kcVoltSpareWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withValues(alpha: 0.06),
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
                            colors: [Color(0xFF059669), Color(0xFF10B981)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF059669).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
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
                              'Order History',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kcVoltSpareDark,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Track past orders and delivery status',
                              style: TextStyle(
                                fontSize: 13,
                                color: kcVoltSpareTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              viewModel.orders.isEmpty
                                  ? 'No orders yet'
                                  : (viewModel.orders.length == 1
                                      ? '1 order placed'
                                      : '${viewModel.orders.length} orders placed'),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        viewModel.isOrdersExpanded
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        size: 26,
                        color: kcVoltSpareDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (viewModel.isOrdersExpanded) ...[
              const SizedBox(height: 16),
              if (viewModel.orders.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: kcVoltSpareWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kcVoltSpareBorder),
                  ),
                  child: const Center(
                    child: Text(
                      'No orders placed yet.',
                      style: TextStyle(
                          color: kcVoltSpareTextSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                ...viewModel.orders.map((order) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kcVoltSpareWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kcVoltSpareBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.orderNumber,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              '₹${order.total.toInt()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: kcVoltSpareTextPrimary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Placed on: ${order.date.day}/${order.date.month}/${order.date.year}',
                          style: const TextStyle(
                              color: kcVoltSpareTextSecondary, fontSize: 11),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ${order.status.name.toUpperCase()}',
                              style: TextStyle(
                                color: order.status == OrderStatus.delivered
                                    ? kcVoltSpareEVGreen
                                    : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => viewModel.trackOrder(order),
                              child: const Text('Track Order',
                                  style: TextStyle(
                                      color: kcVoltSpareEVGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ],
        );

        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'My Profile',
            showBackButton: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded,
                    color: kcVoltSpareTextPrimary),
                tooltip: 'Logout',
                onPressed: viewModel.logout,
              ),
            ],
          ),
          body: SafeArea(
            child: viewModel.isBusy &&
                    viewModel.vehicles.isEmpty &&
                    viewModel.addresses.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: kcVoltSpareEVGreen))
                : MaxContentWidth(
                    maxWidth: 1200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 5,
                                    child:
                                        SingleChildScrollView(child: leftSide)),
                                const SizedBox(width: 24),
                                Expanded(
                                    flex: 7,
                                    child: SingleChildScrollView(
                                        child: rightSide)),
                              ],
                            )
                          : ListView(
                              children: [
                                leftSide,
                                const SizedBox(height: 24),
                                rightSide,
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

  void _showVehicleDialog(
      BuildContext context, AccountVehiclesViewModel viewModel,
      [VehicleModel? vehicle]) {
    final brandController = TextEditingController(text: vehicle?.brand ?? '');
    final nameController = TextEditingController(text: vehicle?.name ?? '');
    final yearController = TextEditingController(text: vehicle?.year ?? '');
    VehicleType type = vehicle?.type ?? VehicleType.ev;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(vehicle == null ? 'Add Vehicle' : 'Edit Vehicle',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: brandController,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          const InputDecoration(labelText: 'Brand Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          const InputDecoration(labelText: 'Model Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Year'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Type: '),
                        Radio<VehicleType>(
                          value: VehicleType.ev,
                          groupValue: type,
                          onChanged: (val) {
                            if (val != null) setState(() => type = val);
                          },
                        ),
                        const Text('EV'),
                        Radio<VehicleType>(
                          value: VehicleType.petrol,
                          groupValue: type,
                          onChanged: (val) {
                            if (val != null) setState(() => type = val);
                          },
                        ),
                        const Text('Petrol'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: kcVoltSpareTextSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcVoltSpareEVGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (brandController.text.trim().isEmpty ||
                        nameController.text.trim().isEmpty ||
                        yearController.text.trim().isEmpty) {
                      return;
                    }
                    final updatedVehicle = VehicleModel(
                      id: vehicle?.id ?? '',
                      brand: brandController.text.trim(),
                      name: nameController.text.trim(),
                      year: yearController.text.trim(),
                      type: type,
                    );
                    if (vehicle == null) {
                      viewModel.addVehicleDetails(updatedVehicle);
                    } else {
                      viewModel.updateVehicleDetails(
                          vehicle.id, updatedVehicle);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(vehicle == null ? 'Add' : 'Save',
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuggestionDialog(
      BuildContext context, AccountVehiclesViewModel viewModel) {
    final suggestionController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFFFF3E0),
                    child: Icon(Icons.lightbulb_rounded,
                        color: Color(0xFFFF9900), size: 20),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Suggestions & Feedback',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: kcVoltSpareTextPrimary,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'We value your ideas and feedback! Help us improve our spare parts catalog, store experience, or services.',
                      style: TextStyle(
                        fontSize: 13,
                        color: kcVoltSpareTextSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: suggestionController,
                      maxLines: 5,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Your Suggestion / Feedback *',
                        hintText:
                            'Describe your suggestion, missing spare part, or feedback in detail...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: kcVoltSpareTextSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcVoltSpareDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          final suggestion = suggestionController.text.trim();

                          if (suggestion.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter your suggestion or feedback.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          setState(() => isSubmitting = true);
                          final success = await viewModel.sendSuggestion(
                            suggestion: suggestion,
                            context: context,
                          );
                          setState(() => isSubmitting = false);

                          if (context.mounted) {
                            Navigator.pop(context);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Thank you! Your suggestion has been submitted to the admin team.'),
                                  backgroundColor: Color(0xFF10B981),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Unable to submit suggestion. Please try again later.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Submit Suggestion'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  AccountVehiclesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AccountVehiclesViewModel();
}
