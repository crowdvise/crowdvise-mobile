import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/insights/presentation/manager/insights_provider.dart';
import 'package:crowdvise/features/insights/presentation/screens/reaction_detail.dart';
import 'package:crowdvise/features/insights/presentation/widgets/behaviour_tone.dart';
import 'package:crowdvise/features/session/domain/models/simulation_model.dart';
import 'package:crowdvise/features/session/presentation/widgets/ai_generated_chip.dart';
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
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final pad = wide ? 32.0 : 20.0;
    final journeys = widget.journeys;
    final responded = journeys.where((j) => j.reactions.isNotEmpty).length;
    final activeIndex = (_selected != null && _selected! < journeys.length)
        ? _selected
        : (wide && journeys.isNotEmpty ? 0 : null);

    return ProviderWidget(
      provider: InsightsProvider(),
      appBarTitle: widget.isLive ? 'Live reactions' : 'Persona reactions',
      leading: true,
      padding: 0,
      actions: [
        if (widget.isLive) const LiveGeneratedChip(),
        const Gap(8),
        _HomeButton(onTap: () => context.goHome()),
      ],
      children: (provider, theme) {
        final list = ListView.separated(
          padding: EdgeInsets.fromLTRB(pad, 16, wide ? 0 : pad, 32),
          physics: const ClampingScrollPhysics(),
          itemCount: journeys.length + 1,
          separatorBuilder: (_, i) => Gap(i == 0 ? 14 : 8),
          itemBuilder: (context, i) {
            if (i == 0) {
              return Text(
                '${journeys.length} personas · $responded responded',
                style: const TextStyle(fontSize: 12.5, color: textTertiary),
              );
            }
            final idx = i - 1;
            final j = journeys[idx];
            return _PersonaRow(
              journey: j,
              selected: wide && activeIndex == idx,
              onTap: () {
                if (wide) {
                  setState(() => _selected = idx);
                } else {
                  context.pushInner(ReactionDetailScreen(journey: j));
                }
              },
            );
          },
        );

        if (!wide) return [Expanded(child: list)];

        return [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 340, child: list),
                const Gap(20),
                const VerticalDivider(width: 1, color: hairline),
                Expanded(
                  child: activeIndex == null
                      ? const Center(
                          child: Text(
                            'Select a persona',
                            style: TextStyle(color: textTertiary),
                          ),
                        )
                      : SingleChildScrollView(
                          key: ValueKey(activeIndex),
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(24, 20, 32, 40),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 820),
                              child: ReactionDetailBody(
                                journey: journeys[activeIndex],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back to overview',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: wsCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: hairline),
          ),
          child: const Icon(Icons.grid_view_rounded, size: 15, color: textSecondary),
        ),
      ),
    );
  }
}

class _PersonaRow extends StatefulWidget {
  const _PersonaRow({
    required this.journey,
    required this.selected,
    required this.onTap,
  });
  final AgentJourney journey;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_PersonaRow> createState() => _PersonaRowState();
}

class _PersonaRowState extends State<_PersonaRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final j = widget.journey;
    final a = j.agent;
    final last = j.reactions.isNotEmpty ? j.reactions.last : null;
    final tone = BehaviourTone.of(last?.behaviour ?? j.finalOutcome);
    final quote = last?.internalMonologue.trim();
    final lost = tone.color == statusDanger;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.selected || _hover ? wsCardHover : wsCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.selected
                  ? signal
                  : _hover
                      ? hairlineStrong
                      : hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InitialAvatar(a.name, size: 32),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${a.name}, ${a.age}',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: lost ? textSecondary : textPrimary,
                          ),
                        ),
                        Text(
                          a.location,
                          style: const TextStyle(fontSize: 12, color: textTertiary),
                        ),
                      ],
                    ),
                  ),
                  TonePill(tone),
                ],
              ),
              if (quote != null && quote.isNotEmpty) ...[
                const Gap(10),
                Text(
                  '“$quote”',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: lost ? textTertiary : textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
