import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';

class EmptyState extends StatelessWidget {
  const EmptyState(
      {super.key, required this.title, required this.description, this.onTap});
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgImage(
                  asset: 'icEmptyVector',
                ),
                SvgImage(
                  asset: 'icSearch',
                  height: 32,
                ),
              ],
            ),
          ),
          const Gap(16),
          Text(
            "No $title",
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 14.0),
          ),
          const Gap(4),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.0,
              color: theme.colorScheme.onSurface.withValues(alpha: .5),
            ),
          ),
          const Gap(16),
          if (onTap != null)
            IntrinsicWidth(
              child: Button(
                height: 40,
                title: 'Add $title ',
                onPressed: onTap!,
              ),
            )
        ],
      ),
    );
  }
}
