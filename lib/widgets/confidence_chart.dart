import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/analysis_response.dart';
import '../theme/app_colors.dart';

class ConfidenceChart extends StatelessWidget {
  final List<ProductCandidate> candidates;

  const ConfidenceChart({super.key, required this.candidates});

  @override
  Widget build(BuildContext context) {
    if (candidates.isEmpty) return const SizedBox.shrink();

    final sorted = List<ProductCandidate>.from(candidates)
      ..sort((a, b) => b.confidence.compareTo(a.confidence));

    final maxItems = sorted.length > 4 ? 4 : sorted.length;
    final items = sorted.sublist(0, maxItems);

    return SizedBox(
      height: maxItems * 40.0,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.0,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 80,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= items.length) {
                    return const SizedBox.shrink();
                  }
                  final name = items[idx].name;
                  final display =
                      name.length > 8 ? '${name.substring(0, 8)}...' : name;
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      display,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(items.length, (i) {
            final isTop = i == 0;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: items[i].confidence,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                  gradient: isTop
                      ? const LinearGradient(
                          colors: [
                            AppColors.gradientStart,
                            AppColors.gradientEnd,
                          ],
                        )
                      : null,
                  color: isTop ? null : AppColors.shimmerBase,
                ),
              ],
            );
          }),
        ),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}
