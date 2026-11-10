import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/dashed_container.dart';
import 'package:crowdvise/core/presentation/widgets/field_label.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/session/presentation/widgets/ai_generated_chip.dart';
import 'package:crowdvise/features/session/presentation/widgets/journey_card.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/session/presentation/screens/assembling_panel.dart';
import 'package:crowdvise/features/session/presentation/widgets/journey_modal.dart';
import 'package:crowdvise/features/session/presentation/widgets/panel_size.dart';
import 'package:flutter/material.dart';
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
      if (event is String) showError(event);
    });
    super.onStarted();
  }

  void _sheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final pad = isDesktop ? 32.0 : 20.0;

    return ConsumerWidget(
      provider: SessionProvider(),
      appBarTitle: 'Review journey',
      leading: true,
      padding: 0,
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;
        return [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(pad, 28, pad, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageHeader(
                        eyebrow: 'Step 2 of 3',
                        title: 'Review the journey',
                        description:
                            'These are the stages each persona will move through. Edit, reorder by order number, or add your own.',
                      ),
                      const Gap(28),
                      SectionTitle(
                        'Stages',
                        trailing: const AiGeneratedChip(),
                      ),
                      const Gap(12),
                      for (var i = 0; i < state.journeyStages.length; i++) ...[
                        JourneyCard(
                          index: state.journeyStages[i].order,
                          title: state.journeyStages[i].name,
                          description: state.journeyStages[i].description,
                          onEdit: () => _sheet(
                            context,
                            JourneyModal(stageModel: state.journeyStages[i]),
                          ),
                          onDelete: () => _sheet(
                            context,
                            DeleteModal(order: state.journeyStages[i].order),
                          ),
                        ),
                        const Gap(8),
                      ],
                      DashedBorderContainer(
                        height: 44,
                        onTap: () => _sheet(context, const JourneyModal()),
                        child: const Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: textSecondary, size: 16),
                              Gap(6),
                              Text(
                                'Add a stage',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(32),
                      const FieldLabel(
                        'Panel size',
                        helper:
                            'Larger panels give steadier numbers and take longer to run.',
                      ),
                      Row(
                        children: [
                          for (var i = 0; i < state.panelSize.length; i++) ...[
                            if (i > 0) const Gap(8),
                            PanelSizeWidget(
                              size: state.panelSize[i],
                              isSelected:
                                  state.selectedPanelSize == state.panelSize[i],
                              onSelect: () =>
                                  provider.selectPanelSize(state.panelSize[i]),
                            ),
                          ],
                        ],
                      ),
                      const Gap(32),
                      Row(
                        children: [
                          Expanded(
                            child: BorderButton(
                              title: 'Back',
                              onPressed: () => context.popInner(),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            flex: 2,
                            child: Button(
                              title: 'Run simulation',
                              isEnabled: state.journeyStages.isNotEmpty,
                              onPressed: () {
                                if (state.journeyStages.isEmpty) {
                                  showError(
                                    'Add at least one stage before running.',
                                  );
                                  return;
                                }
                                if (state.selectedPanelSize == null) {
                                  showError('Choose a panel size first.');
                                  return;
                                }
                                context.pushInner(
                                  AssemblingPanelScreen(
                                    productDescription:
                                        state.productDescription,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
