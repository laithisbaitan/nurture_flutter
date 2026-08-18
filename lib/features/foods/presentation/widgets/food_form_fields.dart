import 'package:flutter/material.dart';

import '../../../auth/presentation/widgets/auth_text_field.dart';
import 'food_search_tile.dart';

class FoodFormFields extends StatelessWidget {
  const FoodFormFields({
    super.key,
    required this.nameEn,
    required this.nameAr,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final TextEditingController nameEn;
  final TextEditingController nameAr;
  final TextEditingController servingSize;
  final TextEditingController servingUnit;
  final TextEditingController calories;
  final TextEditingController protein;
  final TextEditingController carbs;
  final TextEditingController fat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          controller: nameEn,
          label: 'Name (English)',
          validator: validateRequired,
        ),
        AuthTextField(
          controller: nameAr,
          label: 'Name (Arabic)',
          validator: validateRequired,
        ),
        AuthTextField(
          controller: servingSize,
          label: 'Serving size',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validatePositiveNumber,
        ),
        AuthTextField(
          controller: servingUnit,
          label: 'Serving unit (g, ml, piece)',
          validator: validateRequired,
        ),
        AuthTextField(
          controller: calories,
          label: 'Calories',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validatePositiveNumber,
        ),
        AuthTextField(
          controller: protein,
          label: 'Protein (g)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validatePositiveNumber,
        ),
        AuthTextField(
          controller: carbs,
          label: 'Carbs (g)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validatePositiveNumber,
        ),
        AuthTextField(
          controller: fat,
          label: 'Fat (g)',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: validatePositiveNumber,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
