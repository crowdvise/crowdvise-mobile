import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/field_label.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

/// Shared sheet chrome: centered on wide screens, bottom sheet on mobile.
class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final inset = MediaQuery.viewInsetsOf(context).bottom;

    final body = Container(
      width: wide ? 520 : double.infinity,
      padding: EdgeInsets.fromLTRB(22, 18, 22, 22 + (wide ? 0 : inset)),
      decoration: BoxDecoration(
        color: wsCard,
        borderRadius: wide
            ? BorderRadius.circular(14)
            : const BorderRadius.vertical(top: Radius.circular(14)),
        border: Border.all(color: hairline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
              InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded, size: 18, color: textTertiary),
                ),
              ),
            ],
          ),
          const Gap(18),
          child,
        ],
      ),
    );

    if (wide) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Material(color: Colors.transparent, child: body),
        ),
      );
    }
    return Material(color: Colors.transparent, child: body);
  }
}

class JourneyModal extends StatefulWidget {
  const JourneyModal({super.key, this.stageModel});
  final JourneyStageModel? stageModel;

  @override
  State<JourneyModal> createState() => _JourneyModalState();
}

class _JourneyModalState extends CustomState<JourneyModal> {
  SessionProvider? _provider;

  @override
  void onStarted() {
    if (widget.stageModel != null) {
      _provider?.setJourneyName(widget.stageModel!.name);
      _provider?.setJourneyDescription(widget.stageModel!.description);
    } else {
      _provider?.setJourneyName('');
      _provider?.setJourneyDescription('');
    }
    super.onStarted();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.stageModel != null;
    return Consumer<SessionProvider>(
      builder: (_, provider, _) {
        _provider ??= provider;
        final state = provider.state;
        return _SheetFrame(
          title: editing ? 'Edit stage' : 'Add a stage',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FieldLabel('Title'),
              InputField(
                hint: 'e.g. Pricing page',
                value: state.journeyName,
                onChange: provider.setJourneyName,
              ),
              const Gap(16),
              const FieldLabel(
                'What happens here',
                helper: 'What the persona sees and has to decide.',
              ),
              InputField(
                hint: 'e.g. Sees three tiers; must pick one or leave.',
                maxLines: 4,
                minLines: 3,
                value: state.journeyDescription,
                onChange: provider.setJourneyDescription,
              ),
              const Gap(22),
              Row(
                children: [
                  Expanded(
                    child: BorderButton(
                      title: 'Cancel',
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Button(
                      title: editing ? 'Save' : 'Add stage',
                      onPressed: () {
                        if (editing) {
                          provider.updateStage(widget.stageModel!.order);
                        } else {
                          provider.addStage();
                        }
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class DeleteModal extends StatelessWidget {
  const DeleteModal({super.key, required this.order});
  final int order;

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (_, provider, _) {
        return _SheetFrame(
          title: 'Remove this stage?',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Personas will skip it in the run. You can add it back before running.',
                style: TextStyle(
                  fontSize: 13.5,
                  color: textSecondary,
                  height: 1.5,
                ),
              ),
              const Gap(22),
              Row(
                children: [
                  Expanded(
                    child: BorderButton(
                      title: 'Keep',
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: BorderButton(
                      title: 'Remove',
                      destructive: true,
                      onPressed: () {
                        provider.deleteStage(order);
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
