import 'entities/progress_snapshot.dart';

abstract interface class ProgressRepository {
  Future<DailyTotals> daily(DateTime date);

  Future<List<DailyTotals>> weekly(DateTime start);

  Future<List<WeightPoint>> weightTrend();
}
