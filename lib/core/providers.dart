import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../features/auth/data/auth_repository_impl.dart';
import '../features/auth/data/token_storage.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/diary/data/diary_repository_impl.dart';
import '../features/diary/domain/diary_repository.dart';
import '../features/foods/data/foods_repository_impl.dart';
import '../features/foods/domain/foods_repository.dart';
import '../features/progress/data/progress_repository_impl.dart';
import '../features/progress/domain/progress_repository.dart';
import 'api/api_client.dart';

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const TokenStorage(FlutterSecureStorage()),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    ref.watch(tokenStorageProvider),
    // Refresh token dead -> rebuild auth state, which lands on the login screen.
    onSessionExpired: () => ref.invalidate(authControllerProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  ),
);

final foodsRepositoryProvider = Provider<FoodsRepository>(
  (ref) => FoodsRepositoryImpl(ref.watch(apiClientProvider)),
);

final diaryRepositoryProvider = Provider<DiaryRepository>(
  (ref) => DiaryRepositoryImpl(ref.watch(apiClientProvider)),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepositoryImpl(ref.watch(apiClientProvider)),
);
