import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomStep {
  final Widget title;
  final Widget content;
  final bool isActive;
  final Color connectorColor;

  CustomStep({
    required this.title,
    required this.content,
    this.isActive = true,
    this.connectorColor = signal,
  });
}

/// Vertical timeline. Plain Column — no nested ListView inside a scroll view.
class CustomStepper extends StatelessWidget {
  final List<CustomStep> steps;

  const CustomStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 16,
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: steps[i].isActive
                              ? steps[i].connectorColor
                              : Colors.transparent,
                          border: Border.all(
                            color: steps[i].isActive
                                ? steps[i].connectorColor
                                : hairlineStrong,
                          ),
                        ),
                      ),
                      if (i != steps.length - 1)
                        const Expanded(
                          child: VerticalDivider(width: 1, color: hairlineStrong),
                        ),
                    ],
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      steps[i].title,
                      steps[i].content,
                      if (i != steps.length - 1) const Gap(18),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
