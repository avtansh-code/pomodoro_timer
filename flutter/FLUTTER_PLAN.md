# Flutter Pomodoro Timer App Development Plan

This document outlines a detailed plan for creating a Pomodoro timer application using Flutter. The goal is to replicate the functionality of the existing native iOS and Android applications while adhering to modern Flutter development best practices. The plan is designed to be executed by a coding agent.

## 1. Non-Functional Requirements

*   **UI:** Simple, clean, and intuitive user interface.
*   **Design:** Follow the latest design patterns for both iOS (Cupertino) and Android (Material You) where appropriate, but maintain a consistent brand identity.
*   **Performance:** The app should be lightweight and fast, with minimal resource consumption.
*   **Code Quality:** The codebase should be well-structured, maintainable, and testable.

## 2. Core Functional Requirements

Based on the existing applications, the Flutter app will have the following features:

*   **Pomodoro Timer:**
    *   Standard Pomodoro timer with configurable work, short break, and long break durations.
    *   States: running, paused, and stopped.
    *   Visual and audible notifications upon completion of a session.
    *   Haptic feedback on user interactions.
*   **Session Management:**
    *   Track the number of completed Pomodoro sessions.
    *   Automatically switch between work and break sessions.
    *   A configurable number of work sessions before a long break.
*   **Statistics:**
    *   Display historical data of completed sessions.
    *   Visualize progress over time (daily, weekly, monthly).
*   **Settings:**
    *   Customize timer durations.
    *   Adjust the number of sessions before a long break.
    *   Choose from different app themes (e.g., light, dark, custom colors).
    *   Toggle notifications, sounds, and haptics.
*   **Onboarding/Information:**
    *   A screen explaining the benefits of the Pomodoro Technique.
*   **Privacy:**
    *   A simple privacy policy screen.

## 3. Technology Stack

*   **Framework:** Flutter
*   **State Management:** BLoC / Cubit
*   **Persistence:** `shared_preferences` for settings, and `hive` or `sqflite` for statistics data.
*   **Notifications:** `flutter_local_notifications`
*   **Audio:** `audioplayers` for notification sounds.
*   **Haptics:** `flutter_haptic_feedback`
*   **Routing:** `go_router`
*   **Testing:** `flutter_test` for unit and widget tests, and `integration_test` for end-to-end tests.

## 4. Project Structure

The project will follow a feature-driven directory structure:

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── app_router.dart
│   └── theme/
│       ├── app_theme.dart
│       └── themes.dart
├── core/
│   ├── di/
│   │   └── service_locator.dart
│   ├── models/
│   │   ├── timer_session.dart
│   │   └── timer_settings.dart
│   └── services/
│       ├── persistence_service.dart
│       ├── notification_service.dart
│       └── audio_service.dart
├── features/
│   ├── timer/
│   │   ├── bloc/
│   │   │   ├── timer_bloc.dart
│   │   │   ├── timer_event.dart
│   │   │   └── timer_state.dart
│   │   └── view/
│   │       ├── main_timer_screen.dart
│   │       └── widgets/
│   │           ├── timer_display.dart
│   │           └── timer_controls.dart
│   ├── settings/
│   │   ├── bloc/
│   │   │   ├── settings_cubit.dart
│   │   │   └── settings_state.dart
│   │   └── view/
│   │       └── settings_screen.dart
│   ├── statistics/
│   │   ├── bloc/
│   │   │   ├── statistics_cubit.dart
│   │   │   └── statistics_state.dart
│   │   ├── data/
│   │   │   └── statistics_repository.dart
│   │   └── view/
│   │       └── statistics_screen.dart
│   ├── onboarding/
│   │   └── view/
│   │       └── pomodoro_benefits_screen.dart
│   └── privacy/
│       └── view/
│           └── privacy_policy_screen.dart
└── generated/
    └── ... (for generated files like l10n)
```

## 5. Development Plan - Step-by-Step

### Phase 1: Project Setup and Core Models

1.  **Initialize Flutter Project:** Create a new Flutter project named `pomodoro_timer`.
2.  **Add Dependencies:** Add the following dependencies to `pubspec.yaml`: `flutter_bloc`, `equatable`, `shared_preferences`, `hive`, `hive_flutter`, `flutter_local_notifications`, `audioplayers`, `go_router`, `flutter_haptic_feedback`.
3.  **Setup Project Structure:** Create the directories as defined in the "Project Structure" section.
4.  **Define Models:**
    *   Create `TimerSettings` model (`core/models/timer_settings.dart`) with properties for work duration, short break duration, long break duration, and sessions before long break.
    *   Create `TimerSession` model (`core/models/timer_session.dart`) with properties for session type (work, short break, long break), start time, end time, and duration.
5.  **Service Locator:** Set up a simple service locator (e.g., using `get_it`) in `core/di/service_locator.dart`.

### Phase 2: Core Timer Logic and Main UI

1.  **Timer BLoC:**
    *   Create `TimerBloc` (`features/timer/bloc/timer_bloc.dart`) to manage the timer state (initial, running, paused, finished).
    *   Implement events: `TimerStarted`, `TimerPaused`, `TimerResumed`, `TimerReset`.
    *   The BLoC will handle the countdown logic using a `Ticker` or `Stream.periodic`.
2.  **Main Timer Screen:**
    *   Create `MainTimerScreen` (`features/timer/view/main_timer_screen.dart`).
    *   Use a `BlocProvider` to provide the `TimerBloc`.
    *   Create `TimerDisplay` widget to show the remaining time.
    *   Create `TimerControls` widget with buttons for start, pause, and reset.
    *   The UI should update based on the `TimerState`.

### Phase 3: Settings

1.  **Persistence Service:**
    *   Create `PersistenceService` (`core/services/persistence_service.dart`) with methods to save and retrieve `TimerSettings` using `shared_preferences`.
2.  **Settings Cubit:**
    *   Create `SettingsCubit` (`features/settings/bloc/settings_cubit.dart`).
    *   The cubit will load the initial settings from `PersistenceService`.
    *   It will have methods to update each setting, which will also save the new value to `PersistenceService`.
3.  **Settings Screen:**
    *   Create `SettingsScreen` (`features/settings/view/settings_screen.dart`).
    *   The screen will display the current settings and allow the user to modify them.
    *   Use `BlocBuilder` to rebuild the UI when settings change.

### Phase 4: Statistics

1.  **Hive Setup:** Initialize Hive in `main.dart`.
2.  **Statistics Repository:**
    *   Create `StatisticsRepository` (`features/statistics/data/statistics_repository.dart`).
    *   It will use Hive to store and retrieve `TimerSession` objects.
    *   Implement methods like `addSession(TimerSession session)` and `getAllSessions()`.
3.  **Statistics Cubit:**
    *   Create `StatisticsCubit` (`features/statistics/bloc/statistics_cubit.dart`).
    *   It will load the statistics from `StatisticsRepository`.
    *   Provide methods to filter statistics (e.g., by date).
4.  **Statistics Screen:**
    *   Create `StatisticsScreen` (`features/statistics/view/statistics_screen.dart`).
    *   Display the session history in a list.
    *   (Optional) Add charts to visualize the data.

### Phase 5: Notifications, Audio, and Haptics

1.  **Notification Service:**
    *   Create `NotificationService` (`core/services/notification_service.dart`) to handle local notifications.
    *   Implement methods to show a notification when a timer session ends.
2.  **Audio Service:**
    *   Create `AudioService` (`core/services/audio_service.dart`) to play sounds.
    *   Integrate with `TimerBloc` to play a sound on session completion.
3.  **Haptic Feedback:**
    *   Use the `flutter_haptic_feedback` package to add tactile feedback to button presses and other interactions.

### Phase 6: Theming and Navigation

1.  **App Theme:**
    *   Define different themes in `app/theme/themes.dart` (e.g., light, dark).
    *   Create `AppTheme` class (`app/theme/app_theme.dart`) to manage the current theme.
    *   The theme should be selectable in the settings screen and persisted.
2.  **Routing:**
    *   Configure `go_router` in `app/app_router.dart` to handle navigation between screens.
    *   Define routes for the main timer, settings, statistics, and other screens.

### Phase 7: Final Touches and Testing

1.  **Onboarding and Privacy Screens:**
    *   Create `PomodoroBenefitsScreen` and `PrivacyPolicyScreen`.
2.  **Testing:**
    *   Write unit tests for BLoCs, Cubits, and services.
    *   Write widget tests for the main UI components.
    *   Write integration tests to verify the end-to-end user flows.
3.  **Platform-Specific Polish:**
    *   Ensure the app looks and feels native on both iOS and Android.
    *   Test on a variety of device sizes and resolutions.
4.  **App Icons and Splash Screen:**
    *   Create and add app icons for both platforms.
    *   Design and implement a splash screen.
5.  **Build and Release:**
    *   Prepare the app for release on the Apple App Store and Google Play Store.

This plan provides a comprehensive roadmap for developing the Pomodoro timer app. Each phase can be broken down into smaller tasks for implementation by a coding agent.