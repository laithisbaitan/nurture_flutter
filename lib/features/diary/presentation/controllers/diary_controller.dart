import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../domain/entities/diary_entries.dart';

@immutable
class DiaryDay {
  const DiaryDay({
    required this.date,
    required this.logs,
    required this.weights,
  });

  final DateTime date;
  final List<FoodLogEntry> logs;
  final List<WeightEntry> weights;

  double get totalCalories =>
      logs.fold(0, (sum, log) => sum + log.totalCalories);
}

class DiaryController extends AsyncNotifier<DiaryDay> {
  DateTime _date = dateOnly(DateTime.now());

  DateTime get date => _date;

  @override
  Future<DiaryDay> build() => _load(_date);

  Future<void> shiftDay(int days) async {
    _date = dateOnly(_date.add(Duration(days: days)));
    await reload();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(_date));
  }

  Future<DiaryDay> _load(DateTime date) async {
    final repo = ref.read(diaryRepositoryProvider);
    final logs = await repo.listLogs(date);
    final allWeights = await repo.listWeights();
    final dayKey = formatApiDate(date);
    return DiaryDay(
      date: date,
      logs: logs,
      weights: allWeights.where((row) => row.date == dayKey).toList(),
    );
  }

  Future<void> addLog({
    required int foodItemId,
    required double quantity,
    String? mealType,
  }) async {
    await ref
        .read(diaryRepositoryProvider)
        .addLog(
          foodItemId: foodItemId,
          quantity: quantity,
          date: _date,
          mealType: mealType,
        );
    await reload();
  }

  Future<void> deleteLog(int id) async {
    await ref.read(diaryRepositoryProvider).deleteLog(id);
    await reload();
  }

  Future<void> addWeight(double weightKg) async {
    await ref
        .read(diaryRepositoryProvider)
        .addWeight(date: _date, weightKg: weightKg);
    await reload();
  }
}

final diaryControllerProvider =
    AsyncNotifierProvider<DiaryController, DiaryDay>(DiaryController.new);
