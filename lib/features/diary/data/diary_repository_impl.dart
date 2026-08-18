import '../../../core/api/api_client.dart';
import '../domain/diary_repository.dart';
import '../domain/entities/diary_entries.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  const DiaryRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<FoodLogEntry>> listLogs(DateTime date) async {
    final data = await _api.get(
      '/api/logs/',
      query: {'date': formatApiDate(date)},
    );
    final list = data as List<dynamic>;
    return list
        .cast<Map<String, dynamic>>()
        .map(FoodLogEntry.fromJson)
        .toList();
  }

  @override
  Future<FoodLogEntry> addLog({
    required int foodItemId,
    required double quantity,
    required DateTime date,
    String? mealType,
  }) async {
    final data =
        await _api.post(
              '/api/logs/',
              body: {
                'food_item': foodItemId,
                'quantity': quantity,
                'meal_type': ?mealType,
                // Noon UTC so logged_at__date matches the selected calendar day.
                'logged_at': '${formatApiDate(date)}T12:00:00Z',
              },
            )
            as Map<String, dynamic>;
    return FoodLogEntry.fromJson(data);
  }

  @override
  Future<void> deleteLog(int id) => _api.delete('/api/logs/$id/');

  @override
  Future<List<WeightEntry>> listWeights() async {
    final data = await _api.get('/api/weight/');
    final list = data as List<dynamic>;
    return list.cast<Map<String, dynamic>>().map(WeightEntry.fromJson).toList();
  }

  @override
  Future<WeightEntry> addWeight({
    required DateTime date,
    required double weightKg,
  }) async {
    final data =
        await _api.post(
              '/api/weight/',
              body: {'date': formatApiDate(date), 'weight_kg': weightKg},
            )
            as Map<String, dynamic>;
    return WeightEntry.fromJson(data);
  }
}
