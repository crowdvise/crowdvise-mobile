import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/field_label.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/session/domain/models/generated_journey_model.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:crowdvise/features/session/presentation/screens/review_journey.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GenerateJourneyScreen extends StatefulWidget {
  static const id = '/generate_journey';

  const GenerateJourneyScreen({super.key});

  @override
  State<GenerateJourneyScreen> createState() => _GenerateJourneyScreenState();
}

class _GenerateJourneyScreenState extends CustomState<GenerateJourneyScreen> {
  SessionProvider? _provider;

  void _subscribe() {
    _provider?.listen((event) {
      if (event is String) {
        showError(event);
      } else if (event is GeneratedJourneyModel) {
        context.pushInner(const ReviewJourneyScreen());
      }
    });
  }

  @override
  void onStarted() {
    _subscribe();
    super.onStarted();
  }

  @override
  void onPopNext() {
    // Review owns the shared stream while it is on top; take it back when the
    // user returns so a second draft still navigates.
    _subscribe();
    super.onPopNext();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final pad = isDesktop ? 32.0 : 20.0;

    return ConsumerWidget(
      provider: SessionProvider(),
      appBarTitle: 'New journey',
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
                        eyebrow: 'Step 1 of 3',
                        title: 'What are you testing?',
                        description:
                            'Describe the product and who it’s for. We’ll draft a customer journey you can edit before the panel runs.',
                      ),
                      const Gap(32),
                      const FieldLabel(
                        'Product or feature',
                        helper:
                            'What it does, how it’s priced, what the first-run experience looks like.',
                      ),
                      InputField(
                        hint:
                            'e.g. A B2B expense card for remote teams with instant virtual cards and weekly spend digests.',
                        maxLines: 6,
                        minLines: 4,
                        value: state.productDescription,
                        error: state.productDescriptionError,
                        onChange: provider.setProductDescription,
                      ),
                      const Gap(22),
                      const FieldLabel(
                        'What do you want to learn?',
                        helper:
                            'The decision this run should inform: pricing, onboarding, or messaging.',
                      ),
                      InputField(
                        hint:
                            'e.g. Will finance leads trust a card product from a startup without SSO?',
                        maxLines: 3,
                        minLines: 2,
                        value: state.testScenario,
                        error: state.testScenarioError,
                        onChange: provider.setTestScenario,
                      ),
                      const Gap(22),
                      const FieldLabel(
                        'Target customer',
                        helper: 'Role, company stage, and context.',
                      ),
                      InputField(
                        hint: 'e.g. Finance leads at 20-200 person startups',
                        value: state.targetSegment,
                        error: state.targetSegmentError,
                        onChange: provider.setTargetSegment,
                      ),
                      const Gap(32),
                      Row(
                        children: [
                          Expanded(
                            child: BorderButton(
                              title: 'Cancel',
                              onPressed: () => context.popInner(),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            flex: 2,
                            child: Button(
                              title: 'Draft journey',
                              isEnabled: state.isValidated,
                              isLoading: provider.loading,
                              onPressed: provider.generateJourney,
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
