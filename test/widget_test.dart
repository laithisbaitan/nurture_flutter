import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurture_flutter/core/providers.dart';
import 'package:nurture_flutter/features/auth/domain/auth_repository.dart';
import 'package:nurture_flutter/features/auth/domain/entities/auth_user.dart';
import 'package:nurture_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:nurture_flutter/features/diary/domain/diary_repository.dart';
import 'package:nurture_flutter/features/diary/domain/entities/diary_entries.dart';
import 'package:nurture_flutter/features/diary/presentation/screens/diary_screen.dart';
import 'package:nurture_flutter/features/foods/domain/entities/food_item.dart';
import 'package:nurture_flutter/features/foods/domain/foods_repository.dart';
import 'package:nurture_flutter/features/foods/presentation/screens/foods_search_screen.dart';
import 'package:nurture_flutter/features/profile/presentation/screens/profile_screen.dart';
import 'package:nurture_flutter/features/progress/domain/entities/progress_snapshot.dart';
import 'package:nurture_flutter/features/progress/domain/progress_repository.dart';
import 'package:nurture_flutter/features/progress/presentation/screens/progress_screen.dart';

const _testUser = AuthUser(
  id: 1,
  email: 'ada@example.com',
  name: 'Ada',
  age: 30,
  sex: 'female',
);

/// Avoids the secure-storage platform channel, which isn't available in tests.
class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.user});

  final AuthUser? user;

  @override
  Future<AuthUser?> restoreSession() async => user;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
    String name = '',
  }) => throw UnimplementedError();

  @override
  Future<void> logout() async {}

  @override
  Future<AuthUser> updateProfile({
    required String name,
    int? age,
    String? sex,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? goal,
  }) async => _testUser.copyWith(
    name: name,
    age: age,
    sex: sex,
    heightCm: heightCm,
    weightKg: weightKg,
    activityLevel: activityLevel,
    goal: goal,
  );
}

class _FakeFoodsRepository implements FoodsRepository {
  @override
  Future<List<FoodItem>> list() async => const [];

  @override
  Future<List<FoodItem>> search(String query) async => const [];

  @override
  Future<FoodItem> getById(int id) => throw UnimplementedError();

  @override
  Future<FoodItem> create(FoodWrite draft) => throw UnimplementedError();

  @override
  Future<FoodItem> update(int id, FoodWrite draft) =>
      throw UnimplementedError();

  @override
  Future<FoodItem> uploadPhoto(String filePath) => throw UnimplementedError();
}

class _FakeDiaryRepository implements DiaryRepository {
  @override
  Future<List<FoodLogEntry>> listLogs(DateTime date) async => const [];

  @override
  Future<FoodLogEntry> addLog({
    required int foodItemId,
    required double quantity,
    required DateTime date,
    String? mealType,
  }) => throw UnimplementedError();

  @override
  Future<void> deleteLog(int id) async {}

  @override
  Future<List<WeightEntry>> listWeights() async => const [];

  @override
  Future<WeightEntry> addWeight({
    required DateTime date,
    required double weightKg,
  }) => throw UnimplementedError();
}

class _FakeProgressRepository implements ProgressRepository {
  @override
  Future<DailyTotals> daily(DateTime date) async => DailyTotals(
    date: formatApiDate(date),
    calories: 1850,
    proteinG: 120,
    carbsG: 180,
    fatG: 55,
  );

  @override
  Future<List<DailyTotals>> weekly(DateTime start) async => [
    for (var offset = 0; offset < 7; offset++)
      DailyTotals(
        date: formatApiDate(start.add(Duration(days: offset))),
        calories: offset == 0 ? 1850 : 0,
        proteinG: 0,
        carbsG: 0,
        fatG: 0,
      ),
  ];

  @override
  Future<List<WeightPoint>> weightTrend() async => const [
    WeightPoint(date: '2026-08-10', weightKg: 84),
    WeightPoint(date: '2026-08-12', weightKg: 83.2),
  ];
}

Widget _testApp({required Widget home, AuthUser? session}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        _FakeAuthRepository(user: session),
      ),
      foodsRepositoryProvider.overrideWithValue(_FakeFoodsRepository()),
      diaryRepositoryProvider.overrideWithValue(_FakeDiaryRepository()),
      progressRepositoryProvider.overrideWithValue(_FakeProgressRepository()),
    ],
    child: MaterialApp(home: home),
  );
}

void main() {
  testWidgets('login screen renders email, password and actions', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(home: const LoginScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Nurture'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text("Don't have an account? Sign up"), findsOneWidget);
  });

  testWidgets('login form validates empty input', (tester) async {
    await tester.pumpWidget(_testApp(home: const LoginScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('At least 8 characters'), findsOneWidget);
  });

  testWidgets('profile screen shows current user fields', (tester) async {
    await tester.pumpWidget(
      _testApp(home: const ProfileScreen(), session: _testUser),
    );
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Ada'), findsOneWidget);
    expect(find.text('ada@example.com'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('foods screen shows search and add actions', (tester) async {
    await tester.pumpWidget(_testApp(home: const FoodsSearchScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Foods'), findsOneWidget);
    expect(find.text('Search English or Arabic'), findsOneWidget);
    expect(find.text('Add manually'), findsOneWidget);
    expect(find.text('Add from photo'), findsOneWidget);
    expect(find.text('No foods yet. Add one or search.'), findsOneWidget);
  });

  testWidgets('diary screen shows day view and add food', (tester) async {
    await tester.pumpWidget(
      _testApp(home: const Scaffold(body: DiaryScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add food'), findsOneWidget);
    expect(find.text('No meals logged.'), findsOneWidget);
    expect(find.text('Weight (kg)'), findsOneWidget);
    expect(find.text('0 kcal'), findsOneWidget);
  });

  testWidgets('progress screen shows daily totals and charts', (tester) async {
    await tester.pumpWidget(_testApp(home: const ProgressScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
    expect(find.text('1850 kcal'), findsOneWidget);
    expect(find.text('Week'), findsOneWidget);
    expect(find.text('Weight trend'), findsOneWidget);
  });
}
