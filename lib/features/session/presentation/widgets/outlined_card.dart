import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:flutter/material.dart';

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    required this.height,
    required this.width,
    required this.widget,
    required this.onTap,
  });
  final double height;
  final double width;
  final Widget widget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onPressed: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: grey300.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: neutral500, width: .5),
        ),
        child: widget,
      ),
    );
  }
}
