import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

class NurtureApp extends StatelessWidget {
  const NurtureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nurture',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

/// Routes to login or the app based on auth state.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.valueOrNull;
    if (user != null) return const HomeScreen();
    // Session restore in flight (first launch) -> splash spinner.
    if (authState.isLoading && !authState.hasValue && !authState.hasError) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return const LoginScreen();
  }
}
