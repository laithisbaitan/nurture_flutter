/// App-wide configuration.
///
/// Override the API base URL at build/run time, e.g.:
///   flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
/// Android emulator reaching a backend on the host machine:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://72.61.91.102',
  );
}
