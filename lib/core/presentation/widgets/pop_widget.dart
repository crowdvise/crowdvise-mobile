import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:flutter/material.dart';

class PopWidget extends StatelessWidget {
  const PopWidget({super.key, this.callback});

  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Clickable(
      onPressed:
          callback == null
              ? () {
                context.pop();
              }
              : callback!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SvgImage(
          asset: icArrowLeft,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
