import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/dashed_container.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/session/presentation/widgets/ai_generated_chip.dart';
import 'package:crowdvise/features/session/presentation/widgets/journey_card.dart';
import 'package:crowdvise/features/session/presentation/manager/home_provider.dart';
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
  HomeProvider? _provider;

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: HomeProvider(),
      appBarTitle: 'Review Journey',
      leading: true,
      children: (provider, theme) {
        _provider ??= provider;
        final state = provider.state;
        return [
          const Gap(16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AiGeneratedChip(),

                  const Gap(24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(
                      3,
                      (index) => JourneyCard(
                        index: index + 1,
                        title: 'Journey Title',
                        description:
                            'Describe your product and we\'ll build a synthetic panel that reacts like real humans.',
                        onEdit: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return JourneyModal(isEditMode: true);
                            },
                          );
                        },
                        onDelete: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return DeleteModal();
                            },
                          );
                        },
                      ),
                    ),
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
                      context.pushNamed(AssemblingPanelScreen.id);
                    },
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
