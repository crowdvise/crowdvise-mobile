import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/field_label.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/features/experiments/presentation/manager/experiment_provider.dart';
import 'package:crowdvise/features/experiments/presentation/screens/fix_loading_screen.dart';
import 'package:crowdvise/features/experiments/presentation/widgets/reruns_chip.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

/// Step 3: POST /experiments/{id}/preview-fix. No simulation cost.
/// Shows journey_before vs journey_after and highlights the patched stage.
class FixPreviewScreen extends StatelessWidget {
  static const id = '/fix_preview';

  const FixPreviewScreen({
    super.key,
    required this.provider,
    required this.experimentId,
    required this.preview,
  });

  final ExperimentProvider provider;
  final String experimentId;
  final PreviewFixResponse preview;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final pad = wide ? 32.0 : 20.0;
    final fix = preview.fix;

    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<ExperimentProvider>(
        builder: (context, p, _) {
          final reruns = p.rerunsRemaining ?? 0;
          return ScreenShell(
            appBarTitle: 'Preview fix',
            leading: true,
            padding: 0,
            actions: [RerunsChip(remaining: reruns)],
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(pad, 28, pad, 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PageHeader(
                            eyebrow: 'Preview · no simulation cost',
                            title: fix.title,
                            description: fix.rationale,
                          ),
                          const Gap(24),
                          _ChangeCard(fix: fix),
                          const Gap(28),
                          const SectionTitle('Journey with this fix'),
                          const Gap(4),
                          const Text(
                            'Only the highlighted stage changes. Every other stage, and the panel itself, stays identical.',
                            style: TextStyle(fontSize: 12.5, color: textTertiary, height: 1.5),
                          ),
                          const Gap(14),
                          _JourneyDiff(
                            before: preview.journeyBefore,
                            after: preview.journeyAfter,
                            wide: wide,
                          ),
                          const Gap(32),
                          Row(
                            children: [
                              Expanded(
                                child: BorderButton(
                                  title: 'Back',
                                  onPressed: () => context.popInner(),
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                flex: 2,
                                child: Button(
                                  title: p.canRerun
                                      ? 'Test this fix · 1 re-run'
                                      : 'No re-runs left',
                                  isEnabled: p.canRerun,
                                  onPressed: () => context.pushReplacementInner(
                                    FixLoadingScreen(
                                      provider: p,
                                      experimentId: experimentId,
                                      fix: fix,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChangeCard extends StatelessWidget {
  const _ChangeCard({required this.fix});
  final FixSuggestion fix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
            child: Row(
              children: [
                Expanded(child: SectionTitle('Change to “${fix.targetStageName}”')),
                Text(
                  fix.expectedImpact,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: statusReady,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: hairline),
          _DiffLine(
            marker: '−',
            color: statusDanger,
            text: fix.originalDescription,
          ),
          const Divider(height: 1, color: hairline),
          _DiffLine(
            marker: '+',
            color: statusReady,
            text: fix.patchedDescription,
          ),
        ],
      ),
    );
  }
}

class _DiffLine extends StatelessWidget {
  const _DiffLine({required this.marker, required this.color, required this.text});
  final String marker, text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      color: color.withValues(alpha: 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 16,
            child: Text(
              marker,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13.5, color: textPrimary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyDiff extends StatelessWidget {
  const _JourneyDiff({required this.before, required this.after, required this.wide});
  final List<JourneyStageModel> before, after;
  final bool wide;

  bool _changed(int i) {
    if (i >= before.length || i >= after.length) return true;
    return before[i].name != after[i].name ||
        before[i].description != after[i].description;
  }

  @override
  Widget build(BuildContext context) {
    final n = before.length > after.length ? before.length : after.length;

    if (wide) {
      return Column(
        children: [
          Row(
            children: const [
              Expanded(child: _ColumnHeader('Before')),
              Gap(12),
              Expanded(child: _ColumnHeader('After')),
            ],
          ),
          const Gap(8),
          for (var i = 0; i < n; i++) ...[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: i < before.length
                        ? _StageTile(stage: before[i], changed: _changed(i), side: _Side.before)
                        : const SizedBox.shrink(),
                  ),
                  const Gap(12),
                  Expanded(
                    child: i < after.length
                        ? _StageTile(stage: after[i], changed: _changed(i), side: _Side.after)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            if (i < n - 1) const Gap(8),
          ],
        ],
      );
    }

    // Narrow: only show the after-journey, with the changed stage expanded
    // to also show what it replaced.
    return Column(
      children: [
        for (var i = 0; i < after.length; i++) ...[
          _StageTile(
            stage: after[i],
            changed: _changed(i),
            side: _Side.after,
            replaced: _changed(i) && i < before.length ? before[i] : null,
          ),
          if (i < after.length - 1) const Gap(8),
        ],
      ],
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        color: textTertiary,
      ),
    );
  }
}

enum _Side { before, after }

class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.stage,
    required this.changed,
    required this.side,
    this.replaced,
  });
  final JourneyStageModel stage;
  final bool changed;
  final _Side side;
  final JourneyStageModel? replaced;

  @override
  Widget build(BuildContext context) {
    final accent = side == _Side.after ? statusReady : statusDanger;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: changed ? accent.withValues(alpha: 0.05) : wsCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: changed ? accent.withValues(alpha: 0.6) : hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                stage.order.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: changed ? accent : signal,
                ),
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  stage.name,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: changed ? textPrimary : textSecondary,
                  ),
                ),
              ),
              if (changed)
                Text(
                  side == _Side.after ? 'Patched' : 'Original',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
            ],
          ),
          const Gap(6),
          if (replaced != null) ...[
            Text(
              replaced!.description,
              style: const TextStyle(
                fontSize: 12.5,
                color: textTertiary,
                height: 1.45,
                decoration: TextDecoration.lineThrough,
                decorationColor: textTertiary,
              ),
            ),
            const Gap(6),
          ],
          Text(
            stage.description,
            style: TextStyle(
              fontSize: 12.5,
              color: changed ? textPrimary : textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
