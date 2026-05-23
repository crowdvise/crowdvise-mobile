import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/dashed_container.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/scrollable_widget.dart';
import 'package:crowdvise/features/session/presentation/widgets/ai_generated_chip.dart';
import 'package:crowdvise/features/session/presentation/widgets/journey_card.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/session/presentation/screens/assembling_panel.dart';
import 'package:crowdvise/features/session/presentation/widgets/journey_modal.dart';
import 'package:crowdvise/features/session/presentation/widgets/panel_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class ReviewJourneyScreen extends StatefulWidget {
  static const id = '/review_journey';

  const ReviewJourneyScreen({super.key});

  @override
  State<ReviewJourneyScreen> createState() => _ReviewJourneyScreenState();
}

class _ReviewJourneyScreenState extends CustomState<ReviewJourneyScreen> {
  SessionProvider? _provider;

  @override
  void onStarted() {
    _provider?.listen((event) {
      if (event is String) {
        showError(event);
      }
    });
    super.onStarted();
  }

  @override
  Widget build(BuildContext context) {
    return ConsumerWidget(
      provider: SessionProvider(),
      appBarTitle: 'Review Journey',
      leading: true,
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;
        return [
          ScrollableWidget(
            maxWidth: 700,
            children:
                [
                      const Gap(16),
                      AiGeneratedChip(),
                      const Gap(24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: List.generate(state.journeyStages.length, (
                          index,
                        ) {
                          final stage = state.journeyStages[index];
                          return JourneyCard(
                            index: stage.order,
                            title: stage.name,
                            description: stage.description,
                            onEdit: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return JourneyModal(stageModel: stage);
                                },
                              );
                            },
                            onDelete: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return DeleteModal(order: stage.order);
                                },
                              );
                            },
                          );
                        }),
                      ),
                      const Gap(16),
                      DashedBorderContainer(
                        height: 50,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return JourneyModal();
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.add, color: electricBlue, size: 16),

                              Text(
                                'Add a stage',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: electricBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(24),

                      Text(
                        'PANEL SIZE',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white54,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Gap(8),
                      Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: state.panelSize.map((size) {
                          final isSelected = state.selectedPanelSize == size;
                          return PanelSizeWidget(
                            size: size,
                            isSelected: isSelected,
                            onSelect: () {
                              provider.selectPanelSize(size);
                            },
                          );
                        }).toList(),
                      ),
                      const Gap(40),
                      Button(
                        title: 'Run Simulation',
                        onPressed: () {
                          provider.runSimulation(stages: state.journeyStages);
                          context.push(AssemblingPanelScreen());
                        },
                      ),
                      const Gap(40),
                    ]
                    .animate(interval: 50.ms)
                    .fade(duration: 400.ms, curve: Curves.easeOut)
                    .slideY(begin: 0.1, curve: Curves.easeOut),
          ),
        ];
      },
    );
  }
}
