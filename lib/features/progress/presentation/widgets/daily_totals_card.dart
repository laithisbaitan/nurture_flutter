import 'package:flutter/material.dart';

import '../../domain/entities/progress_snapshot.dart';

class DailyTotalsCard extends StatelessWidget {
  const DailyTotalsCard({super.key, required this.totals});

  final DailyTotals totals;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '${totals.calories.round()} kcal',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MacroChip(label: 'Protein', value: totals.proteinG),
                _MacroChip(label: 'Carbs', value: totals.carbsG),
                _MacroChip(label: 'Fat', value: totals.fatG),
              ],
            ),
            if (totals.micros.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final entry in totals.micros.entries)
                    Text(
                      '${entry.key}: ${entry.value.toStringAsFixed(1)}',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        Text('${value.toStringAsFixed(1)} g'),
      ],
    );
  }
}
