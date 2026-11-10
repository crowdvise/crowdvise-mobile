import 'package:flutter/material.dart';

/// Asset image wrapper. Web/WASM safe — no `dart:io` dependency.
class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.asset,
    this.height,
    this.color,
    this.width,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double? height;
  final Color? color;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      height: height,
      width: width,
      color: color,
      fit: fit,
      errorBuilder: (_, _, _) => SizedBox(width: width, height: height),
    );
  }
}
