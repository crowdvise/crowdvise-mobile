import 'package:flutter/material.dart';

class OutlineContainer extends StatelessWidget {
  const OutlineContainer(
      {super.key,
      required this.child,
      this.horizontalPadding = 12,
      this.verticalPadding = 12,
      this.borderWidth});

  final double? borderWidth;
  final Widget child;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: borderWidth ?? 1,
        ),
      ),
      child: child,
    );
  }
}
