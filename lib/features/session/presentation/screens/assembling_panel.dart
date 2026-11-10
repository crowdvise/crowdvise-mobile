import 'dart:async';

import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:crowdvise/features/session/domain/models/simulation_response_wrapper_model.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AssemblingPanelScreen extends StatefulWidget {
  static const id = '/assembling_panel';

  const AssemblingPanelScreen({super.key, required this.productDescription});
  final String productDescription;

  @override
  State<AssemblingPanelScreen> createState() => _AssemblingPanelScreenState();
}

class _AssemblingPanelScreenState extends CustomState<AssemblingPanelScreen> {
  int _step = 0;
  Timer? _timer;
  SessionProvider? _provider;
  String? _error;
  bool _started = false;
  bool _done = false;

  static const _steps = [
    ('Assembling panel', 'Selecting personas that match your segment.'),
    ('Building profiles', 'Motivations, budgets, and friction thresholds.'),
    ('Calibrating behaviour', 'Tuning how each persona reacts to cost and effort.'),
    ('Running the journey', 'Personas are moving through each stage.'),
    ('Collecting reactions', 'Logging decisions, objections, and drop-offs.'),
    ('Scoring', 'Computing readiness and top insights.'),
  ];

  @override
  void onStarted() {
    final provider = _provider ?? context.read<SessionProvider>();
    _provider = provider;

    provider.listen((event) {
      if (!mounted) return;
      if (event is String) {
        _timer?.cancel();
        setState(() {
          _error = event;
          _done = false;
        });
      } else if (event is SimulationResponseWrapperModel) {
        _onSuccess(event);
      }
    });

    _start();
    super.onStarted();
  }

  void _start() {
    final provider = _provider;
    if (provider == null || _started) return;
    _started = true;
    _timer?.cancel();
    setState(() {
      _error = null;
      _done = false;
      _step = 0;
    });
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      if (_step < _steps.length - 1) setState(() => _step++);
    });
    provider.runSimulation(stages: provider.state.journeyStages);
  }

  void _retry() {
    _started = false;
    _start();
  }

  void _onSuccess(SimulationResponseWrapperModel event) {
    if (_done) return;
    _done = true;
    _timer?.cancel();
    try {
      context.read<HistoryProvider>().fetchHistory();
    } catch (_) {
      // History is best-effort; never block the results screen.
    }
    context.replaceInnerUntilRoot(
      InsightsScreen(
        simulationId: event.result.simulationId,
        productDescription: widget.productDescription,
        model: event.result,
        experimentId: event.experimentId,
        rerunsRemaining: event.rerunsRemaining,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _eta => switch (_provider?.state.selectedPanelSize?.value) {
        '10' => '1-3 min',
        '25' => '3-6 min',
        _ => '6-12 min',
      };

  @override
  Widget build(BuildContext context) {
    return ConsumerWidget(
      provider: SessionProvider(),
      appBarTitle: 'Running simulation',
      padding: 0,
      children: (provider, theme) {
        _provider ??= provider;
        final size = provider.state.selectedPanelSize?.value ?? '0';
        return [
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
                        'STEP 3 OF 3',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                          color: textTertiary,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        _error == null ? 'Your panel is reacting' : 'Run didn’t complete',
                        style: const TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        _error == null
                            ? '$size personas · about $_eta · keep this tab open'
                            : 'Nothing was saved. You can retry with the same panel.',
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: textSecondary,
                        ),
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
        ];
      },
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
                  title: 'Retry run',
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

  final int index;
  final int current;
  final String title;
  final String detail;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final done = index < current;
    final active = index == current;
    final fg = done || active ? textPrimary : textTertiary;

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
                          child: CircularProgressIndicator(
                            strokeWidth: 1.6,
                            color: signal,
                          ),
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
                    color: fg,
                  ),
                ),
                if (active) ...[
                  const Gap(2),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: textSecondary,
                      height: 1.4,
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
