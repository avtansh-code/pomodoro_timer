# Pomodoro Timer - Flutter

A beautiful, production-ready Pomodoro Timer application built with Flutter, featuring Clean Architecture, BLoC pattern, and comprehensive state management.

## 📱 Features

- **Full Pomodoro Timer Functionality**
  - Customizable work sessions (default: 25 minutes)
  - Short breaks (default: 5 minutes)
  - Long breaks (default: 15 minutes)
  - Configurable sessions before long break

- **Statistics & Analytics**
  - Track completed sessions
  - View daily, weekly, and monthly statistics
  - Visual charts and progress tracking
  - Session history with filtering

- **User Experience**
  - Material Design 3 UI
  - Light and dark theme support
  - Haptic feedback
  - Local notifications
  - Custom app icon and splash screen

- **Additional Features**
  - Onboarding screen explaining Pomodoro Technique
  - Privacy policy screen
  - Persistent settings
  - Background timer support

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** (Business Logic Component) pattern for state management.

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── app/                      # App-level configuration
│   ├── app.dart             # Main app widget
│   ├── app_router.dart      # Navigation configuration
│   └── theme/               # Theme definitions
├── core/                     # Core utilities and models
│   ├── di/                  # Dependency injection
│   ├── models/              # Data models
│   └── services/            # Core services
└── features/                 # Feature modules
    ├── timer/               # Timer feature
    │   ├── bloc/           # Timer BLoC
    │   └── view/           # Timer UI
    ├── settings/            # Settings feature
    ├── statistics/          # Statistics feature
    ├── onboarding/         # Onboarding screens
    └── privacy/            # Privacy policy
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart 3.10+
- **State Management**: `flutter_bloc` ^8.1.3
- **Routing**: `go_router` ^13.0.0
- **Local Storage**: 
  - `shared_preferences` ^2.2.2 (settings)
  - `hive` ^2.2.3 (statistics)
- **Notifications**: `flutter_local_notifications` ^16.3.0
- **Audio**: `audioplayers` ^5.2.1
- **Haptics**: `vibration` ^2.0.0
- **DI**: `get_it` ^7.6.7

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK (3.10.0 or higher)
- iOS: Xcode 14.0+, CocoaPods
- Android: Android Studio, Android SDK 33+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pomodoro_timer.git
   cd pomodoro_timer/flutter/pomodoro_timer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Hive adapters)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **iOS specific setup**
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Running the App

```bash
# Development mode
flutter run

# Release mode
flutter run --release

# On specific device
flutter run -d <device_id>
```

## 📦 Building

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build for device
flutter build ios --release

# Build IPA (for App Store)
flutter build ipa --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/models/timer_settings_test.dart

# Run with coverage
flutter test --coverage
```

## 🎨 Customization

### App Icon

Update `flutter_launcher_icons.yaml` with your icon:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
```

Then run:
```bash
dart run flutter_launcher_icons
```

### Splash Screen

Update `flutter_native_splash.yaml`:

```yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash_logo.png
```

Then run:
```bash
dart run flutter_native_splash:create
```

### Theme

Modify themes in `lib/app/theme/themes.dart`:

```dart
static final lightTheme = ThemeData(
  // Your light theme customization
);

static final darkTheme = ThemeData(
  // Your dark theme customization
);
```

## 📱 App Configuration

### Bundle Identifier

- **iOS**: `com.avtanshgupta.mr.pomodoro`
- **Android**: `com.avtanshgupta.mr.pomodoro`

Update in:
- iOS: `ios/Runner.xcodeproj/project.pbxproj`
- Android: `android/app/build.gradle.kts`

### Version

Update in `pubspec.yaml`:
```yaml
version: 1.2.0+5  # version+build_number
```

## 🔧 Configuration Files

- `pubspec.yaml` - Dependencies and app metadata
- `flutter_launcher_icons.yaml` - App icon configuration
- `flutter_native_splash.yaml` - Splash screen configuration
- `analysis_options.yaml` - Linter rules

## 🏛️ Architecture Patterns

### BLoC Pattern

Each feature uses BLoC for state management:

```dart
// Event
abstract class TimerEvent extends Equatable {}

// State
abstract class TimerState extends Equatable {}

// BLoC
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  // Business logic here
}
```

### Dependency Injection

Using `get_it` for service location:

```dart
final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<TimerBloc>(() => TimerBloc());
  // Register other dependencies
}
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues and feature requests, please use the GitHub issues page.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- BLoC library maintainers
- All open-source contributors

---

**Built with ❤️ using Flutter**
