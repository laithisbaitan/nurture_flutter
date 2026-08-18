import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

/// Saves profile edits. Separate from [AuthController] so a save spinner
/// does not kick the user back to the login screen.
class ProfileController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> save({
    required String name,
    int? age,
    String? sex,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goal,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final AuthUser updated = await ref
          .read(authRepositoryProvider)
          .updateProfile(
            name: name,
            age: age,
            sex: sex,
            heightCm: heightCm,
            weightKg: weightKg,
            activityLevel: activityLevel,
            goal: goal,
          );
      ref.read(authControllerProvider.notifier).replaceUser(updated);
    });
    return !state.hasError;
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, void>(ProfileController.new);
