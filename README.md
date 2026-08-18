# nurture_flutter

Flutter app for **Nurture**, a personal-first health/food-tracking service.
Backend: [nurture_backend](https://github.com/) (Django + DRF + JWT).

## Run

```bash
flutter pub get

# against production (default)
flutter run

# against a local backend
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

Android emulators reach a backend on the host machine via
`http://10.0.2.2:8000`.

## Structure

Feature-first clean architecture — see `docs/PROJECT.md` for the roadmap and
`.cursor/rules/` for conventions.

```
lib/
├── core/          # config, theme, ApiClient (JWT + refresh), providers
└── features/
    ├── auth/      # login/register, token storage, session restore
    └── home/      # app shell (tabs arrive in later stages)
```

## Checks

```bash
flutter analyze
flutter test
```
