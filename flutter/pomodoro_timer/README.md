# Pomodoro Timer - Flutter

A beautiful, production-ready Pomodoro Timer application built with Flutter, featuring Clean Architecture, BLoC pattern, and comprehensive state management.

---

## 📱 Features

### Timer Functionality
- **Customizable Work Sessions** - Default: 25 minutes, configurable 1-120 minutes
- **Short Breaks** - Default: 5 minutes
- **Long Breaks** - Default: 15 minutes
- **Configurable Sessions** - Set sessions before long break

### Statistics & Analytics
- Track completed sessions
- View daily, weekly, and monthly statistics
- Visual charts with `fl_chart`
- Session history with filtering

### User Experience
- Material Design 3 UI
- 5 beautiful themes (Classic Red, Ocean Blue, Forest Green, Midnight Dark, Sunset Orange)
- Light and dark mode support
- Haptic feedback
- Local notifications
- Custom app icon and splash screen

### Additional Features
- Onboarding screen explaining Pomodoro Technique
- Privacy policy screen
- Persistent settings
- Background timer support

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **BLoC** (Business Logic Component) pattern for state management.

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── app/                      # App-level configuration
│   ├── app.dart             # Main app widget
│   ├── app_router.dart      # Navigation configuration (go_router)
│   ├── navigation/          # Navigation screens
│   └── theme/               # Theme definitions
├── core/                     # Core utilities and models
│   ├── di/                  # Dependency injection (get_it)
│   ├── models/              # Data models
│   └── services/            # Core services
└── features/                 # Feature modules
    ├── timer/               # Timer feature
    │   ├── bloc/           # Timer BLoC
    │   └── view/           # Timer UI & widgets
    ├── settings/            # Settings feature
    │   ├── bloc/           # Settings Cubit
    │   └── view/           # Settings UI
    ├── statistics/          # Statistics feature
    │   ├── bloc/           # Statistics Cubit
    │   ├── data/           # Statistics repository
    │   └── view/           # Statistics UI
    ├── onboarding/         # Onboarding screens
    └── privacy/            # Privacy policy
```

---

## 🛠️ Tech Stack

| Component | Technology | Version |
|-----------|------------|---------|
| **Framework** | Flutter | 3.8.0+ |
| **Language** | Dart | 3.8.0+ |
| **State Management** | flutter_bloc | ^9.1.1 |
| **Navigation** | go_router | ^17.0.0 |
| **Local Storage** | shared_preferences | ^2.2.2 |
| **Database** | hive + hive_flutter | ^2.2.3 |
| **Notifications** | flutter_local_notifications | ^19.5.0 |
| **Charts** | fl_chart | ^0.69.0 |
| **Haptics** | vibration | ^3.1.5 |
| **DI** | get_it | ^9.2.0 |
| **Internationalization** | intl | ^0.20.2 |

### Dev Dependencies

| Component | Technology | Version |
|-----------|------------|---------|
| **Testing** | flutter_test, bloc_test, mocktail | - |
| **Code Generation** | build_runner, hive_generator | - |
| **App Icons** | flutter_launcher_icons | ^0.14.4 |
| **Splash Screen** | flutter_native_splash | ^2.3.10 |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.8.0 or higher
- iOS: Xcode 14.0+, CocoaPods
- Android: Android Studio, Android SDK 33+
- macOS: Xcode 14.0+, CocoaPods
- Windows: Visual Studio 2022 with C++ workload

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/avtansh-code/pomodoro_timer.git
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

4. **Platform-specific setup**
   ```bash
   # iOS
   cd ios && pod install && cd ..
   
   # macOS
   cd macos && pod install && cd ..
   ```

### Running the App

```bash
# Development mode
flutter run

# Release mode
flutter run --release

# On specific device
flutter run -d <device_id>

# List available devices
flutter devices
```

### Using the Build Script

From the project root directory:

```bash
# Interactive mode
../../build.sh

# Command line mode
../../build.sh -m release -p android    # Android
../../build.sh -m release -p ios        # iOS
../../build.sh -m release -p macos      # macOS
../../build.sh -m release -p windows    # Windows
```

---

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

**Output:**
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
# Build for device
flutter build ios --release

# Build IPA (for App Store)
flutter build ipa --release
```

**Output:** `build/ios/ipa/pomodoro_timer.ipa`

### macOS

```bash
flutter build macos --release
```

**Output:** `build/macos/Build/Products/Release/`

### Windows

```bash
flutter build windows --release
```

**Output:** `build/windows/x64/runner/Release/`

---

## 🧪 Testing

This project has **comprehensive test coverage** with **200+ tests** covering all major components.

### Test Coverage

| Category | Tests |
|----------|-------|
| Core Models | 21+ |
| Core Services | 21+ |
| Data Layer | 17+ |
| BLoC/Cubit | 57+ |
| Widget Tests | 13+ |
| **Total** | **200+** |

### Test Structure

```
test/
├── core/
│   ├── models/
│   │   ├── app_theme_model_test.dart
│   │   ├── timer_session_test.dart
│   │   └── timer_settings_test.dart
│   └── services/
│       ├── persistence_service_test.dart
│       ├── notification_service_test.dart
│       └── audio_service_test.dart
├── features/
│   ├── settings/bloc/
│   │   └── settings_cubit_test.dart
│   ├── statistics/
│   │   ├── bloc/
│   │   │   └── statistics_cubit_test.dart
│   │   └── data/
│   │       └── statistics_repository_test.dart
│   └── timer/bloc/
│       ├── timer_bloc_test.dart
│       ├── timer_event_test.dart
│       └── timer_state_test.dart
├── app/
│   └── theme/
│       └── app_theme_test.dart
└── widget_test.dart
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/timer/bloc/timer_bloc_test.dart

# Run tests in a specific directory
flutter test test/features/timer/

# Run a single test by name
flutter test --plain-name "TimerBloc initial state"

# Run tests with verbose output
flutter test --reporter expanded

# Generate coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### CI/CD Integration

Tests are automatically run via GitHub Actions on:
- Pull requests to `main`/`master`
- Pushes to `main`/`master`

The pipeline includes:
- Code formatting verification (`dart format`)
- Static analysis (`flutter analyze`)
- Full test suite with coverage reporting

---

## 🎨 Customization

### App Icon

Update `flutter_launcher_icons.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
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
  color_dark: "#1A1A1A"
  image_dark: assets/splash/splash_logo_dark.png
```

Then run:
```bash
dart run flutter_native_splash:create
```

### Themes

Modify themes in `lib/app/theme/`. The app includes 5 built-in themes:
- Classic Red
- Ocean Blue
- Forest Green
- Midnight Dark
- Sunset Orange

---

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
version: 2.0.0+7  # version+build_number
```

The Flutter build system automatically updates platform-specific version files.

---

## 🔧 Configuration Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dependencies and app metadata |
| `flutter_launcher_icons.yaml` | App icon configuration |
| `flutter_native_splash.yaml` | Splash screen configuration |
| `analysis_options.yaml` | Linter rules |
| `devtools_options.yaml` | DevTools configuration |

---

## 🏛️ Architecture Patterns

### BLoC Pattern

Each feature uses BLoC for state management:

```dart
// Event
abstract class TimerEvent extends Equatable {}

class StartTimer extends TimerEvent {}
class PauseTimer extends TimerEvent {}
class ResetTimer extends TimerEvent {}

// State
abstract class TimerState extends Equatable {}

class TimerInitial extends TimerState {}
class TimerRunning extends TimerState {}
class TimerPaused extends TimerState {}

// BLoC
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerInitial()) {
    on<StartTimer>(_onStartTimer);
    on<PauseTimer>(_onPauseTimer);
    on<ResetTimer>(_onResetTimer);
  }
}
```

### Dependency Injection

Using `get_it` for service location:

```dart
final sl = GetIt.instance;

void setupServiceLocator() {
  // Services
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<PersistenceService>(() => PersistenceService());
  
  // BLoCs
  sl.registerFactory<TimerBloc>(() => TimerBloc());
  sl.registerFactory<SettingsCubit>(() => SettingsCubit());
}
```

### Clean Architecture Layers

1. **Presentation Layer** (`lib/features/*/view/`)
   - UI widgets and screens
   - BLoC consumers

2. **Domain Layer** (`lib/features/*/bloc/`)
   - Business logic (BLoCs/Cubits)
   - Use cases

3. **Data Layer** (`lib/core/`, `lib/features/*/data/`)
   - Models
   - Repositories
   - Services

---

## 📄 Related Documentation

- **[Main README](../../README.md)** - Project overview
- **[Deployment Guide](../../DEPLOYMENT.md)** - Complete deployment instructions
- **[Website README](../../website/README.md)** - Marketing website

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in
- **Website**: [pomodorotimer.in](https://pomodorotimer.in)

---

## 📄 License

This project is proprietary software. See [LICENSE](../../LICENSE) for details.

---

<div align="center">

**Built with ❤️ using Flutter**

</div>