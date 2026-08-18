import 'package:flutter/foundation.dart';

abstract final class FoodSource {
  static const manual = 'manual';
  static const photoPendingAi = 'photo_pending_ai';
}

@immutable
class FoodItem {
  const FoodItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.photoUrl,
    this.fiberG,
    this.sugarG,
    this.sodiumMg,
    this.source = FoodSource.manual,
  });

  final int id;
  final String nameEn;
  final String nameAr;
  final String? photoUrl;
  final double servingSize;
  final String servingUnit;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double? fiberG;
  final double? sugarG;
  final double? sodiumMg;
  final String source;

  bool get isPhotoPending => source == FoodSource.photoPendingAi;

  String get title {
    if (nameEn.isNotEmpty) return nameEn;
    if (nameAr.isNotEmpty) return nameAr;
    return isPhotoPending ? 'Photo (nutrition pending)' : 'Untitled food';
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'] as int,
    nameEn: (json['name_en'] as String?) ?? '',
    nameAr: (json['name_ar'] as String?) ?? '',
    photoUrl: json['photo'] as String?,
    servingSize: _asDouble(json['serving_size']) ?? 0,
    servingUnit: (json['serving_unit'] as String?) ?? '',
    calories: _asDouble(json['calories']) ?? 0,
    proteinG: _asDouble(json['protein_g']) ?? 0,
    carbsG: _asDouble(json['carbs_g']) ?? 0,
    fatG: _asDouble(json['fat_g']) ?? 0,
    fiberG: _asDouble(json['fiber_g']),
    sugarG: _asDouble(json['sugar_g']),
    sodiumMg: _asDouble(json['sodium_mg']),
    source: (json['source'] as String?) ?? FoodSource.manual,
  );
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
