# flutter_blog (Riverpod starter)

A small Flutter + Riverpod starter project that scaffolds auth (login/join) and basic post pages.

## Requirements

- Flutter SDK (Dart `>=3.0.3 <4.0.0`) - see `pubspec.yaml`

## Quick start

```bash
flutter pub get
flutter run
```

## Tech stack

- UI: Flutter (Material)
- State: `flutter_riverpod` (Notifier/NotifierProvider)
- Network: `dio`
- Storage: `flutter_secure_storage`
- Utils: `intl`, `validators`, `logger`, `flutter_svg`

## Project structure

```text
lib/
  _core/          shared constants/utils (theme, routes, dio)
  data/
    gvm/          Riverpod Notifier layer (state)
    repository/   API repository layer
  ui/
    pages/        screens
    widgets/      reusable widgets
test/
  *_test.dart     unit/widget tests
assets/           static assets (images, svg, ...)
```

## Routing

- Route names and route map: `lib/_core/constants/move.dart`
- Start route: `lib/main.dart` (`initialRoute`)

## Session / Login flow (Riverpod)

- State model: `SessionUser` (`lib/data/gvm/session_gvm.dart`)
- Notifier: `SessionGVM extends Notifier<SessionUser>`
- Provider: `sessionProvider`
- Login call: `SessionGVM.login()` -> `UserRepository.login()` -> updates `state`

## API / Base URL

Dio is configured in `lib/_core/utils/my_http.dart`.

The `baseUrl` is currently hard-coded to a local network IP. Update it to match your backend:

```dart
baseUrl: "http://192.168.0.58:8080"
```

## Tests

```bash
flutter test
```

Notes:
- `test/widget_test.dart` is the default Flutter template test and may not match the current app UI (so it can fail).
- `test/user_repository_test.dart` performs a real network call to `/login` and will only pass when the backend is running and `baseUrl` is correct.
