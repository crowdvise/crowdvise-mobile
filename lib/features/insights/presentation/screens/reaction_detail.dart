import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/field_label.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/insights/presentation/manager/insights_provider.dart';
import 'package:crowdvise/features/insights/presentation/widgets/behaviour_tone.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReactionDetailScreen extends StatelessWidget {
  static const id = '/reaction_detail';

  final AgentJourney journey;

  const ReactionDetailScreen({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      appBarTitle: 'Reaction',
      leading: true,
      padding: 0,
      provider: InsightsProvider(),
      children: (provider, theme) {
        return [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: ReactionDetailBody(journey: journey),
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}

/// Non-scrolling body so it can live inside either the standalone screen or
/// the desktop split pane.
class ReactionDetailBody extends StatelessWidget {
  final AgentJourney journey;
  const ReactionDetailBody({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    final a = journey.agent;
    final outcome = BehaviourTone.of(journey.finalOutcome);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InitialAvatar(a.name, size: 44),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${a.name}, ${a.age}',
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const Gap(6),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _Meta(a.location),
                      _Meta(a.incomeBracket),
                      _Meta(_title(a.decisionStyle)),
                      TonePill(outcome),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(24),
        _Card(
          children: [
            const SectionTitle('Who they are'),
            const Gap(8),
            Text(
              a.backstory,
              style: const TextStyle(
                fontSize: 13.5,
                color: textSecondary,
                height: 1.55,
              ),
            ),
            const Gap(16),
            const Divider(height: 1, color: hairline),
            const Gap(14),
            Row(
              children: [
                const Expanded(child: SectionTitle('Personality')),
                Text(
                  'Friction threshold ${a.frictionThreshold}',
                  style: const TextStyle(fontSize: 12, color: textTertiary),
                ),
              ],
            ),
            const Gap(12),
            _Trait('Openness', a.ocean.openness),
            _Trait('Conscientiousness', a.ocean.conscientiousness),
            _Trait('Extraversion', a.ocean.extraversion),
            _Trait('Agreeableness', a.ocean.agreeableness),
            _Trait('Neuroticism', a.ocean.neuroticism, last: true),
          ],
        ),
        const Gap(28),
        const SectionTitle('Journey'),
        const Gap(12),
        if (journey.reactions.isEmpty)
          const Text(
            'No reactions recorded.',
            style: TextStyle(color: textTertiary, fontSize: 13),
          )
        else
          for (var i = 0; i < journey.reactions.length; i++)
            _Step(
              reaction: journey.reactions[i],
              last: i == journey.reactions.length - 1,
            ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hairline),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 12.5, color: textTertiary));
  }
}

class _Trait extends StatelessWidget {
  const _Trait(this.label, this.value, {this.last = false});
  final String label;
  final double value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final v = (value <= 1 ? value : value / 10).clamp(0.0, 1.0);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 8),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: textSecondary),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(
                height: 4,
                child: Stack(
                  children: [
                    const ColoredBox(color: hairline, child: SizedBox.expand()),
                    FractionallySizedBox(
                      widthFactor: v,
                      child: const ColoredBox(
                        color: textSecondary,
                        child: SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(12),
          SizedBox(
            width: 28,
            child: Text(
              (v * 10).toStringAsFixed(1),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.reaction, required this.last});
  final Reaction reaction;
  final bool last;

  bool _has(String? s) => s != null && s.trim().isNotEmpty && s != 'null';

  @override
  Widget build(BuildContext context) {
    final tone = BehaviourTone.of(reaction.behaviour);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 16,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tone.color,
                  ),
                ),
                if (!last)
                  const Expanded(
                    child: VerticalDivider(width: 1, color: hairlineStrong),
                  ),
              ],
            ),
          ),
          const Gap(12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _title(reaction.stageName),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      TonePill(tone),
                    ],
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: wsCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: hairline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“${reaction.internalMonologue.trim()}”',
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: textSecondary,
                            height: 1.5,
                          ),
                        ),
                        if (_has(reaction.frictionTriggered)) ...[
                          const Gap(10),
                          _Note(
                            label: 'Friction',
                            text: reaction.frictionTriggered!,
                            color: statusWarning,
                            cost: reaction.frictionCost,
                          ),
                        ],
                        if (_has(reaction.whatWouldChangeThis)) ...[
                          const Gap(6),
                          _Note(
                            label: 'Would change this',
                            text: reaction.whatWouldChangeThis!,
                            color: signal,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    required this.label,
    required this.text,
    required this.color,
    this.cost,
  });
  final String label, text;
  final Color color;
  final int? cost;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 12.5,
          height: 1.5,
          color: textSecondary,
        ),
        children: [
          TextSpan(
            text: cost != null && cost! > 0 ? '$label (−$cost)  ' : '$label  ',
            style: TextStyle(fontWeight: FontWeight.w700, color: color),
          ),
          TextSpan(text: text.trim()),
        ],
      ),
    );
  }
}

String _title(String s) => s
    .replaceAll('_', ' ')
    .split(' ')
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
    .join(' ');
