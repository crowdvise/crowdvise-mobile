import 'package:flutter/material.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';

class GradientCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;
  final double borderRadius;

  const GradientCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 24.0,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: value ? mefaraiGradient : null,
          color: value ? null : Colors.transparent,
          border: value ? null : Border.all(color: neutral700, width: 2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child:
            value
                ? Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: size * 0.7,
                )
                : null,
      ),
    );
  }
}
