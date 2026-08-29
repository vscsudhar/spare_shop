import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:stacked/stacked.dart';

class CreateAccountViewModel extends BaseViewModel with NavigationMixin {
  final _authService = locator<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get phoneError => _phoneError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    rebuildUi();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    rebuildUi();
  }

  Future<void> register() async {
    if (!_validate()) return;

    setBusy(true);
    _emailError = null;

    try {
      final success = await _authService.registerCustomer(
        nameController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
        passwordController.text.trim(),
      );
      if (success) {
        final loginSuccess = await _authService.loginCustomer(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        if (loginSuccess) {
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

  Future<void> navigateToLogin() async {
    await replaceWithLogin();
  }

  bool _validate() {
    _nameError =
        nameController.text.trim().isEmpty ? 'Enter your full name' : null;
    _emailError = emailController.text.contains('@')
        ? null
        : 'Enter a valid email address';
    _phoneError = phoneController.text.trim().length >= 10
        ? null
        : 'Enter a valid phone number';
    final password = passwordController.text.trim();
    if (password.length < 8) {
      _passwordError = 'Password must be at least 8 characters';
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      _passwordError = 'Password must contain at least one uppercase letter';
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      _passwordError = 'Password must contain at least one lowercase letter';
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      _passwordError = 'Password must contain at least one number';
    } else if (!password.contains(RegExp(r'[^A-Za-z0-9]'))) {
      _passwordError = 'Password must contain at least one special character';
    } else {
      _passwordError = null;
    }
    _confirmPasswordError =
        confirmPasswordController.text == passwordController.text
            ? null
            : 'Passwords do not match';

    rebuildUi();
    return [
      _nameError,
      _emailError,
      _phoneError,
      _passwordError,
      _confirmPasswordError,
    ].every((error) => error == null);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
