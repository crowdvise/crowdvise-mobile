import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Workspace page header: eyebrow, title, optional description, actions.
/// Left-aligned, restrained — the convention for tooling UIs.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.description,
    this.actions = const [],
  });

  final String title;
  final String? eyebrow;
  final String? description;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 700;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: textTertiary,
            ),
          ),
          const Gap(6),
        ],
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Syne',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            height: 1.15,
          ),
        ),
        if (description != null) ...[
          const Gap(6),
          Text(
            description!,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              color: textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ],
    );

    if (narrow || actions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text,
          if (actions.isNotEmpty) ...[
            const Gap(16),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: text),
        const Gap(24),
        ...actions,
      ],
    );
  }
}

/// Compact primary button for toolbar contexts.
class ToolbarButton extends StatefulWidget {
  const ToolbarButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.primary = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  State<ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<ToolbarButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.primary
        ? (_hover ? signalSoft : signal)
        : (_hover ? wsCardHover : wsCard);
    final fg = widget.primary ? Colors.white : textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: widget.primary ? null : Border.all(color: hairlineStrong),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: fg),
                const Gap(8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
