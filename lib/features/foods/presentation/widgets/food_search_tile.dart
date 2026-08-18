import 'package:flutter/material.dart';

import '../../domain/entities/food_item.dart';
import '../screens/food_detail_screen.dart';

class FoodSearchTile extends StatelessWidget {
  const FoodSearchTile({super.key, required this.item, this.onPicked});

  final FoodItem item;
  final ValueChanged<FoodItem>? onPicked;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title),
      subtitle: Text(
        item.nameAr.isEmpty
            ? '${item.calories.round()} kcal / ${item.servingSize} ${item.servingUnit}'
            : '${item.nameAr} · ${item.calories.round()} kcal',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (onPicked != null) {
          onPicked!(item);
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FoodDetailScreen(foodId: item.id)),
        );
      },
    );
  }
}

String? validateRequired(String? value) {
  if ((value ?? '').trim().isEmpty) return 'Required';
  return null;
}

String? validatePositiveNumber(String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) return 'Required';
  final parsed = num.tryParse(text);
  if (parsed == null || parsed < 0) return 'Enter a number';
  return null;
}

double parseNumber(String value) => num.parse(value.trim()).toDouble();

double? parseOptionalNumber(String value) {
  final text = value.trim();
  if (text.isEmpty) return null;
  return num.tryParse(text)?.toDouble();
}

void showFoodSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
