import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:flutter/material.dart';

/// "2 re-runs left" — two dots, filled for each remaining re-run.
class RerunsChip extends StatelessWidget {
  const RerunsChip({super.key, required this.remaining, this.max = 2});
  final int remaining;
  final int max;

  @override
  Widget build(BuildContext context) {
    final r = remaining.clamp(0, max);
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < max; i++)
            Container(
              width: 7,
              height: 7,
              margin: EdgeInsets.only(right: i == max - 1 ? 8 : 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < r ? signal : Colors.transparent,
                border: Border.all(color: i < r ? signal : hairlineStrong),
              ),
            ),
          Text(
            r == 0 ? 'No re-runs left' : '$r re-run${r == 1 ? '' : 's'} left',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: r == 0 ? textTertiary : textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
