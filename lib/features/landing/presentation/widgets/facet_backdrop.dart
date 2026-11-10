import 'dart:math' as math;

import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

/// Angular facet field — Crowdvise’s geometric language.
/// Facets stay in the upper/mid field; the bottom band is solid ink
/// so the hero→paper cut never shows a mid-tone polygon shelf.
class FacetBackdrop extends StatelessWidget {
  const FacetBackdrop({
    super.key,
    this.intensity = 1,
    this.accent = signal,
    this.fillBottom = true,
  });

  final double intensity;
  final Color accent;

  /// When false (small cards), facets can reach the edges.
  final bool fillBottom;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _FacetPainter(
          intensity: intensity,
          accent: accent,
          fillBottom: fillBottom,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FacetPainter extends CustomPainter {
  _FacetPainter({
    required this.intensity,
    required this.accent,
    required this.fillBottom,
  });

  final double intensity;
  final Color accent;
  final bool fillBottom;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..style = PaintingStyle.fill;

    // Solid ink — always covers the full rect, including the bottom edge.
    canvas.drawRect(Offset.zero & size, Paint()..color = ink);

    // Keep decorative mass above this line so the hero cut stays clean.
    final floor = fillBottom ? size.height * 0.78 : size.height + 40;

    // Right rear plane
    _poly(
      canvas,
      [
        Offset(size.width * 0.52, -40),
        Offset(size.width + 80, size.height * 0.12),
        Offset(size.width + 40, size.height * 0.55),
        Offset(size.width * 0.46, size.height * 0.42),
      ],
      base..color = const Color(0xFF0E1118).withValues(alpha: 0.95 * intensity),
    );

    // Left plane — stops above the floor
    _poly(
      canvas,
      [
        Offset(-80, size.height * 0.22),
        Offset(size.width * 0.36, size.height * 0.18),
        Offset(size.width * 0.22, math.min(floor, size.height * 0.72)),
        Offset(-60, math.min(floor, size.height * 0.68)),
      ],
      base..color = const Color(0xFF12151E).withValues(alpha: 0.9 * intensity),
    );

    // Mid facet
    _poly(
      canvas,
      [
        Offset(size.width * 0.58, size.height * 0.06),
        Offset(size.width * 0.96, size.height * 0.18),
        Offset(size.width * 0.76, size.height * 0.42),
        Offset(size.width * 0.44, size.height * 0.32),
      ],
      base..color = const Color(0xFF1A2030).withValues(alpha: 0.85 * intensity),
    );

    // Lower-right facet — still above the floor
    _poly(
      canvas,
      [
        Offset(size.width * 0.68, size.height * 0.48),
        Offset(size.width * 1.05, size.height * 0.42),
        Offset(size.width * 1.02, math.min(floor - 8, size.height * 0.72)),
        Offset(size.width * 0.62, math.min(floor - 8, size.height * 0.68)),
      ],
      base..color = const Color(0xFF151922).withValues(alpha: 0.9 * intensity),
    );

    // Accent edge
    _poly(
      canvas,
      [
        Offset(size.width * 0.78, size.height * 0.52),
        Offset(size.width * 0.95, size.height * 0.48),
        Offset(size.width * 0.9, size.height * 0.64),
      ],
      base..color = accent.withValues(alpha: 0.55 * intensity),
    );

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.06 * intensity);

    _polyStroke(
      canvas,
      [
        Offset(size.width * 0.58, size.height * 0.06),
        Offset(size.width * 0.96, size.height * 0.18),
        Offset(size.width * 0.76, size.height * 0.42),
        Offset(size.width * 0.44, size.height * 0.32),
      ],
      stroke,
    );

    // Soft vignette — stronger at bottom so any residual edge dissolves into ink
    final vignette = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          Colors.transparent,
          ink.withValues(alpha: 0.35 * intensity),
          ink.withValues(alpha: 0.85 * intensity),
        ],
        stops: const [0.0, 0.55, 0.78, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignette);
  }

  void _poly(Canvas canvas, List<Offset> points, Paint paint) {
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  void _polyStroke(Canvas canvas, List<Offset> points, Paint paint) {
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FacetPainter oldDelegate) =>
      oldDelegate.intensity != intensity ||
      oldDelegate.accent != accent ||
      oldDelegate.fillBottom != fillBottom;
}

/// Subtle paper grain / diagonal for light sections.
class PaperTexture extends StatelessWidget {
  const PaperTexture({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: paper),
        CustomPaint(painter: _PaperPainter(), size: Size.infinite),
        ?child,
      ],
    );
  }
}

class _PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1D26).withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const step = 56.0;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }

    final wash = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.55),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.35));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.35), wash);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Soft parallax drift for hero facets — always clipped by the hero.
class ParallaxFacetBackdrop extends StatelessWidget {
  const ParallaxFacetBackdrop({
    super.key,
    required this.scrollOffset,
  });

  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    final t = (scrollOffset / 600).clamp(0.0, 1.0);
    // No Opacity widget (that forces an offscreen layer); fade via paint
    // intensity instead. Quantize to avoid repainting on sub-pixel changes.
    final intensity = (math.max(0.7, 1 - t * 0.25) * 20).round() / 20;
    final dy = (scrollOffset * 0.04).roundToDouble();
    return Transform.translate(
      offset: Offset(0, dy),
      child: FacetBackdrop(intensity: intensity),
    );
  }
}
