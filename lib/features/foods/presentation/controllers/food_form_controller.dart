import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/foods_repository.dart';

class FoodFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<FoodItem?> save(FoodWrite draft, {int? id}) async {
    state = const AsyncLoading();
    FoodItem? saved;
    state = await AsyncValue.guard(() async {
      final repo = ref.read(foodsRepositoryProvider);
      saved = id == null
          ? await repo.create(draft)
          : await repo.update(id, draft);
    });
    return state.hasError ? null : saved;
  }

  Future<FoodItem?> uploadPhoto(String filePath) async {
    state = const AsyncLoading();
    FoodItem? saved;
    state = await AsyncValue.guard(() async {
      saved = await ref.read(foodsRepositoryProvider).uploadPhoto(filePath);
    });
    return state.hasError ? null : saved;
  }
}

final foodFormControllerProvider =
    AsyncNotifierProvider<FoodFormController, void>(FoodFormController.new);
