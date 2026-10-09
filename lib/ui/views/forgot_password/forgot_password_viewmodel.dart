import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:stacked/stacked.dart';

enum ForgotPasswordStep {
  email,
  otp,
  newPassword,
}

class ForgotPasswordViewModel extends BaseViewModel with NavigationMixin {
  final _authService = locator<AuthService>();

  ForgotPasswordStep _currentStep = ForgotPasswordStep.email;
  ForgotPasswordStep get currentStep => _currentStep;

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _emailError;
  String? get emailError => _emailError;

  String? _otpError;
  String? get otpError => _otpError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  String? _confirmPasswordError;
  String? get confirmPasswordError => _confirmPasswordError;

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  String? _resetToken;
  String? get resetToken => _resetToken;

  int _resendSeconds = 30;
  int get resendSeconds => _resendSeconds;
  Timer? _timer;
  bool get isTimerActive => _timer?.isActive ?? false;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void startResendTimer() {
    _timer?.cancel();
    _resendSeconds = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        _resendSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  /// Step 1: Check if email exists & send OTP
  Future<void> checkEmailAndSendOtp(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _emailError = 'Please enter a valid email address';
      notifyListeners();
      return;
    }
    _emailError = null;

    setBusy(true);
    try {
      final res = await _authService.forgotPasswordCheckEmail(email);
      final data = res['data'] is Map<String, dynamic>
          ? res['data'] as Map<String, dynamic>
          : null;
      _resetToken =
          data?['resetToken']?.toString() ?? data?['token']?.toString();

      _currentStep = ForgotPasswordStep.otp;
      startResendTimer();
      setBusy(false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent to your registered email.'),
            backgroundColor: Color(0xFF0D1B2A),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on DioException catch (e) {
      setBusy(false);
      final statusCode = e.response?.statusCode;
      final msg = e.response?.data?['message']?.toString() ??
          'User not found with this email.';

      if (statusCode == 404 ||
          msg.toLowerCase().contains('not found') ||
          msg.toLowerCase().contains('register')) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg.isNotEmpty
                  ? msg
                  : 'No account found with this email. Please register.'),
              backgroundColor: Colors.redAccent,
              action: SnackBarAction(
                label: 'REGISTER',
                textColor: Colors.white,
                onPressed: () => goToCreateAccount(),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        // Redirect to register after brief delay so user sees feedback
        await Future.delayed(const Duration(milliseconds: 1200));
        goToCreateAccount();
      } else {
        _emailError = msg;
        notifyListeners();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
          );
        }
      }
    } catch (e) {
      setBusy(false);
      _emailError = 'Unable to check email. Please check your connection.';
      notifyListeners();
    }
  }

  /// Step 2: Verify OTP
  Future<void> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();
    if (otp.length < 4) {
      _otpError = 'Please enter at least 4 digits (e.g. 0000 or 000000)';
      notifyListeners();
      return;
    }
    _otpError = null;

    setBusy(true);
    try {
      final res = await _authService.forgotPasswordVerifyOtp(
        emailController.text.trim(),
        otp,
      );
      final data = res['data'] is Map<String, dynamic>
          ? res['data'] as Map<String, dynamic>
          : null;
      if (data?['resetToken'] != null) {
        _resetToken = data!['resetToken'].toString();
      }

      _currentStep = ForgotPasswordStep.newPassword;
      setBusy(false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP verified successfully. Create a new password.'),
            backgroundColor: Color(0xFF00C853),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } on DioException catch (e) {
      setBusy(false);
      final msg =
          e.response?.data?['message']?.toString() ?? 'Invalid or expired OTP.';
      _otpError = msg;
      notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      setBusy(false);
      _otpError = 'Verification failed. Please try again.';
      notifyListeners();
    }
  }

  /// Resend OTP
  Future<void> resendOtp(BuildContext context) async {
    if (isTimerActive) return;
    setBusy(true);
    try {
      await _authService.forgotPasswordCheckEmail(emailController.text.trim());
      startResendTimer();
      setBusy(false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New verification code sent to your email.'),
            backgroundColor: Color(0xFF0D1B2A),
          ),
        );
      }
    } catch (_) {
      setBusy(false);
    }
  }

  /// Step 3: Reset / Change Password
  Future<void> resetPassword(BuildContext context) async {
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (password.length < 6) {
      _passwordError = 'Password must be at least 6 characters long';
      notifyListeners();
      return;
    }
    _passwordError = null;

    if (password != confirm) {
      _confirmPasswordError = 'Passwords do not match';
      notifyListeners();
      return;
    }
    _confirmPasswordError = null;

    setBusy(true);
    try {
      await _authService.forgotPasswordReset(
        email: emailController.text.trim(),
        password: password,
        confirmPassword: confirm,
        token: _resetToken,
      );

      setBusy(false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully! Please log in.'),
            backgroundColor: Color(0xFF00C853),
            duration: Duration(seconds: 3),
          ),
        );
      }

      await Future.delayed(const Duration(milliseconds: 600));
      replaceWithLogin();
    } on DioException catch (e) {
      setBusy(false);
      final msg = e.response?.data?['message']?.toString() ??
          'Failed to reset password.';
      _confirmPasswordError = msg;
      notifyListeners();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      setBusy(false);
      _confirmPasswordError = 'Password update failed. Please try again.';
      notifyListeners();
    }
  }

  /// Back handling
  void handleBack() {
    if (_currentStep == ForgotPasswordStep.otp) {
      _currentStep = ForgotPasswordStep.email;
      notifyListeners();
    } else if (_currentStep == ForgotPasswordStep.newPassword) {
      _currentStep = ForgotPasswordStep.otp;
      notifyListeners();
    } else {
      goToLogin();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
