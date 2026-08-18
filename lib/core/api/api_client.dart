import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../features/auth/data/token_storage.dart';
import '../config.dart';
import 'api_exception.dart';

/// Thin JSON HTTP client for the Nurture backend.
///
/// Attaches the JWT access token to every request. On a 401 it refreshes the
/// access token once (via /api/auth/refresh/) and retries; if the refresh
/// itself fails, tokens are cleared and [onSessionExpired] fires so the UI
/// can drop back to the login screen.
class ApiClient {
  ApiClient(this._tokenStorage, {this.onSessionExpired});

  final TokenStorage _tokenStorage;
  final void Function()? onSessionExpired;

  Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, {Object? body, bool auth = true}) =>
      _send('POST', path, body: body, auth: auth);

  Future<dynamic> patch(String path, {Object? body}) =>
      _send('PATCH', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  /// Multipart POST (food photo). Field name must match the backend (`photo`).
  Future<dynamic> postMultipart(
    String path, {
    required String fieldName,
    required String filePath,
  }) async {
    return _sendMultipart(path, fieldName: fieldName, filePath: filePath);
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(queryParameters: query);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
    bool auth = true,
    bool isRetry = false,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final access = await _tokenStorage.readAccess();
      if (access != null) headers['Authorization'] = 'Bearer $access';
    }

    http.Response response;
    try {
      final request = http.Request(method, _uri(path, query))
        ..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      response = await http.Response.fromStream(
        await request.send().timeout(const Duration(seconds: 20)),
      );
    } on SocketException {
      throw const ApiException(
        'Cannot reach the server. Check your connection.',
      );
    }

    if (response.statusCode == 401 && auth && !isRetry) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _send(method, path, body: body, query: query, isRetry: true);
      }
      await _tokenStorage.clear();
      onSessionExpired?.call();
    }

    return _decode(response);
  }

  Future<dynamic> _sendMultipart(
    String path, {
    required String fieldName,
    required String filePath,
    bool isRetry = false,
  }) async {
    final access = await _tokenStorage.readAccess();
    final request = http.MultipartRequest('POST', _uri(path));
    if (access != null) request.headers['Authorization'] = 'Bearer $access';
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

    http.Response response;
    try {
      response = await http.Response.fromStream(
        await request.send().timeout(const Duration(seconds: 60)),
      );
    } on SocketException {
      throw const ApiException(
        'Cannot reach the server. Check your connection.',
      );
    }

    if (response.statusCode == 401 && !isRetry) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _sendMultipart(
          path,
          fieldName: fieldName,
          filePath: filePath,
          isRetry: true,
        );
      }
      await _tokenStorage.clear();
      onSessionExpired?.call();
    }

    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    final decoded = response.body.isEmpty
        ? null
        : jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode >= 200 && response.statusCode < 300) return decoded;
    throw ApiException(
      readableApiError(decoded),
      statusCode: response.statusCode,
    );
  }

  Future<bool> _tryRefresh() async {
    final refresh = await _tokenStorage.readRefresh();
    if (refresh == null) return false;
    try {
      final response = await http
          .post(
            _uri('/api/auth/refresh/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refresh}),
          )
          .timeout(const Duration(seconds: 20));
      if (response.statusCode != 200) return false;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      await _tokenStorage.saveAccess(data['access'] as String);
      return true;
    } on Exception {
      return false;
    }
  }
}
