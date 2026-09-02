import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel with NavigationMixin {
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();

  LoginViewModel() {
    emailController.text = 'customer.dash@test.com';
    passwordController.text = 'P@ssword123!';
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;

  bool get isPasswordVisible => _isPasswordVisible;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    rebuildUi();
  }

  Future<void> login() async {
    if (!_validate()) return;

    setBusy(true);
    _emailError = null;
    _passwordError = null;

    try {
      final success = await _authService.loginCustomer(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (success) {
        final email = emailController.text.trim();
        final vehicle = await _tokenService.getSelectedVehicle(email);
        if (vehicle != null) {
          currentSelectedVehicle = vehicle;
          userVehicles = [vehicle];
          await replaceWithHome();
        } else {
          await replaceWithChooseVehicleType();
        }
      }
    } catch (e) {
      _emailError = e.toString().replaceAll('ApiException: ', '');
      rebuildUi();
    } finally {
      setBusy(false);
    }
  }

  Future<void> navigateToCreateAccount() async {
    await goToCreateAccount();
  }

  Future<void> continueAsGuest() async {
    setBusy(true);
    try {
      await _authService.enterGuestMode();
      await replaceWithHome();
    } finally {
      setBusy(false);
    }
  }

  bool _validate() {
    _emailError = null;
    _passwordError = null;

    if (emailController.text.trim().isEmpty ||
        !emailController.text.contains('@')) {
      _emailError = 'Enter a valid email address';
    }

    if (passwordController.text.trim().length < 6) {
      _passwordError = 'Password must be at least 6 characters';
    }

    rebuildUi();
    return _emailError == null && _passwordError == null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
