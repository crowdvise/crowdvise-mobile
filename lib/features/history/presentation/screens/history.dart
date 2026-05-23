import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/shimmers.dart';
import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/history/presentation/widgets/history_card.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends CustomState<HistoryScreen> {
  HistoryProvider? _provider;
  @override
  void onStarted() {
    _provider?.fetchHistory();
    _provider?.listen((event) {
      if (event is String) {
        showError(event);
      }
    });
    super.onStarted();
  }

  String _searchQuery = '';
  String _selectedStatus = 'All';

  String _getStatusLabel(int score) {
    if (score >= 70) {
      return 'Ready';
    } else if (score >= 40) {
      return 'Needs work';
    } else {
      return 'Not ready';
    }
  }

  List<RunModel> _getFilteredRuns(List<RunModel> runs) {
    return runs.where((run) {
      final matchesQuery =
          run.productDescription.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          run.targetSegment.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedStatus == 'All') {
        return matchesQuery;
      }
      final status = _getStatusLabel(run.readinessScore);
      return matchesQuery && status == _selectedStatus;
    }).toList();
  }

  Map<String, List<RunModel>> _groupRunsByDate(List<RunModel> runs) {
    final Map<String, List<RunModel>> groups = {
      'THIS WEEK': [],
      'LAST WEEK': [],
      'OLDER': [],
    };

    final now = DateTime.now();
    final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    for (final run in runs) {
      try {
        final date = DateTime.parse(run.createdAt);
        if (date.isAfter(startOfThisWeek)) {
          groups['THIS WEEK']!.add(run);
        } else if (date.isAfter(startOfLastWeek)) {
          groups['LAST WEEK']!.add(run);
        } else {
          groups['OLDER']!.add(run);
        }
      } catch (_) {
        groups['OLDER']!.add(run);
      }
    }

    return groups;
  }

  Widget _buildFilterPill({
    required String label,
    required String statusValue,
    Color? dotColor,
  }) {
    final isSelected = _selectedStatus == statusValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = statusValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5B7FFF).withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF5B7FFF)
                : Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xff94AFFF)
                    : const Color(0xff6C7078),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      provider: HistoryProvider(),
      appBarTitle: 'History',
      padding: 16,
      children: (provider, theme) {
        _provider ??= provider;
        final history = provider.state.history;
        final totalCount = history.length;
        final filteredRuns = _getFilteredRuns(history);
        final groupedRuns = _groupRunsByDate(filteredRuns);

        return [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(16),
                    InputField(
                      hint: 'Search simulations...',
                      onChange: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      prefix: search,
                    ),
                    const Gap(16),
                    // Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterPill(
                            label: 'All ($totalCount)',
                            statusValue: 'All',
                          ),
                          const Gap(8),
                          _buildFilterPill(
                            label: 'Ready',
                            statusValue: 'Ready',
                            dotColor: const Color(0xff00FF87),
                          ),
                          const Gap(8),
                          _buildFilterPill(
                            label: 'Needs work',
                            statusValue: 'Needs work',
                            dotColor: const Color(0xffFFB03A),
                          ),
                          const Gap(8),
                          _buildFilterPill(
                            label: 'Not ready',
                            statusValue: 'Not ready',
                            dotColor: const Color(0xffFF5C7A),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    // Grouped List
                    Expanded(
                      child: provider.loading
                          ? const HistoryShimmer()
                          : filteredRuns.isEmpty
                          ? Center(
                              child: Text(
                                history.isEmpty
                                    ? 'No simulations found.'
                                    : 'No matches found.',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final groupKey in [
                                    'THIS WEEK',
                                    'LAST WEEK',
                                    'OLDER',
                                  ])
                                    if (groupedRuns[groupKey]!.isNotEmpty) ...[
                                      Text(
                                        groupKey,
                                        style: const TextStyle(
                                          color: Color(0xff555861),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const Gap(12),
                                      Responsive.isDesktop(context)
                                          ? GridView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 16,
                                                mainAxisSpacing: 16,
                                                mainAxisExtent: 300,
                                              ),
                                              itemCount: groupedRuns[groupKey]!.length,
                                              itemBuilder: (context, index) {
                                                final run = groupedRuns[groupKey]![index];
                                                return HistoryCard(
                                                  run: run,
                                                  onTap: () {
                                                    context.pushNamed(
                                                      InsightsScreen.id,
                                                      args: run.id,
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : ListView.separated(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: groupedRuns[groupKey]!.length,
                                              separatorBuilder: (_, _) => const Gap(12),
                                              itemBuilder: (context, index) {
                                                final run = groupedRuns[groupKey]![index];
                                                return HistoryCard(
                                                  run: run,
                                                  onTap: () {
                                                    context.pushNamed(
                                                      InsightsScreen.id,
                                                      args: run.id,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                      const Gap(32),
                                    ],
                                ],
                              ),
                            ),
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
