import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/field_label.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/shimmers.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/features/experiments/presentation/screens/compare_screen.dart';
import 'package:crowdvise/features/experiments/presentation/screens/fix_list_screen.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/insights/presentation/screens/live_reactions.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/presentation/widgets/ai_generated_chip.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InsightsScreen extends StatefulWidget {
  static const id = '/insights';

  const InsightsScreen({
    super.key,
    required this.simulationId,
    this.model,
    this.productDescription,
    this.experimentId,
    this.rerunsRemaining,
    this.appliedFix,
  });
  final String simulationId;
  final SimulationModel? model;
  final String? productDescription;

  /// Experiment this run belongs to. Needed for fix/compare calls — never
  /// use [simulationId] for those.
  final String? experimentId;
  final int? rerunsRemaining;

  /// Set when this run is a re-run with a fix applied.
  final FixSuggestion? appliedFix;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends CustomState<InsightsScreen> {
  HistoryProvider? _provider;

  @override
  void onStarted() {
    if (widget.model == null) {
      _provider?.gePastSimulations(simulationId: widget.simulationId);
    }
    super.onStarted();
  }

  @override
  Widget build(BuildContext context) {
    final isLive = widget.model != null;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 1000;
    final pad = wide ? 32.0 : 20.0;

    return ProviderWidget(
      provider: HistoryProvider(),
      appBarTitle: 'Results',
      leading: true,
      padding: 0,
      actions: isLive ? const [LiveGeneratedChip()] : null,
      children: (provider, theme) {
        _provider ??= provider;
        final sim = widget.model ?? provider.state.histroyDetails;

        if (provider.loading) {
          return [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(pad, 28, pad, 0),
                child: const InsightsShimmer(),
              ),
            ),
          ];
        }
        if (sim == null) {
          return const [
            Expanded(
              child: Center(
                child: Text(
                  'No results for this run.',
                  style: TextStyle(color: textSecondary),
                ),
              ),
            ),
          ];
        }

        return [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(pad, 28, pad, 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _ResultsBody(
                    sim: sim,
                    wide: wide,
                    isLive: isLive,
                    productDescription: widget.productDescription,
                    experimentId: widget.experimentId,
                    rerunsRemaining: widget.rerunsRemaining,
                    appliedFix: widget.appliedFix,
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
// Body
// ---------------------------------------------------------------------------

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.sim,
    required this.wide,
    required this.isLive,
    required this.productDescription,
    required this.experimentId,
    required this.rerunsRemaining,
    required this.appliedFix,
  });

  final SimulationModel sim;
  final bool wide;
  final bool isLive;
  final String? productDescription;
  final String? experimentId;
  final int? rerunsRemaining;
  final FixSuggestion? appliedFix;

  @override
  Widget build(BuildContext context) {
    final total = sim.agentJourneys.length;
    final converted = (sim.overallConversionRate * total).round();
    final dropped = (sim.overallDropoutRate * total).round();
    final delayed = (sim.overallDelayedRate * total).round();
    final tone = _scoreTone(sim.readinessScore);
    final fix = appliedFix;
    final hasExperiment = experimentId != null && experimentId!.isNotEmpty;
    // When a run is opened from history the remaining count is unknown until
    // the fix list loads; allow entry so the server can be the source of truth.
    final canRerun =
        hasExperiment && (rerunsRemaining == null || rerunsRemaining! > 0);
    // A re-run exists if we're looking at one, or the counter has moved.
    final hasRerun = fix != null || (rerunsRemaining != null && rerunsRemaining! < 2);

    final headline = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          eyebrow: fix != null
              ? 'Re-run · $total personas'
              : isLive
                  ? 'Live run · $total personas'
                  : 'Past run · $total personas',
          title: fix?.title ?? _firstSentence(productDescription) ?? 'Simulation results',
          description: fix != null
              ? 'Fix applied to “${fix.targetStageName}”. ${_verdict(sim)}'
              : _verdict(sim),
        ),
        const Gap(28),
        _StatRow(
          cells: [
            _StatCell(
              label: 'Readiness',
              value: '${sim.readinessScore}',
              unit: '/100',
              tone: tone,
              caption: _scoreLabel(sim.readinessScore),
            ),
            _StatCell(
              label: 'Converted',
              value: '$converted',
              unit: ' of $total',
              tone: statusReady,
              caption: _pct(sim.overallConversionRate),
            ),
            _StatCell(
              label: 'Delayed',
              value: '$delayed',
              unit: ' of $total',
              tone: statusWarning,
              caption: _pct(sim.overallDelayedRate),
            ),
            _StatCell(
              label: 'Dropped',
              value: '$dropped',
              unit: ' of $total',
              tone: statusDanger,
              caption: _pct(sim.overallDropoutRate),
            ),
          ],
          wide: wide,
        ),
      ],
    );

    final stages = _Panel(
      title: 'Where the panel struggled',
      child: _StageTable(stages: sim.stageInsights, wide: wide),
    );

    final insights = _Panel(
      title: 'Top insights',
      child: sim.topInsights.isEmpty
          ? const _Muted('No insights were generated for this run.')
          : Column(
              children: [
                for (var i = 0; i < sim.topInsights.length; i++)
                  _InsightRow(
                    index: i + 1,
                    text: sim.topInsights[i],
                    last: i == sim.topInsights.length - 1,
                  ),
              ],
            ),
    );

    final actions = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionRow(
          title: isLive ? 'Read live reactions' : 'Read persona reactions',
          detail: 'Every persona’s path through each stage, in their own words.',
          onTap: () => context.pushInner(
            LiveReactionsScreen(journeys: sim.agentJourneys, isLive: isLive),
          ),
        ),
        if (hasExperiment && hasRerun) ...[
          const Gap(8),
          _ActionRow(
            title: 'Compare runs',
            detail: 'Baseline vs each fix, side by side with stage drop-off.',
            accent: fix != null,
            onTap: () => context.pushInner(CompareScreen(experimentId: experimentId!)),
          ),
        ],
        if (hasExperiment) ...[
          const Gap(8),
          _ActionRow(
            title: fix != null ? 'Test another fix' : 'Test a fix',
            detail: !canRerun
                ? 'No re-runs left. Start a new simulation to keep iterating.'
                : rerunsRemaining == null
                    ? 'Try a change and re-run the same panel.'
                    : '${rerunsRemaining ?? 0} re-run${rerunsRemaining == 1 ? '' : 's'} left on this panel.',
            accent: fix == null && canRerun,
            enabled: canRerun,
            onTap: () => context.pushInner(
              FixListScreen(
                experimentId: experimentId!,
                rerunsRemaining: rerunsRemaining ?? 2,
              ),
            ),
          ),
        ],
      ],
    );

    if (wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headline,
          const Gap(28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [stages, const Gap(16), insights],
                ),
              ),
              const Gap(16),
              SizedBox(width: 320, child: actions),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        headline,
        const Gap(24),
        actions,
        const Gap(16),
        stages,
        const Gap(16),
        insights,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pieces
// ---------------------------------------------------------------------------

class _StatRow extends StatelessWidget {
  const _StatRow({required this.cells, required this.wide});
  final List<Widget> cells;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final box = BoxDecoration(
      color: wsCard,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: hairline),
    );

    if (wide) {
      return Container(
        decoration: box,
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (var i = 0; i < cells.length; i++) ...[
                if (i > 0) const VerticalDivider(width: 1, color: hairline),
                Expanded(child: cells[i]),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: box,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(children: [
              Expanded(child: cells[0]),
              const VerticalDivider(width: 1, color: hairline),
              Expanded(child: cells[1]),
            ]),
          ),
          const Divider(height: 1, color: hairline),
          IntrinsicHeight(
            child: Row(children: [
              Expanded(child: cells[2]),
              const VerticalDivider(width: 1, color: hairline),
              Expanded(child: cells[3]),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.unit,
    required this.tone,
    required this.caption,
  });
  final String label, value, unit, caption;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textTertiary,
            ),
          ),
          const Gap(10),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w700,
                color: textPrimary,
                height: 1,
              ),
              children: [
                TextSpan(text: value, style: const TextStyle(fontSize: 30)),
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: tone),
              ),
              const Gap(6),
              Text(
                caption,
                style: const TextStyle(fontSize: 12, color: textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});
  final String title;
  final Widget child;

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
            child: SectionTitle(title),
          ),
          const Divider(height: 1, color: hairline),
          child,
        ],
      ),
    );
  }
}

class _StageTable extends StatelessWidget {
  const _StageTable({required this.stages, required this.wide});
  final List<StageInsight> stages;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) {
      return const _Muted('No per-stage data for this run.');
    }
    const h = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w600,
      color: textTertiary,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Row(
            children: [
              const Expanded(flex: 5, child: Text('Stage', style: h)),
              const Expanded(flex: 2, child: Text('Drop-off', style: h)),
              const Expanded(flex: 2, child: Text('Delay', style: h)),
              if (wide) const Expanded(flex: 4, child: Text('Top friction', style: h)),
            ],
          ),
        ),
        const Divider(height: 1, color: hairline),
        for (var i = 0; i < stages.length; i++)
          _StageRow(stage: stages[i], wide: wide, last: i == stages.length - 1),
      ],
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({required this.stage, required this.wide, required this.last});
  final StageInsight stage;
  final bool wide;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final friction = stage.topFrictionTrigger?.trim();
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  _stageTitle(stage.stageName),
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
              Expanded(flex: 2, child: _RateCell(stage.dropoutRate, statusDanger)),
              Expanded(flex: 2, child: _RateCell(stage.delayRate, statusWarning)),
              if (wide)
                Expanded(
                  flex: 4,
                  child: Text(
                    friction == null || friction.isEmpty ? 'None' : friction,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12.5, color: textSecondary),
                  ),
                ),
            ],
          ),
          if (!wide && friction != null && friction.isNotEmpty) ...[
            const Gap(6),
            Text(
              friction,
              style: const TextStyle(fontSize: 12.5, color: textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _RateCell extends StatelessWidget {
  const _RateCell(this.rate, this.tone);
  final double rate;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final v = rate.clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            _pct(v),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 4,
              child: Stack(
                children: [
                  const ColoredBox(
                    color: hairline,
                    child: SizedBox.expand(),
                  ),
                  FractionallySizedBox(
                    widthFactor: v,
                    child: ColoredBox(color: tone, child: const SizedBox.expand()),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Gap(12),
      ],
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.index, required this.text, required this.last});
  final int index;
  final String text;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Text(
              index.toString().padLeft(2, '0'),
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: signal,
                height: 1.5,
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatefulWidget {
  const _ActionRow({
    required this.title,
    required this.detail,
    required this.onTap,
    this.accent = false,
    this.enabled = true,
  });
  final String title, detail;
  final VoidCallback onTap;
  final bool accent;
  final bool enabled;

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final on = widget.enabled;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: on ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: on ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          decoration: BoxDecoration(
            color: _hover && on ? wsCardHover : wsCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.accent && on
                  ? signal.withValues(alpha: _hover ? 0.9 : 0.6)
                  : _hover && on
                      ? hairlineStrong
                      : hairline,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: on ? textPrimary : textTertiary,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      widget.detail,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: widget.accent && on ? signal : textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Muted extends StatelessWidget {
  const _Muted(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Text(text, style: const TextStyle(fontSize: 13, color: textTertiary)),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _pct(double r) => '${(r * 100).round()}%';

Color _scoreTone(int s) =>
    s >= 70 ? statusReady : s >= 40 ? statusWarning : statusDanger;

String _scoreLabel(int s) =>
    s >= 70 ? 'Ready to ship' : s >= 40 ? 'Needs work' : 'Not ready';

String _stageTitle(String name) => name
    .replaceAll('_', ' ')
    .split(' ')
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
    .join(' ');

String? _firstSentence(String? s) {
  if (s == null) return null;
  final t = s.trim();
  if (t.isEmpty) return null;
  final cut = t.indexOf(RegExp(r'[.!?]'));
  final out = cut > 0 ? t.substring(0, cut) : t;
  return out.length > 90 ? '${out.substring(0, 88).trimRight()}…' : out;
}

String _verdict(SimulationModel sim) {
  final s = sim.readinessScore;
  if (s >= 70) {
    return '${_pct(sim.overallConversionRate)} of the panel converted. The concept holds up; remaining friction is cosmetic.';
  }
  if (sim.stageInsights.isEmpty) {
    return sim.topInsights.isNotEmpty ? sim.topInsights.first : 'Mixed result.';
  }
  if (s >= 40) {
    final st = sim.stageInsights.reduce((a, b) => a.delayRate > b.delayRate ? a : b);
    return '${_pct(st.delayRate)} of personas stalled at ${_stageTitle(st.stageName)}. Worth fixing before launch.';
  }
  final st = sim.stageInsights.reduce((a, b) => a.dropoutRate > b.dropoutRate ? a : b);
  return '${_pct(st.dropoutRate)} dropped out at ${_stageTitle(st.stageName)}. This stage is the blocker.';
}
