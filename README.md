# nurture_flutter

Flutter app for **Nurture**, a personal-first health/food-tracking service.
Backend: sibling repo `nurture_backend/` (Django + DRF + JWT).

## Run

```bash
flutter pub get

# Linux: one-time native dep for flutter_secure_storage
sudo apt-get install -y libsecret-1-dev

# against production (default)
flutter run

# against a local backend (Linux desktop)
make run-local

# Android emulator → backend on the host machine
make run-android-local
```

In Cursor, use the **Nurture (local backend)** launch config.

## Structure

Feature-first clean architecture — see `docs/PROJECT.md` for the roadmap and
`.cursor/rules/` for conventions.

```
lib/
├── core/          # config, theme, ApiClient (JWT + refresh), providers
└── features/
    ├── auth/      # login/register, token storage, session restore
    ├── profile/   # view/edit /api/auth/me/
    ├── foods/     # search, detail, manual create, photo flow
    ├── diary/     # day view of logs + weight
    ├── progress/  # daily totals, weekly bars, weight-trend chart
    └── home/      # shell (diary body, foods/progress/profile in the app bar)
```

## Checks

```bash
flutter analyze
flutter test
```
