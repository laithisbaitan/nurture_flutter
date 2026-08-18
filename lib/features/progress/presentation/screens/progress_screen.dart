import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../diary/presentation/widgets/diary_widgets.dart';
import '../controllers/progress_controller.dart';
import '../widgets/daily_totals_card.dart';
import '../widgets/weekly_calories_chart.dart';
import '../widgets/weight_trend_chart.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(progressControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (snapshot) {
          final notifier = ref.read(progressControllerProvider.notifier);
          return Column(
            children: [
              DiaryDateBar(
                date: snapshot.date,
                onPrev: () => notifier.shiftDay(-1),
                onNext: () => notifier.shiftDay(1),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    DailyTotalsCard(totals: snapshot.daily),
                    const SizedBox(height: 12),
                    WeeklyCaloriesChart(week: snapshot.week),
                    const SizedBox(height: 12),
                    WeightTrendChart(points: snapshot.weightTrend),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
