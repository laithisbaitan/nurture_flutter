/// App-wide configuration.
///
/// Override the API base URL at build/run time:
///   make run-local
///   flutter run --dart-define-from-file=dart_defines/local.json
/// Android emulator reaching a backend on the host machine:
///   make run-android-local
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://72.61.91.102',
  );
}
