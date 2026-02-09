# CAT.AI (Flutter)

Minimalist digital desk companion with an animated robot cat face and persistent behavior memory.

## Local Run

```bash
cd cat_os_flutter
flutter pub get
flutter run
```

## PWA Ready (Mobile Web Install)

This project is configured for installable PWA in:

- `web/manifest.json`
- `web/index.html`

Build production web with offline caching:

```bash
flutter build web --release --pwa-strategy=offline-first
```

Deploy the `build/web/` folder to HTTPS hosting (Vercel, Firebase Hosting, Netlify, Cloudflare Pages, etc.).

## Play Store Ready (Android)

Android release config is prepared in:

- `android/app/build.gradle.kts`
- `android/app/proguard-rules.pro`
- `android/key.properties.example`

### 1. Create upload keystore

```bash
keytool -genkey -v -keystore keystore/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Configure signing

Copy `android/key.properties.example` to `android/key.properties` and fill values:

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=../keystore/upload-keystore.jks
```

If `android/key.properties` is missing, the project falls back to debug signing for local release testing only.

### 3. Build AAB for Play Store

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Identity and Branding

- Android `applicationId`: `ai.catos.catos`
- Android app name: `CAT.AI`
- PWA name/short name: `CAT.AI`

Before release, replace default launcher/PWA icons in:

- `android/app/src/main/res/mipmap-*`
- `web/icons/*`
- `web/favicon.png`

You can regenerate all app icons from one SVG base:

```bash
cd design/icons/generate-icons
npm install
npm run generate
```

## Stack

- Flutter + Provider (state management)
- SharedPreferences (Behavior Memory persistence)
- GestureDetector + CustomPainter (interactions + face rendering)

## Feature Mapping

- Apple-minimal single-screen UI with squircle face surface
- 6 emotion states with 300ms eased transitions
- Idle blink every 5-10 seconds + gaze tracking from pointer/touch
- Persistent Memory Model:
  - Friendship (tap-driven)
  - Energy (hourly decay, forced sleepy under 20)
  - Stimulation (interaction up, time decay down, sad when idle at 0)
- Tap/Swipe/Long-press interactions with haptics and 0.8s micro-icon feedback
- Time-diff decay applied at launch/resume using last-exit timestamp
