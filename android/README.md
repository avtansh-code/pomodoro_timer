# Mr. Pomodoro - Android

Native Android implementation of the Mr. Pomodoro timer app built with Jetpack Compose and modern Android development practices.

[![Android](https://img.shields.io/badge/Android-13.0+-green.svg)](https://www.android.com/)
[![Kotlin](https://img.shields.io/badge/Kotlin-2.0+-purple.svg)](https://kotlinlang.org/)
[![Compose](https://img.shields.io/badge/Compose-2024.12-blue.svg)](https://developer.android.com/jetpack/compose)

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
- **Android SDK**: API 35 (Android 15)
- **Minimum Android Version**: API 33 (Android 13.0)

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

### Native Debug Symbols

The app is configured to generate native debug symbols automatically when building release bundles. This helps with crash analysis in Google Play Console:

- **Debug symbols** are included in the AAB by default
- **Symbol level**: FULL (complete stack traces)
- **Location**: Build output includes native `.so` files with debug info
- **Upload**: Symbols are automatically uploaded with the AAB to Play Console

If you need to manually upload symbols:
```bash
# Symbols are located in:
# app/build/intermediates/merged_native_libs/release/out/lib/
```

**Note**: After enabling debug symbols, the first build may take slightly longer and produce a larger AAB file (~2-5MB increase).

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
    compileSdk = 35
    defaultConfig {
        minSdk = 33
        targetSdk = 35
        versionCode = 4
        versionName = "1.1.1"
    }
}
```

### Dependencies

Major dependencies (see `gradle/libs.versions.toml`):

- Compose BOM 2024.12.01
- Room 2.6.1
- Hilt 2.54
- Kotlin 2.0.21
- Coroutines 1.9.0

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

**Version**: 1.1.1  
**Min SDK**: 33 (Android 13.0)  
**Target SDK**: 35  
**Built with**: Kotlin 2.0.21 + Jetpack Compose
