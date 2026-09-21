# Zenin Messenger Android

Flutter Android client for the Zenin Messenger backend.

## Features

- Black Kokugetsu-themed splash screen
- Login and registration
- Persistent auth token storage
- Profile and chat list loading from the existing REST API
- Telegram-style chat list
- Bottom navigation for Chats, Contacts, Stories, and Settings
- Android APK project structure

## Run locally

Install Flutter, then run:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

`10.0.2.2` points an Android emulator at the host machine. For a physical device, use the host machine's LAN address. For a published backend, pass the full HTTPS API URL:

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain.example/api
```

## Build an Android APK

```bash
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://your-domain.example/api
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`.

The backend currently returns an in-memory bearer token rather than a signed JWT. The client persists that returned token in `SharedPreferences` and sends it as `Authorization: Bearer <token>` on authenticated requests.


