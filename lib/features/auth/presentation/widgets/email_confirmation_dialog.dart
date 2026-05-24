import 'dart:async';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Chorus design tokens ────────────────────────────────────────────────────
const _kBg = Color(0xFF09090C);
const _kSurface = Color(0xFF111116);
const _kBorder = Color(0x12FFFFFF);
const _kAccent = electricBlue;
const _kText = Color(0xFFF0F0F5);
const _kMuted = Color(0xFF6E6E7A);

// ── Widget ───────────────────────────────────────────────────────────────────
class EmailConfirmationDialog extends StatefulWidget {
  const EmailConfirmationDialog({
    super.key,
    required this.email,
    this.onOpenEmail,
    this.onLogin,
  });

  final String email;
  final VoidCallback? onOpenEmail;
  final VoidCallback? onLogin;

  /// Convenience method — call this instead of showDialog directly.
  static Future<void> show(
    BuildContext context, {
    required String email,
    VoidCallback? onOpenEmail,
    VoidCallback? onLogin,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.72),
      builder: (_) =>
          EmailConfirmationDialog(email: email, onOpenEmail: onOpenEmail),
    );
  }

  @override
  State<EmailConfirmationDialog> createState() =>
      _EmailConfirmationDialogState();
}

class _EmailConfirmationDialogState extends State<EmailConfirmationDialog>
    with SingleTickerProviderStateMixin {
  // Pulse animation for the envelope icon
  late final AnimationController _pulse;
  late final Animation<double> _ring;
  late final Animation<double> _icon;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _ring = Tween<double>(
      begin: 0.3,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
    _icon = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  // ── Copy email to clipboard ───────────────────────────────────────────────
  void _copyEmail() {
    Clipboard.setData(ClipboardData(text: widget.email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email address copied'),
        duration: const Duration(seconds: 2),
        backgroundColor: _kSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 48,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _IconArea(ring: _ring, icon: _icon),
            _Content(
              email: widget.email,
              onCopy: _copyEmail,
              onOpenEmail: widget.onOpenEmail,
              onResend: () {
                widget.onLogin?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Icon area (top half of dialog) ───────────────────────────────────────────
class _IconArea extends StatelessWidget {
  const _IconArea({required this.ring, required this.icon});

  final Animation<double> ring;
  final Animation<double> icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: const BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring
          AnimatedBuilder(
            animation: ring,
            builder: (_, __) => Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kAccent.withOpacity(ring.value * 0.07),
              ),
            ),
          ),
          // Inner pulse ring
          AnimatedBuilder(
            animation: ring,
            builder: (_, __) => Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _kAccent.withOpacity(ring.value * 0.1),
              ),
            ),
          ),
          // Icon container
          AnimatedBuilder(
            animation: icon,
            builder: (_, child) =>
                Transform.scale(scale: icon.value, child: child),
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: _kAccent.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: _kAccent.withOpacity(0.22), width: 1),
              ),
              child: const Icon(
                Icons.mark_email_unread_outlined,
                color: _kAccent,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Content (bottom half of dialog) ──────────────────────────────────────────
class _Content extends StatelessWidget {
  const _Content({
    required this.email,
    required this.onCopy,
    required this.onResend,
    this.onOpenEmail,
  });

  final String email;
  final VoidCallback onCopy;
  final VoidCallback onResend;
  final VoidCallback? onOpenEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        children: [
          // Title
          const Text(
            'Check your inbox',
            style: TextStyle(
              fontFamily: 'Syne',
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: _kText,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We sent a confirmation link to',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: _kMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Email chip — tap to copy
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _kText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.copy_rounded, size: 13, color: _kMuted),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap the link in the email to activate\nyour account, then come back and log in.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 13,
              color: _kMuted,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),

          // Primary CTA — open email app
          ElevatedButton.icon(
            onPressed: () {
              context.pop();
              onOpenEmail?.call();
            },
            icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
            label: const Text('Okay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(
                double.infinity,
                52,
              ), // 👈 handles full width + height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
