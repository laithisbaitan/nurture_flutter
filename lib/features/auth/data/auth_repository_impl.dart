import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../domain/auth_repository.dart';
import '../domain/entities/auth_user.dart';
import 'token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._api, this._tokens);

  final ApiClient _api;
  final TokenStorage _tokens;

  @override
  Future<AuthUser?> restoreSession() async {
    if (await _tokens.readRefresh() == null) return null;
    try {
      final me = await _api.get('/api/auth/me/') as Map<String, dynamic>;
      return AuthUser.fromJson(me);
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await _tokens.clear();
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final data =
        await _api.post(
              '/api/auth/login/',
              body: {'email': email, 'password': password},
              auth: false,
            )
            as Map<String, dynamic>;
    await _tokens.save(
      access: data['access'] as String,
      refresh: data['refresh'] as String,
    );
    final me = await _api.get('/api/auth/me/') as Map<String, dynamic>;
    return AuthUser.fromJson(me);
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    String name = '',
  }) async {
    final data =
        await _api.post(
              '/api/auth/register/',
              body: {'email': email, 'password': password, 'name': name},
              auth: false,
            )
            as Map<String, dynamic>;
    await _tokens.save(
      access: data['access'] as String,
      refresh: data['refresh'] as String,
    );
    return AuthUser.fromJson(data);
  }

  @override
  Future<void> logout() => _tokens.clear();

  @override
  Future<AuthUser> updateProfile({
    required String name,
    int? age,
    String? sex,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goal,
  }) async {
    final me =
        await _api.patch(
              '/api/auth/me/',
              body: {
                'name': name,
                'age': age,
                'sex': sex,
                'height_cm': heightCm,
                'weight_kg': weightKg,
                'activity_level': activityLevel,
                'goal': goal,
              },
            )
            as Map<String, dynamic>;
    return AuthUser.fromJson(me);
  }
}
