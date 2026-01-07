# Mr. Pomodoro - iOS (Legacy)

> ⚠️ **RETIRED**: This native iOS implementation has been retired. Please use the [Flutter app](../../flutter/pomodoro_timer/README.md) instead, which provides the same features with cross-platform support.

Native iOS implementation of the Mr. Pomodoro timer app built with SwiftUI for modern iOS devices.

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-6.0-red.svg)](https://developer.apple.com/xcode/swiftui/)
[![Status](https://img.shields.io/badge/Status-Retired-red.svg)]()

---

## ⚠️ Deprecation Notice

**This native iOS app is no longer actively maintained.** 

The project has transitioned to a **Flutter-based cross-platform implementation** which provides:
- Single codebase for iOS and Android
- Consistent UI/UX across platforms
- Easier maintenance and updates
- 200+ comprehensive tests

**➡️ Please use the [Flutter app](../../flutter/pomodoro_timer/README.md) for all new development and contributions.**

---

## Features (Historical Reference)

- **Full Pomodoro Timer** - Start, pause, resume, and reset functionality
- **Session Management** - Focus, short break, and long break sessions with auto-transition
- **Statistics Tracking** - View productivity metrics with daily, weekly, and all-time views
- **5 Themes** - Classic Red, Ocean Blue, Forest Green, Midnight Dark, Sunset Orange
- **Focus Mode Integration** - Native iOS Focus Mode suggestions during work sessions
- **Siri Shortcuts** - Voice control for timer operations
- **Notifications** - Local notifications for session completion
- **Background Support** - Timer continues running when app is backgrounded
- **Privacy First** - All data stored locally with UserDefaults and CoreData

---

## Screenshots

<table>
  <tr>
    <td><img src="../../screenshots/iPhone/focus_mode.png" alt="Focus Mode" width="200"/></td>
    <td><img src="../../screenshots/iPhone/short_break_mode.png" alt="Break Mode" width="200"/></td>
    <td><img src="../../screenshots/iPhone/stats_1.png" alt="Statistics" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><em>Focus Mode</em></td>
    <td align="center"><em>Break Time</em></td>
    <td align="center"><em>Your Progress</em></td>
  </tr>
</table>

---

## Prerequisites

- **Xcode**: 26.0.1 or later
- **iOS**: 17.0+ (Minimum deployment target)
- **Swift**: 5.0+
- **macOS**: Latest version for Xcode support

---

## Quick Start (For Reference Only)

### Clone and Build

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer/native_apps/iOS

# Open in Xcode
open PomodoroTimer.xcodeproj

# Build and run (⌘+R)
```

### Running on Device

1. Connect your iPhone or iPad
2. Select your device in Xcode
3. Configure signing in project settings
4. Build and run (⌘+R)
5. Grant notification permissions when prompted

---

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

```
native_apps/iOS/PomodoroTimer/
├── Models/              # Data models
│   ├── TimerSession.swift
│   ├── TimerSettings.swift
│   └── AppTheme.swift
│
├── Services/            # Business logic
│   ├── TimerManager.swift
│   ├── PersistenceManager.swift
│   ├── ThemeManager.swift
│   ├── FocusModeManager.swift
│   ├── HapticManager.swift
│   └── ScreenshotHelper.swift
│
├── Views/               # SwiftUI views
│   ├── MainTimerView.swift
│   ├── SettingsView.swift
│   ├── StatisticsView.swift
│   ├── ThemeSelectionView.swift
│   ├── PomodoroBenefitsView.swift
│   └── PrivacyPolicyView.swift
│
├── AppIntents/          # Siri integration
│   ├── StartPomodoroIntent.swift
│   ├── PauseTimerIntent.swift
│   ├── ResumeTimerIntent.swift
│   ├── ResetTimerIntent.swift
│   └── ShowStatisticsIntent.swift
│
└── Assets.xcassets/     # Images and colors
```

### Key Technologies

- **Language**: Swift 5.0+ with modern concurrency
- **UI**: SwiftUI for declarative interface
- **Architecture**: MVVM pattern
- **Storage**: UserDefaults for settings, CoreData for sessions
- **Reactive**: Combine framework for state management
- **Background**: Timer continues via background execution

---

## Siri Shortcuts (Historical)

The app supported the following Siri commands:

1. **"Start a Pomodoro Timer"** - Begin a new focus session
2. **"Pause Pomodoro Timer"** - Pause the current timer
3. **"Resume Pomodoro Timer"** - Resume a paused timer
4. **"Reset Pomodoro Timer"** - Reset to beginning
5. **"Show my Pomodoro Timer stats"** - Open statistics

---

## Focus Mode Integration (Historical)

The app integrated with iOS Focus Mode:

- **Automatic Suggestions** - App suggests enabling Focus Mode when starting work sessions
- **User Control** - Enable/disable in Settings
- **Privacy First** - App never automatically enables Focus Mode
- **Seamless Integration** - Works with your existing Focus configurations

---

## Configuration

### Build Settings

Key configurations in Xcode project:

```
IPHONEOS_DEPLOYMENT_TARGET = 17.0
SDKROOT = iphoneos
TARGETED_DEVICE_FAMILY = 1,2 (iPhone and iPad)
MARKETING_VERSION = 1.1.0
CURRENT_PROJECT_VERSION = 3
SWIFT_VERSION = 5.0
```

### Capabilities

Required capabilities configured in project:

- Background Modes (for timer)
- Push Notifications (local notifications)
- Siri (for shortcuts)

---

## Project Structure

```
native_apps/iOS/
├── PomodoroTimer/
│   ├── Models/
│   ├── Services/
│   ├── Views/
│   ├── AppIntents/
│   └── Assets.xcassets/
├── PomodoroTimer.xcodeproj/
├── PomodoroTimerUITests/
└── README.md
```

---

## Related Documentation

- **[Main README](../../README.md)** - Project overview
- **[Flutter App](../../flutter/pomodoro_timer/README.md)** - Active development (recommended)
- **[Legacy Android App](../android/README.md)** - Legacy Android implementation

---

## License

See [LICENSE](../../LICENSE) for details.

---

## Support

For the actively maintained Flutter version:
- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in

---

**Status**: Retired (Legacy)  
**Version**: 1.1.2 (Build 6)  
**Min iOS**: 17.0  
**Built with**: Xcode 26.0.1 / Swift 5.0+ / SwiftUI  
**Successor**: [Flutter App](../../flutter/pomodoro_timer/README.md)
