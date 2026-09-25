import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/core/services/auth_service.dart';
import 'package:spare_shop/core/services/token_service.dart';
import 'package:spare_shop/core/services/vehicle_service.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:stacked/stacked.dart';

class SignInOtpViewModel extends BaseViewModel with NavigationMixin {
  final _authService = locator<AuthService>();
  final _tokenService = locator<TokenService>();
  final _vehicleService = locator<VehicleService>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool _isOtpSent = false;
  bool get isOtpSent => _isOtpSent;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _resendSeconds = 30;
  int get resendSeconds => _resendSeconds;

  bool _isTimerActive = false;
  bool get isTimerActive => _isTimerActive;

  Timer? _timer;

  Future<void> sendOtp() async {
    if (mobileController.text.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.sendOtp(mobileController.text.trim());
      _isLoading = false;
      _isOtpSent = true;
      startResendTimer();
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startResendTimer() {
    _resendSeconds = 30;
    _isTimerActive = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        _resendSeconds--;
        notifyListeners();
      } else {
        _isTimerActive = false;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  Future<void> resendOtp() async {
    if (_isTimerActive) return;
    await sendOtp();
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.verifyOtp(
          mobileController.text.trim(), otpController.text.trim());
      _isLoading = false;
      notifyListeners();

      final email = await _tokenService.getUserEmail();
      VehicleModel? vehicle;
      if (email != null && email.isNotEmpty) {
        vehicle = await _tokenService.getSelectedVehicle(email);
      }

      if (vehicle == null) {
        try {
          final backendVehicles = await _vehicleService.getVehicles();
          if (backendVehicles.isNotEmpty) {
            vehicle = backendVehicles.first;
            userVehicles = backendVehicles;
            if (email != null && email.isNotEmpty) {
              await _tokenService.saveSelectedVehicle(email, vehicle);
            }
          }
        } catch (_) {}
      }

      if (vehicle != null) {
        currentSelectedVehicle = vehicle;
        if (!userVehicles.any((v) => v.id == vehicle!.id)) {
          userVehicles.add(vehicle);
        }
        await replaceWithHome();
      } else {
        await replaceWithChooseVehicleType();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    mobileController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
