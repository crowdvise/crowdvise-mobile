import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/insights/presentation/manager/insights_provider.dart';
import 'package:crowdvise/features/insights/presentation/screens/live_reactions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InsightsScreen extends StatefulWidget {
  static const id = '/insights';

  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget<InsightsProvider>(
      provider: InsightsProvider(),
      children: (provider, theme) {
        return [
          const Gap(16),
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    const Gap(8),
                    Text(
                      'Back',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Insights',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    'Premium subscription tier · 25 personas',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                  const Gap(24),

                  // Adoption Likelihood card
                  _InsightCard(
                    child: Row(
                      children: [
                        // Circular gauge
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: 0.75,
                                strokeWidth: 5,
                                constraints: const BoxConstraints(
                                  minWidth: 60,
                                  minHeight: 60,
                                ),
                                backgroundColor: Colors.white10,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  electricBlue,
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '68',
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
                        const Gap(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Adoption likelihood',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(6),
                              Text(
                                'Strong fit for teams. Price is the main barrier for individuals.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  color: Colors.white60,
                                  height: 1.4,
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
                          'REACTION BREAKDOWN',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white54,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Gap(20),
                        _ReactionBar(
                          label: 'Subscribed',
                          value: 0.55,
                          count: 7,
                          color: const Color(0xFF0FBC73),
                        ),
                        const Gap(16),
                        _ReactionBar(
                          label: 'Excited',
                          value: 0.60,
                          count: 8,
                          color: const Color(0xFF0FBC73),
                        ),
                        const Gap(16),
                        _ReactionBar(
                          label: 'Skeptical',
                          value: 0.45,
                          count: 6,
                          color: const Color(0xFFF3B70F),
                        ),
                        const Gap(16),
                        _ReactionBar(
                          label: 'Confused',
                          value: 0.15,
                          count: 2,
                          color: const Color(0xFF4285F4),
                        ),
                        const Gap(16),
                        _ReactionBar(
                          label: 'Dropped off',
                          value: 0.15,
                          count: 2,
                          color: const Color(0xFFF24968),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // Top Objections card
                  _InsightCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOP OBJECTIONS',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white54,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Gap(16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _TagChip(
                              label: 'Price too high for solo users',
                              isObjection: true,
                            ),
                            _TagChip(
                              label: 'Unclear value prop',
                              isObjection: true,
                            ),
                            _TagChip(
                              label: 'Happy with current tool',
                              isObjection: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // Top Praise card
                  _InsightCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOP PRAISE',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white54,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Gap(16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _TagChip(
                              label: 'Solves a real pain point',
                              isObjection: false,
                            ),
                            _TagChip(
                              label: 'Strong ROI for teams',
                              isObjection: false,
                            ),
                            _TagChip(
                              label: 'Easy to understand',
                              isObjection: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),

                  // Live reactions button
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(LiveReactionsScreen.id);
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
                  const Gap(40),
                ],
              ),
            ),
          ),
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
  final bool isObjection;

  const _TagChip({required this.label, required this.isObjection});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = isObjection
        ? const Color(0xFF3B1515)
        : const Color(0xFF0F2B1E);
    final textColor = isObjection
        ? const Color(0xFFF24968)
        : const Color(0xFF0FBC73);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
