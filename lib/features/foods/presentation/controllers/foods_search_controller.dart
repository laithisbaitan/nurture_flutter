import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../domain/entities/food_item.dart';

class FoodsSearchController extends AsyncNotifier<List<FoodItem>> {
  @override
  Future<List<FoodItem>> build() => _load('');

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(query));
  }

  Future<List<FoodItem>> _load(String query) {
    final trimmed = query.trim();
    final repo = ref.read(foodsRepositoryProvider);
    return trimmed.isEmpty ? repo.list() : repo.search(trimmed);
  }
}

final foodsSearchControllerProvider =
    AsyncNotifierProvider<FoodsSearchController, List<FoodItem>>(
      FoodsSearchController.new,
    );
