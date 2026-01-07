# 🍅 Mr. Pomodoro

> **Focus with ease. Flow with purpose.**

A beautiful, privacy-first Pomodoro timer for iOS and Android. Stay focused, track your productivity, and build better work habits—all while keeping your data completely private.

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://www.apple.com/ios/)
[![Android](https://img.shields.io/badge/Android-13.0+-green.svg)](https://www.android.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)

---

## 🆕 What's New

### Flutter Cross-Platform App ✨

We've introduced a **Flutter implementation** of Mr. Pomodoro! This cross-platform version brings all the features you love to multiple platforms with a single codebase:

- **🏗️ Clean Architecture** - Scalable, testable, and maintainable code structure
- **📦 BLoC State Management** - Predictable state handling with `flutter_bloc`
- **🧪 129 Comprehensive Tests** - Full test coverage for models, services, and UI
- **🎨 Material Design 3** - Modern, beautiful UI following latest design guidelines
- **💾 Local Storage** - Hive + SharedPreferences for fast, reliable persistence
- **🔔 Notifications** - Local notifications for session completion
- **🎵 Audio & Haptics** - Sound effects and haptic feedback support

**Quick Start:**
```bash
cd flutter/pomodoro_timer
flutter pub get
flutter run
```

---

## ✨ Features

- **Customizable Timer** - Adjust focus and break durations (1-120 minutes)
- **Smart Statistics** - Track productivity with daily, weekly, and monthly insights
- **5 Beautiful Themes** - Choose from Classic Red, Ocean Blue, Forest Green, Midnight Dark, and Sunset Orange
- **Focus Mode Integration** - Native Do Not Disturb support to minimize distractions (iOS)
- **Smart Notifications** - Stay on track with timely, non-intrusive alerts
- **Siri Shortcuts (iOS)** - Control your timer with voice commands
- **App Shortcuts (Android)** - Quick actions from your home screen
- **Privacy First** - All data stays on your device, always

---

## 📱 Download

### iOS
**Requirements:** iOS 17.0 or later

Coming soon to the App Store

### Android
**Requirements:** Android 13.0 (API 33) or later

[Get it on Google Play](https://play.google.com/store/apps/details?id=com.avtanshgupta.mr.pomodoro&pli=1)

---

## 🍅 What is the Pomodoro Technique?

The Pomodoro Technique is a proven time management method that breaks work into focused intervals (traditionally 25 minutes) separated by short breaks.

**How it works:**
1. Choose a task to focus on
2. Start a 25-minute focus session
3. Work without distractions until the timer ends
4. Take a 5-minute break
5. After 4 focus sessions, take a longer 15-minute break
6. Repeat and build momentum

This simple approach helps improve focus, reduce mental fatigue, increase productivity, and build sustainable work habits.

---

## 🏗️ Project Structure

```
Mr. Pomodoro/
├── iOS/                    # Native iOS App (SwiftUI)
│   └── PomodoroTimer/
├── android/                # Native Android App (Jetpack Compose)
│   └── app/
├── flutter/                # Flutter App (Cross-platform) ✨ NEW
│   └── pomodoro_timer/
├── website/                # Landing Page & Privacy Policy
│   └── www/
├── screenshots/            # App Screenshots
└── LICENSE
```

---

## 🛠️ Tech Stack

### iOS (Native)
| | |
|---|---|
| **Language** | Swift 5.0+ |
| **Framework** | SwiftUI |
| **Architecture** | MVVM |
| **Min Version** | iOS 17.0 |
| **Storage** | UserDefaults + CoreData |
| **Special** | Focus Mode, Siri Shortcuts |

### Android (Native)
| | |
|---|---|
| **Language** | Kotlin 2.0+ |
| **Framework** | Jetpack Compose |
| **Architecture** | MVVM + Clean Architecture |
| **Min Version** | Android 13.0 (API 33) |
| **Storage** | DataStore + Room |
| **Special** | App Shortcuts |

### Flutter (Cross-Platform) ✨
| | |
|---|---|
| **Language** | Dart 3.10+ |
| **Framework** | Flutter 3.10+ |
| **Architecture** | Clean Architecture + BLoC |
| **State Management** | flutter_bloc |
| **Storage** | SharedPreferences + Hive |
| **Testing** | 129 comprehensive tests |
| **Platforms** | iOS, Android |

---

## 🚀 Quick Start

### Flutter Development (Recommended) ✨

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer/flutter/pomodoro_timer

# Install dependencies
flutter pub get

# iOS specific setup
cd ios && pod install && cd ..

# Run the app
flutter run

# Run all 129 tests
flutter test
```

📖 **[Flutter README](flutter/pomodoro_timer/README.md)** - Complete setup and architecture guide

### iOS Development

```bash
cd iOS
open PomodoroTimer.xcodeproj
# Build and run in Xcode (⌘+R)
```

📖 **[iOS README](iOS/README.md)** - Complete iOS setup guide

### Android Development

```bash
cd android
./gradlew build
./gradlew installDebug
```

📖 **[Android README](android/README.md)** - Complete Android setup guide

---

## 📦 Building for Release

### Flutter

```bash
cd flutter/pomodoro_timer

# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS IPA (App Store)
flutter build ipa --release
```

### Native iOS

```bash
# Archive in Xcode: Product > Archive
# Then distribute via App Store Connect
```

### Native Android

```bash
cd android
./gradlew assembleRelease
./gradlew bundleRelease
```

---

## 🧪 Testing

### Flutter (129 Tests)

```bash
cd flutter/pomodoro_timer

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/timer/bloc/timer_bloc_test.dart
```

**Test Coverage:**
- Core Models: 21 tests
- Core Services: 21 tests  
- Data Layer: 17 tests
- BLoC/Cubit: 57 tests
- Widget Tests: 13 tests

### iOS

```bash
# In Xcode: ⌘+U
# Or via command line:
xcodebuild test -scheme PomodoroTimer -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Android

```bash
cd android
./gradlew test
```

---

## 🔒 Privacy & Security

**Your privacy is our priority.** Mr. Pomodoro is designed with privacy at its core:

- **No data collection** - We don't collect any personal information
- **No analytics** - No tracking or usage statistics
- **No third-party services** - No external connections
- **Local storage only** - All data stays on your device
- **100% Offline** - No internet connection required

Read our complete [Privacy Policy](https://pomodorotimer.in/privacy.html).

---

## 🌐 Website

**Location:** `website/`

The project includes a landing page with app features, download links, and privacy policy.

📖 **[Website README](website/README.md)** | 🔗 **[pomodorotimer.in](https://pomodorotimer.in)**

---

## 📄 License

This project is proprietary software. See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

Contributions are welcome! To get started:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📞 Support

- **Bug Reports:** [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Feature Requests:** [GitHub Discussions](https://github.com/avtansh-code/pomodoro_timer/discussions)
- **Email:** support@pomodorotimer.in

---

## 👨‍💻 Developer

Created by **[Avtansh Gupta](https://github.com/avtansh-code)**

- 🌐 Website: [pomodorotimer.in](https://pomodorotimer.in)
- 🐙 GitHub: [@avtansh-code](https://github.com/avtansh-code)

---

<div align="center">

**Made with ❤️ using SwiftUI, Jetpack Compose & Flutter**

</div>