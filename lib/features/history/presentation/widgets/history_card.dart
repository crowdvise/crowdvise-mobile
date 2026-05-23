import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final RunModel run;
  final VoidCallback? onTap;

  const HistoryCard({super.key, required this.run, this.onTap});

  Color _getStatusColor(int score) {
    if (score >= 70) return const Color(0xff00FF87); // Ready
    if (score >= 40) return const Color(0xffFFB03A); // Needs work
    return const Color(0xffFF5C7A); // Not ready
  }

  String _getStatusLabel(int score) {
    if (score >= 70) return 'Ready';
    if (score >= 40) return 'Needs work';
    return 'Not ready';
  }

  int _getStageCount(RunModel r) {
    final hash = r.id.hashCode.abs();
    return 3 + (hash % 3);
  }

  String _getDuration(RunModel r) {
    final hash = r.id.hashCode.abs();
    final totalSeconds = 60 + (hash % 500);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes}m ${seconds.toString().padLeft(2, '0')}s';
  }

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(run.readinessScore);
    final statusLabel = _getStatusLabel(run.readinessScore);

    final convPercent = (run.overallConversionRate * 100).round();
    final delayPercent = (run.overallDelayedRate * 100).round();
    final dropPercent = (run.overallDropoutRate * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131314),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Date/Duration & Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Colors.white54,
                      ),
                      const Gap(6),
                      Expanded(
                        child: Text(
                          '${_formatDate(run.createdAt)}  •  ${_getDuration(run)}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withValues(alpha: 0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const Gap(6),
                      Text(
                        statusLabel.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        '${run.readinessScore}',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Middle Section: Product Name
            Text(
              run.productDescription,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(12),

            // Chips: Agents & Stages
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildInfoChip(Icons.people_outline, '${run.panelSize} Agents'),
                _buildInfoChip(
                  Icons.layers_outlined,
                  '${_getStageCount(run)} Stages',
                ),
              ],
            ),
            const Gap(24),

            // Bottom Section: Progress Bar & Legend
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    if (convPercent > 0)
                      Expanded(
                        flex: convPercent,
                        child: Container(color: const Color(0xff00FF87)),
                      ),
                    if (delayPercent > 0)
                      Expanded(
                        flex: delayPercent,
                        child: Container(color: const Color(0xffFFB03A)),
                      ),
                    if (dropPercent > 0)
                      Expanded(
                        flex: dropPercent,
                        child: Container(color: const Color(0xffFF5C7A)),
                      ),
                  ],
                ),
              ),
            ),
            const Gap(18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                _buildLegendItem(
                  const Color(0xff00FF87),
                  'Converted',
                  convPercent,
                ),
                _buildLegendItem(
                  const Color(0xffFFB03A),
                  'Delayed',
                  delayPercent,
                ),
                _buildLegendItem(
                  const Color(0xffFF5C7A),
                  'Dropped',
                  dropPercent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const Gap(6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, int percent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(6),
        Text(
          '$percent% $label',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
