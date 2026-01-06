# Flutter Implementation

This directory contains the Flutter cross-platform implementation of the Pomodoro Timer application.

## 📱 About

The Flutter version is a complete rewrite of the native iOS and Android apps, providing a unified codebase while maintaining native performance and look-and-feel on both platforms.

## 🎯 Key Features

- **Cross-platform**: Single codebase for iOS and Android
- **Native Performance**: Compiled to native ARM code
- **Modern Architecture**: Clean Architecture with BLoC pattern
- **Production Ready**: Comprehensive testing and state management
- **Identical Bundle IDs**: Configured to update existing native apps in stores

## 📂 Project Structure

```
flutter/
├── pomodoro_timer/          # Main Flutter application
│   ├── lib/                 # Dart source code
│   ├── android/             # Android-specific files
│   ├── ios/                 # iOS-specific files
│   ├── test/                # Unit and widget tests
│   └── assets/              # Images, sounds, and other assets
├── FLUTTER_PLAN.md          # Original development plan
└── README.md                # This file
```

## 🚀 Quick Start

Navigate to the app directory and follow the README:

```bash
cd pomodoro_timer
flutter pub get
flutter run
```

For detailed setup instructions, build guides, and architecture documentation, see [pomodoro_timer/README.md](./pomodoro_timer/README.md).

## 📊 App Details

- **Bundle ID (iOS)**: `com.avtanshgupta.mr.pomodoro`
- **Package Name (Android)**: `com.avtanshgupta.mr.pomodoro`
- **Current Version**: 1.2.0+5
- **Minimum iOS**: 13.0
- **Minimum Android**: API 21 (Android 5.0)

## 🏗️ Architecture Highlights

- **State Management**: BLoC (Business Logic Component)
- **Architecture**: Clean Architecture with feature-based modules
- **Navigation**: go_router for declarative routing
- **Storage**: Hive for local database, SharedPreferences for settings
- **Notifications**: flutter_local_notifications
- **DI**: get_it for dependency injection

## 📱 Platform Compatibility

| Platform | Status | Notes |
|----------|--------|-------|
| iOS | ✅ Fully Supported | iOS 13.0+ |
| Android | ✅ Fully Supported | API 21+ (Android 5.0+) |
| Web | ⚠️ Experimental | Core features work |
| macOS | ⚠️ Experimental | Desktop support available |
| Windows | ⚠️ Experimental | Desktop support available |
| Linux | ⚠️ Experimental | Desktop support available |

## 🔄 Relationship to Native Apps

This Flutter implementation is designed to **replace** the existing native iOS and Android applications:

- Uses identical bundle IDs to update existing apps
- Maintains feature parity with native versions
- Provides consistent UX across platforms
- Simplifies maintenance with single codebase

## 📈 Migration Benefits

- **Single Codebase**: Reduces development effort by ~60%
- **Faster Iterations**: Hot reload enables rapid development
- **Consistent UX**: Same behavior on iOS and Android
- **Easier Testing**: Unified test suite for both platforms
- **Lower Maintenance**: One codebase to maintain and debug

## 🛠️ Development

### Prerequisites
- Flutter SDK 3.10.0+
- Dart SDK 3.10.0+
- Xcode 14.0+ (for iOS)
- Android Studio (for Android)

### Common Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run tests
flutter test

# Build release APK
flutter build apk --release

# Build iOS release
flutter build ios --release

# Generate code
dart run build_runner build --delete-conflicting-outputs
```

## 📚 Documentation

- [Main App README](./pomodoro_timer/README.md) - Detailed setup and usage
- [Development Plan](./FLUTTER_PLAN.md) - Original implementation roadmap
- [Flutter Docs](https://docs.flutter.dev/) - Official Flutter documentation

## 🎨 Customization

The app is designed to be easily customizable:

- **Themes**: Modify `lib/app/theme/`
- **App Icon**: Update `flutter_launcher_icons.yaml`
- **Splash**: Update `flutter_native_splash.yaml`
- **Bundle ID**: Change in platform-specific files

## ✅ Production Readiness

- [x] Clean Architecture implementation
- [x] Comprehensive state management
- [x] Unit tests for business logic
- [x] Widget tests for UI components
- [x] Platform-specific optimizations
- [x] App icons and splash screens
- [x] Local notifications configured
- [x] Data persistence implemented
- [x] iOS and Android builds tested

## 📞 Support

For issues specific to the Flutter implementation, please create a GitHub issue with the `flutter` label.

---

**Part of the Pomodoro Timer project** • [View Parent README](../README.md)
