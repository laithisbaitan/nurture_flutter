import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../diary/presentation/screens/diary_screen.dart';
import '../../../foods/presentation/screens/foods_search_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../progress/presentation/screens/progress_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nurture'),
        actions: [
          IconButton(
            tooltip: 'Foods',
            icon: const Icon(Icons.restaurant_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FoodsSearchScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Progress',
            icon: const Icon(Icons.show_chart),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProgressScreen())),
          ),
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: const DiaryScreen(),
    );
  }
}
