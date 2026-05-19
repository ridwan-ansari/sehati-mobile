# Sehati

Sehati is a comprehensive mobile health and wellness application built with Flutter. It helps users monitor, track, and improve their health through an integrated suite of features.

## Features

- **Monitoring** — Track body weight, height, and BMI over time
- **Journal** — Log daily food intake, calories, exercise, and eating habits
- **Reminder** — Set personalized reminders for medication, meals, and workouts
- **Sleep Tracker** — Record and visualize sleep duration and quality
- **Healthy Recipes** — Browse and search curated healthy meal recipes
- **Appointment** — Schedule consultations with health professionals
- **Edutainment** — Watch educational health videos and earn points
- **Games** — Gamified health challenges with a reward system
- **Leaderboard** — Compete with the community via a points and ranking system
- **Chat** — Real-time messaging with peers and health professionals
- **Community Forum** — Share posts, discuss health topics, and engage with others
- **Merchandise** — Redeem earned points for health products

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter |
| State Management & Routing | GetX |
| HTTP Client | Dio |
| Real-time | WebSocket |
| Local Storage | GetStorage, Hive, SharedPreferences |
| Notifications | Flutter Local Notifications, Awesome Notifications |

## Getting Started

Ensure the Flutter SDK is installed, then run:

```bash
flutter pub get
flutter run
```

For Flutter documentation, visit [flutter.dev](https://flutter.dev).

## Release Build

All release builds are obfuscated. The Dart compiler requires a `--split-debug-info` directory whenever `--obfuscate` is used — keep the generated symbol files; they are needed to de-symbolicate crash reports later.

### Android — Split APK per ABI (obfuscated)

```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols/android
```

Output (one APK per CPU architecture):

```
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

### Android — App Bundle (obfuscated, recommended for Play Store)

```bash
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/symbols/android
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS — IPA (obfuscated)

```bash
flutter build ipa --release \
  --obfuscate \
  --split-debug-info=build/symbols/ios
```

> ⚠️ Always archive the `build/symbols/` directory together with the release artifact. Without it, crash stack traces from obfuscated builds cannot be decoded.
