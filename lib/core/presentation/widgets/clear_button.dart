import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({super.key, required this.onPressed, required this.title});
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Clickable(
      onPressed: onPressed,
      child: SizedBox(
        height: 51,
        width: double.infinity,
        child: Center(
          child: Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 16,
              color: secondary,
            ),
          ),
        ),
      ),
    );
  }
}
