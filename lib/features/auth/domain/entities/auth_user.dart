import 'package:flutter/foundation.dart';

/// The authenticated account, as returned by GET/PATCH `/api/auth/me/`.
@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    this.age,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.goal,
  });

  final int id;
  final String email;
  final String name;
  final int? age;
  final String? sex;
  final double? heightCm;
  final double? weightKg;
  final String? activityLevel;
  final String? goal;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as int,
    email: json['email'] as String,
    name: (json['name'] as String?) ?? '',
    age: _asInt(json['age']),
    sex: json['sex'] as String?,
    heightCm: _asDouble(json['height_cm']),
    weightKg: _asDouble(json['weight_kg']),
    activityLevel: json['activity_level'] as String?,
    goal: json['goal'] as String?,
  );

  AuthUser copyWith({
    int? id,
    String? email,
    String? name,
    int? age,
    String? sex,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goal,
  }) => AuthUser(
    id: id ?? this.id,
    email: email ?? this.email,
    name: name ?? this.name,
    age: age ?? this.age,
    sex: sex ?? this.sex,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    activityLevel: activityLevel ?? this.activityLevel,
    goal: goal ?? this.goal,
  );

  @override
  bool operator ==(Object other) =>
      other is AuthUser &&
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.age == age &&
      other.sex == sex &&
      other.heightCm == heightCm &&
      other.weightKg == weightKg &&
      other.activityLevel == activityLevel &&
      other.goal == goal;

  @override
  int get hashCode => Object.hash(
    id,
    email,
    name,
    age,
    sex,
    heightCm,
    weightKg,
    activityLevel,
    goal,
  );
}

int? _asInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _asDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
