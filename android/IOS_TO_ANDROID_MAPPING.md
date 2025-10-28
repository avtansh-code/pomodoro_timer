# iOS to Android Mapping Document

This document provides a comprehensive mapping between the iOS Pomodoro Timer app and the Android implementation.

## Project Structure Mapping

### iOS Project Structure
```
iOS/PomodoroTimer/
├── PomodoroTimerApp.swift          # App entry point
├── ContentView.swift                # Main container view
├── Models/
│   ├── TimerSession.swift
│   ├── TimerSettings.swift
│   └── AppTheme.swift
├── Services/
│   ├── TimerManager.swift
│   ├── PersistenceManager.swift
│   ├── ThemeManager.swift
│   ├── FocusModeManager.swift
│   └── ScreenshotHelper.swift
├── Views/
│   ├── MainTimerView.swift
│   ├── SettingsView.swift
│   ├── StatisticsView.swift
│   ├── ThemeSelectionView.swift
│   ├── PomodoroBenefitsView.swift
│   ├── PrivacyPolicyView.swift
│   └── ScreenshotPreparationView.swift
└── AppIntents/
    ├── StartPomodoroIntent.swift
    ├── PauseTimerIntent.swift
    ├── ResumeTimerIntent.swift
    ├── ResetTimerIntent.swift
    └── ShowStatisticsIntent.swift
```

### Android Project Structure
```
android/app/src/main/java/com/pomodoro/timer/
├── PomodoroApplication.kt          # App entry point (Hilt)
├── MainActivity.kt                  # Main activity with Compose
│
├── domain/                          # ✅ COMPLETE
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
├── data/                            # 🚧 TODO: Milestone 2
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
├── presentation/                    # 🚧 TODO: Milestones 4-6
│   ├── navigation/
│   ├── theme/
│   ├── components/
│   └── screens/
│       ├── timer/
│       ├── statistics/
│       ├── settings/
│       ├── privacy/
│       └── benefits/
│
├── service/                         # 🚧 TODO: Milestone 3
│   ├── TimerService.kt
│   └── NotificationHelper.kt
│
└── util/                            # 🚧 TODO: Milestone 3
    ├── TimerManager.kt
    ├── Constants.kt
    └── Extensions.kt
```

## File-by-File Mapping

### Models (✅ Complete)

| iOS File | Android File | Status | Notes |
|----------|--------------|--------|-------|
| `Models/TimerSession.swift` | `domain/model/TimerSession.kt` | ✅ | Exact field mapping with Kotlin data class |
| `Models/TimerSettings.swift` | `domain/model/TimerSettings.kt` | ✅ | All properties mapped, includes AppThemeType enum |
| `Models/AppTheme.swift` | `domain/model/AppTheme.kt` | ✅ | All 5 themes with exact color values |
| `SessionType` (enum in TimerSession.swift) | `domain/model/SessionType.kt` | ✅ | FOCUS, SHORT_BREAK, LONG_BREAK |
| `TimerState` (enum in TimerManager.swift) | `domain/model/TimerState.kt` | ✅ | IDLE, RUNNING, PAUSED |

### Services/Persistence (✅ Interfaces, 🚧 Implementation)

| iOS File | Android File | Status | Notes |
|----------|--------------|--------|-------|
| `Services/PersistenceManager.swift` | `domain/repository/SessionRepository.kt` | ✅ | Interface complete |
| `Services/PersistenceManager.swift` | `domain/repository/SettingsRepository.kt` | ✅ | Interface complete |
| `Services/PersistenceManager.swift` | `data/repository/SessionRepositoryImpl.kt` | 🚧 | Implementation TODO (Milestone 2) |
| `Services/PersistenceManager.swift` | `data/repository/SettingsRepositoryImpl.kt` | 🚧 | Implementation TODO (Milestone 2) |
| `Services/PersistenceManager.swift` | `data/local/database/*` | 🚧 | Room database TODO (Milestone 2) |
| `Services/PersistenceManager.swift` | `data/local/datastore/*` | 🚧 | DataStore TODO (Milestone 2) |

### Timer & Logic (🚧 TODO)

| iOS File | Android File | Status | Notes |
|----------|--------------|--------|-------|
| `Services/TimerManager.swift` | `util/TimerManager.kt` | 🚧 | Milestone 3: Core timer logic |
| `Services/TimerManager.swift` | `presentation/screens/timer/TimerViewModel.kt` | 🚧 | Milestone 4: UI state management |
| Background timer | `service/TimerService.kt` | 🚧 | Milestone 3: Foreground service |
| Notifications | `service/NotificationHelper.kt` | 🚧 | Milestone 3: Notification channels |

### Theme Management (🚧 TODO)

| iOS File | Android File | Status | Notes |
|----------|--------------|--------|-------|
| `Services/ThemeManager.swift` | `presentation/theme/Theme.kt` | 🚧 | Milestone 5: Compose theme |
| `Services/ThemeManager.swift` | `presentation/theme/Color.kt` | 🚧 | Milestone 5: Color definitions |
| `Services/ThemeManager.swift` | `presentation/theme/Type.kt` | 🚧 | Milestone 5: Typography |

### Views/Screens (🚧 TODO)

| iOS File | Android File | Status | Notes |
|----------|--------------|--------|-------|
| `Views/MainTimerView.swift` | `presentation/screens/timer/TimerScreen.kt` | 🚧 | Milestone 6: Main timer UI |
| `Views/SettingsView.swift` | `presentation/screens/settings/SettingsScreen.kt` | 🚧 | Milestone 6: Settings UI |
| `Views/StatisticsView.swift` | `presentation/screens/statistics/StatisticsScreen.kt` | 🚧 | Milestone 6: Statistics UI with Vico charts |
| `Views/ThemeSelectionView.swift` | `presentation/screens/settings/ThemeSelectionDialog.kt` | 🚧 | Milestone 6: Theme picker dialog |
| `Views/PomodoroBenefitsView.swift` | `presentation/screens/benefits/PomodoroBenefitsScreen.kt` | 🚧 | Milestone 7: Benefits content |
| `Views/PrivacyPolicyView.swift` | `presentation/screens/privacy/PrivacyPolicyScreen.kt` | 🚧 | Milestone 7: Privacy policy |
| `Views/ScreenshotPreparationView.swift` | Debug only feature | 🚧 | Milestone 7: Optional |

### App Intents & Shortcuts (🚧 TODO)

| iOS File | Android Implementation | Status | Notes |
|----------|------------------------|--------|-------|
| `AppIntents/StartPomodoroIntent.swift` | Android App Shortcuts XML + Handler | 🚧 | Milestone 7: Launcher shortcuts |
| `AppIntents/PauseTimerIntent.swift` | Android App Shortcuts XML + Handler | 🚧 | Milestone 7: Launcher shortcuts |
| `AppIntents/ResumeTimerIntent.swift` | Android App Shortcuts XML + Handler | 🚧 | Milestone 7: Launcher shortcuts |
| `AppIntents/ResetTimerIntent.swift` | Android App Shortcuts XML + Handler | 🚧 | Milestone 7: Launcher shortcuts |
| `AppIntents/ShowStatisticsIntent.swift` | Android App Shortcuts XML + Handler | 🚧 | Milestone 7: Launcher shortcuts |
| Siri Integration | *(Not applicable)* | N/A | Android has no Siri equivalent |

### Other Services (🚧 TODO)

| iOS File | Android Implementation | Status | Notes |
|----------|------------------------|--------|-------|
| `Services/FocusModeManager.swift` | Do Not Disturb integration | 🚧 | Milestone 3: NotificationManager API |
| `Services/ScreenshotHelper.swift` | Share intent | 🚧 | Milestone 7: Android ShareSheet |

## Data Model Field Mapping

### TimerSession

| iOS Property | Android Property | Type | Notes |
|--------------|------------------|------|-------|
| `id: UUID` | `id: String` | String | UUID string representation |
| `type: SessionType` | `type: SessionType` | Enum | Same values |
| `duration: TimeInterval` | `duration: Long` | Seconds | Same unit |
| `completedAt: Date` | `completedAt: Long` | Epoch seconds | Unix timestamp |
| `wasCompleted: Bool` | `wasCompleted: Boolean` | Boolean | Same meaning |

### TimerSettings

| iOS Property | Android Property | Type | Notes |
|--------------|------------------|------|-------|
| `focusDuration: TimeInterval` | `focusDuration: Long` | Seconds | Default: 25 * 60 |
| `shortBreakDuration: TimeInterval` | `shortBreakDuration: Long` | Seconds | Default: 5 * 60 |
| `longBreakDuration: TimeInterval` | `longBreakDuration: Long` | Seconds | Default: 15 * 60 |
| `sessionsUntilLongBreak: Int` | `sessionsUntilLongBreak: Int` | Int | Default: 4 |
| `autoStartBreaks: Bool` | `autoStartBreaks: Boolean` | Boolean | Default: false |
| `autoStartFocus: Bool` | `autoStartFocus: Boolean` | Boolean | Default: false |
| `soundEnabled: Bool` | `soundEnabled: Boolean` | Boolean | Default: true |
| `hapticEnabled: Bool` | `hapticEnabled: Boolean` | Boolean | Default: true |
| `notificationsEnabled: Bool` | `notificationsEnabled: Boolean` | Boolean | Default: true |
| `selectedTheme: AppTheme` | `selectedTheme: AppThemeType` | Enum | SYSTEM/LIGHT/DARK |
| *(implicit)* | `selectedCustomTheme: String` | String | Theme ID (classic_red, etc.) |
| `focusModeEnabled: Bool` | `focusModeEnabled: Boolean` | Boolean | Default: false |
| `syncWithFocusMode: Bool` | `syncWithFocusMode: Boolean` | Boolean | Default: false |

### AppTheme Color Values

| Theme | iOS Hex | Android Hex | Match |
|-------|---------|-------------|-------|
| Classic Red Primary | #ED4242 | 0xFFED4242 | ✅ |
| Classic Red Secondary | #FA7343 | 0xFFFA7343 | ✅ |
| Ocean Blue Primary | #3399DB | 0xFF3399DB | ✅ |
| Ocean Blue Secondary | #33CCED | 0xFF33CCED | ✅ |
| Forest Green Primary | #339966 | 0xFF339966 | ✅ |
| Forest Green Secondary | #4DC785 | 0xFF4DC785 | ✅ |
| Midnight Dark Primary | #736BC2 | 0xFF736BC2 | ✅ |
| Midnight Dark Secondary | #998CD9 | 0xFF998CD9 | ✅ |
| Sunset Orange Primary | #FA8033 | 0xFFFA8033 | ✅ |
| Sunset Orange Secondary | #FFA64D | 0xFFFFA64D | ✅ |

## Business Logic Mapping

### Statistics Calculations

| iOS Function | Android Implementation | Status |
|--------------|------------------------|--------|
| `getTodaySessions()` | `SessionRepository.getTodaySessions()` | ✅ Interface |
| `getWeeklySessions()` | `SessionRepository.getWeeklySessions()` | ✅ Interface |
| `getMonthlySessions()` | `SessionRepository.getMonthlySessions()` | ✅ Interface |
| `getCurrentStreak()` | `SessionRepository.getCurrentStreak()` | ✅ Interface |
| *(calculated in view)* | `GetStatisticsUseCase.invoke()` | ✅ Complete |

### Timer State Machine

| iOS State | Android State | Transitions |
|-----------|---------------|-------------|
| `idle` | `IDLE` | → RUNNING |
| `running` | `RUNNING` | → PAUSED, → IDLE (reset), → IDLE (complete) |
| `paused` | `PAUSED` | → RUNNING (resume), → IDLE (reset) |

## Architecture Pattern Mapping

| iOS Pattern | Android Pattern | Notes |
|-------------|-----------------|-------|
| MVVM (SwiftUI) | MVVM (Jetpack Compose) | Same high-level pattern |
| `@Published` | `StateFlow` / `Flow` | Reactive state management |
| `@StateObject` | `ViewModel` + `collectAsState()` | Lifecycle-aware state |
| `Combine` | Kotlin `Flow` | Reactive streams |
| `async/await` | Kotlin Coroutines | Async operations |
| `UserDefaults` | DataStore Preferences | Settings persistence |
| Core Data *(not used)* | Room Database | SQL database |
| App Intents | App Shortcuts | Launcher integration |

## Platform Differences

### Features with Different Implementations

1. **Focus Mode / Do Not Disturb**
   - **iOS**: Native Focus Mode API (iOS 16.1+)
   - **Android**: NotificationManager.setInterruptionFilter()
   - **Difference**: iOS has richer integration, Android is more basic

2. **Haptic Feedback**
   - **iOS**: UIImpactFeedbackGenerator with multiple styles (light, medium, heavy)
   - **Android**: Vibrator/VibratorManager with patterns
   - **Difference**: iOS has more granular haptic options

3. **App Shortcuts**
   - **iOS**: App Intents with Siri integration
   - **Android**: Static/Dynamic shortcuts (launcher only)
   - **Difference**: iOS has voice assistant integration

4. **Charts**
   - **iOS**: Native Swift Charts (iOS 16+)
   - **Android**: Vico library (open-source)
   - **Difference**: Different APIs, similar capabilities

5. **Notifications**
   - **iOS**: UserNotifications framework
   - **Android**: NotificationManager with channels
   - **Difference**: Android requires notification channels (API 26+)

### Features Not Implemented on Android

1. **Siri Integration**: No Android equivalent (Google Assistant has different API)
2. **Live Activities**: iOS 16.1+ feature for lock screen widgets
3. **WidgetKit**: Different widget system on Android (Glance)
4. **Screenshot Automation**: Different tools/workflow

### Android-Specific Features

1. **Adaptive Icons**: Support for different launcher shapes
2. **Material You**: Dynamic color theming (Android 12+)
3. **Foreground Services**: Required for background timer
4. **WorkManager**: Background task scheduling
5. **Notification Channels**: Required grouping of notifications

## Testing Strategy Mapping

| iOS Test Type | Android Test Type | Location |
|---------------|-------------------|----------|
| Unit Tests (XCTest) | Unit Tests (JUnit) | `app/src/test/` |
| UI Tests (XCUITest) | UI Tests (Compose Testing) | `app/src/androidTest/` |
| *(none)* | Integration Tests | `app/src/test/` |

## Build System Mapping

| iOS | Android |
|-----|---------|
| Xcode Project | Android Studio Project |
| Swift Package Manager | Gradle + Version Catalog |
| Info.plist | AndroidManifest.xml |
| Assets.xcassets | res/ directory |
| Build Configurations | Build Variants (debug/release) |

## Persistence Strategy

### iOS (UserDefaults + Memory)
```swift
// Settings
UserDefaults.standard.set(encodedSettings, forKey: "TimerSettings")

// Sessions
In-memory array encoded/decoded to UserDefaults
```

### Android (DataStore + Room)
```kotlin
// Settings
DataStore Preferences (async, type-safe)

// Sessions  
Room SQLite Database (structured queries, indexing)
```

**Advantage**: Android approach scales better for large session histories.

## API Level Requirements

### iOS Requirements
- **Minimum**: iOS 16.0 (for Charts and modern SwiftUI)
- **Target**: iOS 17.0

### Android Requirements
- **Minimum**: API 26 (Android 8.0) - Notification channels
- **Target**: API 34 (Android 14)
- **Compile**: API 34 (Android 14)

## Migration Path

### iOS → Android Data Migration

To migrate user data from iOS to Android:

1. **Export from iOS**:
   ```swift
   // Export sessions and settings as JSON
   let sessions = PersistenceManager.shared.getAllSessions()
   let settings = PersistenceManager.shared.loadSettings()
   let data = ["sessions": sessions, "settings": settings]
   // Convert to JSON and share
   ```

2. **Import to Android**:
   ```kotlin
   // Parse JSON and save to Room + DataStore
   val sessions = json.decodeFromString<List<TimerSession>>(...)
   sessions.forEach { sessionRepository.saveSession(it) }
   settingsRepository.saveSettings(settings)
   ```

### Data Compatibility
- ✅ Same field names and types
- ✅ Same enums and values
- ✅ JSON serialization on both platforms
- ✅ Epoch timestamps (universal)

## Summary

### Completion Status
- ✅ **Domain Layer**: 100% complete (all models, repositories, use cases)
- 🚧 **Data Layer**: 0% (Milestone 2 - next priority)
- 🚧 **Service Layer**: 0% (Milestone 3)
- 🚧 **Presentation Layer**: 0% (Milestone 4)
- 🚧 **UI Layer**: 0% (Milestones 5-6)
- 🚧 **Additional Features**: 0% (Milestone 7)

### Overall Progress
- **Completed**: ~25% (foundation and domain layer)
- **Remaining**: ~75% (data, services, UI, tests, polish)

### Key Achievements
1. ✅ 100% iOS feature parity in domain models
2. ✅ Clean architecture with zero framework dependencies in domain
3. ✅ Type-safe, testable business logic
4. ✅ Cross-platform data compatibility
5. ✅ Modern Android best practices (Kotlin, Coroutines, Flow)

### Next Steps
Follow **IMPLEMENTATION_MILESTONES.md** → Start **Milestone 2: Data Layer**

---

**Document Version**: 1.0  
**Last Updated**: October 28, 2025  
**Status**: Domain layer mapping complete, implementation ongoing
