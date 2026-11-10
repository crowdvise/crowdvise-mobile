import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

/// Flat run card: title, meta line, outcome bar, score. No glow, no glass.
class HistoryCard extends StatefulWidget {
  final RunModel run;
  final VoidCallback? onTap;

  const HistoryCard({super.key, required this.run, this.onTap});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  bool _hover = false;

  Color _tone(int score) {
    if (score >= 70) return statusReady;
    if (score >= 40) return statusWarning;
    return statusDanger;
  }

  String _label(int score) {
    if (score >= 70) return 'Ready';
    if (score >= 40) return 'Needs work';
    return 'Not ready';
  }

  String _date(String iso) {
    try {
      return DateFormat('MMM d, yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final run = widget.run;
    final tone = _tone(run.readinessScore);
    final conv = (run.overallConversionRate * 100).round();
    final delay = (run.overallDelayedRate * 100).round();
    final drop = (run.overallDropoutRate * 100).round();
    final title = run.productDescription.split('.').first.trim();

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _hover ? wsCardHover : wsCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _hover ? hairlineStrong : hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title.isEmpty ? run.productDescription : title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${run.readinessScore}',
                        style: TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: tone,
                          height: 1,
                        ),
                      ),
                      const Gap(3),
                      Text(
                        _label(run.readinessScore),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: tone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(8),
              Text(
                '${run.targetSegment} · ${run.panelSize} personas · ${_date(run.createdAt)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5, color: textTertiary),
              ),
              const Gap(14),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(
                  height: 4,
                  child: Row(
                    children: [
                      if (conv > 0)
                        Expanded(
                          flex: conv,
                          child: const ColoredBox(color: statusReady),
                        ),
                      if (delay > 0)
                        Expanded(
                          flex: delay,
                          child: const ColoredBox(color: statusWarning),
                        ),
                      if (drop > 0)
                        Expanded(
                          flex: drop,
                          child: const ColoredBox(color: statusDanger),
                        ),
                      if (conv + delay + drop == 0)
                        const Expanded(
                          child: ColoredBox(color: hairlineStrong),
                        ),
                    ],
                  ),
                ),
              ),
              const Gap(10),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  _Legend(color: statusReady, label: 'Converted', value: conv),
                  _Legend(color: statusWarning, label: 'Delayed', value: delay),
                  _Legend(color: statusDanger, label: 'Dropped', value: drop),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.color,
    required this.label,
    required this.value,
  });
  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(6),
        Text(
          '$value% $label',
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
      ],
    );
  }
}
