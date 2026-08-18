import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurture_flutter/core/providers.dart';
import 'package:nurture_flutter/features/auth/domain/auth_repository.dart';
import 'package:nurture_flutter/features/auth/domain/entities/auth_user.dart';
import 'package:nurture_flutter/features/auth/presentation/screens/login_screen.dart';

/// Avoids the secure-storage platform channel, which isn't available in tests.
class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser?> restoreSession() async => null;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    String name = '',
  }) =>
      throw UnimplementedError();

  @override
  Future<void> logout() async {}
}

Widget _testApp() {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(_FakeAuthRepository())],
    child: const MaterialApp(home: LoginScreen()),
  );
}

void main() {
  testWidgets('login screen renders email, password and actions', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    expect(find.text('Nurture'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text("Don't have an account? Sign up"), findsOneWidget);
  });

  testWidgets('login form validates empty input', (tester) async {
    await tester.pumpWidget(_testApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('At least 8 characters'), findsOneWidget);
  });
}
