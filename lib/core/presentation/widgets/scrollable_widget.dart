import 'package:flutter/material.dart';

class ScrollableWidget extends StatelessWidget {
  const ScrollableWidget({
    super.key,
    required this.children,
    this.padding = 0,
    this.alignment = CrossAxisAlignment.start,
    this.maxWidth,
  });

  final List<Widget> children;
  final double padding;
  final CrossAxisAlignment alignment;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    Widget child = SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: alignment,
        children: children,
      ),
    );

    if (maxWidth != null) {
      child = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: child,
        ),
      );
    }

    return Expanded(child: child);
  }
}
