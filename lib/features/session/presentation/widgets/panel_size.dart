
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/clickable.dart';
import 'package:crowdvise/features/session/domain/models/panel_size.dart';
import 'package:flutter/material.dart';

class PanelSizeWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Clickable(
        onPressed: () {
          onSelect();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? electricBlue.withValues(alpha: .09)
                : const Color(0xFF131314),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? electricBlue : Colors.white10,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4,
            children: [
              Text(
                size.value,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? electricBlue : white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              Text(
                size.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: grey300,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                size.estimatedTime,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: grey900,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}