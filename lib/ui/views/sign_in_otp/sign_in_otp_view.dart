import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'sign_in_otp_viewmodel.dart';

import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';

class SignInOtpView extends StackedView<SignInOtpViewModel> {
  const SignInOtpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignInOtpViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: viewModel.isOtpSent ? 'Verify OTP' : 'Sign In',
        showBackButton: viewModel.isOtpSent,
        onBackPressed: () {
          // If OTP state, back to mobile entry
          if (viewModel.isOtpSent) {
            // Just trigger UI change by using internal state
            // (We could add a back method to viewModel)
            viewModel.sendOtp(); // Toggle it back
          }
        },
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Icon(
                      Icons.electric_bolt_rounded,
                      color: kcVoltSpareEVGreen,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'VoltSpare',
                      style: TextStyle(
                        color: kcVoltSpareDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (!viewModel.isOtpSent) ...[
                    // Mobile entry state
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your mobile number to continue',
                      style: TextStyle(
                        color: kcVoltSpareTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Mobile number',
                      style: TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: viewModel.mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        hintText: '98765 43210',
                        prefixText: '+91   ',
                        prefixStyle: const TextStyle(
                          color: kcVoltSpareTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        counterText: '',
                        filled: true,
                        fillColor: kcVoltSpareWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: kcVoltSpareEVGreen, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryActionButton(
                      label: 'Send OTP',
                      isLoading: viewModel.isLoading,
                      onPressed: viewModel.mobileController.text.length == 10
                          ? viewModel.sendOtp
                          : null,
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: kcVoltSpareBorder)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                                color: kcVoltSpareTextSecondary, fontSize: 13),
                          ),
                        ),
                        Expanded(child: Divider(color: kcVoltSpareBorder)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SecondaryActionButton(
                      label: 'Continue with WhatsApp',
                      icon: Icons.chat_rounded,
                      onPressed: () {
                        // WhatsApp Mock login (Direct to Vehicle selection)
                        viewModel.goToChooseVehicleType();
                      },
                    ),
                  ] else ...[
                    // OTP Verification state
                    const Text(
                      'Verify Mobile',
                      style: TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the 4-digit OTP sent to +91 ${viewModel.mobileController.text}',
                      style: const TextStyle(
                        color: kcVoltSpareTextSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Verification Code',
                      style: TextStyle(
                        color: kcVoltSpareTextPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: viewModel.otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: 24.0,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: '••••',
                        hintStyle: const TextStyle(
                          letterSpacing: 24.0,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        counterText: '',
                        filled: true,
                        fillColor: kcVoltSpareWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: kcVoltSpareEVGreen, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryActionButton(
                      label: 'Verify & Proceed',
                      isLoading: viewModel.isLoading,
                      onPressed: viewModel.otpController.text.length == 4
                          ? viewModel.verifyOtp
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: viewModel.isTimerActive
                          ? Text(
                              'Resend OTP in 0:${viewModel.resendSeconds.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: kcVoltSpareTextSecondary,
                                fontSize: 14,
                              ),
                            )
                          : TextButton(
                              onPressed: viewModel.resendOtp,
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: kcVoltSpareEVGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  SignInOtpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignInOtpViewModel();
}
