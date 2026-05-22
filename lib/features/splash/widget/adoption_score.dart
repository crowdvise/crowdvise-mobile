import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdoptionScoreWidget extends StatelessWidget {
  const AdoptionScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'ADOPTION LIKELIHOOD',
          style: TextStyle(
            color: Colors.white54,
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const Gap(16),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: CircularProgressIndicator(
                value: 0.68,
                strokeWidth: 16,
                backgroundColor: Colors.white10,
                color: electricBlue,
                strokeCap: StrokeCap.round,
              ),
            ),
            const Column(
              children: [
                Text(
                  '68',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Text(
                  '/100',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(24),
        const ProgressBarWidget(
          label: 'Subscribed',
          value: 0.4,
          color: Color(0xFF0FBC73),
        ),
        const SizedBox(height: 16),
        const ProgressBarWidget(
          label: 'Skeptical',
          value: 0.3,
          color: Color(0xFFF3B70F),
        ),
        const SizedBox(height: 16),
        const ProgressBarWidget(
          label: 'Dropped off',
          value: 0.15,
          color: Color(0xFFF24968),
        ),
      ],
    );
  }
}

class ProgressBarWidget extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const ProgressBarWidget({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white10,
              color: color,
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}
