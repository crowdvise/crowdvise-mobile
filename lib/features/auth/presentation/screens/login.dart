import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/auth/domain/model/login_model.dart';
import 'package:crowdvise/features/auth/presentation/manager/auth_provider.dart';
import 'package:crowdvise/features/auth/presentation/screens/register.dart';
import 'package:crowdvise/features/auth/presentation/widgets/auth_layout.dart';
import 'package:crowdvise/features/landing/presentation/screens/landing_screen.dart';
import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends CustomState<LoginScreen> {
  AuthProvider? _provider;

  @override
  void onStarted() {
    _provider?.listen((event) {
      if (event is String) {
        showError(event);
      } else if (event is LoginModel) {
        context.pushNamedAndClear(DashboardScreen.id);
        showSuccess('Login Successful');
      }
    });
    super.onStarted();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: AuthProvider(isLogin: true),
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;

        return [
          Expanded(
            child: AuthScreenLayout(
              showBackButton: true,
              onBack: () => context.pushNamedAndClear(LandingScreen.id),
              form: AuthFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeading(
                      title: 'Welcome back',
                      subtitle:
                          'Sign in to continue testing your ideas with AI.',
                    ),
                    const Gap(32),
                    const AuthFieldLabel(label: 'Email address'),
                    const Gap(8),
                    InputField(
                      hint: 'you@company.com',
                      prefix: icEmail,
                      value: state.email,
                      error: state.emailError,
                      inputType: TextInputType.emailAddress,
                      onChange: provider.setEmail,
                    ),
                    const Gap(20),
                    const AuthFieldLabel(label: 'Password'),
                    const Gap(8),
                    InputField(
                      hint: 'Enter your password',
                      prefix: icPassword,
                      value: state.password,
                      error: state.passwordError,
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                      onChange: provider.setPassword,
                    ),
                    const Gap(32),
                    Button(
                      title: 'Sign in',
                      isEnabled: state.isValidated,
                      isLoading: provider.loading,
                      onPressed: provider.login,
                    ),
                    const Gap(28),
                    AuthFooterLink(
                      prompt: 'Don\'t have an account? ',
                      action: 'Create one',
                      onTap: () => context.push(const RegisterScreen()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
