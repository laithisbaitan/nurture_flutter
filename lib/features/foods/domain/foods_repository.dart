import 'entities/food_item.dart';

class FoodWrite {
  const FoodWrite({
    required this.nameEn,
    required this.nameAr,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.fiberG,
    this.sugarG,
    this.sodiumMg,
    this.source,
  });

  final String nameEn;
  final String nameAr;
  final double servingSize;
  final String servingUnit;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double? fiberG;
  final double? sugarG;
  final double? sodiumMg;
  final String? source;

  Map<String, dynamic> toJson() => {
    'name_en': nameEn,
    'name_ar': nameAr,
    'serving_size': servingSize,
    'serving_unit': servingUnit,
    'calories': calories,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    if (fiberG != null) 'fiber_g': fiberG,
    if (sugarG != null) 'sugar_g': sugarG,
    if (sodiumMg != null) 'sodium_mg': sodiumMg,
    if (source != null) 'source': source,
  };
}

abstract interface class FoodsRepository {
  Future<List<FoodItem>> list();

  Future<List<FoodItem>> search(String query);

  Future<FoodItem> getById(int id);

  Future<FoodItem> create(FoodWrite draft);

  Future<FoodItem> update(int id, FoodWrite draft);

  Future<FoodItem> uploadPhoto(String filePath);
}
