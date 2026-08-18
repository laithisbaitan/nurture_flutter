import 'entities/auth_user.dart';

/// Contract for authentication; implemented in the data layer.
abstract interface class AuthRepository {
  /// Returns the signed-in user if stored tokens are still valid, else null.
  Future<AuthUser?> restoreSession();

  Future<AuthUser> login({required String email, required String password});

  Future<AuthUser> register({
    required String email,
    required String password,
    String name,
  });

  Future<void> logout();
}
