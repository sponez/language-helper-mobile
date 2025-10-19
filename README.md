# Language Helper Mobile

Flutter mobile app for Language Helper 2 - A flashcard learning application with spaced repetition system.

## Features

- User management with multiple profiles
- Flashcard creation and management
- Spaced repetition learning system
- AI-powered card generation and explanations
- Support for multiple languages
- Dark/Light theme support

## Architecture

This Flutter app uses FFI (Foreign Function Interface) to call native Rust code for all business logic:

- **Frontend**: Flutter (Dart) for UI
- **Backend**: Rust via FFI bridge (lh_mobile_bridge)
- **Database**: SQLite (managed by Rust)

## Project Structure

```
lib/
├── main.dart                 # App entry point
└── src/
    ├── screens/             # UI screens
    │   ├── splash_screen.dart
    │   └── user_selection_screen.dart
    ├── services/            # Business logic services
    │   └── native_bridge.dart   # FFI bridge to Rust
    ├── models/              # Data models
    └── widgets/             # Reusable UI components

android/app/src/main/jniLibs/   # Native libraries
├── arm64-v8a/              # ARM64 devices
├── armeabi-v7a/            # ARMv7 devices
├── x86_64/                 # x64 emulators
└── x86/                    # x86 emulators
```

## Setup

### Prerequisites

1. Flutter SDK (3.0 or higher)
2. Android Studio with Android SDK
3. Rust toolchain (for building native libraries)

### Installation

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Build native libraries (if not already built):
```bash
cd ..
cargo build --target aarch64-linux-android --release -p lh_mobile_bridge
cargo build --target armv7-linux-androideabi --release -p lh_mobile_bridge
cargo build --target x86_64-linux-android --release -p lh_mobile_bridge
cargo build --target i686-linux-android --release -p lh_mobile_bridge
```

3. Copy libraries to jniLibs (already done if you followed the setup)

### Running

```bash
# Run on connected device or emulator
flutter run

# Build APK
flutter build apk

# Build App Bundle for Play Store
flutter build appbundle
```

## Native Bridge

The `NativeBridge` service in `lib/src/services/native_bridge.dart` provides Dart wrapper methods for all Rust FFI functions:

- User management (create, get, update, delete)
- Profile management
- Card operations
- Learning sessions
- AI assistant features
- Settings management

## Development

### Adding New Features

1. Add Rust FFI function in `lh_mobile_bridge`
2. Rebuild native libraries for all Android targets
3. Add Dart wrapper method in `NativeBridge`
4. Create UI screens/widgets in Flutter

### Testing

```bash
# Run tests
flutter test

# Run on device for testing
flutter run --debug
```

## Building for Release

1. Update version in `pubspec.yaml`
2. Build release APK:
```bash
flutter build apk --release
```

3. Or build App Bundle:
```bash
flutter build appbundle --release
```

## Platform Support

- ✅ Android (ARM64, ARMv7, x86_64, x86)
- 🚧 iOS (Coming soon)

## License

MIT OR Apache-2.0
