import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/features/session/domain/models/panel_size.dart';
import 'package:flutter/material.dart';

class PanelSizeWidget extends StatefulWidget {
  const PanelSizeWidget({
    super.key,
    required this.isSelected,
    required this.onSelect,
    required this.size,
  });

  final bool isSelected;
  final VoidCallback onSelect;
  final PanelSize size;

  @override
  State<PanelSizeWidget> createState() => _PanelSizeWidgetState();
}

class _PanelSizeWidgetState extends State<PanelSizeWidget> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onSelect,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: sel ? Colors.white.withValues(alpha: 0.06) : wsCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: sel
                    ? signal
                    : _hover
                        ? hairlineStrong
                        : hairline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.size.value,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: sel ? textPrimary : textSecondary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.size.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.size.estimatedTime,
                  style: const TextStyle(fontSize: 11.5, color: textTertiary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
