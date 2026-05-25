import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/svg_image.dart';
import 'package:crowdvise/features/insights/presentation/manager/insights_provider.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/insights/presentation/screens/reaction_detail.dart';
import 'package:crowdvise/features/session/presentation/widgets/ai_generated_chip.dart';
import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LiveReactionsScreen extends StatefulWidget {
  static const id = '/live_reactions';

  const LiveReactionsScreen({
    super.key,
    required this.journeys,
    this.isLive = false,
  });
  final List<AgentJourney> journeys;
  final bool isLive;

  @override
  State<LiveReactionsScreen> createState() => _LiveReactionsScreenState();
}

class _LiveReactionsScreenState extends State<LiveReactionsScreen> {
  late final List<PersonaReaction> _personas;

  AgentJourney? _selectedJourney;

  @override
  void initState() {
    super.initState();
    _personas = _generatePersonasFromJourneys();
  }

  List<PersonaReaction> _generatePersonasFromJourneys() {
    return widget.journeys.map((journey) {
      final agent = journey.agent;
      // Use the last reaction as the current "live" reaction state.
      final lastReaction = journey.reactions.isNotEmpty
          ? journey.reactions.last
          : null;

      final reactionBehavior = lastReaction?.behaviour ?? journey.finalOutcome;
      final quote = lastReaction?.internalMonologue ?? "No recent thought.";

      // Determine color based on behavior
      Color reactionColor = Colors.grey;
      bool isMuted = false;
      String reactionText = reactionBehavior.toUpperCase();

      switch (reactionBehavior.toLowerCase()) {
        case 'converted':
          reactionColor = const Color(0xFF0FBC73);
          reactionText = 'Converted';
          break;
        case 'dropped':
          reactionColor = const Color(0xFFF24968);
          reactionText = 'Dropped off';
          isMuted = true;
          break;
        case 'frustrated':
          reactionColor = const Color(0xFFF24968);
          reactionText = 'Frustrated';
          break;
        case 'confused':
          reactionColor = const Color(0xFF4285F4);
          reactionText = 'Confused';
          break;
        case 'delaying':
          reactionColor = const Color(0xFFF3B70F);
          reactionText = 'Delaying';
          break;
        case 'continuing':
          reactionColor = const Color(0xFF8B5CF6);
          reactionText = 'Continuing';
          break;
        default:
          reactionColor = Colors.grey;
          reactionText = reactionBehavior;
      }

      // Assign an avatar color based on agent hash
      final colors = [
        const Color(0xFF4285F4),
        const Color(0xFFEA4335),
        const Color(0xFF8B5CF6),
        const Color(0xFF0FBC73),
        const Color(0xFFF3B70F),
      ];
      final color = colors[agent.id.hashCode % colors.length];

      return PersonaReaction(
        initial: agent.name.isNotEmpty ? agent.name[0].toUpperCase() : '?',
        color: color,
        name: '${agent.name}, ${agent.age}',
        role: agent.location,
        reaction: reactionText,
        reactionColor: reactionColor,
        quote: '"$quote"',
        isMuted: isMuted,
        journey: journey,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: InsightsProvider(),
      appBarTitle: widget.isLive ? 'Live Reactions' : 'Synthetic Reactions',
      leading: true,
      actions: [
        IconButton(
          onPressed: () => context.goHome(),
          icon: SvgImage(asset: home, color: white),
          tooltip: 'Back to Home',
        ),
        const Gap(8),
      ],
      children: (provider, theme) {
        // Calculate counts
        final totalPersonas = _personas.length;
        final respondedCount = _personas
            .where((p) => p.journey.reactions.isNotEmpty)
            .length;

        final listContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalPersonas personas · $respondedCount responded',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
                if (widget.isLive) ...[LiveGeneratedChip()],
              ],
            ),
            const Gap(24),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _personas.length,
                separatorBuilder: (_, _) => const Gap(12),
                itemBuilder: (context, index) {
                  final persona = _personas[index];
                  final isSelected =
                      Responsive.isDesktop(context) &&
                      _selectedJourney == persona.journey;
                  return GestureDetector(
                    onTap: () {
                      if (Responsive.isDesktop(context)) {
                        setState(() {
                          _selectedJourney = persona.journey;
                        });
                      } else {
                        context.pushInner(
                          ReactionDetailScreen(journey: persona.journey),
                        );
                      }
                    },
                    child: Container(
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: electricBlue),
                            )
                          : null,
                      child: _PersonaCard(persona: persona, theme: theme),
                    ),
                  );
                },
              ),
            ),
            const Gap(24),
          ],
        );

        return [
          Expanded(
            child: Responsive(
              mobile: listContent,
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 380, child: listContent),
                  const Gap(32),
                  if (_selectedJourney != null) ...[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF131314),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            ReactionDetailBody(journey: _selectedJourney!),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Select a persona to view details',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}

class _PersonaCard extends StatelessWidget {
  final PersonaReaction persona;
  final ThemeData theme;

  const _PersonaCard({required this.persona, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF131314),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: persona.color,
                child: Text(
                  persona.initial,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      persona.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: persona.isMuted ? Colors.white54 : Colors.white,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      persona.role,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: persona.reactionColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  persona.reaction,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: persona.reactionColor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            persona.quote,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: persona.isMuted ? Colors.white30 : Colors.white70,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class PersonaReaction {
  final String initial;
  final Color color;
  final String name;
  final String role;
  final String reaction;
  final Color reactionColor;
  final String quote;
  final bool isMuted;
  final AgentJourney journey;

  const PersonaReaction({
    required this.initial,
    required this.color,
    required this.name,
    required this.role,
    required this.reaction,
    required this.reactionColor,
    required this.quote,
    required this.journey,
    this.isMuted = false,
  });
}
