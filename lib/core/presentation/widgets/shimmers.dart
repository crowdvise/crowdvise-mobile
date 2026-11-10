import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Static skeletons. The old shimmer sweep ran a perpetual animation on top
/// of a large repaint area; a flat placeholder reads just as clearly and
/// costs nothing per frame.
class BaseShimmer extends StatelessWidget {
  final Widget child;
  const BaseShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child;
}

class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

BoxDecoration _card() => BoxDecoration(
      color: wsCard,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: hairline),
    );

class HistoryShimmer extends StatelessWidget {
  const HistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, _) => const Gap(12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: _card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBlock(width: 220, height: 14),
              Gap(14),
              ShimmerBlock(width: 80, height: 28),
              Gap(14),
              ShimmerBlock(width: double.infinity, height: 4),
            ],
          ),
        );
      },
    );
  }
}

class InsightsShimmer extends StatelessWidget {
  const InsightsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ShimmerBlock(width: 120, height: 10),
        const Gap(10),
        const ShimmerBlock(width: 320, height: 22),
        const Gap(8),
        const ShimmerBlock(width: 420, height: 14),
        const Gap(28),
        Container(
          height: 104,
          decoration: _card(),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: _card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBlock(width: 160, height: 14),
              Gap(18),
              ShimmerBlock(width: double.infinity, height: 12),
              Gap(12),
              ShimmerBlock(width: double.infinity, height: 12),
              Gap(12),
              ShimmerBlock(width: double.infinity, height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
