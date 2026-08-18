import 'package:flutter/foundation.dart';

/// The authenticated account, as returned by the backend's auth endpoints.
@immutable
class AuthUser {
  const AuthUser({required this.id, required this.email, required this.name});

  final int id;
  final String email;
  final String name;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as int,
        email: json['email'] as String,
        name: (json['name'] as String?) ?? '',
      );

  AuthUser copyWith({int? id, String? email, String? name}) => AuthUser(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
      );

  @override
  bool operator ==(Object other) =>
      other is AuthUser &&
      other.id == id &&
      other.email == email &&
      other.name == name;

  @override
  int get hashCode => Object.hash(id, email, name);
}
