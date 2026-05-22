import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/features/splash/screen/onboarding.dart';
import 'package:crowdvise/features/splash/widget/avatar_grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = '/welcome';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: nearBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(24),
              Center(
                child: Text(
                  'CROWDVISE',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 20,
                    color: electricBlue,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Gap(65),
              const AvatarGrid1(),
              const Gap(48),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your focus\ngroup,\n',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: white,
                      ),
                    ),
                    TextSpan(
                      text: 'on\ndemand.',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: electricBlue,
                      ),
                    ),
                  ],
                ),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
              const Gap(24),
              Text(
                'Synthetic customer panels that react, drop off,\nand subscribe, just like real humans. Zero\nbudget required.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BorderButton(
              title: 'Get started',
              onPressed: () {
                context.pushNamed(OnboardingScreen.id);
              },
            ),
            const Gap(16),
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: electricBlue,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // context.pushNamed(OnboardingScreen.id);
                        },
                    ),
                  ],
                ),
              ),
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}
