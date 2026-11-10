import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

/// Static status chip. No pulsing animation — a perpetual AnimationController
/// keeps the raster thread busy for nothing.
class AiGeneratedChip extends StatelessWidget {
  const AiGeneratedChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Chip(
      label: 'Generated draft · edit any stage',
      dot: signal,
      fg: textSecondary,
    );
  }
}

class LiveGeneratedChip extends StatelessWidget {
  const LiveGeneratedChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Chip(label: 'Live', dot: statusDanger, fg: statusDanger);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.dot, required this.fg});
  final String label;
  final Color dot;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dot),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
