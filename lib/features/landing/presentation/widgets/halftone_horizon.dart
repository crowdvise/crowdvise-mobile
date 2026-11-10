import 'dart:math' as math;

import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

/// A still, print-inspired halftone field that fades in from one corner.
///
/// Painted once and cached in a [RepaintBoundary], so it adds texture without
/// a per-frame shader or animation controller.
class HalftoneHorizon extends StatelessWidget {
  const HalftoneHorizon({
    super.key,
    this.color = signal,
    this.opacity = 0.1,
    this.alignment = Alignment.bottomRight,
    this.spacing = 18,
    this.maxRadius = 2,
    this.curve = 0.07,
  });

  final Color color;
  final double opacity;
  final Alignment alignment;
  final double spacing;
  final double maxRadius;
  final double curve;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _HalftoneHorizonPainter(
            color: color,
            opacity: opacity,
            alignment: alignment,
            spacing: spacing,
            maxRadius: maxRadius,
            curve: curve,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _HalftoneHorizonPainter extends CustomPainter {
  _HalftoneHorizonPainter({
    required this.color,
    required this.opacity,
    required this.alignment,
    required this.spacing,
    required this.maxRadius,
    required this.curve,
  });

  final Color color;
  final double opacity;
  final Alignment alignment;
  final double spacing;
  final double maxRadius;
  final double curve;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || spacing <= 0) return;

    final focal = alignment.alongSize(size);
    final reach = size.longestSide * 0.85;

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity * 0.45),
          color.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(center: focal, radius: reach),
      );
    canvas.drawRect(Offset.zero & size, glow);

    final dot = Paint()..style = PaintingStyle.fill;
    final wave = size.height * curve;

    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        final dx = x - focal.dx;
        final dy = y - focal.dy +
            math.sin((x / size.width) * math.pi) * wave;
        final distance = math.sqrt(dx * dx + dy * dy);
        final falloff = (1 - distance / reach).clamp(0.0, 1.0);
        final eased = falloff * falloff * (3 - 2 * falloff);
        final radius = maxRadius * eased;
        if (radius < 0.35) continue;

        dot.color = color.withValues(
          alpha: (opacity * eased * 2.4).clamp(0.0, 1.0),
        );
        canvas.drawCircle(Offset(x, y), radius, dot);
      }
    }

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color.withValues(alpha: opacity * 0.35);
    canvas.drawArc(
      Rect.fromCircle(center: focal, radius: reach * 0.52),
      math.pi,
      math.pi,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _HalftoneHorizonPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.opacity != opacity ||
      oldDelegate.alignment != alignment ||
      oldDelegate.spacing != spacing ||
      oldDelegate.maxRadius != maxRadius ||
      oldDelegate.curve != curve;
}
