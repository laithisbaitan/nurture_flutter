import 'package:flutter/material.dart';

import '../../domain/entities/food_item.dart';

class FoodFormControllers {
  FoodFormControllers(FoodItem? item)
    : nameEn = TextEditingController(text: item?.nameEn ?? ''),
      nameAr = TextEditingController(text: item?.nameAr ?? ''),
      servingSize = TextEditingController(
        text: _num(item, (i) => i.servingSize),
      ),
      servingUnit = TextEditingController(text: item?.servingUnit ?? 'g'),
      calories = TextEditingController(text: _num(item, (i) => i.calories)),
      protein = TextEditingController(text: _num(item, (i) => i.proteinG)),
      carbs = TextEditingController(text: _num(item, (i) => i.carbsG)),
      fat = TextEditingController(text: _num(item, (i) => i.fatG));

  final TextEditingController nameEn;
  final TextEditingController nameAr;
  final TextEditingController servingSize;
  final TextEditingController servingUnit;
  final TextEditingController calories;
  final TextEditingController protein;
  final TextEditingController carbs;
  final TextEditingController fat;

  void dispose() {
    nameEn.dispose();
    nameAr.dispose();
    servingSize.dispose();
    servingUnit.dispose();
    calories.dispose();
    protein.dispose();
    carbs.dispose();
    fat.dispose();
  }

  static String _num(FoodItem? item, double Function(FoodItem) read) {
    if (item == null || item.isPhotoPending) return '';
    return '${read(item)}';
  }
}
