# Changelog

All notable changes to Mr. Pomodoro will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned Features
- iPad optimization with two-pane layouts
- Watch app for iOS
- Home screen widgets (iOS/Android)
- Export statistics as CSV
- Wear OS support

---

## [1.1.0] - Android - 2025-10-29

### Added
- 🎉 Android stable release (upgraded from beta)
- ✨ All features from iOS 1.1.0 ported to Android
- 📊 Enhanced statistics with improved data visualization
- 🎨 Complete theme system with all 5 themes
- 🔔 Improved notification system
- 📱 Better background timer handling

### Changed
- 🔧 Updated version from 1.0.0-beta to 1.1.0
- 🔧 Improved app performance and stability
- 🔧 Enhanced UI/UX consistency with iOS version
- 📱 Better Material3 design integration

### Fixed
- 🐛 Various bug fixes from beta feedback
- 🐛 Improved timer accuracy
- 🐛 Better memory management

---

## [1.1.0] - iOS - 2025-10-28

### Added
- ✨ Enhanced statistics with daily, weekly, and monthly views
- ✨ Improved streak tracking with visual indicators
- ✨ Additional theme customization options
- ✨ Better session history management
- ✨ Enhanced haptic feedback patterns
- 🎨 Refined UI animations and transitions
- 📊 More detailed productivity insights

### Changed
- 🔧 Optimized timer accuracy
- 🔧 Improved Focus Mode integration
- 🔧 Enhanced notification handling
- 🔧 Better memory management
- 📱 Updated minimum iOS version to 18.6

### Fixed
- 🐛 Fixed streak calculation across timezone changes
- 🐛 Resolved notification timing issues
- 🐛 Corrected statistics display for edge cases
- 🐛 Fixed theme switching animation glitches
- 🐛 Improved app stability during background transitions

---

## [1.0.0] - iOS - 2025-10-15

### Added
- 🎉 Initial App Store release
- ⏱️ Core Pomodoro timer functionality
- 📊 Basic statistics and session tracking
- 🎨 5 beautiful themes (Classic Red, Ocean Blue, Forest Green, Midnight Dark, Sunset Orange)
- 🌙 iOS Focus Mode integration
- 🔔 Smart notifications for session completion
- 📱 Siri Shortcuts support
- 🔒 Privacy-first design (all data local)
- 📈 Daily streak tracking
- ⚙️ Customizable timer durations
- 🎵 Optional sound notifications
- 📳 Haptic feedback support

### Features
- Customize focus duration (1-60 minutes)
- Customize short break duration (1-30 minutes)
- Customize long break duration (5-60 minutes)
- Set sessions before long break (2-10 sessions)
- Track completed sessions
- View productivity statistics
- Monitor daily streaks
- Enable/disable sounds
- Enable/disable haptics
- Enable/disable Focus Mode

---

## [1.0.0-beta] - Android - 2025-10-28

### Added
- 🎉 Android beta release
- ⏱️ Full Pomodoro timer implementation
- 📊 Complete statistics system
- 🎨 All 5 iOS themes ported
- 🌙 Do Not Disturb integration
- 🔔 Foreground service for background timer
- 🤖 App shortcuts for quick actions
- 🔒 Privacy-first architecture
- 📈 Streak tracking
- ⚙️ Complete settings customization
- 🎵 Notification sounds
- 📳 Vibration support

### Technical
- Built with Jetpack Compose
- MVVM + Clean Architecture
- Material3 design system
- Room database for session storage
- DataStore for settings
- Hilt dependency injection
- Comprehensive test coverage (60%+)
- 99% iOS feature parity

### Known Limitations
- No privacy policy screen (uses web link)
- No benefits/onboarding screen
- No app shortcuts implemented yet
- UI tests not complete

---

## Version History Summary

| Version | Platform | Release Date | Status |
|---------|----------|--------------|--------|
| 1.1.0 | Android | 2025-10-29 | ✅ Released |
| 1.1.0 | iOS | 2025-10-28 | ✅ Released |
| 1.0.0 | iOS | 2025-10-15 | ✅ Released |
| 1.0.0-beta | Android | 2025-10-28 | 🚧 Beta |

---

## Upgrade Notes

### Upgrading to 1.1.0 (iOS)

No breaking changes. All user data will be preserved automatically.

**New Features:**
- Enhanced statistics are available immediately
- New theme options in Settings
- Improved streak tracking

**Recommendations:**
- Review new statistics features in the Stats tab
- Check out the improved theme options
- Update iOS to 18.6 or later for best performance

### Upgrading to 1.0.0-beta (Android)

First Android release. No upgrade path needed.

**Installation:**
- Requires Android 8.0 (API 26) or later
- Grant notification permission for timer alerts
- Allow app to run in background for accurate timing

---

## Release Notes Format

We use the following categories for changes:

- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security improvements

---

## Platform-Specific Changes

### iOS

#### Build Information
- **Xcode:** 26.0.1+
- **Swift:** 5.0+
- **Min iOS:** 18.6
- **Target SDK:** iOS 18.6

#### App Store
- **Bundle ID:** com.example.pomodoro (placeholder)
- **Version:** 1.1.0
- **Build:** 3

### Android

#### Build Information
- **Android Studio:** Hedgehog+
- **Kotlin:** 1.9.21
- **Min SDK:** 26 (Android 8.0)
- **Target SDK:** 34 (Android 14)
- **Compile SDK:** 34

#### Play Store
- **Package:** com.pomodoro.timer
- **Version:** 1.1.0
- **Version Code:** 2

---

## Links

- **Repository:** https://github.com/avtansh-code/pomodoro_timer
- **Issues:** https://github.com/avtansh-code/pomodoro_timer/issues
- **Discussions:** https://github.com/avtansh-code/pomodoro_timer/discussions
- **Website:** https://pomodorotimer.in *(Coming Soon)*

---

## Contributors

Thank you to all contributors who helped make these releases possible!

**Main Developer:**
- Avtansh Gupta ([@avtansh-code](https://github.com/avtansh-code))

---

## Feedback

We welcome your feedback! Please:

- 🐛 Report bugs via [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- 💡 Suggest features via [GitHub Discussions](https://github.com/avtansh-code/pomodoro_timer/discussions)
- ⭐ Star the repository if you find it helpful
- 📧 Email us at support@pomodorotimer.in

---

*Last Updated: October 28, 2025*
