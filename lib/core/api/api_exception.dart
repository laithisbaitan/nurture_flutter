/// Error thrown by [ApiClient] for non-2xx responses or connectivity issues.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

/// Turns DRF error bodies into a single readable message.
///
/// DRF returns either {"detail": "..."} or {"field": ["msg", ...], ...}.
String readableApiError(Object? decodedBody) {
  if (decodedBody is Map<String, dynamic>) {
    final detail = decodedBody['detail'];
    if (detail is String) return detail;
    final parts = <String>[];
    decodedBody.forEach((field, value) {
      final messages = value is List ? value.join(' ') : value.toString();
      parts.add(field == 'non_field_errors' ? messages : '$field: $messages');
    });
    if (parts.isNotEmpty) return parts.join('\n');
  }
  return 'Something went wrong. Please try again.';
}
