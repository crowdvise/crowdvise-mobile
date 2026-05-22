import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/insights/presentation/manager/insights_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LiveReactionsScreen extends StatefulWidget {
  static const id = '/live_reactions';

  const LiveReactionsScreen({super.key});

  @override
  State<LiveReactionsScreen> createState() => _LiveReactionsScreenState();
}

class _LiveReactionsScreenState extends State<LiveReactionsScreen> {
  final List<PersonaReaction> _personas = const [
    PersonaReaction(
      initial: 'M',
      color: Color(0xFF4285F4),
      name: 'Marcus, 34',
      role: 'Product Manager · San Francisco',
      reaction: 'Subscribed',
      reactionColor: Color(0xFF0FBC73),
      quote:
          '"This is exactly what my team needs. We\'ve been paying \$200/month for half this. I signed up on the spot."',
    ),
    PersonaReaction(
      initial: 'P',
      color: Color(0xFFEA4335),
      name: 'Priya, 28',
      role: 'Freelance Designer · Toronto',
      reaction: 'Skeptical',
      reactionColor: Color(0xFFF3B70F),
      quote:
          '"\$49 is steep for a solo. I\'d use it if there was a cheaper individual plan. The feature sounds useful though."',
    ),
    PersonaReaction(
      initial: 'A',
      color: Color(0xFF8B5CF6),
      name: 'Aisha, 22',
      role: 'Student / Side Hustler · Lagos',
      reaction: 'Confused',
      reactionColor: Color(0xFF4285F4),
      quote:
          '"What\'s an AI-generated report exactly? I don\'t know what I\'m getting. Needs more examples on the page."',
    ),
    PersonaReaction(
      initial: 'D',
      color: Color(0xFF6B7280),
      name: 'David, 52',
      role: 'Small Business Owner · Manchester',
      reaction: 'Dropped off',
      reactionColor: Color(0xFFF24968),
      quote:
          '"Left after seeing the pricing page. Happy with my current solution. No strong reason to switch."',
      isMuted: true,
    ),
    PersonaReaction(
      initial: 'T',
      color: Color(0xFF0FBC73),
      name: 'Tanya, 41',
      role: 'VP of Growth · New York',
      reaction: 'Excited',
      reactionColor: Color(0xFF0FBC73),
      quote:
          '"We\'ve been waiting for something like this. Running focus groups costs us \$8k a pop. This changes everything."',
    ),
    PersonaReaction(
      initial: 'K',
      color: Color(0xFFF3B70F),
      name: 'Kevin, 31',
      role: 'Indie Founder · Berlin',
      reaction: 'Subscribed',
      reactionColor: Color(0xFF0FBC73),
      quote:
          '"Bootstrapped and scrappy. This is exactly the validation tool I\'ve been looking for. Worth every cent."',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<InsightsProvider>(
      provider: InsightsProvider(),
      children: (provider, theme) {
        return [
          const Gap(16),
          // Header row: back + LIVE badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B1515),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF24968),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      'LIVE',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFF24968),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(32),
          Text(
            'Live reactions',
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              height: 1.0,
              color: Colors.white,
            ),
          ),
          const Gap(8),
          Text(
            '25 personas · 18 responded',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
          const Gap(24),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _personas.length,
              separatorBuilder: (_, _) => const Gap(12),
              itemBuilder: (context, index) {
                final persona = _personas[index];
                return _PersonaCard(persona: persona, theme: theme);
              },
            ),
          ),
          const Gap(24),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  const PersonaReaction({
    required this.initial,
    required this.color,
    required this.name,
    required this.role,
    required this.reaction,
    required this.reactionColor,
    required this.quote,
    this.isMuted = false,
  });
}
