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
    this.connectorColor = const Color(0xFF5B7FFF),
  });
}

class CustomStepper extends StatelessWidget {
  final List<CustomStep> steps;

  const CustomStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indicator & Vertical Line
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: step.isActive ? step.connectorColor : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: step.isActive ? step.connectorColor : Colors.white30,
                        width: 2,
                      ),
                    ),
                    child: step.isActive
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: step.connectorColor,
                      ),
                    ),
                ],
              ),
              const Gap(16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    step.title,
                    step.content,
                    if (!isLast) const Gap(32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
