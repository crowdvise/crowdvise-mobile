import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/utils/util_functions.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/scrollable_widget.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/session/presentation/screens/generate_journery.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  static const id = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: SessionProvider(),
      children: (provider, theme) {
        return [
          const Gap(24),
          Text.rich(
            TextSpan(
              text: 'Crowd',
              children: [
                TextSpan(
                  text: 'Vise',
                  style: TextStyle(color: electricBlue),
                ),
              ],
            ),
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            ),
          ),
          const Gap(24),

          ScrollableWidget(
            alignment: CrossAxisAlignment.start,
            children: [
              const Gap(40),
              Text.rich(
                TextSpan(
                  text: 'Test\nbefore\nyou ',
                  children: [
                    TextSpan(
                      text: 'launch.',
                      style: TextStyle(color: electricBlue),
                    ),
                  ],
                ),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 54,
                  fontWeight: FontWeight.w600,
                  // height: 1.0,
                  color: Colors.white,
                ),
              ),
              const Gap(16),
              Text(
                'Synthetic customer panels that behave like real humans without the focus group bill.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  color: Colors.white60,
                  height: 1.5,
                ),
              ),
              const Gap(32),

              Button(
                width: Responsive.isDesktop(context)
                    ? screenWidth(context) / 3
                    : null,
                title: 'Start your Journey',
                onPressed: () {
                  context.pushInner(GenerateJourneyScreen());
                },
              ),
              const Gap(40),
            ],
          ),
        ];
      },
    );
  }
}
