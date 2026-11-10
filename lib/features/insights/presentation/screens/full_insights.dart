import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FullInsightsScreen extends StatelessWidget {
  static const id = '/full_insights';
  final List<String> insights;

  const FullInsightsScreen({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final pad = wide ? 32.0 : 20.0;
    return ProviderWidget(
      provider: HistoryProvider(),
      appBarTitle: 'Insights',
      leading: true,
      padding: 0,
      children: (provider, theme) {
        return [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(pad, 28, pad, 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeader(
                        eyebrow: '${insights.length} insights',
                        title: 'What the panel told us',
                        description:
                            'Objections and positive signals, ranked by how many personas raised them.',
                      ),
                      const Gap(24),
                      Container(
                        decoration: BoxDecoration(
                          color: wsCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: hairline),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < insights.length; i++)
                              Container(
                                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                                decoration: BoxDecoration(
                                  border: i == insights.length - 1
                                      ? null
                                      : const Border(
                                          bottom: BorderSide(color: hairline),
                                        ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        (i + 1).toString().padLeft(2, '0'),
                                        style: const TextStyle(
                                          fontFamily: 'Syne',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: signal,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const Gap(8),
                                    Expanded(
                                      child: Text(
                                        insights[i],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: textPrimary,
                                          height: 1.55,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
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
