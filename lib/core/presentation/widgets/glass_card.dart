import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/app_background.dart';
import 'package:flutter/material.dart';

/// Flat content card. Name kept for compatibility with existing call sites;
/// no blur or glow is rendered anymore.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 12,
    this.onTap,
    this.glowColor,
    this.showGlow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  // Retained for API compatibility; intentionally unused.
  final Color? glowColor;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      child: child,
    );
  }
}

/// Interactive card with a quiet hover state (surface tint + border).
class ActionCard extends StatefulWidget {
  const ActionCard({
    super.key,
    required this.child,
    required this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.accentColor,
  });

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;
  final Color? accentColor;

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _hovered ? wsCardHover : wsCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? hairlineStrong : hairline,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
