# 🍅 Mr. Pomodoro

> **Focus with ease. Flow with purpose.**

A beautiful, privacy-first Pomodoro timer for iOS, Android, macOS, and Windows. Stay focused, track your productivity, and build better work habits—all while keeping your data completely private.

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://www.apple.com/ios/)
[![Android](https://img.shields.io/badge/Android-13.0+-green.svg)](https://www.android.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.8+-02569B.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8+-0175C2.svg)](https://dart.dev/)
[![Tests](https://img.shields.io/badge/Tests-200+-brightgreen.svg)](flutter/pomodoro_timer/test/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)

---

## ✨ Features

- **Customizable Timer** - Adjust focus and break durations (1-120 minutes)
- **Smart Statistics** - Track productivity with daily, weekly, and monthly insights
- **5 Beautiful Themes** - Choose from Classic Red, Ocean Blue, Forest Green, Midnight Dark, and Sunset Orange
- **Smart Notifications** - Stay on track with timely, non-intrusive alerts
- **Haptic Feedback** - Subtle vibrations for timer events
- **Privacy First** - All data stays on your device, always
- **Cross-Platform** - Single codebase for iOS, Android, macOS, and Windows

---

## 📱 Download

### iOS
**Requirements:** iOS 17.0 or later

[Download on the App Store](https://apps.apple.com/in/app/mr-pomodoro/id6754535454)

### Android
**Requirements:** Android 13.0 (API 33) or later

[Get it on Google Play](https://play.google.com/store/apps/details?id=com.avtanshgupta.mr.pomodoro&pli=1)

### Desktop
macOS and Windows builds available via the build script.

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
├── flutter/pomodoro_timer/     # Flutter App (Cross-platform) - PRIMARY
│   ├── lib/                    # Source code
│   ├── test/                   # 200+ tests
│   ├── ios/                    # iOS configuration
│   ├── android/                # Android configuration
│   ├── macos/                  # macOS configuration
│   └── windows/                # Windows configuration
├── website/                    # Landing Page & Privacy Policy
│   └── www/
├── screenshots/                # App Screenshots
├── native_apps/                # Legacy Native Apps (Retired)
│   ├── iOS/                    # Native iOS App (SwiftUI)
│   └── android/                # Native Android App (Jetpack Compose)
├── .github/workflows/          # CI/CD Pipelines
├── build.sh                    # Build Automation Script
├── DEPLOYMENT.md               # Deployment Guide
└── LICENSE
```

---

## 🛠️ Tech Stack

### Flutter (Primary - Cross-Platform)

| Component | Technology |
|-----------|------------|
| **Language** | Dart 3.8+ |
| **Framework** | Flutter 3.8+ |
| **Architecture** | Clean Architecture + BLoC |
| **State Management** | flutter_bloc ^9.1.1 |
| **Navigation** | go_router ^17.0.0 |
| **Storage** | SharedPreferences + Hive |
| **Notifications** | flutter_local_notifications ^19.5.0 |
| **Charts** | fl_chart ^0.69.0 |
| **DI** | get_it ^9.2.0 |
| **Testing** | 200+ comprehensive tests |
| **Platforms** | iOS, Android, macOS, Windows |

**Key Features:**
- **🏗️ Clean Architecture** - Scalable, testable, and maintainable code structure
- **📦 BLoC State Management** - Predictable state handling with `flutter_bloc`
- **🧪 200+ Comprehensive Tests** - Full test coverage for models, services, and UI
- **🎨 Material Design 3** - Modern, beautiful UI following latest design guidelines
- **💾 Local Storage** - Hive + SharedPreferences for fast, reliable persistence
- **🔔 Notifications** - Local notifications for session completion
- **🎵 Audio & Haptics** - Sound effects and haptic feedback support

---

## 🚀 Quick Start

### Using Build Script (Recommended)

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer

# Default build (iOS debug - no prompts)
./build.sh

# Or specify options directly
./build.sh -m release -p android    # Android release
./build.sh -m release -p ios        # iOS release
./build.sh -m release -p macos      # macOS release
./build.sh -m release -p windows    # Windows release
./build.sh -m debug -p android -i   # Debug with install
./build.sh --interactive            # Interactive mode with prompts
```

### Manual Setup

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

# Run all tests
flutter test
```

📖 **[Flutter README](flutter/pomodoro_timer/README.md)** - Complete setup and architecture guide

---

## 📦 Building for Release

### Using Build Script

```bash
# Android (APK)
./build.sh -m release -p android

# iOS (IPA)
./build.sh -m release -p ios

# macOS
./build.sh -m release -p macos

# Windows
./build.sh -m release -p windows
```

### Manual Build

```bash
cd flutter/pomodoro_timer

# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS IPA (App Store)
flutter build ipa --release

# macOS
flutter build macos --release

# Windows
flutter build windows --release
```

📖 **[Full Deployment Guide](DEPLOYMENT.md)** - Complete instructions for publishing to App Store, Play Store, and desktop platforms

---

## 🧪 Testing

### Test Coverage (200+ Tests)

```bash
cd flutter/pomodoro_timer

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/timer/bloc/timer_bloc_test.dart
```

**Test Breakdown:**
- Core Models: 21+ tests
- Core Services: 21+ tests  
- Data Layer: 17+ tests
- BLoC/Cubit: 57+ tests
- Widget Tests: 13+ tests

### CI/CD Pipeline

Tests are automatically run via GitHub Actions on:
- Pull requests to `main`/`master`
- Pushes to `main`/`master`

The pipeline includes:
- Code formatting verification
- Static analysis
- Full test suite with coverage reporting

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

## 📁 Legacy Native Apps

The original native iOS and Android implementations have been retired and moved to the `native_apps/` folder. These are preserved for reference but are no longer actively maintained. The Flutter app is now the primary and only actively developed version.

### Legacy iOS (SwiftUI)
- **Location:** `native_apps/iOS/`
- **Built with:** Swift 5.0+, SwiftUI
- **Status:** Retired - Use Flutter app instead

### Legacy Android (Jetpack Compose)
- **Location:** `native_apps/android/`
- **Built with:** Kotlin 2.0+, Jetpack Compose
- **Status:** Retired - Use Flutter app instead

📖 **[Legacy iOS README](native_apps/iOS/README.md)** | 📖 **[Legacy Android README](native_apps/android/README.md)**

---

## 📄 License

This project is proprietary software. See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

Contributions are welcome! To get started:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Ensure code is formatted (`dart format .`)
4. Ensure tests pass (`flutter test`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

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

**Made with ❤️ using Flutter**

</div>