import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/shop_components.dart';
import 'package:stacked/stacked.dart';

import 'create_account_viewmodel.dart';

class CreateAccountView extends StackedView<CreateAccountViewModel> {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreateAccountViewModel viewModel,
    Widget? child,
  ) {
    return AuthResponsiveScaffold(
      title: 'Create Account',
      subtitle: 'Sign up to get started',
      footerPrompt: 'Already have an account?',
      footerActionLabel: 'Login',
      onFooterAction: viewModel.navigateToLogin,
      formChildren: [
        AppTextField(
          controller: viewModel.nameController,
          hintText: 'Full Name',
          prefixIcon: Icons.person_outline_rounded,
          errorText: viewModel.nameError,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: viewModel.emailController,
          hintText: 'Email Address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.emailError,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: viewModel.phoneController,
          hintText: 'Phone Number',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          errorText: viewModel.phoneError,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: viewModel.passwordController,
          hintText: 'Password',
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
        const SizedBox(height: 12),
        AppTextField(
          controller: viewModel.confirmPasswordController,
          hintText: 'Confirm Password',
          prefixIcon: Icons.lock_outline_rounded,
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
        const SizedBox(height: 20),
        AppPrimaryButton(
          label: 'REGISTER',
          isLoading: viewModel.isBusy,
          onPressed: viewModel.register,
        ),
      ],
    );
  }

  @override
  CreateAccountViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateAccountViewModel();
}
