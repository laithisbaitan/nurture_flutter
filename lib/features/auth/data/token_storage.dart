import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT pair in platform secure storage.
class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'jwt_access';
  static const _refreshKey = 'jwt_refresh';

  Future<String?> readAccess() => _storage.read(key: _accessKey);

  Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  Future<void> save({required String access, required String refresh}) async {
    await _storage.write(key: _accessKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  Future<void> saveAccess(String access) =>
      _storage.write(key: _accessKey, value: access);

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
