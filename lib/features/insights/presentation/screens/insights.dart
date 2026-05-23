import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/scrollable_widget.dart';
import 'package:crowdvise/core/presentation/widgets/shimmers.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/insights/presentation/screens/full_insights.dart';
import 'package:crowdvise/features/insights/presentation/screens/live_reactions.dart';
import 'package:crowdvise/features/session/presentation/widgets/ai_generated_chip.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InsightsScreen extends StatefulWidget {
  static const id = '/insights';

  const InsightsScreen({super.key, required this.simulationId});
  final String simulationId;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends CustomState<InsightsScreen> {
  HistoryProvider? _provider;
  @override
  void onStarted() {
    _provider?.gePastSimulations(simulationId: widget.simulationId);
    super.onStarted();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: HistoryProvider(),
      appBarTitle: 'Simulation Results',
      leading: true,
      actions: const [LiveGeneratedChip(), Gap(8)],
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;
        final simulation = state.histroyDetails;

        int converted = 0;
        int dropped = 0;
        int delayed = 0;

        if (simulation != null) {
          for (var journey in simulation.agentJourneys) {
            final behavior = journey.reactions.isNotEmpty
                ? journey.reactions.last.behaviour
                : journey.finalOutcome;

            switch (behavior.toLowerCase()) {
              case 'converted':
              case 'continuing':
                converted++;
                break;
              case 'dropped':
              case 'frustrated':
                dropped++;
                break;
              case 'delaying':
                delayed++;
                break;
            }
          }
        }

        final total = simulation?.agentJourneys.length ?? 0;

        return [
          const Gap(32),
          if (provider.loading) ...[
            const Expanded(child: InsightsShimmer()),
          ] else if (simulation == null) ...[
            const Center(child: Text('No simulation results found')),
          ] else ...[
            ScrollableWidget(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium subscription tier · $total personas',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                        const Gap(24),

                        Responsive.isDesktop(context) ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  // Adoption Likelihood card
                                  _InsightCard(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Circular gauge
                                        SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value:
                                                    simulation.readinessScore.toDouble() / 100,
                                                strokeWidth: 5,
                                                constraints: const BoxConstraints(
                                                  minWidth: 60,
                                                  minHeight: 60,
                                                ),
                                                backgroundColor: Colors.white10,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  simulation.readinessScore >= 70
                                                      ? const Color(0xFF0FBC73)
                                                      : simulation.readinessScore >= 40
                                                      ? electricBlue
                                                      : const Color(0xFFF24968),
                                                ),
                                                strokeCap: StrokeCap.round,
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    '${simulation.readinessScore}',
                                                    style: theme.textTheme.displayLarge
                                                        ?.copyWith(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w900,
                                                          color: Colors.white,
                                                          height: 1.0,
                                                        ),
                                                  ),
                                                  Text(
                                                    '/100',
                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                      fontSize: 11,
                                                      color: Colors.white54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Gap(24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Adoption Likelihood',
                                                style: theme.textTheme.displaySmall?.copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Gap(8),
                                              Text(
                                                simulation.topInsights.isNotEmpty
                                                    ? simulation.topInsights.first
                                                    : 'This product concept has a strong overall readiness score.',
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontSize: 14,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(16),

                                  // Reaction Breakdown card
                                  _InsightCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Reaction breakdown',
                                          style: theme.textTheme.displaySmall?.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Gap(20),
                                        _ReactionBar(
                                          label: 'Converted',
                                          value:
                                              total > 0 ? converted / total : 0,
                                          count: converted,
                                          color: const Color(0xFF0FBC73),
                                        ),
                                        const Gap(16),
                                        _ReactionBar(
                                          label: 'Delayed',
                                          value:
                                              total > 0 ? delayed / total : 0,
                                          count: delayed,
                                          color: const Color(0xFFF3B70F),
                                        ),
                                        const Gap(16),
                                        _ReactionBar(
                                          label: 'Dropped',
                                          value:
                                              total > 0 ? dropped / total : 0,
                                          count: dropped,
                                          color: const Color(0xFFF24968),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                children: [
                                  // Top Insights card
                                  _InsightCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Top insights',
                                              style: theme.textTheme.displaySmall?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.pushNamed(FullInsightsScreen.id, args: simulation.topInsights);
                                              },
                                              child: const Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white54,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(16),
                                        ...simulation.topInsights.map(
                                          (insight) => Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '•',
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: electricBlue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Gap(8),
                                                Expanded(
                                                  child: Text(
                                                    insight,
                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                      fontSize: 14,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(24),

                                  // Live reactions button
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        LiveReactionsScreen.id,
                                        args: simulation.agentJourneys,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF131314),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.white10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'See live reactions',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white54,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) : Column(
                          children: [
                            // Adoption Likelihood card
                            _InsightCard(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Circular gauge
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value:
                                              simulation.readinessScore.toDouble() / 100,
                                          strokeWidth: 5,
                                          constraints: const BoxConstraints(
                                            minWidth: 60,
                                            minHeight: 60,
                                          ),
                                          backgroundColor: Colors.white10,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            simulation.readinessScore >= 70
                                                ? const Color(0xFF0FBC73)
                                                : simulation.readinessScore >= 40
                                                ? electricBlue
                                                : const Color(0xFFF24968),
                                          ),
                                          strokeCap: StrokeCap.round,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${simulation.readinessScore}',
                                              style: theme.textTheme.displayLarge
                                                  ?.copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                    height: 1.0,
                                                  ),
                                            ),
                                            Text(
                                              '/100',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                fontSize: 11,
                                                color: Colors.white54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(24),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Adoption Likelihood',
                                          style: theme.textTheme.displaySmall?.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Gap(8),
                                        Text(
                                          simulation.topInsights.isNotEmpty
                                              ? simulation.topInsights.first
                                              : 'This product concept has a strong overall readiness score.',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(16),

                            // Reaction Breakdown card
                            _InsightCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reaction breakdown',
                                    style: theme.textTheme.displaySmall?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(20),
                                  _ReactionBar(
                                    label: 'Converted',
                                    value:
                                        total > 0 ? converted / total : 0,
                                    count: converted,
                                    color: const Color(0xFF0FBC73),
                                  ),
                                  const Gap(16),
                                  _ReactionBar(
                                    label: 'Delayed',
                                    value:
                                        total > 0 ? delayed / total : 0,
                                    count: delayed,
                                    color: const Color(0xFFF3B70F),
                                  ),
                                  const Gap(16),
                                  _ReactionBar(
                                    label: 'Dropped',
                                    value:
                                        total > 0 ? dropped / total : 0,
                                    count: dropped,
                                    color: const Color(0xFFF24968),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(16),

                            // Top Insights card
                            _InsightCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Top insights',
                                        style: theme.textTheme.displaySmall?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed(FullInsightsScreen.id, args: simulation.topInsights);
                                        },
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white54,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(16),
                                  ...simulation.topInsights.map(
                                    (insight) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '•',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: electricBlue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Gap(8),
                                          Expanded(
                                            child: Text(
                                              insight,
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(24),

                            // Live reactions button
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  LiveReactionsScreen.id,
                                  args: simulation.agentJourneys,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF131314),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'See live reactions',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white54,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ];
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  final Widget child;

  const _InsightCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131314),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }
}

class _ReactionBar extends StatelessWidget {
  final String label;
  final double value;
  final int count;
  final Color color;

  const _ReactionBar({
    required this.label,
    required this.value,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const Gap(12),
        Text(
          count.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7FFF).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF5B7FFF),
        ),
      ),
    );
  }
}
