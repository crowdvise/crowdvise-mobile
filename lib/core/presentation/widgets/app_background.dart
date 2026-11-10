import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

/// Flat app background. Intentionally plain: no blur, no dot grid,
/// no orbs — those cost a full-screen raster pass per frame on web
/// and read as "template UI".
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    // Kept for call-site compatibility; no longer rendered.
    this.showGrid = false,
    this.showOrbs = false,
  });

  final Widget child;
  final bool showGrid;
  final bool showOrbs;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: ink, child: child);
  }
}

/// Solid elevated surface with a hairline border.
/// Replaces the old frosted-glass surface (BackdropFilter) which is the
/// single most expensive primitive on Flutter web.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 12,
    this.blur = 0,
    this.color,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  // Ignored; retained so existing call sites compile.
  final double blur;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final surface = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? inkElevated,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? hairline, width: 1),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: surface);
    }
    return surface;
  }
}
