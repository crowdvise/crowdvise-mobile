import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:crowdvise/core/presentation/widgets/custom_image.dart';
import 'package:crowdvise/core/presentation/res/drawables.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.buttonTitle,
    required this.onPressed,
    required this.asset,
    this.isClose = true,
  });
  final bool isClose;
  final String asset;
  final String title;
  final String description;
  final String buttonTitle;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isClose)
                    Clickable(
                      onPressed: () {
                        context.pop();
                      },
                      child: SvgImage(
                        asset: icClose,
                        height: 24,
                        width: 24,
                        color: neutral700,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                ],
              ),
              const Gap(8),
              CustomImage(asset: asset, height: 80, width: 80),
              const Gap(15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
              ),
              const Gap(8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: .5),
                ),
              ),
              const Gap(20),
              Button(
                title: buttonTitle,
                onPressed: () {
                  onPressed();
                },
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
