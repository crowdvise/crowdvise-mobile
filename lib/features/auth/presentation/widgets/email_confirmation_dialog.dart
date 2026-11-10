import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailConfirmationDialog extends StatelessWidget {
  const EmailConfirmationDialog({
    super.key,
    required this.email,
    this.onOpenEmail,
    this.onLogin,
  });

  final String email;
  final VoidCallback? onOpenEmail;
  final VoidCallback? onLogin;

  static Future<void> show(
    BuildContext context, {
    required String email,
    VoidCallback? onOpenEmail,
    VoidCallback? onLogin,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => EmailConfirmationDialog(
        email: email,
        onOpenEmail: onOpenEmail,
        onLogin: onLogin,
      ),
    );
  }

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email address copied'),
        duration: const Duration(seconds: 2),
        backgroundColor: wsCardHover,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: wsCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: hairlineStrong),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: wsCardHover,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: hairline),
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  color: signal,
                  size: 18,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Check your inbox',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'We sent a confirmation link to',
                style: TextStyle(fontSize: 13.5, color: textSecondary, height: 1.5),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _copy(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: wsCanvas,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: hairline),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          email,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.copy_rounded, size: 14, color: textTertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Open the link to activate your account, then come back and sign in.',
                style: TextStyle(fontSize: 13, color: textSecondary, height: 1.55),
              ),
              const SizedBox(height: 22),
              Button(
                title: 'Done',
                onPressed: () {
                  context.pop();
                  onOpenEmail?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
