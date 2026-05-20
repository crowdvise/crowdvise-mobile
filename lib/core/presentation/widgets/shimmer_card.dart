import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, required this.height, required this.width, this.shape, this.radius});
  final double height;
  final double width;
  final BoxShape? shape;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        shape: shape ?? BoxShape.rectangle,
        borderRadius: radius == null ? null : BorderRadius.circular(radius!)
      ),
    ).animate(
        onPlay: (controller) => controller
            .repeat(reverse: true))
        .shimmer(
        delay: 400.ms,
        duration: 1800.ms,
        color: const Color(0xff7B8891)
    );
  }
}
