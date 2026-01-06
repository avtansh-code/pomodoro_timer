# Pomodoro Timer - Technical Documentation

**Project:** Flutter Pomodoro Timer Application  
**Version:** 1.0.0  
**Last Updated:** January 6, 2026

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Technology Stack](#technology-stack)
3. [Project Structure](#project-structure)
4. [Setup Instructions](#setup-instructions)
5. [Core Components](#core-components)
6. [State Management](#state-management)
7. [Data Persistence](#data-persistence)
8. [Testing Strategy](#testing-strategy)
9. [Running the Application](#running-the-application)
10. [Implementation Notes](#implementation-notes)

---

## Architecture Overview

This application follows **Clean Architecture** principles combined with the **BLoC (Business Logic Component)** pattern for state management.

### Architecture Layers

```
┌─────────────────────────────────────┐
│     Presentation Layer (UI)         │
│  - Screens, Widgets, Themes         │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│   Business Logic Layer (BLoC)       │
│  - BLoCs, Cubits, Events, States    │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│      Data Layer                     │
│  - Repositories, Services, Models   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│   External Services                 │
│  - Hive, SharedPrefs, Notifications │
└─────────────────────────────────────┘
```

### Key Principles

- **Separation of Concerns:** Each layer has a single, well-defined responsibility
- **Dependency Inversion:** Higher layers depend on abstractions, not concrete implementations
- **Testability:** Business logic is isolated and easily testable
- **Maintainability:** Modular structure allows for easy updates and feature additions

---

## Technology Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| Framework | Flutter 3.10.4+ | Cross-platform mobile development |
| State Management | flutter_bloc | Predictable state management |
| Routing | go_router | Declarative routing |
| Local Storage (Settings) | shared_preferences | Simple key-value storage |
| Local Database (Stats) | hive | Fast, type-safe NoSQL database |
| Notifications | flutter_local_notifications | Cross-platform local notifications |
| Audio | audioplayers | Sound playback |
| Haptics | flutter_haptic_feedback | Tactile feedback |
| Dependency Injection | get_it | Service locator pattern |
| Value Equality | equatable | Simplify state comparisons |

---

## Project Structure

```
lib/
├── main.dart                          # Application entry point
├── app/
│   ├── app.dart                       # Root app widget
│   ├── app_router.dart                # Navigation configuration
│   └── theme/
│       ├── app_theme.dart             # Theme management
│       └── themes.dart                # Theme definitions
├── core/
│   ├── di/
│   │   └── service_locator.dart       # Dependency injection setup
│   ├── models/
│   │   ├── timer_session.dart         # Session data model
│   │   └── timer_settings.dart        # Settings data model
│   └── services/
│       ├── persistence_service.dart   # Settings persistence
│       ├── notification_service.dart  # Local notifications
│       └── audio_service.dart         # Sound management
├── features/
│   ├── timer/
│   │   ├── bloc/
│   │   │   ├── timer_bloc.dart        # Timer business logic
│   │   │   ├── timer_event.dart       # Timer events
│   │   │   └── timer_state.dart       # Timer states
│   │   └── view/
│   │       ├── main_timer_screen.dart # Main timer UI
│   │       └── widgets/
│   │           ├── timer_display.dart # Timer display widget
│   │           └── timer_controls.dart# Control buttons
│   ├── settings/
│   │   ├── bloc/
│   │   │   ├── settings_cubit.dart    # Settings management
│   │   │   └── settings_state.dart    # Settings state
│   │   └── view/
│   │       └── settings_screen.dart   # Settings UI
│   ├── statistics/
│   │   ├── bloc/
│   │   │   ├── statistics_cubit.dart  # Statistics logic
│   │   │   └── statistics_state.dart  # Statistics state
│   │   ├── data/
│   │   │   └── statistics_repository.dart # Data access layer
│   │   └── view/
│   │       └── statistics_screen.dart # Statistics UI
│   ├── onboarding/
│   │   └── view/
│   │       └── pomodoro_benefits_screen.dart
│   └── privacy/
│       └── view/
│           └── privacy_policy_screen.dart
└── generated/
    └── ...                            # Auto-generated files
```

---

## Setup Instructions

### Prerequisites

- Flutter SDK 3.10.4 or higher
- Dart SDK (included with Flutter)
- iOS: Xcode 14+ (for iOS development)
- Android: Android Studio with Android SDK 21+

### Initial Setup

```bash
# 1. Navigate to project directory
cd flutter/pomodoro_timer

# 2. Install dependencies
flutter pub get

# 3. Run code generation (when needed)
flutter pub run build_runner build

# 4. Verify setup
flutter doctor

# 5. Run the application
flutter run
```

### Dependencies Installation

The following dependencies will be added in Phase 1:

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Persistence
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Notifications & Audio
  flutter_local_notifications: ^16.3.0
  audioplayers: ^5.2.1
  
  # Navigation
  go_router: ^13.0.0
  
  # Haptics
  flutter_haptic_feedback: ^2.2.0
  
  # Dependency Injection
  get_it: ^7.6.7
```

---

## Core Components

### Models

#### TimerSettings
**Purpose:** Store user-configurable timer preferences  
**Location:** `core/models/timer_settings.dart`

**Properties:**
- `workDuration`: Duration of work sessions (default: 25 minutes)
- `shortBreakDuration`: Duration of short breaks (default: 5 minutes)
- `longBreakDuration`: Duration of long breaks (default: 15 minutes)
- `sessionsBeforeLongBreak`: Number of work sessions before long break (default: 4)

#### TimerSession
**Purpose:** Record completed timer sessions for statistics  
**Location:** `core/models/timer_session.dart`

**Properties:**
- `id`: Unique identifier
- `sessionType`: Enum (work, shortBreak, longBreak)
- `startTime`: DateTime when session started
- `endTime`: DateTime when session completed
- `duration`: Actual duration of the session

---

## State Management

### BLoC Pattern

The application uses the BLoC pattern for predictable state management:

1. **Events:** User actions or system events that trigger state changes
2. **States:** Immutable representations of the application state
3. **BLoC:** Business logic that transforms events into states

### Timer BLoC Flow

```
User Action → Event → BLoC → State → UI Update
     ↓          ↓        ↓       ↓        ↓
Start Timer → Start → Running → Display Countdown
Pause Timer → Pause → Paused → Show Pause State
```

---

## Data Persistence

### Settings (shared_preferences)
- Simple key-value storage
- Used for user preferences
- Synchronous and asynchronous access
- Platform-specific implementation

### Statistics (Hive)
- Fast, type-safe NoSQL database
- Stores session history
- Supports complex queries
- No native dependencies

---

## Testing Strategy

### Unit Tests
**Target:** Business logic (BLoCs, Cubits, Services)  
**Coverage Goal:** 80%+

```dart
// Example: TimerBloc test
testWidgets('TimerBloc emits running state when started', (tester) async {
  // Arrange, Act, Assert
});
```

### Widget Tests
**Target:** UI components and their interactions  
**Coverage Goal:** Critical user paths

### Integration Tests
**Target:** End-to-end user flows  
**Scope:** Complete feature workflows

---

## Running the Application

### Development

```bash
# Run on connected device/emulator
flutter run

# Run with specific device
flutter run -d <device_id>

# Hot reload (during development)
# Press 'r' in terminal

# Hot restart
# Press 'R' in terminal
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/timer_bloc_test.dart

# Run with coverage
flutter test --coverage
```

### Building

```bash
# Build APK (Android)
flutter build apk --release

# Build iOS
flutter build ios --release

# Build for all platforms
flutter build apk && flutter build ios
```

---

## Implementation Notes

### Phase-by-Phase Details

#### Phase 1: Project Setup
**Status:** ✅ Complete  
**Completed:** January 6, 2026

**Implementation Summary:**
1. ✅ Added all required dependencies to pubspec.yaml
2. ✅ Created complete directory structure for core models and services
3. ✅ Defined TimerSettings and TimerSession models with full documentation
4. ✅ Set up GetIt service locator with proper dependency injection

**Key Implementations:**
- **TimerSettings Model**: Immutable settings model with JSON serialization, default values following traditional Pomodoro (25/5/15 minutes), uses Equatable for value equality
- **TimerSession Model**: Hive-annotated model for statistics tracking, includes session type enum (work/short break/long break), auto-generated IDs, date filtering helpers
- **PersistenceService**: SharedPreferences wrapper for settings storage, handles JSON serialization/deserialization, graceful error handling with fallback to defaults
- **NotificationService**: flutter_local_notifications integration, platform-specific initialization (Android/iOS), separate methods for each session type completion
- **AudioService**: Audioplayers integration with volume control, sound enable/disable toggle, placeholder for asset-based sounds
- **Service Locator**: GetIt configuration with proper dependency order, lazy singleton pattern for services, async initialization support

**Technical Decisions Made:**
- Used `vibration` package instead of `flutter_haptic_feedback` due to SDK version compatibility
- Services registered as lazy singletons for memory efficiency
- SharedPreferences registered as singleton (required async initialization)
- All services include proper error handling and initialization checks

**Files Created:**
- `lib/core/models/timer_settings.dart` (97 lines)
- `lib/core/models/timer_session.dart` (116 lines, requires code generation)
- `lib/core/services/persistence_service.dart` (58 lines)
- `lib/core/services/notification_service.dart` (143 lines)
- `lib/core/services/audio_service.dart` (78 lines)
- `lib/core/di/service_locator.dart` (50 lines)

---

#### Phase 2: Core Timer Logic and Main UI
**Status:** ✅ Complete  
**Completed:** January 6, 2026

**Implementation Summary:**
1. ✅ Created TimerBloc with comprehensive event/state management
2. ✅ Implemented accurate countdown using Stream.periodic
3. ✅ Built MainTimerScreen with BlocProvider integration
4. ✅ Created TimerDisplay widget with session-based styling
5. ✅ Created TimerControls widget with state-based buttons

**Key Implementations:**
- **TimerEvent (7 events)**: Sealed class hierarchy with TimerStarted, TimerPaused, TimerResumed, TimerReset, TimerTicked, TimerSkipped, TimerCompleted
- **TimerState (5 states)**: Sealed class with TimerInitial, TimerRunning, TimerPaused, TimerCompleted, TimerError - all extending base TimerState with duration and sessionType
- **TimerBloc**: Full BLoC implementation with Stream.periodic ticker, automatic session transitions, notification/audio integration, proper cleanup in close()
- **MainTimerScreen**: Material 3 UI with BlocBuilder, session counter, timer display, controls, completion messages, navigation placeholders
- **TimerDisplay Widget**: Large format MM:SS display, session-type colors (primary/green/blue), progress indicator, rounded container design
- **TimerControls Widget**: State-based button rendering (Start/Pause/Resume), secondary actions (Reset/Skip), elevated/outlined button styles

**Technical Decisions Made:**
- Used import prefixes (`as event`, `as state`) to resolve naming collisions between events and states
- Stream.periodic provides 1-second accuracy with takeWhile for automatic completion
- SessionType enum determines colors, labels, and next session logic
- Auto-transition after 2 seconds on completion for smooth UX
- Material 3 with deepOrange seed color for modern, accessible design
- BlocProvider scoped to screen level for proper lifecycle management

**Files Created:**
- `lib/features/timer/bloc/timer_event.dart` (68 lines)
- `lib/features/timer/bloc/timer_state.dart` (95 lines)
- `lib/features/timer/bloc/timer_bloc.dart` (210 lines)
- `lib/features/timer/view/widgets/timer_display.dart` (106 lines)
- `lib/features/timer/view/widgets/timer_controls.dart` (124 lines)
- `lib/features/timer/view/main_timer_screen.dart` (163 lines)
- Updated `lib/main.dart` (40 lines) - service initialization and app root

**Architecture Notes:**
- Clean separation: Events trigger BLoC → BLoC emits States → UI rebuilds
- Dependency injection via GetIt for services (notification, audio)
- Widgets are pure and stateless - all state managed by BLoC
- Session counter and completion messages enhance user feedback

---

#### Phase 3: Settings
**Status:** ✅ Complete  
**Completed:** January 6, 2026

**Implementation Summary:**
1. ✅ Created SettingsState with loading/error handling
2. ✅ Created SettingsCubit with validation and persistence
3. ✅ Built comprehensive SettingsScreen with sliders
4. ✅ Integrated settings with TimerBloc via global provider

**Key Implementations:**
- **SettingsState**: Simple state with settings, loading flag, and error message - uses copyWith for updates with clearError flag
- **SettingsCubit**: Manages all timer settings (work/break durations, sessions before long break), validates input ranges (1-60 min work, 1-30 min short break, 1-10 sessions), immediate persistence on changes, reset to defaults functionality
- **SettingsScreen**: Material 3 UI with slider controls, real-time value display, section headers for organization, reset confirmation dialog, informational card about Pomodoro Technique, error snackbar with dismiss action
- **Global Settings Provider**: SettingsCubit provided at app root in PomodoroApp, BlocBuilder in MainTimerScreen recreates TimerBloc when settings change, ensures timer always uses current settings

**Technical Decisions Made:**
- Cubit over BLoC: Settings don't need complex event handling, simpler state updates
- Input validation in Cubit: Prevents invalid values before persistence
- Global provider pattern: Settings accessible throughout app hierarchy
- BlocBuilder recreation: Clean way to apply new settings without complex state management
- Slider UI: Intuitive for duration selection with visual feedback
- Separate SettingsCubit instance in SettingsScreen: Independent from global instance for proper lifecycle

**Files Created:**
- `lib/features/settings/bloc/settings_state.dart` (51 lines)
- `lib/features/settings/bloc/settings_cubit.dart` (134 lines)
- `lib/features/settings/view/settings_screen.dart` (332 lines)
- `lib/app/app.dart` (41 lines) - Global provider setup
- Updated `lib/main.dart` (12 lines) - Simplified to use PomodoroApp
- Updated `lib/features/timer/view/main_timer_screen.dart` - Settings integration

**Architecture Notes:**
- Clean separation: SettingsCubit → PersistenceService → SharedPreferences
- Validation at business logic layer prevents invalid data
- Global state accessible via context.read<SettingsCubit>()
- Settings changes trigger TimerBloc recreation with new settings

---

#### Phase 4: Statistics
**Status:** ✅ Complete  
**Completed:** January 6, 2026

**Implementation Summary:**
1. ✅ Initialized Hive with type adapters for TimerSession and SessionType
2. ✅ Created StatisticsRepository with comprehensive data access methods
3. ✅ Built StatisticsCubit with filtering and state management
4. ✅ Created feature-rich StatisticsScreen with data visualization
5. ✅ Integrated automatic session saving in TimerBloc

**Key Implementations:**
- **Hive Setup**: Initialized in main.dart with registered adapters (TimerSessionAdapter, SessionTypeAdapter), @HiveType annotations on models with unique typeIds
- **StatisticsRepository (133 lines)**: Comprehensive data access layer with methods for adding sessions, retrieving all/filtered sessions (today/week/month), date-range queries with proper start/end handling, aggregate statistics (total sessions, work count, focus time), bulk operations (clear all, delete specific)
- **StatisticsState (103 lines)**: Immutable state with sessions list and filter enum, computed properties for workSessionCount, totalFocusTime, totalBreakTime, sessionsByDate grouping for UI display, copyWith with clearError flag
- **StatisticsCubit (73 lines)**: Simple cubit for loading and filtering statistics, switch expression for filter handling (today/week/month/all), refresh functionality, clear all with confirmation, error handling
- **StatisticsScreen (429 lines)**: Material 3 UI with comprehensive features - Filter chips (Today/Week/Month/All Time) at top, Three summary stat cards (Sessions/Focus Time/Break Time), Pull-to-refresh support, Grouped session list by date (Today/Yesterday/Date format), Session tiles with type-specific icons and colors, Empty state messages per filter, Clear all data with confirmation dialog, Error snackbar with dismiss action
- **TimerBloc Integration**: Auto-saves completed sessions to repository, Creates TimerSession with proper start/end times, Calculates duration based on session type, Repository injected via GetIt service locator

**Technical Decisions Made:**
- Hive over sqflite: Better performance, no native dependencies, type-safe
- Repository pattern: Clean separation of data access from business logic  
- Filter enum: Type-safe filtering with switch expressions
- Computed properties in state: Aggregate stats calculated on-demand from session list
- intl package: Professional date/time formatting (DateFormat)
- Grouped by date: Better UX showing sessions organized by day
- Type-specific colors: Visual distinction (orange work, green short break, blue long break)
- Pull-to-refresh: Natural mobile UX pattern for data reload
- SessionType as HiveType: Proper enum serialization in Hive

**Files Created:**
- `lib/features/statistics/data/statistics_repository.dart` (133 lines)
- `lib/features/statistics/bloc/statistics_state.dart` (103 lines)
- `lib/features/statistics/bloc/statistics_cubit.dart` (73 lines)
- `lib/features/statistics/view/statistics_screen.dart` (429 lines)
- Updated `lib/main.dart` - Hive initialization and adapter registration
- Updated `lib/core/models/timer_session.dart` - Added @HiveType annotations
- Updated `lib/core/di/service_locator.dart` - Registered StatisticsRepository
- Updated `lib/features/timer/bloc/timer_bloc.dart` - Session auto-save on completion
- Updated `lib/features/timer/view/main_timer_screen.dart` - Navigation to statistics
- Updated `pubspec.yaml` - Added intl package

**Architecture Notes:**
- Clean data flow: TimerBloc → StatisticsRepository → Hive
- Repository handles all Hive operations, BLoC/Cubit never touches Hive directly
- StatisticsScreen gets its own StatisticsCubit instance for independent lifecycle
- Sessions saved automatically when timer completes, no manual save needed
- Filter changes reload data from repository, maintaining single source of truth

---

#### Phase 5: Notifications, Audio, and Haptics
**Status:** ✅ Complete  
**Completed:** January 6, 2026

**Implementation Summary:**
1. ✅ NotificationService already implemented in Phase 1
2. ✅ AudioService already implemented in Phase 1
3. ✅ Created assets directory structure for audio files
4. ✅ Integrated haptic feedback in timer controls
5. ✅ Added comprehensive audio assets documentation

**Key Implementations:**
- **NotificationService (143 lines)**: Already complete from Phase 1 - flutter_local_notifications integration, platform-specific initialization (Android/iOS), three notification methods (work complete, short break complete, long break complete), high priority notifications with sound and badge, cancelAll method for cleanup
- **AudioService (78 lines)**: Already complete from Phase 1 - audioplayers integration, sound enable/disable toggle, three sound methods (completion, break, tick), graceful failure if audio files missing, dispose method for cleanup
- **Assets Structure**: Created `assets/sounds/` directory, added comprehensive README with required files (notification.mp3, break_complete.mp3, tick.mp3 optional), documented audio format specifications (MP3/OGG, 44.1kHz, 128kbps+), listed royalty-free sound sources, explained graceful failure behavior
- **Haptic Feedback (vibration package)**: Integrated in TimerControls widget, 50ms vibration for primary actions (Start/Pause/Resume), 30ms vibration for secondary actions (Reset/Skip), vibration package used instead of flutter_haptic_feedback for SDK compatibility
- **pubspec.yaml Updates**: Added assets section pointing to `assets/sounds/` directory, vibration: ^2.0.0 dependency already added in Phase 1

**Technical Decisions Made:**
- Vibration over flutter_haptic_feedback: Better SDK version compatibility
- Graceful audio failure: App continues without audio if files missing
- Separate vibration durations: 50ms feels substantial for primary, 30ms subtle for secondary
- Assets README: Comprehensive documentation for audio requirements
- No actual audio files committed: User can add their own preferred sounds
- AudioService tries to play, catches exceptions silently

**Files Modified:**
- `lib/features/timer/view/widgets/timer_controls.dart` - Added haptic feedback to all buttons
- `pubspec.yaml` - Added assets section
- `assets/sounds/README.md` - Created comprehensive audio documentation

**Architecture Notes:**
- Haptic feedback fires before event dispatch for immediate tactile response
- NotificationService and AudioService called from TimerBloc on session completion
- Audio failure doesn't break app flow - try/catch in AudioService
- Vibration is cross-platform via vibration package
- Assets are optional - app functional without audio files

---

### Code Quality Standards

- **Naming Conventions:** Follow Dart style guide
- **Documentation:** Document all public APIs
- **Error Handling:** Comprehensive try-catch blocks with meaningful errors
- **Formatting:** Use `dart format` before commits
- **Linting:** Follow rules in `analysis_options.yaml`

### Performance Considerations

- Minimize widget rebuilds using `const` constructors
- Use `BlocSelector` for granular state listening
- Lazy-load statistics data
- Optimize Hive queries with indexes

---

## Troubleshooting

### Common Issues

**Issue:** Dependencies not resolving  
**Solution:** Run `flutter pub get` and `flutter clean`

**Issue:** Build failures after adding dependencies  
**Solution:** Delete `pubspec.lock` and re-run `flutter pub get`

**Issue:** Hot reload not working  
**Solution:** Perform hot restart (R) or full restart

---

## Contributing Guidelines

1. Create feature branch from `main`
2. Follow the established architecture patterns
3. Write tests for new features
4. Update this documentation for significant changes
5. Run `flutter analyze` before committing
6. Update PROGRESS.md with completed tasks

---

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Document Status:** Initial version - will be updated as features are implemented.
