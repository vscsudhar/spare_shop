import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/shop_components.dart';
import 'package:stacked/stacked.dart';

import 'forgot_password_viewmodel.dart';

class ForgotPasswordView extends StackedView<ForgotPasswordViewModel> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    Widget? child,
  ) {
    String title;
    String subtitle;

    switch (viewModel.currentStep) {
      case ForgotPasswordStep.email:
        title = 'Forgot Password';
        subtitle = 'Enter your email address to recover your account';
        break;
      case ForgotPasswordStep.otp:
        title = 'Verify Email OTP';
        subtitle = 'Enter the 4-digit code sent to ${viewModel.emailController.text}';
        break;
      case ForgotPasswordStep.newPassword:
        title = 'Reset Password';
        subtitle = 'Create a strong, new password for your account';
        break;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        viewModel.handleBack();
      },
      child: AuthResponsiveScaffold(
        title: title,
        subtitle: subtitle,
        footerPrompt: 'Remember your password?',
        footerActionLabel: 'Login',
        onFooterAction: viewModel.goToLogin,
        formChildren: [
          if (viewModel.currentStep == ForgotPasswordStep.email) ...[
            // Step 1: Email Address Input
            AppTextField(
              controller: viewModel.emailController,
              hintText: 'Registered Email Address',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              errorText: viewModel.emailError,
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: 'SEND OTP',
              isLoading: viewModel.isBusy,
              onPressed: () => viewModel.checkEmailAndSendOtp(context),
            ),
          ] else if (viewModel.currentStep == ForgotPasswordStep.otp) ...[
            // Step 2: OTP Verification
            AppTextField(
              controller: viewModel.otpController,
              hintText: 'Enter OTP (e.g. 0000 or 000000)',
              prefixIcon: Icons.pin_outlined,
              keyboardType: TextInputType.number,
              errorText: viewModel.otpError,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: viewModel.handleBack,
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Change Email'),
                  style: TextButton.styleFrom(
                    foregroundColor: kcVoltSpareTextSecondary,
                  ),
                ),
                viewModel.isTimerActive
                    ? Text(
                        'Resend in 0:${viewModel.resendSeconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: kcVoltSpareTextSecondary,
                          fontSize: 13,
                        ),
                      )
                    : TextButton(
                        onPressed: () => viewModel.resendOtp(context),
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color: kcVoltSpareEVGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: 'VERIFY OTP',
              isLoading: viewModel.isBusy,
              onPressed: () => viewModel.verifyOtp(context),
            ),
          ] else if (viewModel.currentStep == ForgotPasswordStep.newPassword) ...[
            // Step 3: New Password & Confirm Password
            AppTextField(
              controller: viewModel.passwordController,
              hintText: 'New Password (min. 6 characters)',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !viewModel.isPasswordVisible,
              errorText: viewModel.passwordError,
              suffixIcon: IconButton(
                onPressed: viewModel.togglePasswordVisibility,
                icon: Icon(
                  viewModel.isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: kcLightGrey,
                ),
              ),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: viewModel.confirmPasswordController,
              hintText: 'Confirm New Password',
              prefixIcon: Icons.lock_reset_rounded,
              obscureText: !viewModel.isConfirmPasswordVisible,
              errorText: viewModel.confirmPasswordError,
              suffixIcon: IconButton(
                onPressed: viewModel.toggleConfirmPasswordVisibility,
                icon: Icon(
                  viewModel.isConfirmPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: kcLightGrey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: 'UPDATE PASSWORD',
              isLoading: viewModel.isBusy,
              onPressed: () => viewModel.resetPassword(context),
            ),
          ],
        ],
      ),
    );
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(BuildContext context) =>
      ForgotPasswordViewModel();
}
