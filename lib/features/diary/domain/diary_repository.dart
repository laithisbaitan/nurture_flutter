import 'entities/diary_entries.dart';

abstract interface class DiaryRepository {
  Future<List<FoodLogEntry>> listLogs(DateTime date);

  Future<FoodLogEntry> addLog({
    required int foodItemId,
    required double quantity,
    required DateTime date,
    String? mealType,
  });

  Future<void> deleteLog(int id);

  Future<List<WeightEntry>> listWeights();

  Future<WeightEntry> addWeight({
    required DateTime date,
    required double weightKg,
  });
}
