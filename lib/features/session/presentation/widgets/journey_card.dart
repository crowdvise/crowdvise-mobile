import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

/// One stage in the journey list. Index rail on the left, quiet actions right.
class JourneyCard extends StatefulWidget {
  const JourneyCard({
    super.key,
    required this.index,
    required this.title,
    required this.description,
    required this.onEdit,
    required this.onDelete,
  });
  final int index;
  final String title;
  final String description;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<JourneyCard> createState() => _JourneyCardState();
}

class _JourneyCardState extends State<JourneyCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
        decoration: BoxDecoration(
          color: _hover ? wsCardHover : wsCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _hover ? hairlineStrong : hairline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                widget.index.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: signal,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _IconBtn(icon: Icons.edit_outlined, onTap: widget.onEdit),
            _IconBtn(icon: Icons.close_rounded, onTap: widget.onDelete),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: textTertiary),
      ),
    );
  }
}
