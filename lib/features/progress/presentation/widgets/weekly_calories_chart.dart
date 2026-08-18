import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/progress_snapshot.dart';

class WeeklyCaloriesChart extends StatelessWidget {
  const WeeklyCaloriesChart({super.key, required this.week});

  final List<DailyTotals> week;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final maxCalories = week.fold<double>(
      0,
      (max, day) => day.calories > max ? day.calories : max,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Week', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  maxY: maxCalories <= 0 ? 1 : maxCalories * 1.2,
                  barTouchData: const BarTouchData(enabled: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) =>
                            _dayLabel(value, meta, week),
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var index = 0; index < week.length; index++)
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: week[index].calories,
                            width: 14,
                            color: color,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _dayLabel(double value, TitleMeta meta, List<DailyTotals> week) {
  final index = value.toInt();
  if (index < 0 || index >= week.length) return const SizedBox.shrink();
  final date = week[index].date;
  final label = date.length >= 10 ? date.substring(5) : date;
  return SideTitleWidget(
    meta: meta,
    child: Text(label, style: const TextStyle(fontSize: 10)),
  );
}
