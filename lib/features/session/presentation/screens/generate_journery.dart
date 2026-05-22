import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/session/presentation/manager/home_provider.dart';
import 'package:crowdvise/features/session/presentation/screens/review_journey.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GenerateJourneyScreen extends StatefulWidget {
  static const id = '/generate_journey';

  const GenerateJourneyScreen({super.key});

  @override
  State<GenerateJourneyScreen> createState() => _GenerateJourneyScreenState();
}

class _GenerateJourneyScreenState extends State<GenerateJourneyScreen> {

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: HomeProvider(),
      children: (provider, theme) {
        return [
          const Gap(16),

          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          const Gap(32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'What are you testing today?',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    'Describe your product and we\'ll build a synthetic panel that reacts like real humans.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      color: Colors.white60,
                    ),
                  ),
                  const Gap(40),
                  Text(
                    "PRODUCT OR FEATURE",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white54,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Gap(8),
                  InputField(
                    hint: 'Describe your product or feature',
                    maxLength: 500,
                    maxLines: 6,
                    onChange: (val) {},
                  ),
                  const Gap(24),
                  Text(
                    "WHAT DO YOU WANT TO LEARN?",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white54,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Gap(8),
                  InputField(
                    hint: 'Describe what you want to learn',
                    maxLines: 3,
                    onChange: (val) {},
                  ),

                  const Gap(24),
                  Text(
                    'TARGET CUSTOMER',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white54,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Gap(8),
                  InputField(
                    hint: 'Describe your target customer',
                    onChange: (val) {},
                  ),
                  const Gap(40),
                  Button(
                    title: 'Generate Journey',
                    onPressed: () {
                      context.pushNamed(ReviewJourneyScreen.id);
                    },
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}
