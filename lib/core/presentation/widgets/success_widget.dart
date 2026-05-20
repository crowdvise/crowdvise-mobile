import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonTitle,
    this.size = 100,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String image;
  final String buttonTitle;
  final double? size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImage(asset: image, height: size, width: size),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),

                const Gap(8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    color: neutral500,
                  ),
                ),
                const Gap(20),

                Button(title: buttonTitle, onPressed: onPressed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
