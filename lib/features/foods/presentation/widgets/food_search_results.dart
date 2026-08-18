import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_item.dart';
import 'food_search_tile.dart';

class FoodSearchResults extends StatelessWidget {
  const FoodSearchResults({super.key, required this.results, this.onPicked});

  final AsyncValue<List<FoodItem>> results;
  final ValueChanged<FoodItem>? onPicked;

  @override
  Widget build(BuildContext context) {
    if (results.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final items = results.valueOrNull ?? const [];
    if (items.isEmpty) {
      return const Center(child: Text('No foods yet. Add one or search.'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) =>
          FoodSearchTile(item: items[index], onPicked: onPicked),
    );
  }
}

class FoodEntryButtons extends StatelessWidget {
  const FoodEntryButtons({
    super.key,
    required this.onManual,
    required this.onPhoto,
    required this.photoBusy,
  });

  final VoidCallback onManual;
  final VoidCallback onPhoto;
  final bool photoBusy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onManual,
              child: const Text('Add manually'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: photoBusy ? null : onPhoto,
              child: const Text('Add from photo'),
            ),
          ),
        ],
      ),
    );
  }
}
