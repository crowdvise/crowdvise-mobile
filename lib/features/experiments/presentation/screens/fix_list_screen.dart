import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/shimmers.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/features/experiments/presentation/manager/experiment_provider.dart';
import 'package:crowdvise/features/experiments/presentation/screens/compare_screen.dart';
import 'package:crowdvise/features/experiments/presentation/screens/fix_loading_screen.dart';
import 'package:crowdvise/features/experiments/presentation/screens/fix_preview_screen.dart';
import 'package:crowdvise/features/experiments/presentation/widgets/reruns_chip.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Step 2 of the experiment flow: POST /experiments/{id}/suggest-fixes.
class FixListScreen extends StatefulWidget {
  static const id = '/fix_list';

  const FixListScreen({
    super.key,
    required this.experimentId,
    required this.rerunsRemaining,
  });

  final String experimentId;
  final int rerunsRemaining;

  @override
  State<FixListScreen> createState() => _FixListScreenState();
}

class _FixListScreenState extends CustomState<FixListScreen> {
  ExperimentProvider? _provider;

  @override
  void onStarted() {
    _provider?.setInitialRerunsRemaining(widget.rerunsRemaining);
    _provider?.listen((event) {
      if (event is String) showError(event);
    });
    _provider?.fetchFixes(widget.experimentId);
    super.onStarted();
  }

  Future<void> _preview(FixSuggestion fix) async {
    final p = _provider;
    if (p == null) return;
    final preview = await p.previewFix(widget.experimentId, fix.id);
    if (preview == null || !mounted) return;
    context.pushInner(
      FixPreviewScreen(
        provider: p,
        experimentId: widget.experimentId,
        preview: preview,
      ),
    );
  }

  void _test(FixSuggestion fix) {
    final p = _provider;
    if (p == null || !p.canRerun || p.loading) return;
    context.pushInner(
      FixLoadingScreen(
        provider: p,
        experimentId: widget.experimentId,
        fix: fix,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final pad = wide ? 32.0 : 20.0;

    return ProviderWidget(
      provider: ExperimentProvider(),
      appBarTitle: 'Test a fix',
      leading: true,
      padding: 0,
      children: (provider, theme) {
        _provider ??= provider;
        final reruns = provider.rerunsRemaining ?? widget.rerunsRemaining;
        final fixes = provider.fixes ?? const <FixSuggestion>[];
        // Two re-runs are allowed per experiment, so a lower count means at
        // least one re-run already exists to compare against.
        final hasRerun = reruns < 2;

        return [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(pad, 28, pad, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PageHeader(
                        eyebrow: 'Experiment',
                        title: 'Suggested fixes',
                        description:
                            'Each fix rewrites one stage where the panel struggled. Preview is free. Testing re-runs the same panel against the change and costs one re-run.',
                        actions: [
                          RerunsChip(remaining: reruns),
                          if (hasRerun)
                            ToolbarButton(
                              label: 'Compare runs',
                              primary: false,
                              onTap: () => context.pushInner(
                                CompareScreen(experimentId: widget.experimentId),
                              ),
                            ),
                        ],
                      ),
                      const Gap(24),
                      if (provider.loading && fixes.isEmpty)
                        const InsightsShimmer()
                      else if (fixes.isEmpty && provider.lastError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            children: [
                              Text(
                                provider.lastError!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: textSecondary,
                                  height: 1.5,
                                ),
                              ),
                              const Gap(16),
                              BorderButton(
                                title: 'Retry',
                                width: 140,
                                onPressed: () =>
                                    provider.fetchFixes(widget.experimentId),
                              ),
                            ],
                          ),
                        )
                      else if (fixes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Text(
                            'No fixes suggested for this run.',
                            style: TextStyle(color: textTertiary),
                          ),
                        )
                      else
                        for (var i = 0; i < fixes.length; i++) ...[
                          _FixCard(
                            index: i + 1,
                            fix: fixes[i],
                            canTest: provider.canRerun,
                            previewing: provider.previewingFixId == fixes[i].id,
                            busy: provider.previewingFixId != null,
                            onPreview: () => _preview(fixes[i]),
                            onTest: () => _test(fixes[i]),
                          ),
                          if (i < fixes.length - 1) const Gap(12),
                        ],
                      if (!provider.canRerun && fixes.isNotEmpty) ...[
                        const Gap(20),
                        const Text(
                          'This experiment has used both re-runs. Start a new simulation to test more changes.',
                          style: TextStyle(fontSize: 12.5, color: textTertiary, height: 1.5),
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

class _FixCard extends StatelessWidget {
  const _FixCard({
    required this.index,
    required this.fix,
    required this.canTest,
    required this.previewing,
    required this.busy,
    required this.onPreview,
    required this.onTest,
  });

  final int index;
  final FixSuggestion fix;
  final bool canTest, previewing, busy;
  final VoidCallback onPreview, onTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: signal,
                  height: 1.6,
                ),
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  fix.title,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const Gap(10),
          Text(
            fix.rationale,
            style: const TextStyle(fontSize: 13.5, color: textSecondary, height: 1.5),
          ),
          const Gap(14),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              _Kv('Stage', fix.targetStageName, textPrimary),
              _Kv('Expected impact', fix.expectedImpact, statusReady),
            ],
          ),
          const Gap(18),
          Row(
            children: [
              Expanded(
                child: BorderButton(
                  title: 'Preview',
                  height: 40,
                  isLoading: previewing,
                  isEnabled: !busy,
                  onPressed: onPreview,
                ),
              ),
              const Gap(10),
              Expanded(
                flex: 2,
                child: Button(
                  title: canTest ? 'Test this fix · 1 re-run' : 'No re-runs left',
                  height: 40,
                  isEnabled: canTest && !busy,
                  onPressed: onTest,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Kv extends StatelessWidget {
  const _Kv(this.k, this.v, this.color);
  final String k, v;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12.5),
        children: [
          TextSpan(text: '$k  ', style: const TextStyle(color: textTertiary)),
          TextSpan(text: v, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
