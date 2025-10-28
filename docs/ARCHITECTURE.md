# Mr. Pomodoro - Architecture Documentation

**Version:** 1.0  
**Last Updated:** October 28, 2025

---

## Table of Contents

- [Overview](#overview)
- [System Architecture](#system-architecture)
- [iOS Architecture](#ios-architecture)
- [Android Architecture](#android-architecture)
- [Design Patterns](#design-patterns)
- [Data Flow](#data-flow)
- [Technology Stack](#technology-stack)
- [Cross-Platform Parity](#cross-platform-parity)

---

## Overview

Mr. Pomodoro is a cross-platform productivity application built with native technologies for iOS and Android. The architecture emphasizes:

- **Privacy-first design** - All data stored locally
- **Platform-native UX** - SwiftUI for iOS, Jetpack Compose for Android
- **Clean architecture** - Clear separation of concerns
- **Testability** - High test coverage across layers
- **Maintainability** - Well-documented, modular codebase

### Core Principles

1. **Local-First** - No cloud dependencies, no analytics
2. **Native Feel** - Platform-specific UI patterns and interactions
3. **Code Parity** - 99% feature equivalence between platforms
4. **Performance** - Smooth 60fps animations, battery-efficient timers
5. **Accessibility** - Full screen reader support, proper semantics

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│        (SwiftUI Views / Jetpack Compose Screens)        │
├─────────────────────────────────────────────────────────┤
│                  Business Logic Layer                    │
│           (ViewModels / Managers / Use Cases)           │
├─────────────────────────────────────────────────────────┤
│                    Domain Layer                          │
│              (Models / Business Rules)                   │
├─────────────────────────────────────────────────────────┤
│                     Data Layer                           │
│    (CoreData/Room / UserDefaults/DataStore / Repos)    │
└─────────────────────────────────────────────────────────┘
```

### Architecture Layers

#### 1. Presentation Layer
- **Responsibility:** User interface and interaction
- **iOS:** SwiftUI Views with ViewModels
- **Android:** Jetpack Compose Screens with StateFlow
- **Characteristics:** Reactive, declarative, state-driven

#### 2. Business Logic Layer
- **Responsibility:** Application logic and coordination
- **iOS:** Manager classes, SwiftUI ViewModels
- **Android:** ViewModels, Use Cases, Managers
- **Characteristics:** Platform-independent where possible

#### 3. Domain Layer
- **Responsibility:** Core business models and rules
- **iOS:** Swift structs and enums
- **Android:** Kotlin data classes and sealed classes
- **Characteristics:** Pure business logic, no dependencies

#### 4. Data Layer
- **Responsibility:** Data persistence and retrieval
- **iOS:** CoreData, UserDefaults
- **Android:** Room, DataStore (Preferences)
- **Characteristics:** Repository pattern, reactive data streams

---

## iOS Architecture

### Technology Stack

- **Language:** Swift 5.0+
- **UI Framework:** SwiftUI
- **Min iOS:** 18.6
- **Architecture:** MVVM (Model-View-ViewModel)
- **Persistence:** CoreData + UserDefaults
- **Concurrency:** Swift Concurrency (async/await)

### Project Structure

```
iOS/PomodoroTimer/
├── Models/                  # Domain models
│   ├── TimerSession.swift
│   ├── TimerSettings.swift
│   └── AppTheme.swift
│
├── Services/                # Business logic
│   ├── TimerManager.swift
│   ├── PersistenceManager.swift
│   ├── ThemeManager.swift
│   ├── FocusModeManager.swift
│   ├── HapticManager.swift
│   └── ScreenshotHelper.swift
│
├── Views/                   # UI layer
│   ├── MainTimerView.swift
│   ├── SettingsView.swift
│   ├── StatisticsView.swift
│   ├── ThemeSelectionView.swift
│   ├── PomodoroBenefitsView.swift
│   └── PrivacyPolicyView.swift
│
├── AppIntents/              # Siri integration
│   ├── StartPomodoroIntent.swift
│   ├── PauseTimerIntent.swift
│   └── ShowStatisticsIntent.swift
│
└── Assets.xcassets/         # Images and colors
```

### Key Components

#### TimerManager
- Manages timer state and countdown
- Handles session transitions
- Integrates with background execution
- Updates UI via `@Published` properties

```swift
class TimerManager: ObservableObject {
    @Published var state: TimerState = .idle
    @Published var remainingTime: TimeInterval = 0
    @Published var currentSession: TimerSession?
    
    func startTimer(duration: TimeInterval)
    func pauseTimer()
    func resumeTimer()
    func resetTimer()
    func completeSession()
}
```

#### PersistenceManager
- Saves/loads settings using UserDefaults
- Stores session history in CoreData
- Provides reactive data access
- Handles data migrations

#### Views (SwiftUI)
- Declarative UI with state binding
- Reactive to ViewModel changes
- Platform-native components
- Accessibility support built-in

---

## Android Architecture

### Technology Stack

- **Language:** Kotlin 1.9+
- **UI Framework:** Jetpack Compose
- **Min SDK:** 26 (Android 8.0)
- **Architecture:** MVVM + Clean Architecture
- **Persistence:** Room + DataStore
- **Concurrency:** Kotlin Coroutines + Flow
- **DI:** Hilt

### Project Structure

```
android/app/src/main/java/com/pomodoro/timer/
├── domain/                          # Domain layer
│   ├── model/                       # Business models
│   │   ├── TimerSession.kt
│   │   ├── TimerSettings.kt
│   │   ├── AppTheme.kt
│   │   ├── SessionType.kt
│   │   └── TimerState.kt
│   │
│   ├── repository/                  # Repository interfaces
│   │   ├── SessionRepository.kt
│   │   └── SettingsRepository.kt
│   │
│   └── usecase/                     # Business logic
│       ├── GetStatisticsUseCase.kt
│       ├── SaveSessionUseCase.kt
│       └── GetStreakUseCase.kt
│
├── data/                            # Data layer
│   ├── local/
│   │   ├── database/               # Room database
│   │   │   ├── PomodoroDatabase.kt
│   │   │   ├── SessionDao.kt
│   │   │   └── entity/SessionEntity.kt
│   │   │
│   │   └── datastore/              # Preferences
│   │       └── SettingsDataStore.kt
│   │
│   └── repository/                 # Repository implementations
│       ├── SessionRepositoryImpl.kt
│       └── SettingsRepositoryImpl.kt
│
├── presentation/                    # Presentation layer
│   ├── viewmodel/                  # ViewModels
│   │   ├── TimerViewModel.kt
│   │   ├── SettingsViewModel.kt
│   │   └── StatisticsViewModel.kt
│   │
│   └── theme/                      # Compose theme
│       ├── Theme.kt
│       ├── Color.kt
│       └── Type.kt
│
├── ui/                             # UI layer
│   ├── screens/                    # Compose screens
│   │   ├── timer/TimerScreen.kt
│   │   ├── settings/SettingsScreen.kt
│   │   └── statistics/StatisticsScreen.kt
│   │
│   ├── components/                 # Reusable components
│   │   ├── CircularProgress.kt
│   │   ├── ActionButton.kt
│   │   └── StateIndicator.kt
│   │
│   └── navigation/                 # Navigation
│       ├── NavGraph.kt
│       └── Screen.kt
│
├── service/                        # Background services
│   ├── TimerService.kt
│   └── NotificationHelper.kt
│
├── util/                           # Utilities
│   ├── TimerManager.kt
│   └── HapticManager.kt
│
└── di/                             # Dependency injection
    ├── DataModule.kt
    └── ServiceModule.kt
```

### Key Components

#### Clean Architecture Layers

**Domain Layer (Pure Kotlin)**
- Business models (data classes)
- Repository interfaces
- Use cases (single responsibility)
- No Android dependencies

**Data Layer**
- Room database for session storage
- DataStore for settings (type-safe)
- Repository implementations
- DAO interfaces with SQL queries

**Presentation Layer**
- ViewModels with StateFlow
- UI state management
- Business logic coordination
- Platform-independent where possible

#### ViewModels
```kotlin
class TimerViewModel @Inject constructor(
    private val timerManager: TimerManager,
    private val settingsRepository: SettingsRepository,
    private val saveSession: SaveSessionUseCase
) : ViewModel() {
    
    val state: StateFlow<TimerState>
    val remainingTime: StateFlow<Long>
    val currentSession: StateFlow<TimerSession?>
    
    fun startTimer()
    fun pauseTimer()
    fun resumeTimer()
    fun resetTimer()
}
```

#### Dependency Injection (Hilt)
- App-level singleton dependencies
- ViewModel injection
- Repository injection
- Easy testing with test modules

---

## Design Patterns

### 1. MVVM (Model-View-ViewModel)

**Used in:** Both iOS and Android

**Benefits:**
- Clear separation of UI and business logic
- Testable ViewModels
- Reactive data binding
- Platform-native pattern

**Implementation:**
- iOS: SwiftUI + `@StateObject` + `@Published`
- Android: Jetpack Compose + StateFlow + ViewModel

### 2. Repository Pattern

**Used in:** Both platforms

**Benefits:**
- Abstract data sources
- Single source of truth
- Easier testing with mock repositories
- Swap implementations easily

**Implementation:**
```kotlin
// Android
interface SessionRepository {
    fun getAllSessions(): Flow<List<TimerSession>>
    suspend fun saveSession(session: TimerSession)
}

class SessionRepositoryImpl(
    private val dao: SessionDao
) : SessionRepository {
    override fun getAllSessions() = dao.getAllSessions()
    override suspend fun saveSession(session: TimerSession) = 
        dao.insert(session.toEntity())
}
```

### 3. Observer Pattern

**Used in:** Both platforms for reactive updates

**Benefits:**
- Automatic UI updates
- Decoupled components
- Scalable

**Implementation:**
- iOS: Combine framework (`@Published`, `ObservableObject`)
- Android: Kotlin Flow and StateFlow

### 4. Singleton Pattern

**Used in:** Manager classes

**Benefits:**
- Single instance of managers
- Global state access
- Resource efficiency

**Examples:**
- `TimerManager`
- `ThemeManager` (iOS)
- `HapticManager`

### 5. Factory Pattern

**Used in:** Creating themes and sessions

**Benefits:**
- Centralized object creation
- Easy to extend
- Type-safe construction

### 6. Use Case Pattern (Android)

**Used in:** Android business logic

**Benefits:**
- Single responsibility
- Reusable business logic
- Easy to test
- Clean separation

**Example:**
```kotlin
class GetStatisticsUseCase(
    private val repository: SessionRepository
) {
    operator fun invoke(period: StatisticsPeriod): Flow<Statistics> {
        // Calculate statistics for period
    }
}
```

---

## Data Flow

### Timer Flow

```
User Action (Start Timer)
         ↓
    ViewModel
         ↓
   TimerManager
         ↓
   State Update
         ↓
  UI Re-renders
```

### Settings Flow

```
User Changes Setting
         ↓
    ViewModel
         ↓
   Repository
         ↓
DataStore/UserDefaults
         ↓
  Flow/Publisher Emits
         ↓
   ViewModel Updates
         ↓
  UI Re-renders
```

### Statistics Flow

```
  Session Completed
         ↓
    ViewModel
         ↓
 SaveSession UseCase
         ↓
   Repository
         ↓
Room/CoreData
         ↓
Query Changed Data
         ↓
Flow/Publisher Emits
         ↓
Statistics Screen Updates
```

---

## Technology Stack

### iOS

| Component | Technology | Purpose |
|-----------|------------|---------|
| Language | Swift 5.0+ | Type-safe, modern |
| UI | SwiftUI | Declarative UI |
| Storage | CoreData | Session history |
| Preferences | UserDefaults | Settings |
| Concurrency | Swift Concurrency | Async operations |
| Reactive | Combine | Observable state |
| Testing | XCTest | Unit testing |

### Android

| Component | Technology | Purpose |
|-----------|------------|---------|
| Language | Kotlin 1.9+ | Concise, safe |
| UI | Jetpack Compose | Declarative UI |
| Storage | Room | Session history |
| Preferences | DataStore | Settings |
| Concurrency | Coroutines | Async operations |
| Reactive | Flow | Observable state |
| DI | Hilt | Dependency injection |
| Testing | JUnit + MockK | Unit testing |

---

## Cross-Platform Parity

### Feature Comparison

| Feature | iOS | Android | Parity |
|---------|-----|---------|--------|
| Timer | ✅ | ✅ | 100% |
| Statistics | ✅ | ✅ | 100% |
| Settings | ✅ | ✅ | 100% |
| Themes | ✅ | ✅ | 99% |
| Focus Mode | ✅ (Focus Mode) | ✅ (DND) | 95% |
| Shortcuts | ✅ (Siri) | ✅ (App) | 90% |
| Notifications | ✅ | ✅ | 100% |
| Haptics | ✅ | ✅ | 95% |

### Platform-Specific Features

**iOS Only:**
- Siri Shortcuts integration
- Native Focus Mode API
- Live Activities (future)

**Android Only:**
- Material You dynamic theming
- Foreground service for background timer
- Notification actions in notification

### Design Decisions

1. **Local Storage Only**
   - No cloud sync to protect privacy
   - Simple, reliable, fast
   - No account management complexity

2. **Native UI Frameworks**
   - SwiftUI and Compose for best performance
   - Platform-native look and feel
   - Access to latest platform features

3. **Shared Business Logic Approach**
   - Similar architecture patterns
   - Equivalent models and business rules
   - Parallel implementation (not code sharing)

4. **Battery Efficiency**
   - Efficient timer implementation
   - Minimal background processing
   - Smart notification scheduling

---

## Security & Privacy

### Data Protection

- **Local-only storage** - No network transmission
- **Platform encryption** - iOS Keychain, Android Keystore when needed
- **Sandboxed** - App data isolated by OS
- **No analytics** - No tracking whatsoever
- **No third-party SDKs** - Minimal external dependencies

### Security Measures

1. **Input Validation** - All user inputs validated
2. **Error Handling** - Graceful error recovery
3. **Memory Management** - Proper cleanup of sensitive data
4. **Code Signing** - Verified app authenticity
5. **Regular Updates** - Security patches via app updates

---

## Performance Considerations

### iOS
- Lazy view loading with SwiftUI
- Efficient Core Data fetch requests
- Background thread for timer calculations
- Optimized animations (60fps target)

### Android
- Compose remember for expensive operations
- Room database indexing on timestamp fields
- Coroutine scoping for lifecycle awareness
- Material3 motion system for smooth animations

---

## Testing Strategy

### Unit Tests
- **Domain Layer:** 80%+ coverage
- **Business Logic:** 85%+ coverage
- **ViewModels:** 70%+ coverage

### Integration Tests
- Database operations
- Repository implementations
- End-to-end user flows

### UI Tests (iOS)
- XCUITest for critical user journeys
- Accessibility testing
- Screenshot testing

### Future Testing
- Android UI tests with Compose Testing
- Performance testing
- Battery drain testing

---

## Future Architecture Considerations

### Planned Enhancements

1. **Modularization**
   - Split into feature modules
   - Shared core module
   - Improved build times

2. **Widget Support**
   - iOS WidgetKit
   - Android Glance
   - Quick timer access

3. **Watch Apps**
   - iOS Watch app
   - Wear OS app
   - Standalone timer

4. **Optional Cloud Sync**
   - End-to-end encrypted
   - Opt-in only
   - Cross-device statistics

---

## References

- [iOS Developer Guide](../iOS/docs/DEVELOPER_GUIDE.md)
- [Android README](../android/README.md)
- [Design System](../iOS/docs/DESIGN_SYSTEM.md)
- [Contributing Guide](../CONTRIBUTING.md)

---

**Document Version:** 1.0  
**Last Updated:** October 28, 2025  
**Maintained by:** Avtansh Gupta
