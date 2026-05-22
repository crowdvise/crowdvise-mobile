import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.title,
    this.isLoading = false,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
  });

  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height ?? 48,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: isEnabled ? electricBlue : grey900,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: electricBlue.withValues(alpha: .5),
            offset: const Offset(0, 4),
            blurRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: isLoading == true
            ? CupertinoActivityIndicator(color: white)
            : Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,

                      color: isEnabled ? white : neutral600,
                    ),
                  ),
                  SvgImage(
                    asset: icArrowRight,
                    height: 12,
                    color: isEnabled ? white : neutral600,
                  ),
                ],
              ),
      ),
    );
  }
}

class BorderButton extends StatelessWidget {
  const BorderButton({
    super.key,
    required this.title,
    this.isLoading = false,
    required this.onPressed,
    this.isEnabled = true,
    this.width,
    this.height,
  });

  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height ?? 48,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: nearBlack,

        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: electricBlue, width: 2),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: isLoading == true
            ? CupertinoActivityIndicator(color: theme.colorScheme.surface)
            : Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: isEnabled ? electricBlue : neutral500,
                    ),
                  ),
                  SvgImage(
                    asset: icArrowRight,
                    color: electricBlue,
                    height: 14,
                  ),
                ],
              ),
      ),
    );
  }
}
