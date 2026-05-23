import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/features/splash/widget/old_way.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProblemScreen extends StatelessWidget {
  const ProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OldWayCard(
          icon: Icons.attach_money,
          color: Color(0xFFF24968),
          value: '\$15,000',
          subtitle: 'avg. focus group cost',
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Text(
              '— VS —',
              style: TextStyle(
                color: Colors.white30,
                fontWeight: FontWeight.w600,
                fontFamily: 'PlusJakartaSans',
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        const OldWayCard(
          icon: Icons.access_time_outlined,
          color: Color(0xFFF3B70F),
          value: '6 weeks',
          subtitle: 'time to get results',
        ),
        const Gap(24),
        const Text(
          'THE PROBLEM',
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
              TextSpan(text: 'Traditional\nresearch\nis '),
              TextSpan(
                text: 'broken.',
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
          'Focus groups are slow, expensive, and rarely surface\nwhat customers actually want.',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ],
      ),
    );
  }
}
