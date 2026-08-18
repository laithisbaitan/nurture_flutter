import 'package:flutter/foundation.dart';

@immutable
class DailyTotals {
  const DailyTotals({
    required this.date,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.micros = const {},
  });

  final String date;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final Map<String, double> micros;

  factory DailyTotals.fromJson(Map<String, dynamic> json) {
    final rawMicros = json['micros_json'];
    final micros = <String, double>{};
    if (rawMicros is Map) {
      rawMicros.forEach((key, value) {
        if (value is num) micros['$key'] = value.toDouble();
      });
    }
    return DailyTotals(
      date: json['date'] as String,
      calories: _asDouble(json['total_calories']) ?? 0,
      proteinG: _asDouble(json['total_protein_g']) ?? 0,
      carbsG: _asDouble(json['total_carbs_g']) ?? 0,
      fatG: _asDouble(json['total_fat_g']) ?? 0,
      micros: micros,
    );
  }
}

@immutable
class WeightPoint {
  const WeightPoint({required this.date, required this.weightKg});

  final String date;
  final double weightKg;

  factory WeightPoint.fromJson(Map<String, dynamic> json) => WeightPoint(
    date: json['date'] as String,
    weightKg: _asDouble(json['weight_kg']) ?? 0,
  );
}

@immutable
class ProgressSnapshot {
  const ProgressSnapshot({
    required this.date,
    required this.daily,
    required this.week,
    required this.weightTrend,
  });

  final DateTime date;
  final DailyTotals daily;
  final List<DailyTotals> week;
  final List<WeightPoint> weightTrend;
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
