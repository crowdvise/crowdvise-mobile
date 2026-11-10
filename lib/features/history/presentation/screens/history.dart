import 'package:crowdvise/core/presentation/res/drawables.dart';
import 'package:crowdvise/core/presentation/theme/colors/colors.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/core/presentation/utils/navigation_mixin.dart';
import 'package:crowdvise/core/presentation/utils/responsive.dart';
import 'package:crowdvise/core/presentation/utils/snack_bar_utils.dart';
import 'package:crowdvise/core/presentation/widgets/button.dart';
import 'package:crowdvise/core/presentation/widgets/input_field.dart';
import 'package:crowdvise/core/presentation/widgets/page_header.dart';
import 'package:crowdvise/core/presentation/widgets/provider_widget.dart';
import 'package:crowdvise/core/presentation/widgets/shimmers.dart';
import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/history/presentation/widgets/history_card.dart';
import 'package:crowdvise/features/insights/presentation/screens/insights.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends CustomState<HistoryScreen> {
  HistoryProvider? _provider;

  String _searchQuery = '';
  String _selectedStatus = 'All';

  @override
  void onStarted() {
    // Use the app-level provider so Home and History stay in sync.
    final provider = context.read<HistoryProvider>();
    _provider = provider;
    provider.fetchHistory();
    provider.listen((event) {
      if (event is String) showError(event);
    });
    super.onStarted();
  }

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
    final query = _searchQuery.toLowerCase();
    return runs.where((run) {
      final matchesQuery =
          run.productDescription.toLowerCase().contains(query) ||
          run.targetSegment.toLowerCase().contains(query);

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
    final today = DateTime(now.year, now.month, now.day);
    final startOfThisWeek = today.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    for (final run in runs) {
      try {
        final parsed = DateTime.parse(run.createdAt);
        final local = parsed.isUtc ? parsed.toLocal() : parsed;
        final date = DateTime(local.year, local.month, local.day);
        if (!date.isBefore(startOfThisWeek)) {
          groups['THIS WEEK']!.add(run);
        } else if (!date.isBefore(startOfLastWeek)) {
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
        duration: const Duration(milliseconds: 140),
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.08) : wsCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? hairlineStrong : hairline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dotColor != null) ...[
              Container(
                width: 6,
                height: 6,
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
                color: isSelected ? textPrimary : textSecondary,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRun(RunModel run) {
    final product = run.productDescription.split('.')[0].trim();
    context.pushInner(
      InsightsScreen(
        simulationId: run.id,
        productDescription: product,
        experimentId: run.experimentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final pad = isDesktop ? 32.0 : 20.0;
    final provider = context.watch<HistoryProvider>();
    _provider ??= provider;

    final history = provider.state.history;
    final totalCount = history.length;
    final filteredRuns = _getFilteredRuns(history);
    final groupedRuns = _groupRunsByDate(filteredRuns);

    return ScreenShell(
      padding: pad,
      children: [
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(isDesktop ? 28 : 16),
                  PageHeader(
                    eyebrow: 'Workspace',
                    title: 'History',
                    description: totalCount == 0
                        ? 'Every simulation you run will be listed here.'
                        : '$totalCount ${totalCount == 1 ? 'simulation' : 'simulations'}',
                  ),
                  const Gap(20),
                  InputField(
                    hint: 'Search by product or segment',
                    onChange: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    prefix: search,
                  ),
                  const Gap(12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill(
                          label: 'All',
                          statusValue: 'All',
                        ),
                        const Gap(8),
                        _buildFilterPill(
                          label: 'Ready',
                          statusValue: 'Ready',
                          dotColor: statusReady,
                        ),
                        const Gap(8),
                        _buildFilterPill(
                          label: 'Needs work',
                          statusValue: 'Needs work',
                          dotColor: statusWarning,
                        ),
                        const Gap(8),
                        _buildFilterPill(
                          label: 'Not ready',
                          statusValue: 'Not ready',
                          dotColor: statusDanger,
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  Expanded(
                    child: provider.loading && history.isEmpty
                        ? const HistoryShimmer()
                        : provider.lastError != null && history.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      provider.lastError!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: textSecondary,
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                    const Gap(16),
                                    BorderButton(
                                      title: 'Retry',
                                      width: 140,
                                      onPressed: provider.fetchHistory,
                                    ),
                                  ],
                                ),
                              )
                            : filteredRuns.isEmpty
                                ? Center(
                                    child: Text(
                                      history.isEmpty
                                          ? 'No simulations yet.'
                                          : 'No matches.',
                                      style: const TextStyle(
                                        color: textTertiary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                : SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (final groupKey in [
                                          'THIS WEEK',
                                          'LAST WEEK',
                                          'OLDER',
                                        ])
                                          if (groupedRuns[groupKey]!
                                              .isNotEmpty) ...[
                                            Text(
                                              groupKey,
                                              style: const TextStyle(
                                                color: textTertiary,
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 1.6,
                                              ),
                                            ),
                                            const Gap(12),
                                            if (isDesktop)
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 12,
                                                  mainAxisSpacing: 12,
                                                  mainAxisExtent: 232,
                                                ),
                                                itemCount: groupedRuns[groupKey]!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  final run = groupedRuns[
                                                      groupKey]![index];
                                                  return HistoryCard(
                                                    run: run,
                                                    onTap: () => _openRun(run),
                                                  );
                                                },
                                              )
                                            else
                                              Column(
                                                children: [
                                                  for (var index = 0;
                                                      index <
                                                          groupedRuns[groupKey]!
                                                              .length;
                                                      index++) ...[
                                                    HistoryCard(
                                                      run: groupedRuns[groupKey]![
                                                          index],
                                                      onTap: () => _openRun(
                                                        groupedRuns[groupKey]![
                                                            index],
                                                      ),
                                                    ),
                                                    if (index <
                                                        groupedRuns[groupKey]!
                                                                .length -
                                                            1)
                                                      const Gap(12),
                                                  ],
                                                ],
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
      ],
    );
  }
}
