# Nurture Flutter — Project Status & Roadmap

Living document, updated at the end of every stage.

## Goal

Flutter client for the Nurture backend: auth, profile, shared food database
(search + two-step photo entry), per-user food/weight diary, progress charts.
Personal-first, minimal, no bloat.

## Stack

Flutter (Material 3), flutter_riverpod (`AsyncNotifier` controllers), http,
flutter_secure_storage (JWT pair). Platforms: Android, iOS, Linux desktop.
`fl_chart` planned for stage F4 only.

## Stage Roadmap

| Stage | Scope | Status |
|---|---|---|
| F0 | Scaffold, theme, ApiClient (JWT + auto-refresh), login/register, session persistence, home shell | **Done** (analyze + 2 widget tests pass) |
| F1 | Profile screen: view/edit age, sex, height, weight, activity, goal | Not started |
| F2 | Foods: search (EN/AR), detail, manual create, two-step photo flow | Not started |
| F3 | Diary: day view of food logs, add via search, delete, weight logging | Not started |
| F4 | Progress: daily totals, weekly view, weight-trend chart (fl_chart) | Not started |

**Rule: one stage at a time; stop for user confirmation between stages.**

## How to run

```bash
# against the production VPS (default base URL)
flutter run

# against a local backend
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000

# Android emulator -> host machine backend
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Decision log

- 2026-08-18: flutter_riverpod chosen (user rules specify `AsyncNotifier`,
  which is Riverpod's API; Riverpod is Provider's successor by the same author).
- 2026-08-18: Manual immutable entities with `copyWith` instead of freezed —
  avoids build_runner/codegen; rules allow either.
- 2026-08-18: No separate use-case classes; controllers call repositories
  directly (each use case would be a one-line pass-through). Flagged to user.
- 2026-08-18: Default API base URL is the VPS; override via --dart-define.
  Android manifest allows cleartext HTTP until TLS is added.
- 2026-08-18: Navigation via plain Navigator + AuthGate (no go_router in v1).
