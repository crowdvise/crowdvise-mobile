import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Primary action button. Solid signal fill, no glow, quiet hover.
class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.title,
    this.isLoading = false,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
    this.showArrow = false,
  });

  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isEnabled;
  final bool showArrow;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.isEnabled && !widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: widget.height ?? 44,
          width: widget.width ?? double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? (_hovered ? signalSoft : signal) : wsCardHover,
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.isLoading
              ? LoadingAnimationWidget.waveDots(color: white, size: 24)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: enabled ? white : textTertiary,
                      ),
                    ),
                    if (widget.showArrow) ...[
                      const SizedBox(width: 8),
                      SvgImage(
                        asset: icArrowRight,
                        height: 12,
                        color: enabled ? white : textTertiary,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

/// Secondary action. Neutral outline; never competes with the primary.
class BorderButton extends StatefulWidget {
  const BorderButton({
    super.key,
    required this.title,
    this.isLoading = false,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
    this.destructive = false,
  });

  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isEnabled;
  final bool destructive;

  @override
  State<BorderButton> createState() => _BorderButtonState();
}

class _BorderButtonState extends State<BorderButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.isEnabled && !widget.isLoading;
    final fg = !enabled
        ? textTertiary
        : widget.destructive
            ? statusDanger
            : textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: widget.height ?? 44,
          width: widget.width ?? double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hovered && enabled ? wsCardHover : wsCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered && enabled ? hairlineStrong : hairline,
            ),
          ),
          child: widget.isLoading
              ? LoadingAnimationWidget.waveDots(color: textSecondary, size: 24)
              : Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
        ),
      ),
    );
  }
}
