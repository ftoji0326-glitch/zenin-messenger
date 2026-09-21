# Zenin Messenger Flutter build instructions

## Requirements

- Flutter 3.22 or newer
- Dart 3.4 or newer
- Android Studio with an Android SDK and emulator, or a connected Android device
- Android SDK platform and build tools installed for the Flutter stable channel

## Install dependencies

From the Flutter project directory:

```bash
cd zenin-messenger-flutter
flutter pub get
```

## Configure the backend

The app reads `API_BASE_URL` at compile time.

For an Android emulator running against the local backend on the host:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

For a physical Android device, replace `10.0.2.2` with the host machine's LAN IP:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000/api
```

For a published HTTPS backend:

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain.example/api
```

## Run checks

```bash
flutter analyze
flutter test
```

## Build a release APK

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://your-domain.example/api
```

The output APK is:

```text
build/app/outputs/flutter-apk/app-release.apk
```

To build split APKs for smaller downloads:

```bash
flutter build apk --split-per-abi --release \
  --dart-define=API_BASE_URL=https://your-domain.example/api
```

## Android signing

The generated project uses the debug signing configuration for local release builds. Before publishing, create a release keystore, configure `key.properties` locally, and replace the `signingConfig` in `android/app/build.gradle` with a release signing configuration. Do not commit keystores or signing secrets.

## Notes

- The local backend must be reachable from the Android device.
- Android cleartext HTTP is enabled for local development in `AndroidManifest.xml`; use HTTPS for production.
- The backend currently returns an in-memory bearer token. The app persists that token with `SharedPreferences` and sends it as a bearer token on authenticated requests.
