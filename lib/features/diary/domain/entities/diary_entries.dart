import 'package:flutter/foundation.dart';

@immutable
class FoodLogEntry {
  const FoodLogEntry({
    required this.id,
    required this.foodItemId,
    required this.quantity,
    required this.loggedAt,
    required this.foodNameEn,
    required this.foodNameAr,
    required this.foodCalories,
    required this.foodServingSize,
    required this.foodServingUnit,
    this.mealType,
  });

  final int id;
  final int foodItemId;
  final double quantity;
  final String? mealType;
  final DateTime loggedAt;
  final String foodNameEn;
  final String foodNameAr;
  final double foodCalories;
  final double foodServingSize;
  final String foodServingUnit;

  String get title => foodNameEn.isNotEmpty
      ? foodNameEn
      : (foodNameAr.isNotEmpty ? foodNameAr : 'Food');

  double get totalCalories => foodCalories * quantity;

  factory FoodLogEntry.fromJson(Map<String, dynamic> json) => FoodLogEntry(
    id: json['id'] as int,
    foodItemId: json['food_item'] as int,
    quantity: _asDouble(json['quantity']) ?? 1,
    mealType: json['meal_type'] as String?,
    loggedAt: DateTime.parse(json['logged_at'] as String),
    foodNameEn: (json['food_name_en'] as String?) ?? '',
    foodNameAr: (json['food_name_ar'] as String?) ?? '',
    foodCalories: _asDouble(json['food_calories']) ?? 0,
    foodServingSize: _asDouble(json['food_serving_size']) ?? 0,
    foodServingUnit: (json['food_serving_unit'] as String?) ?? '',
  );
}

@immutable
class WeightEntry {
  const WeightEntry({
    required this.id,
    required this.date,
    required this.weightKg,
  });

  final int id;
  final String date;
  final double weightKg;

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
    id: json['id'] as int,
    date: json['date'] as String,
    weightKg: _asDouble(json['weight_kg']) ?? 0,
  );
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String formatApiDate(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
