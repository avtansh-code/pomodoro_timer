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

#### Phase 2: Core Timer Logic
**Status:** Not Started  
**Planned Approach:**
- Implement timer using `Stream.periodic` for countdown
- BLoC will manage three states: initial, running, paused, finished
- Timer accuracy will be maintained using system time checks

---

#### Phase 3: Settings
**Status:** Not Started  
**Planned Approach:**
- Use Cubit (simpler than BLoC) for settings management
- Immediate persistence on every setting change
- Default values defined in model

---

#### Phase 4: Statistics
**Status:** Not Started  
**Planned Approach:**
- Hive will store sessions with timestamp-based keys
- Repository pattern for data access abstraction
- Support for date-range queries

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
