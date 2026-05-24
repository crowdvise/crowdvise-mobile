import 'dart:async';

import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class AssemblingPanelScreen extends StatefulWidget {
  static const id = '/assembling_panel';

  const AssemblingPanelScreen({super.key, required this.productDescription});
  final String productDescription;

  @override
  State<AssemblingPanelScreen> createState() => _AssemblingPanelScreenState();
}

class _AssemblingPanelScreenState extends CustomState<AssemblingPanelScreen> {
  int _statusIndex = 0;
  Timer? _statusTimer;
  SessionProvider? _provider;

  // Cycles through while the request is in flight
  late final List<String> _statusMessages = [
    'Assembling your panel...',
    'Generating ${_provider?.state.selectedPanelSize!.value} synthetic customers...',
    'Building persona profiles...',
    'Calibrating behaviours...',
    'Running through journey stages...',
    'Collecting reactions...',
    'Almost done...',
  ];

  @override
  void onStarted() {
    // Listen for result or error
    _provider?.listen((event) {
      if (event is String) {
        _statusTimer?.cancel();
        showError(event);
        context.pop();
      } else if (event is SimulationModel) {
        context.pushReplacementInner(
          InsightsScreen(
            simulationId: event.simulationId,
            productDescription: widget.productDescription,
            model: event,
          ),
        );
      }
    });

    // Cycle status message every 4 seconds
    _statusTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() {
        _statusIndex = (_statusIndex + 1) % _statusMessages.length;
      });
    });

    super.onStarted();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  String get _estimatedTime =>
      switch (_provider?.state.selectedPanelSize!.value) {
        "10" => '~1-3 minutes',
        "25" => '~3-6 minutes',
        _ => '~6-12 minutes',
      };

  @override
  Widget build(BuildContext context) {
    return ConsumerWidget(
      provider: SessionProvider(),
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;
        return [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const Spacer(),
                const Gap(40),
                // Title
                Text(
                  'Assembling your\npanel',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ).animate().fade(duration: 400.ms).slideY(begin: 0.1),

                const Gap(12),

                // Estimated time
                Text(
                  '${state.selectedPanelSize!.value} synthetic customers · $_estimatedTime',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ).animate().fade(duration: 400.ms, delay: 100.ms),

                const Gap(48),
                _buildAvatarGrid(
                  theme,
                  int.parse(provider.state.selectedPanelSize!.value),
                ).animate().fade(duration: 400.ms, delay: 100.ms),

                const Gap(48),
                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(electricBlue),
                    ),
                  ),
                ),

                const Gap(16),

                // Cycling status message
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _statusMessages[_statusIndex],
                    key: ValueKey(_statusIndex),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ),

                const Gap(24),

                // Subtle "do not close" warning
                Text(
                  'Do not close this screen',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: Colors.white24,
                    letterSpacing: 0.5,
                  ),
                ),
                const Gap(40),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildAvatarGrid(ThemeData theme, int panelSize) {
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFFEA4335),
      const Color(0xFF34A853),
      const Color(0xFF8B5CF6),
      const Color(0xFFF24968),
      const Color(0xFFF3B70F),
      const Color(0xFF0FBC73),
      const Color(0xFF7993F2),
      const Color(0xFF34D399),
    ];
    final letters = [
      'M',
      'P',
      'A',
      'D',
      'J',
      'K',
      'L',
      'S',
      'T',
      'R',
      'N',
      'B',
      'C',
      'F',
      'H',
      'I',
      'W',
      'X',
      'Q',
      'Z',
      'E',
      'O',
      'U',
      'V',
      'Y',
    ];

    // Show rows based on panelSize
    final count = panelSize;
    final rows = (count / 5).ceil().clamp(1, 5);

    return Column(
      children: List.generate(
        rows,
        (row) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (col) {
              final index = row * 5 + col;
              if (index >= count)
                return const SizedBox(width: 56); // placeholder
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: colors[index % colors.length],
                  child: Text(
                    letters[index % letters.length],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
