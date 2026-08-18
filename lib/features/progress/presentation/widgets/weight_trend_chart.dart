import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/progress_snapshot.dart';

class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart({super.key, required this.points});

  final List<WeightPoint> points;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight trend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: points.isEmpty
                  ? const Center(child: Text('No weight logs yet.'))
                  : LineChart(_chartData(context, points)),
            ),
          ],
        ),
      ),
    );
  }
}

LineChartData _chartData(BuildContext context, List<WeightPoint> points) {
  final weights = points.map((point) => point.weightKg);
  final minWeight = weights.reduce((a, b) => a < b ? a : b);
  final maxWeight = weights.reduce((a, b) => a > b ? a : b);
  final pad = ((maxWeight - minWeight).abs() < 1
      ? 1
      : (maxWeight - minWeight) * 0.2);
  return LineChartData(
    minY: minWeight - pad,
    maxY: maxWeight + pad,
    gridData: const FlGridData(show: false),
    borderData: FlBorderData(show: false),
    titlesData: const FlTitlesData(
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 36),
      ),
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    lineBarsData: [
      LineChartBarData(
        isCurved: points.length > 2,
        color: Theme.of(context).colorScheme.primary,
        spots: [
          for (var index = 0; index < points.length; index++)
            FlSpot(index.toDouble(), points[index].weightKg),
        ],
      ),
    ],
  );
}
