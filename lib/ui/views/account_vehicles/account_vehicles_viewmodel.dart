import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/core/services/address_service.dart';
import 'package:spare_shop/core/services/vehicle_service.dart';
import 'package:spare_shop/core/services/order_service.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AccountVehiclesViewModel extends BaseViewModel with NavigationMixin {
  final _dialogService = locator<DialogService>();
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  final _addressService = locator<AddressService>();
  final _vehicleService = locator<VehicleService>();
  final _orderService = locator<OrderService>();

  int get currentTabIndex => 4;

  String _userName = 'Customer';
  String get userName => _userName;

  String _userEmail = '';
  String get userEmail => _userEmail;

  String _userPhone = '+91 98765 43210';
  String get userPhone => _userPhone;

  String? _userImageUrl;
  String? get userImageUrl => _userImageUrl;

  VehicleModel? get selectedVehicle => currentSelectedVehicle;

  List<VehicleModel> _vehicles = [];
  List<VehicleModel> get vehicles => _vehicles;

  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => _addresses;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  Future<void> init() async {
    final name = await _tokenService.getUserName();
    final email = await _tokenService.getUserEmail();
    final phone = await _tokenService.getUserPhone();
    final imageUrl = await _tokenService.getUserImageUrl();
    if (name != null && name.isNotEmpty) {
      _userName = name;
    }
    if (email != null && email.isNotEmpty) {
      _userEmail = email;
    }
    if (phone != null && phone.isNotEmpty) {
      _userPhone = phone;
    }
    if (imageUrl != null && imageUrl.isNotEmpty) {
      _userImageUrl = imageUrl;
    }
    await loadData();
  }

  Future<void> loadData() async {
    setBusy(true);
    try {
      _vehicles = await _vehicleService.getVehicles();
      _addresses = await _addressService.getAddresses();
      _orders = await _orderService.getMyOrders();

      // Sync active selected vehicle state
      if (currentSelectedVehicle != null) {
        final hasSelected = _vehicles.any((v) => v.id == currentSelectedVehicle!.id);
        if (!hasSelected && _vehicles.isNotEmpty) {
          currentSelectedVehicle = _vehicles.first;
        }
      } else if (_vehicles.isNotEmpty) {
        currentSelectedVehicle = _vehicles.first;
      }
    } catch (e) {
      print('Error loading dynamic profile data: $e');
    }
    setBusy(false);
  }

  void selectVehicle() {
    goToVehicleSelector();
  }

  void onTabSelected(int index) {
    navigateToTab(index, currentIndex: currentTabIndex);
  }

  void goHome() {
    clearStackAndShowHome();
  }

  void trackOrder(OrderModel order) {
    goToOrderTracking();
  }

  // --- Address CRUD ---

  Future<void> addAddress(AddressModel address) async {
    setBusy(true);
    try {
      await _addressService.addAddress(address);
      await loadData();
    } catch (e) {
      print('Error adding address: $e');
      setBusy(false);
    }
  }

  Future<void> editAddress(String id, AddressModel address) async {
    setBusy(true);
    try {
      await _addressService.updateAddress(id, address);
      await loadData();
    } catch (e) {
      print('Error updating address: $e');
      setBusy(false);
    }
  }

  Future<void> navigateToAddAddress({AddressModel? address}) async {
    final result = await goToAddAddress(address: address);
    if (result == true) {
      await loadData();
    }
  }

  Future<void> deleteAddress(String id) async {
    final confirm = await _dialogService.showConfirmationDialog(
      title: 'Delete Address',
      description: 'Are you sure you want to delete this address?',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (confirm != null && confirm.confirmed) {
      setBusy(true);
      try {
        await _addressService.deleteAddress(id);
        await loadData();
      } catch (e) {
        print('Error deleting address: $e');
        setBusy(false);
      }
    }
  }

  // --- Vehicle CRUD ---

  Future<void> addVehicleDetails(VehicleModel vehicle) async {
    setBusy(true);
    try {
      final newVeh = await _vehicleService.addVehicle(vehicle);
      if (currentSelectedVehicle == null) {
        currentSelectedVehicle = newVeh;
        final email = await _tokenService.getUserEmail();
        if (email != null) {
          await _tokenService.saveSelectedVehicle(email, newVeh);
        }
      }
      await loadData();
    } catch (e) {
      print('Error adding vehicle: $e');
      setBusy(false);
    }
  }

  Future<void> updateVehicleDetails(String id, VehicleModel vehicle) async {
    setBusy(true);
    try {
      await _vehicleService.updateVehicle(id, vehicle);
      if (currentSelectedVehicle?.id == id) {
        currentSelectedVehicle = vehicle;
        final email = await _tokenService.getUserEmail();
        if (email != null) {
          await _tokenService.saveSelectedVehicle(email, vehicle);
        }
      }
      await loadData();
    } catch (e) {
      print('Error updating vehicle: $e');
      setBusy(false);
    }
  }

  Future<void> deleteVehicle(String id) async {
    final confirm = await _dialogService.showConfirmationDialog(
      title: 'Delete Vehicle',
      description: 'Are you sure you want to delete this vehicle?',
      confirmationTitle: 'Delete',
      cancelTitle: 'Cancel',
    );
    if (confirm != null && confirm.confirmed) {
      setBusy(true);
      try {
        await _vehicleService.deleteVehicle(id);
        if (currentSelectedVehicle?.id == id) {
          currentSelectedVehicle = null;
        }
        await loadData();

        final email = await _tokenService.getUserEmail();
        if (email != null) {
          if (currentSelectedVehicle != null) {
            await _tokenService.saveSelectedVehicle(email, currentSelectedVehicle!);
          } else {
            await _tokenService.removeSelectedVehicle(email);
          }
        }
      } catch (e) {
        print('Error deleting vehicle: $e');
        setBusy(false);
      }
    }
  }

  Future<void> logout() async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'Logout',
      description: 'Are you sure you want to logout?',
      confirmationTitle: 'Logout',
      cancelTitle: 'Cancel',
    );

    if (response != null && response.confirmed) {
      setBusy(true);
      await _authService.logout();
      setBusy(false);
      clearStackAndShowLogin();
    }
  }

  void editProfile(BuildContext context) async {
    final nameController = TextEditingController(text: userName);
    final phoneController = TextEditingController(text: userPhone);
    String? selectedImageUrl = userImageUrl;

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
                        final file = await picker.pickImage(
                            source: ImageSource.gallery);
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
                                    : FileImage(File(selectedImageUrl!))) as ImageProvider?
                                : null,
                            child: selectedImageUrl == null
                                ? Text(
                                    userName.isNotEmpty
                                        ? userName.characters.first.toUpperCase()
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
                      controller: TextEditingController(text: userEmail),
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
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    final newPhone = phoneController.text.trim();
                    if (newName.isNotEmpty && newPhone.isNotEmpty) {
                      _userName = newName;
                      _userPhone = newPhone;
                      _userImageUrl = selectedImageUrl;
                      
                      // Persist locally using TokenService
                      await _tokenService.saveUserName(newName);
                      await _tokenService.saveUserPhone(newPhone);
                      if (selectedImageUrl != null) {
                        await _tokenService.saveUserImageUrl(selectedImageUrl!);
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
