# Nurture Flutter — Project Status & Roadmap

Living document, updated at the end of every stage.

## Goal

Flutter client for the sibling backend `nurture_backend/`: auth, profile, shared food database
(search + two-step photo entry), per-user food/weight diary, progress charts.
Personal-first, minimal, no bloat.

## Stack

Flutter (Material 3), flutter_riverpod (`AsyncNotifier` controllers), http,
flutter_secure_storage (JWT pair). Platforms: Android, iOS, Linux desktop.
`fl_chart` for stage F4 charts.

## Stage Roadmap

| Stage | Scope | Status |
|---|---|---|
| F0 | Scaffold, theme, ApiClient (JWT + auto-refresh), login/register, session persistence, home shell | **Done** (analyze + 2 widget tests pass) |
| F1 | Profile screen: view/edit age, sex, height, weight, activity, goal | **Done** (analyze + 3 widget tests pass) |
| F2 | Foods: search (EN/AR), detail, manual create, two-step photo flow | **Done** (analyze + 4 widget tests pass) |
| F3 | Diary: day view of food logs, add via search, delete, weight logging | **Done** (analyze + 5 widget tests pass) |
| F4 | Progress: daily totals, weekly view, weight-trend chart (fl_chart) | **Done** (analyze + 6 widget tests pass) |

**Rule: one stage at a time; stop for user confirmation between stages.**

## How to run

```bash
# Linux desktop needs libsecret (flutter_secure_storage)
sudo apt-get install -y libsecret-1-dev

# against the production VPS (default base URL)
flutter run
# or: make run

# against a local backend (Linux desktop)
make run-local

# Android emulator -> host machine backend
make run-android-local
```

In Cursor, pick **Nurture (local backend)** from the Run and Debug dropdown
instead of typing flags. URLs live in `dart_defines/*.json`.

## Decision log

- 2026-08-18: flutter_riverpod chosen (user rules specify `AsyncNotifier`,
  which is Riverpod's API; Riverpod is Provider's successor by the same author).
- 2026-08-18: Manual immutable entities with `copyWith` instead of freezed —
  avoids build_runner/codegen; rules allow either.
- 2026-08-18: No separate use-case classes; controllers call repositories
  directly (each use case would be a one-line pass-through). Flagged to user.
- 2026-08-18: Default API base URL is the VPS; override via --dart-define
  (or `make run-local` / Cursor launch configs). Android manifest allows
  cleartext HTTP until TLS is added.
- 2026-08-18: Navigation via plain Navigator + AuthGate (no go_router in v1).
- 2026-08-18: Profile is GET/PATCH `/api/auth/me/` on AuthUser (same resource as
  session). A separate ProfileController saves so a loading state does not
  bounce AuthGate back to login. Linux desktop requires `libsecret-1-dev`.
- 2026-08-18: Foods search is the entry point (EN/AR). Manual create POSTs
  `/api/foods/`. Photo flow is gallery pick → multipart POST `/api/foods/photo/`
  → PATCH nutrition with `source=manual`. `image_picker` (file dialog on Linux).
- 2026-08-18: Home is the diary day view. Logs use GET/POST/DELETE `/api/logs/`
  (`logged_at` noon UTC so the selected date matches). Weight is POST
  `/api/weight/` for that day. Add-food reuses the foods picker.
- 2026-08-18: Progress is a pushed screen from the home app bar. Daily and
  weekly totals use `/api/progress/daily/` and `/api/progress/weekly/?start=`
  (7 days from the selected date). Weight trend is `/api/progress/weight-trend/`
  via `fl_chart`.
