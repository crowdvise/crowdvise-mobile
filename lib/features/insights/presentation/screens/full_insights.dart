import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/scrollable_widget.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FullInsightsScreen extends StatelessWidget {
  static const id = '/full_insights';
  final List<String> insights;

  const FullInsightsScreen({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: HistoryProvider(),
      appBarTitle: 'Top Insights',
      leading: true,
      children: (provider, theme) {
        return [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(16),
                    Text(
                      'Detailed objections and positive signals gathered from the simulation.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                    const Gap(32),
                    ScrollableWidget(
                      children: insights.map((insight) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF131314),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF5B7FFF,
                                    ).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lightbulb_outline,
                                    color: Color(0xFF5B7FFF),
                                    size: 20,
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Text(
                                    insight,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}
