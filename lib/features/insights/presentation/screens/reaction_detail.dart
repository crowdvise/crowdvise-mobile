import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/scrollable_widget.dart';
import 'package:crowdvise/features/insights/presentation/manager/insights_provider.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/core/presentation/widgets/custom_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReactionDetailScreen extends StatelessWidget {
  static const id = '/reaction_detail';

  final AgentJourney journey;

  const ReactionDetailScreen({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      appBarTitle: 'Reaction Details',
      provider: InsightsProvider(),
      children: (provider, theme) {
        return [ReactionDetailBody(journey: journey)];
      },
    );
  }
}

class ReactionDetailBody extends StatelessWidget {
  final AgentJourney journey;
  const ReactionDetailBody({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final agent = journey.agent;

    return ScrollableWidget(
      children: [
        const Gap(16),
        // Agent Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF4285F4),
              child: Text(
                agent.name.isNotEmpty ? agent.name[0].toUpperCase() : '?',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${agent.name}, ${agent.age}',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '${agent.location} • Final Outcome: ${journey.finalOutcome.toUpperCase()}',
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
        const Gap(24),
        // Backstory & Traits
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF131314),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Backstory',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Gap(8),
              Text(
                agent.backstory,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const Gap(16),
              const Divider(color: Colors.white10),
              const Gap(16),
              Text(
                'Personality Traits (Ocean)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Gap(8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _TraitBadge('Openness', agent.ocean.openness, theme),
                  _TraitBadge(
                    'Conscientiousness',
                    agent.ocean.conscientiousness,
                    theme,
                  ),
                  _TraitBadge('Extraversion', agent.ocean.extraversion, theme),
                  _TraitBadge(
                    'Agreeableness',
                    agent.ocean.agreeableness,
                    theme,
                  ),
                  _TraitBadge('Neuroticism', agent.ocean.neuroticism, theme),
                ],
              ),
            ],
          ),
        ),
        const Gap(32),
        Text(
          'Journey Timeline',
          style: theme.textTheme.displaySmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const Gap(16),
        // Timeline using Stepper
        if (journey.reactions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'No reactions recorded.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white54,
              ),
            ),
          )
        else
          CustomStepper(
            steps: journey.reactions.map((reaction) {
              Color behaviorColor = _getBehaviorColor(reaction.behaviour);
              return CustomStep(
                connectorColor: behaviorColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        reaction.stageName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: behaviorColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        reaction.behaviour.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: behaviorColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${reaction.internalMonologue}"',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      if (reaction.frictionTriggered != null &&
                          reaction.frictionTriggered!.isNotEmpty &&
                          reaction.frictionTriggered != 'null') ...[
                        const Gap(12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: Color(0xFFF3B70F),
                            ),
                            const Gap(8),
                            Expanded(
                              child: Text(
                                'Friction: ${reaction.frictionTriggered}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFFF3B70F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        const SizedBox.shrink(),
                      ],
                      if (reaction.whatWouldChangeThis != null &&
                          reaction.whatWouldChangeThis!.isNotEmpty &&
                          reaction.whatWouldChangeThis != 'null') ...[
                        const Gap(8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: Color(0xFF4285F4),
                            ),
                            const Gap(8),
                            Expanded(
                              child: Text(
                                'Fix: ${reaction.whatWouldChangeThis}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF4285F4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                isActive: true,
              );
            }).toList(),
          ),
        const Gap(40),
      ],
    );
  }

  Color _getBehaviorColor(String behavior) {
    switch (behavior.toLowerCase()) {
      case 'converted':
        return const Color(0xFF0FBC73);
      case 'continuing':
        return const Color(0xFF8B5CF6);
      case 'dropped':
      case 'frustrated':
        return const Color(0xFFF24968);
      case 'delaying':
        return const Color(0xFFF3B70F);
      case 'confused':
        return const Color(0xFF4285F4);
      default:
        return Colors.grey;
    }
  }
}

class _TraitBadge extends StatelessWidget {
  final String label;
  final double value;
  final ThemeData theme;

  const _TraitBadge(this.label, this.value, this.theme);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const Gap(8),
          Text(
            (value * 10).toStringAsFixed(1),
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
