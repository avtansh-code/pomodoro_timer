# Pomodoro Timer - Android

Android implementation of the Pomodoro Timer app, ported from the iOS version with feature parity and cross-platform data compatibility.

## 🚀 Quick Start

### Prerequisites
- **Android Studio**: Hedgehog (2023.1.1) or newer
- **JDK**: 17 or higher
- **Android SDK**: API 34 (Android 14)
- **Minimum Android Version**: API 26 (Android 8.0 Oreo)

### Build and Run

```bash
# Clone the repository (if not already cloned)
cd android

# Build the project
./gradlew build

# Run unit tests
./gradlew test

# Build debug APK
./gradlew assembleDebug

# Install on connected device/emulator
./gradlew installDebug

# Run the app (alternative to IDE)
adb shell am start -n com.pomodoro.timer/.MainActivity
```

### Running in Android Studio
1. Open the `/android` directory in Android Studio
2. Wait for Gradle sync to complete
3. Select a device/emulator
4. Click Run (▶️) or press `Shift + F10`

## 📋 Current Implementation Status

### ✅ Complete (Milestones 1-5) - 65% Done!

#### Domain Layer (100%)
- **Models**: `SessionType`, `TimerState`, `TimerSession`, `TimerSettings`, `AppTheme`
- **Repository Interfaces**: `SessionRepository`, `SettingsRepository`
- **Use Cases**: `GetStatisticsUseCase`, `SaveSessionUseCase`, `GetStreakUseCase`
- **Architecture**: Clean Architecture with zero framework dependencies

#### Data Layer (100%)
- **Room Database**: Sessions stored in SQLite with full CRUD operations
- **DataStore**: Settings persisted with type-safe Preferences
- **Repository Implementations**: Full implementation of domain contracts
- **Dependency Injection**: Hilt modules configured

#### Service Layer (100%) ✅
- **TimerManager**: Coroutine-based countdown timer with StateFlow
- **TimerService**: Foreground service for background operation
- **NotificationHelper**: Notification management with actions
- **Background Operation**: Timer continues when app is backgrounded
- **Auto-Save**: Sessions automatically saved on completion
- **Testing**: 16 unit tests for TimerManager (85% coverage)

#### Presentation Layer (100%)
- **TimerViewModel**: Main timer screen controller with service integration
- **SettingsViewModel**: Settings management with validation
- **StatisticsViewModel**: Statistics display with period selection
- **MVVM Architecture**: Complete ViewModel layer with reactive state
- **StateFlow**: Reactive state management for UI binding

#### Theme System (100%) ✅
- **Color.kt**: Complete color palette with 5 iOS themes
- **Type.kt**: Material3 typography system
- **Theme.kt**: PomodoroTheme composable with light/dark modes
- **iOS Parity**: Exact hex color matching
- **Material3**: Modern design system integration

#### Infrastructure (100%)
- **Application Setup**: Hilt-enabled application class
- **MainActivity**: Compose-based activity with placeholder UI
- **AndroidManifest**: Configured with permissions, service, and components
- **Gradle**: Modern build configuration with version catalog
- **DI Modules**: DataModule and ServiceModule configured

### 🚧 Remaining Work (Milestones 6-10)

#### Milestone 6: UI Screens (12-16 hours) - NEXT
- [ ] Timer screen with circular progress
- [ ] Settings screen with pickers
- [ ] Statistics screen with Vico charts
- [ ] Navigation setup

#### Milestone 7: Additional Features (4-6 hours)
- [ ] Privacy policy screen
- [ ] Benefits screen
- [ ] App shortcuts
- [ ] Share functionality

#### Milestone 8-10: Polish & Testing (14-20 hours)
- [ ] Unit tests (60%+ coverage)
- [ ] UI tests
- [ ] CI/CD workflow
- [ ] Final documentation

## 🏗️ Architecture

### Clean Architecture + MVVM

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  (Compose UI, ViewModels, Navigation, Themes)           │
└────────────┬────────────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────────────┐
│                     Domain Layer                         │
│  (Models, Repository Interfaces, Use Cases)             │
│  ✅ COMPLETE - Pure Kotlin, Framework Independent       │
└────────────┬────────────────────────────────────────────┘
             │
┌────────────┴────────────────────────────────────────────┐
│                      Data Layer                          │
│  (Room, DataStore, Repository Implementations)          │
│  ✅ COMPLETE - Persistence fully implemented            │
└─────────────────────────────────────────────────────────┘
```

### Package Structure

```
com.pomodoro.timer/
├── domain/                          ✅ Complete
│   ├── model/
│   │   ├── SessionType.kt
│   │   ├── TimerState.kt
│   │   ├── TimerSession.kt
│   │   ├── TimerSettings.kt
│   │   └── AppTheme.kt
│   ├── repository/
│   │   ├── SessionRepository.kt
│   │   └── SettingsRepository.kt
│   └── usecase/
│       ├── GetStatisticsUseCase.kt
│       ├── SaveSessionUseCase.kt
│       └── GetStreakUseCase.kt
│
├── data/                            ✅ Complete
│   ├── local/
│   │   ├── database/
│   │   │   ├── PomodoroDatabase.kt
│   │   │   ├── SessionDao.kt
│   │   │   └── entity/SessionEntity.kt
│   │   └── datastore/
│   │       └── SettingsDataStore.kt
│   └── repository/
│       ├── SessionRepositoryImpl.kt
│       └── SettingsRepositoryImpl.kt
│
├── di/                              ✅ Complete
│   ├── DataModule.kt
│   └── ServiceModule.kt
│
├── util/                            ✅ Complete
│   └── TimerManager.kt
│
├── service/                         ✅ Complete
│   ├── TimerService.kt
│   └── NotificationHelper.kt
│
├── presentation/                    ✅ Complete
│   └── viewmodel/
│       ├── TimerViewModel.kt
│       ├── SettingsViewModel.kt
│       └── StatisticsViewModel.kt
│
├── ui/                              ⏳ In Progress
│   ├── theme/                       ✅ Complete
│   │   ├── Color.kt
│   │   ├── Type.kt
│   │   └── Theme.kt
│   ├── screens/                     🚧 TODO
│   ├── navigation/                  🚧 TODO
│   └── components/                  🚧 TODO
│
├── PomodoroApplication.kt           ✅ Complete
└── MainActivity.kt                  ✅ Complete (placeholder)
```

## 🔑 Key Technologies

- **Language**: Kotlin 1.9.20
- **UI**: Jetpack Compose (BOM 2024.02.00)
- **Architecture**: MVVM + Clean Architecture
- **Async**: Kotlin Coroutines + Flow
- **DI**: Hilt 2.48
- **Database**: Room 2.6.1
- **Settings**: DataStore Preferences 1.0.0
- **Charts**: Vico 2.0.0-alpha.22
- **Testing**: JUnit 4, Turbine, MockK

## 📊 iOS Feature Mapping

| iOS Feature | Android Status | Notes |
|-------------|----------------|-------|
| Timer Sessions | ✅ Data Model | `TimerSession.kt` |
| Settings | ✅ Data Model | `TimerSettings.kt` |
| Theme System | ✅ Data Model | `AppTheme.kt` with 5 themes |
| Statistics | ✅ Use Case | `GetStatisticsUseCase.kt` |
| Persistence | ✅ Complete | Room + DataStore |
| Timer Logic | ✅ Complete | `TimerManager.kt` |
| Notifications | ✅ Complete | `NotificationHelper.kt` |
| Background Service | ✅ Complete | `TimerService.kt` |
| ViewModels | ✅ Complete | `presentation/viewmodel/*` |
| Theme System | ✅ Complete | `ui/theme/*` |
| UI Screens | 🚧 Milestones 5-6 | Compose UI |
| App Shortcuts | 🚧 Milestone 7 | Static + Dynamic |

See **[IOS_TO_ANDROID_MAPPING.md](IOS_TO_ANDROID_MAPPING.md)** for complete mapping.

## 🧪 Testing

### Run Tests

```bash
# All tests
./gradlew test

# Unit tests only
./gradlew testDebugUnitTest

# Generate coverage report
./gradlew testDebugUnitTestCoverage

# Instrumented tests (requires device/emulator)
./gradlew connectedAndroidTest
```

### Test Coverage Goals
- **Domain Layer**: 85%+ (pure logic, highly testable)
- **Data Layer**: 70%+ (DAO and repository tests)
- **ViewModels**: 70%+ (state transitions)
- **Overall**: 60%+ minimum

### Current Test Status
✅ **24 Unit Tests Passing**

Implemented tests:
```kotlin
// Domain layer tests (8 tests)
TimerSettingsTest - Settings validation and operations

// Service layer tests (16 tests)  
TimerManagerTest - Complete timer functionality
- Start/pause/resume/reset/skip
- Countdown accuracy
- Progress calculation
- Time formatting
- State transitions
```

More tests coming in Milestone 9:
- Data layer tests (DAO, repositories)
- ViewModel tests (TimerViewModel, SettingsViewModel, StatisticsViewModel)
- UI tests (Compose testing)

## 🔧 Development

### Adding a New Feature

1. **Domain First**: Define models, repository interface, use case
2. **Data Layer**: Implement repository, add database/datastore support
3. **Presentation**: Create ViewModel with UI state
4. **UI**: Build Compose screen
5. **Test**: Add unit and UI tests

### Code Style
- Follow [Kotlin Coding Conventions](https://kotlinlang.org/docs/coding-conventions.html)
- Use ktlint for formatting: `./gradlew ktlintFormat`
- All public APIs must have KDoc comments

### Debugging

```bash
# View logs
adb logcat | grep "PomodoroTimer"

# Clear app data
adb shell pm clear com.pomodoro.timer

# Inspect database
adb shell
run-as com.pomodoro.timer
cd databases
sqlite3 pomodoro_database
```

## 📱 Building for Release

```bash
# Build release APK (unsigned)
./gradlew assembleRelease

# Generate signed APK (requires keystore)
./gradlew bundleRelease

# Build and test release variant
./gradlew build -PreleaseBuild
```

### ProGuard
ProGuard rules are configured in `app/proguard-rules.pro`. Key libraries have keep rules:
- Room entities and DAOs
- Hilt generated code
- Kotlinx Serialization
- Compose navigation

## 🚀 CI/CD

**TODO** (Milestone 10): GitHub Actions workflow will:
1. Build debug and release variants
2. Run unit tests
3. Run instrumented tests
4. Generate APK artifacts
5. Upload test reports

Workflow file: `.github/workflows/android-ci.yml`

## 📚 Documentation

- **[ARCHITECTURE_PLAN.md](ARCHITECTURE_PLAN.md)**: Detailed architecture decisions
- **[IMPLEMENTATION_MILESTONES.md](IMPLEMENTATION_MILESTONES.md)**: Phased delivery plan
- **[IOS_TO_ANDROID_MAPPING.md](IOS_TO_ANDROID_MAPPING.md)**: iOS to Android mapping
- **[PROGRESS_REPORT.md](PROGRESS_REPORT.md)**: Current status and metrics

## 🐛 Known Issues

- [ ] Database migration strategy needs production-ready implementation (currently uses fallbackToDestructiveMigration)
- [ ] No UI screens yet (Milestone 6)
- [ ] Limited test coverage (24 tests, need ViewModel and UI tests in Milestone 9)

## 🤝 Contributing

When contributing, please:
1. Follow the existing architecture patterns
2. Write tests for new features
3. Update documentation
4. Maintain iOS feature parity where applicable

## 📄 License

Same license as the main repository.

## 🔗 Related Resources

- [iOS App Source](../iOS/)
- [Project README](../README.md)
- [Privacy Policy](../PrivacyPolicy.md)
- [Android Developer Documentation](https://developer.android.com/)
- [Jetpack Compose Documentation](https://developer.android.com/jetpack/compose)

---

**Current Version**: 0.5.0 (Theme System Complete)  
**Target Version**: 1.0.0 (Full Feature Parity with iOS)  
**Completion**: ~65% (Domain + Data + Service + Presentation + Theme layers)
