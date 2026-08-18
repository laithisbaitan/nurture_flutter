import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../diary/domain/entities/diary_entries.dart';
import '../../domain/entities/progress_snapshot.dart';

class ProgressController extends AsyncNotifier<ProgressSnapshot> {
  DateTime _date = dateOnly(DateTime.now());

  DateTime get date => _date;

  @override
  Future<ProgressSnapshot> build() => _load(_date);

  Future<void> shiftDay(int days) async {
    _date = dateOnly(_date.add(Duration(days: days)));
    await reload();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(_date));
  }

  Future<ProgressSnapshot> _load(DateTime date) async {
    final repo = ref.read(progressRepositoryProvider);
    final daily = await repo.daily(date);
    final week = await repo.weekly(date);
    final weightTrend = await repo.weightTrend();
    return ProgressSnapshot(
      date: date,
      daily: daily,
      week: week,
      weightTrend: weightTrend,
    );
  }
}

final progressControllerProvider =
    AsyncNotifierProvider<ProgressController, ProgressSnapshot>(
      ProgressController.new,
    );
