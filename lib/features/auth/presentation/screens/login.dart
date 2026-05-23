import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/scrollable_widget.dart';
import 'package:crowdvise/features/auth/domain/model/login_model.dart';
import 'package:crowdvise/features/auth/presentation/manager/auth_provider.dart';
import 'package:crowdvise/features/auth/presentation/screens/register.dart';
import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:flutter/gestures.dart';
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
      provider: AuthProvider(),
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;
        final formContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Gap(24),
            Text(
              'Welcome\nback',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                height: 1.0,
                color: Colors.white,
              ),
            ),
            const Gap(12),
            Text(
              'Start testing your ideas today.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: Colors.white60,
              ),
            ),
            const Gap(40),
            Text(
              "EMAIL",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white54,
                letterSpacing: 1.5,
              ),
            ),
            const Gap(8),
            InputField(
              hint: 'Email',
              prefix: icEmail,
              value: state.email,
              error: state.emailError,
              inputType: TextInputType.emailAddress,
              onChange: (value) {
                provider.setEmail(value);
              },
            ),
            const Gap(24),
            Text(
              "PASSWORD",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white54,
                letterSpacing: 1.5,
              ),
            ),
            const Gap(8),
            InputField(
              hint: 'Password',
              prefix: icPassword,
              value: state.password,
              error: state.passwordError,
              inputType: TextInputType.visiblePassword,
              isPassword: true,
              onChange: (value) {
                provider.setPassword(value);
              },
            ),
            const Gap(32),
            Button(
              title: 'Login',
              isLoading: provider.loading,
              onPressed: () {
                provider.login();
              },
            ),
            const Gap(24),
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.white10)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: Colors.white10)),
              ],
            ),
            const Gap(32),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Don\'t have an account? ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: electricBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push(const RegisterScreen());
                        },
                    ),
                  ],
                ),
              ),
            ),
            const Gap(20),
          ],
        );

        return [
          Expanded(
            child: Responsive(
              mobile: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [formContent],
                ),
              ),
              desktop: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2A2D3A),
                            Color(0xFF131314),
                          ],
                        ),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 64,
                              color: electricBlue,
                            ),
                            const Gap(24),
                            Text(
                              'CrowdVise',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(16),
                            Text(
                              'The intelligent platform for testing\nyour ideas with AI personas.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 18,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ScrollableWidget(
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 450),
                          child: formContent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}
