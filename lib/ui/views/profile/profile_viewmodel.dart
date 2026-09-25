import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_shop/app/app.dialogs.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:spare_shop/core/services/wishlist_service.dart';
import 'package:spare_shop/ui/common/mock_data.dart';
import 'package:spare_shop/ui/common/shop_models.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/core/services/order_service.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/core/services/token_service.dart';

class ProfileViewModel extends BaseViewModel with NavigationMixin {
  final _dialogService = locator<DialogService>();
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  final _orderService = locator<OrderService>();
  final _wishlistService = locator<WishlistService>();

  UserProfileData _user = mockUserProfile;
  UserProfileData get user => _user;

  final menuItems = profileMenuItems;

  List<ShopOrder> _recentOrders = [];
  List<ShopOrder> get recentOrders => _recentOrders;

  int get wishlistCount => _wishlistService.wishlistedProductIds.length;

  Future<void> init() async {
    final name = await _tokenService.getUserName();
    final email = await _tokenService.getUserEmail();
    final phone = await _tokenService.getUserPhone();
    final imageUrl = await _tokenService.getUserImageUrl();

    _user = UserProfileData(
      name: (name != null && name.isNotEmpty) ? name : _user.name,
      email: (email != null && email.isNotEmpty) ? email : _user.email,
      phone: (phone != null && phone.isNotEmpty) ? phone : _user.phone,
      address: _user.address,
      imageUrl: imageUrl ?? _user.imageUrl,
    );

    try {
      final profile = await _authService.getProfile();
      if (profile != null) {
        final profName = profile['name']?.toString() ?? _user.name;
        final profEmail = profile['email']?.toString() ?? _user.email;
        final profPhone = profile['phone']?.toString() ?? _user.phone;
        final profImage = profile['profileImage']?.toString() ?? _user.imageUrl;

        _user = UserProfileData(
          name: profName.isNotEmpty ? profName : _user.name,
          email: profEmail.isNotEmpty ? profEmail : _user.email,
          phone: profPhone.isNotEmpty ? profPhone : _user.phone,
          address: _user.address,
          imageUrl: profImage ?? _user.imageUrl,
        );
        notifyListeners();
      }
    } catch (_) {}

    try {
      final list = await _orderService.getMyOrders();
      _recentOrders = list.map((order) {
        OrderStatusFilter filterStatus = OrderStatusFilter.processing;
        if (order.status == OrderStatus.shipped) {
          filterStatus = OrderStatusFilter.shipped;
        } else if (order.status == OrderStatus.delivered) {
          filterStatus = OrderStatusFilter.delivered;
        } else if (order.status == OrderStatus.cancelled) {
          filterStatus = OrderStatusFilter.cancelled;
        }

        final date = order.date;
        final dateStr =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
        final itemsCount =
            order.items.fold<int>(0, (sum, i) => sum + i.quantity);

        final orderNum = order.orderNumber.isNotEmpty
            ? order.orderNumber
            : (order.id.isNotEmpty
                ? 'ORD-${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0).toUpperCase()}'
                : 'ORD-UNKNOWN');

        return ShopOrder(
          id: order.id,
          orderNumber: orderNum,
          dateLabel: dateStr,
          itemCountLabel: '$itemsCount item${itemsCount != 1 ? 's' : ''}',
          total: order.total,
          status: filterStatus,
        );
      }).toList();
    } catch (_) {}

    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    _wishlistService.wishlistedProductIdsNotifier
        .addListener(_onWishlistChanged);
    try {
      await _wishlistService.getWishlist();
    } catch (_) {}

    rebuildUi();
  }

  Future<void> openWishlist([BuildContext? context]) async {
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Wishlist');
      if (!isAuth) return;
    }
    goToWishlist();
  }

  Future<void> openSupportTickets([BuildContext? context]) async {
    if (context != null) {
      final isAuth =
          await ensureAuthenticated(context, featureName: 'Support Tickets');
      if (!isAuth) return;
    }
    goToSupportTickets();
  }

  void _onWishlistChanged() {
    rebuildUi();
  }

  @override
  void dispose() {
    _wishlistService.wishlistedProductIdsNotifier
        .removeListener(_onWishlistChanged);
    super.dispose();
  }

  Future<void> viewOrderDetails(ShopOrder order) async {
    await goToOrderTracking(orderId: order.id);
  }

  AppTab get currentTab => AppTab.profile;

  Future<void> onTabSelected(AppTab tab) async {
    int index = 0;
    if (tab == AppTab.wishlist) index = 1;
    if (tab == AppTab.cart) index = 3;
    if (tab == AppTab.profile) index = 4;
    await navigateToTab(index, currentIndex: 4);
  }

  Future<void> handleMenuTap(String title, [BuildContext? context]) async {
    if (title != 'Logout' && context != null) {
      final isAuth = await ensureAuthenticated(context, featureName: title);
      if (!isAuth) return;
    }

    switch (title) {
      case 'Order History':
      case 'My Orders':
        await goToOrders();
        break;
      case 'My Rare Requests':
        navigationService.navigateTo(Routes.myRareRequestsView);
        break;
      case 'Wishlist':
        await goToWishlist();
        break;
      case 'My Addresses':
      case 'Addresses':
        await goToAddAddress();
        break;
      case 'Logout':
        final response = await _dialogService.showConfirmationDialog(
          title: 'Logout',
          description: 'Are you sure you want to logout?',
          confirmationTitle: 'Logout',
          cancelTitle: 'Cancel',
        );
        if (response != null && response.confirmed) {
          await _authService.logout();
          await replaceWithLogin();
        }
        break;
      default:
        await _dialogService.showCustomDialog(
          variant: DialogType.infoAlert,
          title: title,
          description: '$title feature is currently loaded.',
        );
    }
  }

  void editProfile(BuildContext context) async {
    final isAuth =
        await ensureAuthenticated(context, featureName: 'Edit Profile');
    if (!isAuth) return;

    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    String? selectedImageUrl = user.imageUrl;

    await showDialog(
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
                  Icon(Icons.edit_rounded, color: kcVoltSpareDark),
                  SizedBox(width: 8),
                  Text('Edit Profile',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Image Selector
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final file =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            selectedImageUrl = file.path;
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: selectedImageUrl != null
                                ? (selectedImageUrl!.startsWith('http')
                                        ? NetworkImage(selectedImageUrl!)
                                        : FileImage(File(selectedImageUrl!)))
                                    as ImageProvider?
                                : null,
                            child: selectedImageUrl == null
                                ? Text(
                                    user.name.isNotEmpty
                                        ? user.name.characters.first
                                            .toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: kcVoltSpareDark),
                                  )
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: kcVoltSpareEVGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name Field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Field (Read-only / Non-editable)
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Email Address (Non-Editable)',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      controller: TextEditingController(text: user.email),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newName = nameController.text.trim();
                    final newPhone = phoneController.text.trim();
                    if (newName.isNotEmpty && newPhone.isNotEmpty) {
                      _user = UserProfileData(
                        name: newName,
                        email: _user.email,
                        phone: newPhone,
                        address: _user.address,
                        imageUrl: selectedImageUrl,
                      );
                      _tokenService.saveUserName(newName);
                      _tokenService.saveUserPhone(newPhone);
                      if (selectedImageUrl != null) {
                        _tokenService.saveUserImageUrl(selectedImageUrl!);
                      }
                      rebuildUi();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kcVoltSpareDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
