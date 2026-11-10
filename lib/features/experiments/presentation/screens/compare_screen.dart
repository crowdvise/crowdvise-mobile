import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/field_label.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/shimmers.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/features/experiments/presentation/manager/experiment_provider.dart';
import 'package:crowdvise/features/experiments/presentation/widgets/reruns_chip.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Step 5: GET /simulation/experiments/{id}. Baseline vs each re-run.
class CompareScreen extends StatefulWidget {
  static const id = '/compare';

  const CompareScreen({super.key, required this.experimentId});
  final String experimentId;

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends CustomState<CompareScreen> {
  ExperimentProvider? _provider;

  @override
  void onStarted() {
    _provider?.listen((event) {
      if (event is String) showError(event);
    });
    _provider?.getCompareData(widget.experimentId);
    super.onStarted();
  }

  void _openRun(ExperimentRun run) {
    // Agent detail: GET /simulation/{run_id}
    context.pushInner(
      InsightsScreen(
        simulationId: run.runId,
        experimentId: widget.experimentId,
        rerunsRemaining: _provider?.rerunsRemaining,
        appliedFix: run.appliedFix,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final pad = wide ? 32.0 : 20.0;

    return ProviderWidget(
      provider: ExperimentProvider(),
      appBarTitle: 'Compare runs',
      leading: true,
      padding: 0,
      children: (provider, theme) {
        _provider ??= provider;
        final data = provider.compareResult;
        final runs = [...?data?.runs]..sort((a, b) => a.runIndex.compareTo(b.runIndex));
        final baseline = runs.where((r) => r.runKind == 'baseline').firstOrNull ??
            runs.firstOrNull;

        return [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(pad, 28, pad, 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PageHeader(
                        eyebrow: 'Experiment · ${runs.length} run${runs.length == 1 ? '' : 's'}',
                        title: 'Baseline vs fixes',
                        description:
                            'Same panel every time, so differences come from the change, not the sample. Deltas are against the baseline.',
                        actions: [
                          if (data != null) RerunsChip(remaining: data.rerunsRemaining),
                        ],
                      ),
                      const Gap(28),
                      if (provider.loading && data == null)
                        const InsightsShimmer()
                      else if (runs.isEmpty || baseline == null)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text('No runs found for this experiment.',
                              style: TextStyle(color: textTertiary)),
                        )
                      else ...[
                        _RunsTable(
                          runs: runs,
                          baseline: baseline,
                          wide: wide,
                          onOpen: _openRun,
                        ),
                        const Gap(28),
                        _StageDropout(
                          runs: runs,
                          details: provider.runDetails,
                          loading: provider.loadingDetails,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Runs table
// ---------------------------------------------------------------------------

class _RunsTable extends StatelessWidget {
  const _RunsTable({
    required this.runs,
    required this.baseline,
    required this.wide,
    required this.onOpen,
  });
  final List<ExperimentRun> runs;
  final ExperimentRun baseline;
  final bool wide;
  final ValueChanged<ExperimentRun> onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      child: Column(
        children: [
          if (wide) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Row(
                children: [
                  Expanded(flex: 5, child: _H('Run')),
                  Expanded(flex: 2, child: _H('Readiness')),
                  Expanded(flex: 2, child: _H('Converted')),
                  Expanded(flex: 2, child: _H('Delayed')),
                  Expanded(flex: 2, child: _H('Dropped')),
                  SizedBox(width: 24),
                ],
              ),
            ),
            const Divider(height: 1, color: hairline),
          ],
          for (var i = 0; i < runs.length; i++)
            _RunRow(
              run: runs[i],
              baseline: baseline,
              wide: wide,
              last: i == runs.length - 1,
              onTap: () => onOpen(runs[i]),
            ),
        ],
      ),
    );
  }
}

class _H extends StatelessWidget {
  const _H(this.t);
  final String t;
  @override
  Widget build(BuildContext context) => Text(
        t,
        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textTertiary),
      );
}

class _RunRow extends StatefulWidget {
  const _RunRow({
    required this.run,
    required this.baseline,
    required this.wide,
    required this.last,
    required this.onTap,
  });
  final ExperimentRun run, baseline;
  final bool wide, last;
  final VoidCallback onTap;

  @override
  State<_RunRow> createState() => _RunRowState();
}

class _RunRowState extends State<_RunRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.run;
    final b = widget.baseline;
    final isBase = r.runId == b.runId;

    final name = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isBase ? 'Baseline' : 'Re-run ${r.runIndex}',
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: textPrimary),
            ),
            const Gap(8),
            _LevelPill(r.readinessLevel),
          ],
        ),
        if (r.appliedFix != null) ...[
          const Gap(3),
          Text(
            r.appliedFix!.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.5, color: textSecondary),
          ),
        ],
      ],
    );

    final cells = [
      _Metric(
        value: '${r.readinessScore}',
        delta: isBase ? null : (r.readinessScore - b.readinessScore).toDouble(),
        unit: '',
        higherIsBetter: true,
      ),
      _Metric(
        value: _pct(r.overallConversionRate),
        delta: isBase ? null : (r.overallConversionRate - b.overallConversionRate) * 100,
        unit: 'pt',
        higherIsBetter: true,
      ),
      _Metric(
        value: _pct(r.overallDelayedRate),
        delta: isBase ? null : (r.overallDelayedRate - b.overallDelayedRate) * 100,
        unit: 'pt',
        higherIsBetter: false,
      ),
      _Metric(
        value: _pct(r.overallDropoutRate),
        delta: isBase ? null : (r.overallDropoutRate - b.overallDropoutRate) * 100,
        unit: 'pt',
        higherIsBetter: false,
      ),
    ];

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          decoration: BoxDecoration(
            color: _hover ? wsCardHover : Colors.transparent,
            border: widget.last ? null : const Border(bottom: BorderSide(color: hairline)),
          ),
          child: widget.wide
              ? Row(
                  children: [
                    Expanded(flex: 5, child: name),
                    for (final c in cells) Expanded(flex: 2, child: c),
                    const SizedBox(
                      width: 24,
                      child: Icon(Icons.chevron_right_rounded, size: 18, color: textTertiary),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: name),
                        const Icon(Icons.chevron_right_rounded, size: 18, color: textTertiary),
                      ],
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        for (var i = 0; i < cells.length; i++)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _H(const ['Readiness', 'Converted', 'Delayed', 'Dropped'][i]),
                                const Gap(4),
                                cells[i],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.value,
    required this.delta,
    required this.unit,
    required this.higherIsBetter,
  });
  final String value;
  final double? delta;
  final String unit;
  final bool higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final d = delta;
    Color tone = textTertiary;
    String label = 'N/A';
    if (d != null) {
      final rounded = d.round();
      if (rounded == 0) {
        label = '±0';
      } else {
        final better = higherIsBetter ? rounded > 0 : rounded < 0;
        tone = better ? statusReady : statusDanger;
        label = '${rounded > 0 ? '+' : ''}$rounded$unit';
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Syne',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        if (d != null) ...[
          const Gap(6),
          Text(
            label,
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: tone),
          ),
        ],
      ],
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill(this.level);
  final String level;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (level) {
      'ready' => (statusReady, 'Ready'),
      'iterate' => (statusWarning, 'Iterate'),
      _ => (statusDanger, 'Not ready'),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const Gap(5),
        Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stage-by-stage dropout
// ---------------------------------------------------------------------------

class _StageDropout extends StatelessWidget {
  const _StageDropout({required this.runs, required this.details, required this.loading});
  final List<ExperimentRun> runs;
  final Map<String, SimulationModel> details;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final loaded = runs.where((r) => details.containsKey(r.runId)).toList();

    // Stage order from the baseline (or first loaded run).
    final stageNames = <String>[];
    for (final r in loaded) {
      for (final s in details[r.runId]!.stageInsights) {
        if (!stageNames.contains(s.stageName)) stageNames.add(s.stageName);
      }
    }

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
            child: SectionTitle(
              'Drop-off by stage',
              trailing: _Legend(runs: runs),
            ),
          ),
          const Divider(height: 1, color: hairline),
          if (loading && loaded.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text('Loading stage data…', style: TextStyle(fontSize: 13, color: textTertiary)),
            )
          else if (stageNames.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text('No stage data available.', style: TextStyle(fontSize: 13, color: textTertiary)),
            )
          else
            for (var i = 0; i < stageNames.length; i++)
              Container(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                decoration: BoxDecoration(
                  border: i == stageNames.length - 1
                      ? null
                      : const Border(bottom: BorderSide(color: hairline)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(stageNames[i]),
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    const Gap(8),
                    for (var j = 0; j < runs.length; j++) ...[
                      _Bar(
                        label: runs[j].runKind == 'baseline' ? 'Base' : 'Run ${runs[j].runIndex}',
                        value: _dropFor(runs[j], stageNames[i]),
                        color: _runColor(j),
                        pending: !details.containsKey(runs[j].runId),
                      ),
                      if (j < runs.length - 1) const Gap(4),
                    ],
                  ],
                ),
              ),
        ],
      ),
    );
  }

  double? _dropFor(ExperimentRun run, String stage) {
    final sim = details[run.runId];
    if (sim == null) return null;
    for (final s in sim.stageInsights) {
      if (s.stageName == stage) return s.dropoutRate;
    }
    return 0;
  }
}

Color _runColor(int index) => switch (index) {
      0 => textTertiary,
      1 => signal,
      _ => signalSoft,
    };

class _Legend extends StatelessWidget {
  const _Legend({required this.runs});
  final List<ExperimentRun> runs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        for (var i = 0; i < runs.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: _runColor(i))),
              const Gap(5),
              Text(
                runs[i].runKind == 'baseline' ? 'Baseline' : 'Re-run ${runs[i].runIndex}',
                style: const TextStyle(fontSize: 11.5, color: textSecondary),
              ),
            ],
          ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.label, required this.value, required this.color, required this.pending});
  final String label;
  final double? value;
  final Color color;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final v = (value ?? 0).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(label, style: const TextStyle(fontSize: 11.5, color: textTertiary)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  const ColoredBox(color: hairline, child: SizedBox.expand()),
                  if (!pending)
                    FractionallySizedBox(
                      widthFactor: v,
                      child: ColoredBox(color: color, child: const SizedBox.expand()),
                    ),
                ],
              ),
            ),
          ),
        ),
        const Gap(10),
        SizedBox(
          width: 36,
          child: Text(
            pending ? '…' : _pct(v),
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
          ),
        ),
      ],
    );
  }
}

String _pct(double r) => '${(r * 100).round()}%';

String _title(String s) => s
    .replaceAll('_', ' ')
    .split(' ')
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
    .join(' ');
