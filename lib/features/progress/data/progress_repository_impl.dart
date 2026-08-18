import '../../../core/api/api_client.dart';
import '../../diary/domain/entities/diary_entries.dart';
import '../domain/entities/progress_snapshot.dart';
import '../domain/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  const ProgressRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<DailyTotals> daily(DateTime date) async {
    final data = await _api.get(
      '/api/progress/daily/',
      query: {'date': formatApiDate(date)},
    );
    return DailyTotals.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<List<DailyTotals>> weekly(DateTime start) async {
    final data = await _api.get(
      '/api/progress/weekly/',
      query: {'start': formatApiDate(start)},
    );
    final list = data as List<dynamic>;
    return list.cast<Map<String, dynamic>>().map(DailyTotals.fromJson).toList();
  }

  @override
  Future<List<WeightPoint>> weightTrend() async {
    final data = await _api.get('/api/progress/weight-trend/');
    final list = data as List<dynamic>;
    return list.cast<Map<String, dynamic>>().map(WeightPoint.fromJson).toList();
  }
}
