import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sprung/sprung.dart';

class ClothingChip extends StatelessWidget {
  final String? label;
  final bool isSelected;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  final bool isAddChip;

  const ClothingChip({
    super.key,
    this.label,
    this.isSelected = false,
    this.onRemove,
    this.onTap,
    this.isAddChip = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = isAddChip
        ? Colors.grey.shade100
        : isSelected
        ? electricBlue
        : neutral100;

    final textColor = isSelected ? Colors.white : Colors.black87;
    return Clickable(
      onPressed: () {
        onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Sprung.overDamped,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: isAddChip
            ? const Icon(Icons.add, size: 22, color: Color(0xFF9DB4FF))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontSize: 12,
                    ),
                  ),
                  const Gap(10),
                  // if (isSelected) ...[
                  Clickable(
                    onPressed: () {
                      onRemove?.call();
                    },
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
                // ],
              ),
      ),
    );
  }
}

class ClothingType {
  final String name;
  bool selected;

  ClothingType({required this.name, this.selected = false});
}
