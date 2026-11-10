import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_model.dart';
import 'package:crowdvise/features/auth/presentation/manager/auth_provider.dart';
import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:crowdvise/features/auth/presentation/widgets/auth_layout.dart';
import 'package:crowdvise/features/auth/presentation/widgets/email_confirmation_dialog.dart';
import 'package:crowdvise/features/landing/presentation/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  static const id = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends CustomState<RegisterScreen> {
  AuthProvider? _provider;

  @override
  void onStarted() {
    _provider?.listen((event) {
      if (event is SignUpModel) {
        if (context.mounted) {
          EmailConfirmationDialog.show(
            context,
            email: event.email,
            onOpenEmail: () {
              context.pushNamedAndClear(LoginScreen.id);
            },
            onLogin: () {
              context.pop();
            },
          );
        }
      } else if (event is String) {
        showError(event);
      }
    });
    super.onStarted();
  }

  @override
  Widget build(BuildContext context) {
    // Only split names side-by-side when the form pane is genuinely wide.
    final isWide = Responsive.isDesktop(context);

    return ProviderWidget(
      provider: AuthProvider(),
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;

        return [
          Expanded(
            child: AuthScreenLayout(
              showBackButton: true,
              onBack: () => context.pushNamedAndClear(LandingScreen.id),
              heroTagline:
                  'Join teams using AI personas to validate ideas before launch.',
              heroPills: const [
                'Free to start',
                'No credit card',
                'Setup in minutes',
              ],
              form: AuthFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeading(
                      title: 'Create your account',
                      subtitle:
                          'Get started with synthetic customer panels in minutes.',
                    ),
                    const Gap(32),

                    // Personal info section
                    AuthFormSection(
                      title: 'PERSONAL',
                      children: [
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _NameField(
                                  label: 'First name',
                                  hint: 'Jane',
                                  prefix: icProfile,
                                  value: state.firstName,
                                  error: state.firstNameError,
                                  onChange: provider.setFirstName,
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: _NameField(
                                  label: 'Last name',
                                  hint: 'Doe',
                                  prefix: icProfile,
                                  value: state.lastName,
                                  error: state.lastNameError,
                                  onChange: provider.setLastName,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _NameField(
                            label: 'First name',
                            hint: 'Jane',
                            prefix: icProfile,
                            value: state.firstName,
                            error: state.firstNameError,
                            onChange: provider.setFirstName,
                          ),
                          const Gap(16),
                          _NameField(
                            label: 'Last name',
                            hint: 'Doe',
                            prefix: icProfile,
                            value: state.lastName,
                            error: state.lastNameError,
                            onChange: provider.setLastName,
                          ),
                        ],
                        const Gap(16),
                        const AuthFieldLabel(label: 'Industry'),
                        const Gap(8),
                        InputField(
                          hint: 'e.g. SaaS, Fintech, E-commerce',
                          prefix: briefcase,
                          value: state.industry,
                          error: state.industryError,
                          onChange: provider.setIndustry,
                        ),
                      ],
                    ),

                    const Gap(28),

                    // Account section
                    AuthFormSection(
                      title: 'ACCOUNT',
                      children: [
                        const AuthFieldLabel(label: 'Work email'),
                        const Gap(8),
                        InputField(
                          hint: 'you@company.com',
                          prefix: icEmail,
                          value: state.email,
                          error: state.emailError,
                          inputType: TextInputType.emailAddress,
                          onChange: provider.setEmail,
                        ),
                        const Gap(16),
                        const AuthFieldLabel(label: 'Password'),
                        const Gap(8),
                        InputField(
                          hint: 'Min. 8 characters',
                          prefix: icPassword,
                          value: state.password,
                          error: state.passwordError,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          onChange: provider.setPassword,
                        ),
                        const Gap(16),
                        const AuthFieldLabel(label: 'Confirm password'),
                        const Gap(8),
                        InputField(
                          hint: 'Re-enter your password',
                          prefix: icPassword,
                          value: state.confirmPassword,
                          error: state.confirmPasswordError,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          onChange: provider.setConfirmPassword,
                        ),
                      ],
                    ),

                    const Gap(32),
                    Button(
                      title: 'Create account',
                      isEnabled: state.isValidated && !provider.loading,
                      isLoading: provider.loading,
                      onPressed: provider.register,
                    ),
                    const Gap(28),
                    AuthFooterLink(
                      prompt: 'Already have an account? ',
                      action: 'Sign in',
                      onTap: () => context.push(const LoginScreen()),
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

class _NameField extends StatelessWidget {
  const _NameField({
    required this.label,
    required this.hint,
    required this.prefix,
    required this.value,
    required this.error,
    required this.onChange,
  });

  final String label;
  final String hint;
  final String prefix;
  final String value;
  final String? error;
  final ValueChanged<String> onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(label: label),
        const Gap(8),
        InputField(
          hint: hint,
          prefix: prefix,
          value: value,
          error: error,
          onChange: onChange,
        ),
      ],
    );
  }
}
