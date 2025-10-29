# Mr. Pomodoro - Android

Native Android implementation of the Mr. Pomodoro timer app built with Jetpack Compose and modern Android development practices.

[![Android](https://img.shields.io/badge/Android-14.0+-green.svg)](https://www.android.com/)
[![Kotlin](https://img.shields.io/badge/Kotlin-1.9+-purple.svg)](https://kotlinlang.org/)
[![Compose](https://img.shields.io/badge/Compose-2024.02-blue.svg)](https://developer.android.com/jetpack/compose)

---

## Features

- **Full Pomodoro Timer** - Complete timer functionality with circular progress indicator
- **Session Management** - Focus, short break, and long break sessions
- **Statistics Tracking** - View productivity metrics by day, week, month, or all time
- **5 Themes** - Classic Red, Ocean Blue, Forest Green, Midnight Dark, Sunset Orange
- **Background Service** - Timer continues running when app is backgrounded
- **Notifications** - Progress updates and completion alerts
- **App Shortcuts** - Quick actions from launcher (Start Focus, Short Break, View Stats)
- **Privacy First** - All data stored locally with Room database

---

## Screenshots

<table>
  <tr>
    <td><img src="../screenshots/android/focus_mode.png" alt="Focus Mode" width="200"/></td>
    <td><img src="../screenshots/android/short_break_mode.png" alt="Break Mode" width="200"/></td>
    <td><img src="../screenshots/android/stats_1.png" alt="Statistics" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><em>Focus Mode</em></td>
    <td align="center"><em>Break Time</em></td>
    <td align="center"><em>Your Progress</em></td>
  </tr>
</table>

---

## Prerequisites

- **Android Studio**: Hedgehog (2023.1.1) or newer
- **JDK**: 17 or higher
- **Android SDK**: API 34 (Android 14)
- **Minimum Android Version**: API 34 (Android 14.0)

---

## Quick Start

### Clone and Build

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer/android

# Build the project
./gradlew build

# Run unit tests
./gradlew test

# Install on connected device/emulator
./gradlew installDebug
```

### Running in Android Studio

1. Open the `/android` directory in Android Studio
2. Wait for Gradle sync to complete
3. Select a device or emulator
4. Click Run (▶️) or press `Shift + F10`

---

## Architecture

The app follows **Clean Architecture** principles with **MVVM** pattern:

```
├── domain/              # Business logic and models
│   ├── model/           # Data models
│   ├── repository/      # Repository interfaces
│   └── usecase/         # Business use cases
│
├── data/                # Data layer
│   ├── local/           # Room database & DataStore
│   └── repository/      # Repository implementations
│
├── presentation/        # Presentation layer
│   └── viewmodel/       # ViewModels with StateFlow
│
├── ui/                  # UI layer
│   ├── screens/         # Compose screens
│   ├── components/      # Reusable UI components
│   ├── navigation/      # Navigation setup
│   └── theme/           # Material3 theming
│
├── service/             # Background services
│   ├── TimerService.kt
│   └── NotificationHelper.kt
│
└── di/                  # Dependency injection (Hilt)
```

### Key Technologies

- **UI**: Jetpack Compose with Material3
- **Architecture**: MVVM + Clean Architecture
- **Database**: Room (SQLite)
- **Preferences**: DataStore (Preferences)
- **Async**: Kotlin Coroutines + Flow
- **DI**: Hilt
- **Testing**: JUnit, MockK, Turbine

---

## Testing

### Run Tests

```bash
# All unit tests
./gradlew test

# Specific test suite
./gradlew testDebugUnitTest

# With coverage report
./gradlew testDebugUnitTestCoverage
```

### Test Coverage

- **Domain Layer**: 80%+
- **Service Layer**: 85%+
- **Overall**: ~60%

---

## Building for Release

```bash
# Build release APK
./gradlew assembleRelease

# Build release bundle (for Play Store)
./gradlew bundleRelease
```

---

## App Shortcuts

The app includes 3 static shortcuts accessible via long-press on the app icon:

1. **Start Focus** - Begin a 25-minute focus session
2. **Start Short Break** - Begin a 5-minute break
3. **View Statistics** - Open statistics screen

Shortcuts use deep linking with custom URI scheme (`pomodoro://`).

---

## Project Structure

```
android/
├── app/
│   ├── src/main/
│   │   ├── java/com/pomodoro/timer/  # Source code
│   │   ├── res/                       # Resources
│   │   └── AndroidManifest.xml
│   ├── build.gradle.kts
│   └── proguard-rules.pro
├── gradle/
│   └── libs.versions.toml             # Dependency versions
├── build.gradle.kts
├── settings.gradle.kts
└── README.md
```

---

## Configuration

### Gradle Configuration

Key configurations in `build.gradle.kts`:

```kotlin
android {
    compileSdk = 34
    defaultConfig {
        minSdk = 34
        targetSdk = 34
        versionCode = 1
        versionName = "1.1.0"
    }
}
```

### Dependencies

Major dependencies (see `gradle/libs.versions.toml`):

- Compose BOM 2024.02.00
- Room 2.6.1
- Hilt 2.48
- Kotlin 1.9.20
- Coroutines 1.7.3

---

## Development Guidelines

### Code Style

- Follow [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html)
- Use Compose best practices
- Maintain Clean Architecture separation
- Write unit tests for business logic

### Commit Guidelines

- Write clear commit messages
- Keep commits focused and atomic
- Reference issues when applicable

---

## iOS Feature Parity

This Android app maintains feature parity with the iOS version:

| Feature | iOS | Android | Status |
|---------|-----|---------|--------|
| Timer Functionality | ✅ | ✅ | Complete |
| Statistics | ✅ | ✅ | Complete |
| Themes | ✅ | ✅ | Complete |
| Persistence | ✅ | ✅ | Complete |
| Background Operation | ✅ | ✅ | Complete |
| Notifications | ✅ | ✅ | Complete |
| App Shortcuts | ✅ (Siri) | ✅ (Launcher) | Complete |

---

## Troubleshooting

### Build Issues

**Problem**: Gradle sync fails
```bash
# Solution: Clean and rebuild
./gradlew clean
./gradlew build --refresh-dependencies
```

**Problem**: Out of memory during build
```bash
# Solution: Increase Gradle memory in gradle.properties
org.gradle.jvmargs=-Xmx4096m
```

### Runtime Issues

**Problem**: Timer doesn't run in background
- **Solution**: Ensure notification permission is granted and battery optimization is disabled for the app

**Problem**: Database migration error
- **Solution**: Uninstall and reinstall the app (development only)

---

## Related Documentation

- **[Main README](../README.md)** - Project overview
- **[Architecture](../docs/ARCHITECTURE.md)** - Technical architecture details
- **[iOS Setup](../iOS/README.md)** - iOS development guide
- **[Contributing](../CONTRIBUTING.md)** - Contribution guidelines
- **[Privacy Policy](../PrivacyPolicy.md)** - Privacy information

---

## License

See [LICENSE](../LICENSE) for details.

---

## Support

- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in

---

**Version**: 1.1.0  
**Min SDK**: 34 (Android 14.0)  
**Target SDK**: 34  
**Built with**: Kotlin 1.9.20 + Jetpack Compose
