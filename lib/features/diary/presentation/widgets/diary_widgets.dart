import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../domain/entities/diary_entries.dart';

const mealTypeOptions = ['breakfast', 'lunch', 'dinner', 'snack'];

const mealTypeLabels = {
  'breakfast': 'Breakfast',
  'lunch': 'Lunch',
  'dinner': 'Dinner',
  'snack': 'Snack',
};

class DiaryDateBar extends StatelessWidget {
  const DiaryDateBar({
    super.key,
    required this.date,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime date;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
        Expanded(
          child: Text(
            formatApiDate(date),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
      ],
    );
  }
}

class FoodLogTile extends StatelessWidget {
  const FoodLogTile({super.key, required this.entry, required this.onDelete});

  final FoodLogEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final meal = entry.mealType;
    final mealLabel = meal == null ? null : mealTypeLabels[meal];
    return ListTile(
      title: Text(entry.title),
      subtitle: Text(
        [
          ?mealLabel,
          '${entry.quantity} × ${entry.foodServingSize} ${entry.foodServingUnit}',
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${entry.totalCalories.round()} kcal'),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class DiaryWeightRow extends StatelessWidget {
  const DiaryWeightRow({
    super.key,
    required this.controller,
    required this.onLog,
    this.summary,
  });

  final TextEditingController controller;
  final VoidCallback onLog;
  final String? summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AuthTextField(
                  controller: controller,
                  label: 'Weight (kg)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(72, 52),
                  ),
                  onPressed: onLog,
                  child: const Text('Log'),
                ),
              ),
            ],
          ),
          if (summary != null) Text(summary!),
        ],
      ),
    );
  }
}
