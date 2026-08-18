import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../foods/presentation/screens/foods_search_screen.dart';
import '../../../foods/presentation/widgets/food_search_tile.dart';
import '../controllers/diary_controller.dart';
import '../widgets/diary_widgets.dart';
import 'add_food_log_screen.dart';

class DiaryScreen extends ConsumerWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diaryControllerProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
      data: (day) => _DiaryLoaded(day: day),
    );
  }
}

class _DiaryLoaded extends ConsumerStatefulWidget {
  const _DiaryLoaded({required this.day});

  final DiaryDay day;

  @override
  ConsumerState<_DiaryLoaded> createState() => _DiaryLoadedState();
}

class _DiaryLoadedState extends ConsumerState<_DiaryLoaded> {
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _addFood() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FoodsSearchScreen(
          onPicked: (food) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => AddFoodLogScreen(food: food)),
            );
          },
        ),
      ),
    );
    if (mounted) ref.read(diaryControllerProvider.notifier).reload();
  }

  Future<void> _saveWeight() async {
    final error = validatePositiveNumber(_weightController.text);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    try {
      await ref
          .read(diaryControllerProvider.notifier)
          .addWeight(parseNumber(_weightController.text));
      _weightController.clear();
    } on Object catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final notifier = ref.read(diaryControllerProvider.notifier);
    final weightSummary = day.weights.isEmpty
        ? null
        : 'Logged: ${day.weights.map((w) => '${w.weightKg} kg').join(', ')}';
    return Column(
      children: [
        DiaryDateBar(
          date: day.date,
          onPrev: () => notifier.shiftDay(-1),
          onNext: () => notifier.shiftDay(1),
        ),
        Text(
          '${day.totalCalories.round()} kcal',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        DiaryWeightRow(
          controller: _weightController,
          onLog: _saveWeight,
          summary: weightSummary,
        ),
        Expanded(
          child: day.logs.isEmpty
              ? const Center(child: Text('No meals logged.'))
              : ListView.builder(
                  itemCount: day.logs.length,
                  itemBuilder: (context, index) {
                    final entry = day.logs[index];
                    return FoodLogTile(
                      entry: entry,
                      onDelete: () => notifier.deleteLog(entry.id),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _addFood,
            child: const Text('Add food'),
          ),
        ),
      ],
    );
  }
}
