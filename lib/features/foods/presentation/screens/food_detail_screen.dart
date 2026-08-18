import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../domain/entities/food_item.dart';
import 'food_form_screen.dart';

final foodDetailProvider = FutureProvider.autoDispose.family<FoodItem, int>((
  ref,
  id,
) {
  return ref.watch(foodsRepositoryProvider).getById(id);
});

class FoodDetailScreen extends ConsumerWidget {
  const FoodDetailScreen({super.key, required this.foodId});

  final int foodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(foodDetailProvider(foodId));

    return Scaffold(
      appBar: AppBar(title: const Text('Food')),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (item) => _FoodDetailBody(item: item),
      ),
    );
  }
}

class _FoodDetailBody extends StatelessWidget {
  const _FoodDetailBody({required this.item});

  final FoodItem item;

  @override
  Widget build(BuildContext context) {
    final photo = item.photoUrl;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (photo != null && photo.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Image.network(photo, height: 180, fit: BoxFit.cover),
          ),
        Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
        if (item.nameAr.isNotEmpty) Text(item.nameAr),
        const SizedBox(height: 16),
        Text('${item.calories} kcal · ${item.servingSize} ${item.servingUnit}'),
        Text('P ${item.proteinG}g · C ${item.carbsG}g · F ${item.fatG}g'),
        if (item.isPhotoPending) ...[
          const SizedBox(height: 24),
          const Text('Nutrition is still pending for this photo.'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => FoodFormScreen(existing: item)),
            ),
            child: const Text('Complete nutrition'),
          ),
        ],
      ],
    );
  }
}
