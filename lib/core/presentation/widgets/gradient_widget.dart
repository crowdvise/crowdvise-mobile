import 'package:flutter/material.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';

class GradientText extends StatelessWidget {
  const GradientText({super.key, required this.text, this.style, required this.gradient});
  final String text;
  final Gradient gradient;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: Text(text, style: style),
    );
  }
}

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    super.key,
    required this.icon,
    this.size = 24,
    required this.gradient,
  });
  final String icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback:
          (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: SvgImage(
        asset: icon,
        height: size,
        width: size,
      ),
    );
  }
}
