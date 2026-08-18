import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../domain/entities/auth_user.dart';

/// Holds the signed-in user (null = signed out). All auth logic lives here;
/// screens only render state and forward user actions.
class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() => ref.read(authRepositoryProvider).restoreSession();

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(
            email: email.trim(),
            password: password,
          ),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).register(
            email: email.trim(),
            password: password,
            name: name.trim(),
          ),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthUser?>(AuthController.new);
