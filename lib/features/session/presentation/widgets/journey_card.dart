import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/features/session/presentation/widgets/outlined_card.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: grey300.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: neutral500, width: .5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          OutlinedCard(
            height: 32,
            width: 32,
            widget: Text(
              widget.index.toString(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: electricBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {},
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 4,
            children: [
              OutlinedCard(
                height: 24,
                width: 24,
                onTap: widget.onEdit,
                widget: Icon(Icons.edit_outlined, size: 16, color: grey300),
              ),
              OutlinedCard(
                height: 24,
                width: 24,
                onTap: widget.onDelete,
                widget: Icon(Icons.close_rounded, size: 16, color: grey300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
