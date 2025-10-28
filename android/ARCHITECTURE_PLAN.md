# Android Pomodoro Timer - Architecture Plan

## Overview
This document outlines the architecture and implementation strategy for porting the iOS Pomodoro Timer app to Android using modern Android development best practices.

## Architecture Choice: MVVM with Clean Architecture

### Why MVVM?
- **Industry Standard**: MVVM is the recommended architecture pattern for Android with Jetpack Compose
- **Clear Separation**: View (Compose UI) → ViewModel (Business Logic) → Repository (Data Layer)
- **Lifecycle Aware**: ViewModels survive configuration changes and work seamlessly with Compose
- **Testability**: Easy to unit test ViewModels in isolation from UI
- **State Management**: Works well with Kotlin Flow for reactive state updates

### Architecture Layers

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Compose UI + ViewModels + State)      │
├─────────────────────────────────────────┤
│          Domain Layer                   │
│  (Use Cases + Models + Repositories)    │
├─────────────────────────────────────────┤
│           Data Layer                    │
│  (Room DB + DataStore + Data Sources)   │
└─────────────────────────────────────────┘
```

## Technology Stack

### Core
- **Language**: Kotlin 1.9+
- **Min SDK**: 26 (Android 8.0) - for better notification channels and foreground service support
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 34

### UI & Presentation
- **Jetpack Compose**: Modern declarative UI (BOM 2024.02.00)
- **Material3**: Material Design 3 components
- **Navigation Compose**: Type-safe navigation
- **ViewModel**: Lifecycle-aware state management

### Data & Persistence
- **Room**: 2.6.1 - Session history storage
- **DataStore**: 1.0.0 - Settings persistence (replaces SharedPreferences)
- **Kotlin Serialization**: JSON serialization for complex objects

### Async & Reactive
- **Kotlin Coroutines**: 1.7.3 - Async operations
- **Flow**: State streams and reactive data
- **StateFlow/SharedFlow**: Observable state management

### Dependency Injection
- **Hilt**: 2.48 - Compile-time DI framework
  - Reduces boilerplate
  - Scoped dependencies
  - Easy testing

### Background Work
- **WorkManager**: 2.9.0 - Background timer continuation
- **Foreground Service**: Active timer notification

### Testing
- **JUnit 4**: Unit testing framework
- **Kotlin Coroutines Test**: Testing coroutines
- **Turbine**: Testing Flows
- **MockK**: Mocking framework
- **Compose Testing**: UI testing
- **Truth**: Fluent assertions

### Build & CI
- **Gradle**: Kotlin DSL
- **Version Catalog**: Centralized dependency management
- **GitHub Actions**: CI/CD pipeline

## Project Structure

```
app/src/main/java/com/pomodoro/timer/
├── PomodoroApplication.kt                 # Application class with Hilt
├── MainActivity.kt                        # Single activity + Compose
│
├── di/                                    # Dependency Injection
│   ├── AppModule.kt                       # App-level dependencies
│   ├── DataModule.kt                      # Data layer dependencies
│   └── NotificationModule.kt              # Notification dependencies
│
├── domain/                                # Domain Layer
│   ├── model/                             # Business models
│   │   ├── TimerSession.kt
│   │   ├── TimerSettings.kt
│   │   ├── SessionType.kt
│   │   ├── TimerState.kt
│   │   └── AppTheme.kt
│   │
│   ├── repository/                        # Repository interfaces
│   │   ├── SessionRepository.kt
│   │   └── SettingsRepository.kt
│   │
│   └── usecase/                           # Business logic use cases
│       ├── GetStatisticsUseCase.kt
│       ├── SaveSessionUseCase.kt
│       └── GetStreakUseCase.kt
│
├── data/                                  # Data Layer
│   ├── local/                             # Local data sources
│   │   ├── database/
│   │   │   ├── PomodoroDatabase.kt
│   │   │   ├── SessionDao.kt
│   │   │   └── entity/
│   │   │       └── SessionEntity.kt
│   │   │
│   │   └── datastore/
│   │       └── SettingsDataStore.kt
│   │
│   └── repository/                        # Repository implementations
│       ├── SessionRepositoryImpl.kt
│       └── SettingsRepositoryImpl.kt
│
├── presentation/                          # Presentation Layer
│   ├── navigation/                        # Navigation
│   │   ├── AppNavigation.kt
│   │   └── Screen.kt
│   │
│   ├── theme/                             # Compose theme
│   │   ├── Color.kt
│   │   ├── Theme.kt
│   │   ├── Type.kt
│   │   └── AppThemes.kt
│   │
│   ├── components/                        # Reusable UI components
│   │   ├── CircularTimerProgress.kt
│   │   ├── ActionButton.kt
│   │   ├── StatCard.kt
│   │   └── DurationPicker.kt
│   │
│   └── screens/                           # Screen-specific UI
│       ├── timer/
│       │   ├── TimerScreen.kt
│       │   ├── TimerViewModel.kt
│       │   └── TimerState.kt
│       │
│       ├── statistics/
│       │   ├── StatisticsScreen.kt
│       │   ├── StatisticsViewModel.kt
│       │   └── StatisticsState.kt
│       │
│       ├── settings/
│       │   ├── SettingsScreen.kt
│       │   ├── SettingsViewModel.kt
│       │   └── SettingsState.kt
│       │
│       ├── privacy/
│       │   └── PrivacyPolicyScreen.kt
│       │
│       └── benefits/
│           └── PomodoroBenefitsScreen.kt
│
├── service/                               # Services
│   ├── TimerService.kt                    # Foreground service for timer
│   └── NotificationHelper.kt              # Notification management
│
└── util/                                  # Utilities
    ├── TimerManager.kt                    # Core timer logic
    ├── Constants.kt                       # App constants
    ├── Extensions.kt                      # Kotlin extensions
    └── PermissionManager.kt               # Runtime permissions
```

## iOS to Android File Mapping

### Models
| iOS File | Android File | Notes |
|----------|--------------|-------|
| `TimerSession.swift` | `domain/model/TimerSession.kt` | Kotlin data class with same fields |
| `TimerSettings.swift` | `domain/model/TimerSettings.kt` | Serializable data class |
| `AppTheme.swift` | `domain/model/AppTheme.kt` + `presentation/theme/*` | Split into model and Compose theme |

### Services
| iOS File | Android File | Notes |
|----------|--------------|-------|
| `TimerManager.swift` | `util/TimerManager.kt` + `TimerViewModel.kt` | Split: domain logic + UI state management |
| `PersistenceManager.swift` | `data/repository/*` + `data/local/*` | Split into Repository pattern with Room/DataStore |
| `ThemeManager.swift` | `presentation/theme/AppThemes.kt` | Compose theme system |
| `FocusModeManager.swift` | *(Android DND integration)* | Use NotificationManager.setInterruptionFilter() |
| `ScreenshotHelper.swift` | `util/ScreenshotHelper.kt` | Screenshot sharing via ShareSheet |

### Views (SwiftUI → Compose)
| iOS File | Android File | Notes |
|----------|--------------|-------|
| `MainTimerView.swift` | `screens/timer/TimerScreen.kt` | Compose equivalent with circular progress |
| `SettingsView.swift` | `screens/settings/SettingsScreen.kt` | Compose with preference items |
| `StatisticsView.swift` | `screens/statistics/StatisticsScreen.kt` | Vico charts library for graphs |
| `ThemeSelectionView.swift` | `screens/settings/ThemeSelectionDialog.kt` | Modal dialog in settings |
| `PomodoroBenefitsView.swift` | `screens/benefits/PomodoroBenefitsScreen.kt` | Static content screen |
| `PrivacyPolicyView.swift` | `screens/privacy/PrivacyPolicyScreen.kt` | Markdown or WebView |
| `ScreenshotPreparationView.swift` | *(Debug build only)* | Test data seeding screen |

### App Intents & Shortcuts
| iOS Feature | Android Feature | Notes |
|-------------|-----------------|-------|
| App Intents | App Shortcuts API (API 25+) | Static and dynamic shortcuts |
| Siri Intents | *(Not applicable)* | Android doesn't have Siri equivalent |
| Widget Intents | Glance Widgets (API 31+) | Optional future enhancement |

## Key Implementation Decisions

### 1. Persistence Strategy
- **Room Database**: For session history (structured query capabilities)
- **Proto DataStore**: For settings (type-safe, async, replaces SharedPreferences)
- **Migration**: Export/import functionality for cross-platform data transfer

### 2. Timer Implementation
- **Foreground Service**: Keep timer running when app is backgrounded
- **WorkManager**: Schedule notifications for timer completion
- **WakeLock**: Optional wake lock during focus sessions (user configurable)
- **Exact Alarms**: Use SCHEDULE_EXACT_ALARM permission for precise timing

### 3. State Management
- **StateFlow**: Single source of truth for UI state
- **MutableStateFlow**: Internal mutable state in ViewModels
- **Flow**: Reactive data streams from repositories
- **Compose State**: Local UI state (selections, dialogs, etc.)

### 4. Background Timer Continuation
```kotlin
// When app goes to background:
1. Calculate timer end time = currentTime + remainingTime
2. Start foreground service with notification
3. Save state to DataStore
4. Schedule WorkManager task for completion

// When app returns to foreground:
1. Check saved end time
2. Calculate new remaining time
3. Update UI state
4. Cancel WorkManager if still running
```

### 5. Notification Strategy
- **Notification Channels**: Separate channels for timer, completion, and reminders
- **Foreground Service**: Persistent notification showing timer progress
- **Completion Notification**: Full-screen intent for timer completion
- **Permission Handling**: Request POST_NOTIFICATIONS for Android 13+

### 6. Theme System
- **Material3 Dynamic Color**: Support system theme colors
- **Custom Color Schemes**: 5 predefined themes matching iOS app
- **Dark Mode**: Automatic system theme following
- **Theme Persistence**: Save selected theme in DataStore

### 7. Testing Strategy
- **Unit Tests**: 
  - TimerManager logic (start/pause/reset/complete)
  - ViewModels (state transitions)
  - Repositories (data operations)
  - Use cases (business logic)
  - Target: >60% coverage for domain layer

- **Integration Tests**:
  - Room database operations
  - DataStore read/write
  - End-to-end user flows

- **UI Tests**:
  - Timer screen: start/pause/reset flow
  - Settings screen: change durations
  - Statistics screen: display data
  - Navigation between screens

### 8. Accessibility
- **Content Descriptions**: All interactive elements
- **Semantic Labels**: Proper role descriptions
- **TalkBack Support**: Test with screen reader
- **Touch Target Size**: Minimum 48dp for all buttons
- **Color Contrast**: WCAG AA compliance

## Implementation Phases

### Phase 1: Foundation (Days 1-2)
- [x] Project structure setup
- [ ] Gradle configuration and dependencies
- [ ] Domain models (data classes)
- [ ] Room database setup
- [ ] DataStore setup
- [ ] Repository interfaces and implementations
- [ ] Unit tests for data layer

### Phase 2: Core Timer Logic (Days 3-4)
- [ ] TimerManager implementation
- [ ] Timer service (foreground service)
- [ ] Notification helper
- [ ] Background timer continuation
- [ ] Unit tests for timer logic
- [ ] Integration tests

### Phase 3: UI Layer (Days 5-7)
- [ ] Theme system and colors
- [ ] Navigation setup
- [ ] Timer screen + ViewModel
- [ ] Settings screen + ViewModel
- [ ] Statistics screen + ViewModel
- [ ] Reusable components
- [ ] UI tests

### Phase 4: Additional Features (Days 8-9)
- [ ] Privacy policy screen
- [ ] Benefits/onboarding screen
- [ ] App shortcuts implementation
- [ ] Screenshot helper
- [ ] Export/import data functionality

### Phase 5: Polish & Testing (Days 10-11)
- [ ] Complete test coverage
- [ ] Performance optimization
- [ ] Accessibility audit
- [ ] Edge case handling
- [ ] CI/CD pipeline
- [ ] Documentation

### Phase 6: Final Delivery (Day 12)
- [ ] Mapping document
- [ ] README with build instructions
- [ ] Release notes
- [ ] Known issues/limitations
- [ ] Future enhancement suggestions

## Deviations from iOS App

### Features with Different Implementation
1. **Focus Mode**: 
   - iOS: Native Focus Mode API
   - Android: Do Not Disturb mode via NotificationManager

2. **Haptic Feedback**:
   - iOS: UIImpactFeedbackGenerator with multiple styles
   - Android: Vibrator service (simpler, less granular)

3. **App Intents/Shortcuts**:
   - iOS: App Intents with Siri integration
   - Android: Static/Dynamic shortcuts (launcher only, no voice assistant)

4. **Charts**:
   - iOS: Native Charts framework (iOS 16+)
   - Android: Vico library (open-source, similar capabilities)

### Features Not Implemented (with rationale)
1. **Siri Integration**: Android has no equivalent
2. **Live Activities**: iOS 16.1+ feature, no Android equivalent
3. **WidgetKit**: Different widget system, may add later
4. **Screenshot automation**: Different tools/workflow on Android

### Android-Specific Features
1. **Adaptive Icons**: Support for different launcher shapes
2. **Material You**: Dynamic color theming on Android 12+
3. **Per-app language**: Android 13+ feature
4. **Predictive Back**: Android 14 gesture navigation

## Assets Conversion

### App Icon
- Extract iOS icon (1024x1024)
- Generate adaptive icon layers (foreground + background)
- Use Android Asset Studio for all densities

### Colors
```kotlin
// Extracted from iOS AppTheme.swift
val ClassicRedPrimary = Color(0xFFED4242)
val ClassicRedSecondary = Color(0xFFFA7343)
val OceanBluePrimary = Color(0xFF3399DB)
val ForestGreenPrimary = Color(0xFF339966)
val MidnightDarkPrimary = Color(0xFF736BC2)
val SunsetOrangePrimary = Color(0xFFFA8033)
```

### Launch Screen
- Convert to Android Splash Screen API (Android 12+)
- Use launch_logo.png as splash icon

## Build Configuration

### Gradle Modules
```
pomodoro-timer/
├── app/                    # Main application module
├── gradle/
│   └── libs.versions.toml  # Version catalog
└── build.gradle.kts        # Root build file
```

### Build Variants
- **debug**: Development build with debugging tools
- **release**: Production build with ProGuard/R8

### ProGuard Rules
- Keep Room entities
- Keep DataStore serializers
- Keep Hilt-generated classes

## CI/CD Pipeline

### GitHub Actions Workflow
```yaml
name: Android CI

on: [push, pull_request]

jobs:
  build:
    - Setup JDK 17
    - Gradle cache
    - Run unit tests
    - Run lint checks
    - Build APK
    - Upload artifacts
    
  test:
    - Run unit tests with coverage
    - Generate coverage report
    - Upload to Codecov
```

## Performance Considerations

1. **Timer Precision**: Use `Handler.postDelayed()` with 1-second intervals
2. **Database**: Index on `completedAt` for statistics queries
3. **Compose**: Remember expensive computations with `remember`
4. **Memory**: Avoid leaks in ViewModels (use `viewModelScope`)
5. **Battery**: Minimize wake locks, use WorkManager for scheduling

## Security Considerations

1. **Data Storage**: Room database and DataStore are private to app
2. **Permissions**: Request only necessary permissions
3. **ProGuard**: Obfuscate code in release builds
4. **No Analytics**: Privacy-first approach (matching iOS app)

## Compatibility

- **Minimum SDK 26**: Covers 95%+ of active devices
- **Target SDK 34**: Latest features and security
- **Backwards Compatibility**: Handle API differences gracefully

## Future Enhancements

1. **Wear OS App**: Companion app for smartwatches
2. **Home Screen Widget**: Quick timer controls
3. **Tasker Integration**: Automation support
4. **Export Statistics**: CSV export for data analysis
5. **Cloud Sync**: Optional cloud backup (Firebase)
6. **Tablet Optimization**: Two-pane layouts for tablets

## Success Criteria

- [x] App builds successfully on Android Studio
- [ ] All core features functional (timer, settings, stats)
- [ ] Tests pass with >60% coverage
- [ ] No critical bugs or crashes
- [ ] Smooth UI (60fps minimum)
- [ ] APK size < 15MB
- [ ] Battery drain < 2% per hour during active use
- [ ] Passes accessibility scanner
- [ ] Documentation complete
