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
        gradient: isEnabled ? mefaraiGradient : greyGradient,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A43CA).withValues(alpha: .05),
            offset: const Offset(0, 4),
            blurRadius: 8,
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
        child:
            isLoading == true
                ? CupertinoActivityIndicator(color: theme.colorScheme.surface)
                : Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: isEnabled ? theme.colorScheme.surface : neutral500,
                  ),
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
        color: Colors.white,
        border: Border.all(color: primary),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A43CA).withValues(alpha: .05),
            offset: const Offset(0, 4),
            blurRadius: 8,
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
        child:
            isLoading == true
                ? CupertinoActivityIndicator(color: theme.colorScheme.surface)
                : Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: isEnabled ? primary : neutral500,
                  ),
                ),
      ),
    );
  }
}
