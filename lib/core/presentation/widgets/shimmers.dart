import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class BaseShimmer extends StatelessWidget {
  final Widget child;
  const BaseShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.05),
      highlightColor: Colors.white.withValues(alpha: 0.1),
      child: child,
    );
  }
}

class ShimmerBlock extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBlock({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class HistoryShimmer extends StatelessWidget {
  const HistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 4,
        separatorBuilder: (_, __) => const Gap(24),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerBlock(width: 120, height: 14),
                    const ShimmerBlock(width: 80, height: 24, borderRadius: 12),
                  ],
                ),
                const Gap(16),
                const ShimmerBlock(width: double.infinity, height: 26),
                const Gap(8),
                const ShimmerBlock(width: 200, height: 26),
                const Gap(16),
                Row(
                  children: const [
                    ShimmerBlock(width: 90, height: 26, borderRadius: 8),
                    Gap(12),
                    ShimmerBlock(width: 90, height: 26, borderRadius: 8),
                  ],
                ),
                const Gap(24),
                const ShimmerBlock(width: double.infinity, height: 8),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerBlock(width: 80, height: 12),
                    ShimmerBlock(width: 80, height: 12),
                    ShimmerBlock(width: 80, height: 12),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InsightsShimmer extends StatelessWidget {
  const InsightsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(24),
          const ShimmerBlock(width: 150, height: 16),
          const Gap(24),
          // Adoption Likelihood Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBlock(width: 80, height: 80, borderRadius: 40),
                const Gap(20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBlock(width: 140, height: 20),
                      Gap(8),
                      ShimmerBlock(width: double.infinity, height: 14),
                      Gap(4),
                      ShimmerBlock(width: double.infinity, height: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(16),
          // Reaction Breakdown Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBlock(width: 140, height: 14),
                const Gap(20),
                _buildBarShimmer(),
                const Gap(16),
                _buildBarShimmer(),
                const Gap(16),
                _buildBarShimmer(),
              ],
            ),
          ),
          const Gap(16),
          // Top Insights Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerBlock(width: 100, height: 14),
                    ShimmerBlock(width: 20, height: 20),
                  ],
                ),
                const Gap(16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    ShimmerBlock(width: 100, height: 32),
                    ShimmerBlock(width: 140, height: 32),
                    ShimmerBlock(width: 80, height: 32),
                    ShimmerBlock(width: 120, height: 32),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarShimmer() {
    return Row(
      children: const [
        ShimmerBlock(width: 80, height: 14),
        Gap(12),
        Expanded(child: ShimmerBlock(width: double.infinity, height: 8)),
        Gap(12),
        ShimmerBlock(width: 24, height: 14),
      ],
    );
  }
}
