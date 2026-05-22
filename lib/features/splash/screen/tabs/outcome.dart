import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/features/splash/widget/adoption_score.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OutcomeScreen extends StatelessWidget {
  const OutcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AdoptionScoreWidget(),
        const Gap(16),
        const Text(
          'THE OUTCOME',
          style: TextStyle(
            color: Colors.white54,
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const Gap(16),
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Know what\nto fix\n'),
              TextSpan(
                text: 'before\nlaunch.',
                style: TextStyle(color: electricBlue),
              ),
            ],
          ),
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Adoption score, top objections, and AI-powered\nrecommendations in 30 seconds.',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
