import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:crowdvise/features/session/presentation/screens/generate_journery.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Workspace overview: summary of runs, recent activity, quick start.
/// Reads the app-level [HistoryProvider] so data is real, not decorative.
class HomeScreen extends StatefulWidget {
  static const id = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final p = context.read<HistoryProvider>();
      if (p.state.history.isEmpty && !p.loading) p.fetchHistory();
    });
  }

  void _newJourney() => context.pushInner(const GenerateJourneyScreen());

  void _openRun(RunModel run) {
    context.pushInner(
      InsightsScreen(
        simulationId: run.id,
        productDescription: run.productDescription.split('.').first.trim(),
        experimentId: run.experimentId,
      ),
    );
  }

  void _goHistory() => switchDashboardTab(context, 1);

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final pad = isDesktop ? 32.0 : 20.0;
    // The table needs room for six columns beside the desktop sidebar.
    final wideTable = MediaQuery.sizeOf(context).width >= 1280;
    final history = context.watch<HistoryProvider>();
    final runs = [...history.state.history]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final recent = runs.take(5).toList();

    final total = runs.length;
    final ready = runs.where((r) => r.readinessScore >= 70).length;
    final avgScore = total == 0
        ? null
        : (runs.fold<int>(0, (s, r) => s + r.readinessScore) / total).round();
    final avgConv = total == 0
        ? null
        : (runs.fold<double>(0, (s, r) => s + r.overallConversionRate) /
                total *
                100)
            .round();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(pad, isDesktop ? 28 : 16, pad, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    eyebrow: 'Overview',
                    title: _greeting(),
                    description: total == 0
                        ? 'Run your first simulation to see adoption signal here.'
                        : '$total ${total == 1 ? 'run' : 'runs'} · $ready ready to ship',
                    actions: [
                      ToolbarButton(
                        label: 'New journey',
                        icon: Icons.add_rounded,
                        onTap: _newJourney,
                      ),
                    ],
                  ),
                  const Gap(28),

                  // Stats
                  _StatRow(
                    isDesktop: isDesktop,
                    stats: [
                      _Stat(
                        label: 'Total runs',
                        value: total.toString(),
                      ),
                      _Stat(
                        label: 'Avg. readiness',
                        value: avgScore == null ? 'N/A' : '$avgScore',
                        suffix: avgScore == null ? null : '/100',
                        tone: avgScore == null
                            ? null
                            : avgScore >= 70
                                ? statusReady
                                : avgScore >= 40
                                    ? statusWarning
                                    : statusDanger,
                      ),
                      _Stat(
                        label: 'Avg. conversion',
                        value: avgConv == null ? 'N/A' : '$avgConv%',
                      ),
                      _Stat(
                        label: 'Ready to ship',
                        value: total == 0 ? 'N/A' : '$ready of $total',
                      ),
                    ],
                  ),
                  const Gap(32),

                  // Recent runs
                  Row(
                    children: [
                      const Text(
                        'Recent runs',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const Spacer(),
                      if (total > 5)
                        TextButton(
                          onPressed: _goHistory,
                          style: TextButton.styleFrom(
                            foregroundColor: textSecondary,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('View all'),
                        ),
                    ],
                  ),
                  const Gap(12),
                  if (history.loading && runs.isEmpty)
                    const _RunsSkeleton()
                  else if (recent.isEmpty && history.lastError != null)
                    _HistoryError(
                      message: history.lastError!,
                      onRetry: history.fetchHistory,
                    )
                  else if (recent.isEmpty)
                    _EmptyRuns(onStart: _newJourney)
                  else
                    _RunsTable(
                      runs: recent,
                      isDesktop: wideTable,
                      onOpen: _openRun,
                    ),

                  const Gap(32),

                  // Quick start
                  _QuickStart(isDesktop: isDesktop, onStart: _newJourney),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }
}

// ── Stats ────────────────────────────────────────────────────────────────────

class _Stat {
  const _Stat({
    required this.label,
    required this.value,
    this.suffix,
    this.tone,
  });
  final String label;
  final String value;
  final String? suffix;
  final Color? tone;
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stats, required this.isDesktop});
  final List<_Stat> stats;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final cols = isDesktop ? 4 : 2;
    return Container(
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / cols;
          return Wrap(
            children: [
              for (var i = 0; i < stats.length; i++)
                SizedBox(
                  width: w,
                  child: _StatCell(
                    stat: stats[i],
                    rightBorder: (i + 1) % cols != 0,
                    bottomBorder: i < stats.length - cols,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.stat,
    required this.rightBorder,
    required this.bottomBorder,
  });
  final _Stat stat;
  final bool rightBorder;
  final bool bottomBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        border: Border(
          right: rightBorder
              ? const BorderSide(color: hairline)
              : BorderSide.none,
          bottom: bottomBorder
              ? const BorderSide(color: hairline)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textTertiary,
            ),
          ),
          const Gap(10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  stat.value,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: stat.tone ?? textPrimary,
                    height: 1,
                  ),
                ),
                if (stat.suffix != null) ...[
                  const Gap(4),
                  Text(
                    stat.suffix!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Runs table ───────────────────────────────────────────────────────────────

class _RunsTable extends StatelessWidget {
  const _RunsTable({
    required this.runs,
    required this.isDesktop,
    required this.onOpen,
  });
  final List<RunModel> runs;
  final bool isDesktop;
  final ValueChanged<RunModel> onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (isDesktop)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: hairline)),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 6, child: _Th('Product')),
                  Expanded(flex: 3, child: _Th('Segment')),
                  SizedBox(width: 96, child: _Th('Panel')),
                  SizedBox(width: 140, child: _Th('Outcome')),
                  SizedBox(width: 96, child: _Th('Score', end: true)),
                  SizedBox(width: 110, child: _Th('Date', end: true)),
                ],
              ),
            ),
          for (var i = 0; i < runs.length; i++)
            _RunRow(
              run: runs[i],
              isDesktop: isDesktop,
              last: i == runs.length - 1,
              onTap: () => onOpen(runs[i]),
            ),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  const _Th(this.label, {this.end = false});
  final String label;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: end ? TextAlign.end : TextAlign.start,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textTertiary,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _RunRow extends StatefulWidget {
  const _RunRow({
    required this.run,
    required this.isDesktop,
    required this.last,
    required this.onTap,
  });
  final RunModel run;
  final bool isDesktop;
  final bool last;
  final VoidCallback onTap;

  @override
  State<_RunRow> createState() => _RunRowState();
}

class _RunRowState extends State<_RunRow> {
  bool _hover = false;

  Color get _tone {
    final s = widget.run.readinessScore;
    if (s >= 70) return statusReady;
    if (s >= 40) return statusWarning;
    return statusDanger;
  }

  String _date(String iso) {
    try {
      return DateFormat('MMM d').format(DateTime.parse(iso));
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.run;
    final title = r.productDescription.split('.').first.trim();

    final content = widget.isDesktop
        ? Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  r.targetSegment,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: textSecondary),
                ),
              ),
              SizedBox(
                width: 96,
                child: Text(
                  '${r.panelSize} personas',
                  style: const TextStyle(fontSize: 13, color: textSecondary),
                ),
              ),
              SizedBox(
                width: 140,
                child: _OutcomeBar(run: r),
              ),
              SizedBox(
                width: 96,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _ScorePill(score: r.readinessScore, tone: _tone),
                ),
              ),
              SizedBox(
                width: 110,
                child: Text(
                  _date(r.createdAt),
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 12.5, color: textTertiary),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  const Gap(12),
                  _ScorePill(score: r.readinessScore, tone: _tone),
                ],
              ),
              const Gap(6),
              Text(
                '${r.targetSegment} · ${r.panelSize} personas · ${_date(r.createdAt)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12.5, color: textTertiary),
              ),
              const Gap(10),
              _OutcomeBar(run: r),
            ],
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: widget.isDesktop ? 14 : 14,
          ),
          decoration: BoxDecoration(
            color: _hover ? wsCardHover : Colors.transparent,
            border: widget.last
                ? null
                : const Border(bottom: BorderSide(color: hairline)),
          ),
          child: content,
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.score, required this.tone});
  final int score;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$score',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: tone,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _OutcomeBar extends StatelessWidget {
  const _OutcomeBar({required this.run});
  final RunModel run;

  @override
  Widget build(BuildContext context) {
    final c = (run.overallConversionRate * 100).round();
    final d = (run.overallDelayedRate * 100).round();
    final x = (run.overallDropoutRate * 100).round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 4,
        child: Row(
          children: [
            if (c > 0) Expanded(flex: c, child: const ColoredBox(color: statusReady)),
            if (d > 0) Expanded(flex: d, child: const ColoredBox(color: statusWarning)),
            if (x > 0) Expanded(flex: x, child: const ColoredBox(color: statusDanger)),
            if (c + d + x == 0)
              const Expanded(child: ColoredBox(color: hairlineStrong)),
          ],
        ),
      ),
    );
  }
}

class _RunsSkeleton extends StatelessWidget {
  const _RunsSkeleton();

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
          for (var i = 0; i < 3; i++)
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                border: i == 2
                    ? null
                    : const Border(bottom: BorderSide(color: hairline)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 220,
                    height: 10,
                    decoration: BoxDecoration(
                      color: hairline,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 10,
                    decoration: BoxDecoration(
                      color: hairline,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13.5, color: textSecondary, height: 1.5),
          ),
          const Gap(16),
          ToolbarButton(label: 'Retry', primary: false, onTap: onRetry),
        ],
      ),
    );
  }
}

class _EmptyRuns extends StatelessWidget {
  const _EmptyRuns({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      child: Column(
        children: [
          const Text(
            'No runs yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const Gap(6),
          const Text(
            'Describe a product and we’ll assemble a panel to react to it.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: textSecondary),
          ),
          const Gap(18),
          ToolbarButton(
            label: 'Start a run',
            icon: Icons.add_rounded,
            onTap: onStart,
          ),
        ],
      ),
    );
  }
}

// ── Quick start ──────────────────────────────────────────────────────────────

class _QuickStart extends StatelessWidget {
  const _QuickStart({required this.isDesktop, required this.onStart});
  final bool isDesktop;
  final VoidCallback onStart;

  static const _steps = [
    ('Describe', 'Paste a product brief or pitch.'),
    ('Assemble', 'Choose a panel size and segment.'),
    ('Simulate', 'Personas walk the journey in real time.'),
    ('Decide', 'Readiness score, objections, and fixes.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How a run works',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        const Gap(12),
        Container(
          decoration: BoxDecoration(
            color: wsCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: isDesktop
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < _steps.length; i++)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              border: i == _steps.length - 1
                                  ? null
                                  : const Border(
                                      right: BorderSide(color: hairline),
                                    ),
                            ),
                            child: _Step(index: i, step: _steps[i]),
                          ),
                        ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < _steps.length; i++)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: i == _steps.length - 1
                              ? null
                              : const Border(
                                  bottom: BorderSide(color: hairline),
                                ),
                        ),
                        child: _Step(index: i, step: _steps[i]),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.index, required this.step});
  final int index;
  final (String, String) step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '0${index + 1}',
          style: const TextStyle(
            fontFamily: 'Syne',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: signal,
            height: 1.4,
          ),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.$1,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              const Gap(3),
              Text(
                step.$2,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
