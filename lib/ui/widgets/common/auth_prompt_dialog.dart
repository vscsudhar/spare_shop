import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/app/app.router.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthPromptDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? featureName;

  const AuthPromptDialog({
    Key? key,
    this.title = 'Sign In to Continue',
    this.message = 'Please login or create an account to access this feature.',
    this.featureName,
  }) : super(key: key);

  /// Helper to show the auth prompt modal easily anywhere
  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? message,
    String? featureName,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AuthPromptDialog(
        title: title ?? 'Sign In to Continue',
        message: message ??
            (featureName != null
                ? 'Please login or create an account to access $featureName.'
                : 'Please login or create an account to continue.'),
        featureName: featureName,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final navService = locator<NavigationService>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: kcLightGrey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),

          // Glowing Icon Badge
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0070F3), Color(0xFF00C6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0070F3).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_person_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kcVoltSpareDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle / message
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: kcVoltSpareTextSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Existing User -> Login Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(true);
                navService.navigateTo(Routes.loginView);
              },
              icon: const Icon(Icons.login_rounded, size: 20),
              label: const Text(
                'Existing User - Login',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kcVoltSpareEVGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // New User -> Create Account Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(true);
                navService.navigateTo(Routes.createAccountView);
              },
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
              label: const Text(
                'New User - Create Account',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: kcVoltSpareDark,
                side: const BorderSide(color: kcVoltSpareBorder, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Cancel / Maybe Later
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Continue Browsing as Guest',
              style: TextStyle(
                color: kcVoltSpareTextSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
