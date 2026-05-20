import 'package:flutter/material.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';

// ignore: must_be_immutable
class SelectableChip extends StatefulWidget {
  SelectableChip({
    super.key,
    required this.interest,
    required this.theme,
    required this.isSelected,
    this.onTap,
  });

  final String interest;
  final ThemeData theme;
  bool isSelected;
  final VoidCallback? onTap;

  @override
  State<SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<SelectableChip> {
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant SelectableChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      selected = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected;
        });
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: IntrinsicWidth(
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: widget.isSelected ? secondary : neutral100,
            ),
            color: widget.isSelected ? secondary20 : neutral5,
          ),
          child: Text(
            widget.interest,
            textAlign: TextAlign.center,
            style: widget.theme.textTheme.displaySmall?.copyWith(
              fontSize: 14,
              color:
                  widget.isSelected
                      ? secondary
                      : widget.theme.colorScheme.onSurface.withValues(alpha: .4),
            ),
          ),
        ),
      ),
    );
  }
}

Container chipp(BuildContext context, String text) {
  final theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: theme.cardTheme.color,
    ),
    child: IntrinsicWidth(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.displaySmall?.copyWith(
          fontSize: 12,
          color: theme.colorScheme.onSurface.withValues(alpha: .4),
        ),
      ),
    ),
  );
}
