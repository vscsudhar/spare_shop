import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/shop_components.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return AuthResponsiveScaffold(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue shopping',
      footerPrompt: 'Don\'t have an account?',
      footerActionLabel: 'Sign up',
      onFooterAction: viewModel.navigateToCreateAccount,
      formChildren: [
        AppTextField(
          controller: viewModel.emailController,
          hintText: 'Email Address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.emailError,
        ),
        const SizedBox(height: 14),
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
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: kcPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(height: 20),
        AppPrimaryButton(
          label: 'LOGIN',
          isLoading: viewModel.isBusy,
          onPressed: viewModel.login,
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'OR',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 16),
        AppOutlinedButton(
          label: 'Continue with Google',
          icon: const Text(
            'G',
            style: TextStyle(
              color: Color(0xFFE8453C),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
