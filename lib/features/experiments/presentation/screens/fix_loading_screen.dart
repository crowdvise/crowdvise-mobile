import 'dart:async';

import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/experiments/domain/models/experiment_models.dart';
import 'package:crowdvise/features/experiments/presentation/manager/experiment_provider.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

/// Step 4: POST /experiments/{id}/test-fix. Full re-run on the same panel.
/// Replaces itself with the results screen when the response lands.
class FixLoadingScreen extends StatefulWidget {
  static const id = '/fix_loading';

  const FixLoadingScreen({
    super.key,
    required this.provider,
    required this.experimentId,
    required this.fix,
  });

  final ExperimentProvider provider;
  final String experimentId;
  final FixSuggestion fix;

  @override
  State<FixLoadingScreen> createState() => _FixLoadingScreenState();
}

class _FixLoadingScreenState extends State<FixLoadingScreen> {
  int _step = 0;
  Timer? _timer;
  bool _started = false;
  String? _error;

  static const _steps = [
    ('Patching the stage', 'Applying the fix to the journey only where it changes.'),
    ('Reusing the panel', 'Same personas, same thresholds, same order.'),
    ('Re-running the journey', 'Personas move through the patched flow.'),
    ('Comparing to baseline', 'Measuring what moved and what didn’t.'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      if (_step < _steps.length - 1) setState(() => _step++);
    });
  }

  Future<void> _run() async {
    if (_started) return;
    _started = true;
    setState(() {
      _error = null;
      _step = 0;
    });
    _startTimer();
    final p = widget.provider;
    final res = await p.testFix(widget.experimentId, widget.fix.id);
    if (!mounted) return;
    if (res == null) {
      _timer?.cancel();
      setState(() {
        _error = p.lastError ??
            'The re-run didn’t complete. Nothing was charged against your re-runs.';
      });
      return;
    }
    _timer?.cancel();
    try {
      context.read<HistoryProvider>().fetchHistory();
    } catch (_) {
      // Best-effort refresh.
    }
    context.pushReplacementInner(
      InsightsScreen(
        simulationId: res.result.simulationId,
        model: res.result,
        experimentId: res.experimentId,
        rerunsRemaining: res.rerunsRemaining,
        appliedFix: widget.fix,
      ),
    );
  }

  void _retry() {
    _started = false;
    _run();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenShell(
      appBarTitle: 'Testing fix',
      padding: 0,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RE-RUN',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: textTertiary,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      widget.fix.title,
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        height: 1.15,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      _error == null
                          ? 'Changing “${widget.fix.targetStageName}” · same panel · takes about as long as the first run'
                          : 'Nothing was saved and no re-run was used.',
                      style: const TextStyle(fontSize: 13.5, color: textSecondary, height: 1.5),
                    ),
                    const Gap(28),
                    if (_error != null)
                      _ErrorCard(
                        message: _error!,
                        onRetry: _retry,
                        onBack: () => context.popInner(),
                      )
                    else ...[
                      const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        child: LinearProgressIndicator(minHeight: 3),
                      ),
                      const Gap(24),
                      Container(
                        decoration: BoxDecoration(
                          color: wsCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: hairline),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < _steps.length; i++)
                              _StepRow(
                                index: i,
                                current: _step,
                                title: _steps[i].$1,
                                detail: _steps[i].$2,
                                last: i == _steps.length - 1,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

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
              const Icon(Icons.error_outline_rounded,
                  color: statusDanger, size: 18),
              const Gap(10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const Gap(18),
          Row(
            children: [
              Expanded(
                child: BorderButton(
                  title: 'Back',
                  height: 40,
                  onPressed: onBack,
                ),
              ),
              const Gap(10),
              Expanded(
                flex: 2,
                child: Button(
                  title: 'Retry re-run',
                  height: 40,
                  onPressed: onRetry,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.current,
    required this.title,
    required this.detail,
    required this.last,
  });

  final int index, current;
  final String title, detail;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final done = index < current;
    final active = index == current;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: SizedBox(
              width: 14,
              height: 14,
              child: done
                  ? const Icon(Icons.check_rounded, size: 14, color: statusReady)
                  : active
                      ? const Padding(
                          padding: EdgeInsets.all(1),
                          child: CircularProgressIndicator(strokeWidth: 1.6, color: signal),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: hairlineStrong),
                          ),
                        ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: done || active ? textPrimary : textTertiary,
                  ),
                ),
                if (active) ...[
                  const Gap(2),
                  Text(
                    detail,
                    style: const TextStyle(fontSize: 12.5, color: textSecondary, height: 1.4),
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
