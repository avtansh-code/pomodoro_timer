# 🍅 Mr. Pomodoro

> **Focus with ease. Flow with purpose.**

A beautiful, privacy-first Pomodoro timer that helps you stay focused and productive. Available on iOS and Android.

[![iOS](https://img.shields.io/badge/iOS-18.6+-blue.svg)](https://www.apple.com/ios/)
[![Android](https://img.shields.io/badge/Android-8.0+-green.svg)](https://www.android.com/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
[![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org/)
[![Kotlin](https://img.shields.io/badge/Kotlin-1.9+-purple.svg)](https://kotlinlang.org/)

---

## ✨ Features

- ⏱️ **Customizable Timer** - Adjust focus and break durations to match your workflow
- 📊 **Smart Statistics** - Track your productivity with daily, weekly, and monthly insights
- 🎨 **5 Beautiful Themes** - Personalize your experience with stunning color schemes
- 🌙 **Focus Mode** - Minimize distractions with platform-native Do Not Disturb integration
- 🔔 **Smart Notifications** - Stay informed without being overwhelmed
- 📱 **Siri Shortcuts** (iOS) - Control your timer hands-free with voice commands
- 🤖 **App Shortcuts** (Android) - Quick actions from your home screen
- 🔒 **Privacy First** - All your data stays on your device, always

---

## 📸 Screenshots

<table>
  <tr>
    <td><img src="screenshots/iPhone/focus_mode.png" alt="Focus Mode" width="200"/></td>
    <td><img src="screenshots/iPhone/short_break_mode.png" alt="Break Mode" width="200"/></td>
    <td><img src="screenshots/iPhone/stats_1.png" alt="Statistics" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><em>Focus Mode</em></td>
    <td align="center"><em>Break Time</em></td>
    <td align="center"><em>Your Progress</em></td>
  </tr>
</table>

---

## 🚀 Download

### iOS
**Requirements:** iOS 18.6 or later

[Download on the App Store](#) *(Coming Soon)*

### Android
**Requirements:** Android 8.0 (API 26) or later

[Get it on Google Play](#) *(Coming Soon)*

---

## 🎯 What is the Pomodoro Technique?

The Pomodoro Technique is a time management method that uses a timer to break work into focused intervals (traditionally 25 minutes), separated by short breaks. This approach helps:

- ✅ Improve focus and concentration
- ✅ Reduce mental fatigue
- ✅ Increase productivity
- ✅ Build better work habits
- ✅ Track time spent on tasks

### How It Works

1. **Choose a task** you want to focus on
2. **Start a 25-minute** focus session
3. **Work without distractions** until the timer ends
4. **Take a 5-minute break** to recharge
5. **After 4 focus sessions**, take a longer 15-minute break
6. **Repeat** and watch your productivity soar!

---

## 🏗️ Project Structure

```
Mr. Pomodoro/
├── iOS/                    # iOS App (SwiftUI)
│   ├── PomodoroTimer/      # Source code
│   ├── docs/               # iOS-specific documentation
│   └── README.md           # iOS setup & build guide
│
├── android/                # Android App (Jetpack Compose)
│   ├── app/                # Source code
│   └── README.md           # Android setup & build guide
│
├── website/                # Marketing Website
│   ├── www/                # Static site files
│   └── README.md           # Deployment guide
│
├── screenshots/            # App Store screenshots
│   ├── iPhone/
│   └── iPad/
│
├── docs/                   # Documentation
│   └── ARCHITECTURE.md     # Technical architecture overview
│
└── PrivacyPolicy.md        # Privacy policy (shared)
```

---

## 🛠️ Tech Stack

### iOS
- **Language:** Swift 5.0+
- **Framework:** SwiftUI
- **Architecture:** MVVM
- **Min Version:** iOS 18.6
- **Features:** App Intents, Focus Mode, Siri Shortcuts

### Android
- **Language:** Kotlin 1.9+
- **Framework:** Jetpack Compose
- **Architecture:** MVVM + Clean Architecture
- **Min Version:** Android 8.0 (API 26)
- **Features:** Material3, Room, DataStore, Hilt

### Website
- **Stack:** HTML5, CSS3, Vanilla JavaScript
- **Hosting:** Static (GitHub Pages, Netlify, Vercel)

---

## 📚 Documentation

### For Users
- **[Privacy Policy](PrivacyPolicy.md)** - How we handle your data (spoiler: we don't collect any!)
- **[iOS User Guide](iOS/docs/USER_GUIDE.md)** - Complete guide for iOS users
- **Website:** [pomodorotimer.in](https://pomodorotimer.in) *(Coming Soon)*

### For Developers
- **[iOS Setup](iOS/README.md)** - Build & run the iOS app
- **[Android Setup](android/README.md)** - Build & run the Android app
- **[Architecture](docs/ARCHITECTURE.md)** - Technical design & decisions
- **[Contributing Guide](CONTRIBUTING.md)** - How to contribute
- **[Code of Conduct](CODE_OF_CONDUCT.md)** - Community guidelines

### For App Store Submission
- **[iOS Submission Guide](iOS/docs/APP_STORE_SUBMISSION.md)** - App Store requirements
- **[iOS Design System](iOS/docs/DESIGN_SYSTEM.md)** - UI/UX guidelines
- **[Screenshot Guide](iOS/docs/SCREENSHOT_PREPARATION.md)** - App Store screenshots

---

## 🏃 Quick Start

### iOS Development

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer/iOS

# Open in Xcode
open PomodoroTimer.xcodeproj

# Build and run (⌘+R)
```

See **[iOS/README.md](iOS/README.md)** for detailed instructions.

### Android Development

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer/android

# Build the project
./gradlew build

# Run tests
./gradlew test

# Install on device
./gradlew installDebug
```

See **[android/README.md](android/README.md)** for detailed instructions.

---

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guide](CONTRIBUTING.md) to get started.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure your PR:
- ✅ Follows our coding standards
- ✅ Includes appropriate tests
- ✅ Updates documentation as needed
- ✅ Has a clear description of changes

---

## 🔒 Privacy & Security

**Your privacy is our priority.** Mr. Pomodoro is designed to be completely private:

- ❌ **No data collection** - We don't collect any personal information
- ❌ **No analytics** - No tracking or usage statistics
- ❌ **No third-party services** - No external connections
- ✅ **Local storage only** - All data stays on your device
- ✅ **Open source-friendly** - Transparent about our practices

Read our complete **[Privacy Policy](PrivacyPolicy.md)**.

For security concerns, see **[SECURITY.md](SECURITY.md)**.

---

## 📄 License

This project is proprietary software. See [LICENSE](LICENSE) for details.

**Note:** The code is available for review and learning purposes, but commercial use, redistribution, or derivative works require explicit permission.

---

## 🎨 Branding

**App Name:** Mr. Pomodoro  
**Tagline:** Focus with ease. Flow with purpose.  
**Theme:** Mindful + Modern  
**Brand Colors:**
- Classic Red: `#ED4242`
- Ocean Blue: `#3399DB`
- Forest Green: `#339966`
- Midnight Dark: `#736BC2`
- Sunset Orange: `#FA8033`

---

## 📊 Project Stats

<table>
  <tr>
    <td><strong>iOS Version</strong></td>
    <td>1.1.0 (Build 3)</td>
  </tr>
  <tr>
    <td><strong>Android Version</strong></td>
    <td>1.0.0-beta</td>
  </tr>
  <tr>
    <td><strong>Lines of Code</strong></td>
    <td>~15,000+</td>
  </tr>
  <tr>
    <td><strong>Platforms</strong></td>
    <td>iOS, Android, Web</td>
  </tr>
  <tr>
    <td><strong>Test Coverage</strong></td>
    <td>60%+</td>
  </tr>
</table>

---

## 🗺️ Roadmap

### Version 1.0 ✅
- [x] Core Pomodoro timer functionality
- [x] Customizable durations and sessions
- [x] Statistics and streak tracking
- [x] Multiple theme support
- [x] Focus mode integration
- [x] Local data persistence

### Version 1.1 🚧
- [ ] iPad optimization with two-pane layouts
- [ ] Watch app for iOS
- [ ] Home screen widgets
- [ ] Export statistics as CSV
- [ ] Additional theme customization

### Version 2.0 🔮
- [ ] Optional cloud sync
- [ ] Task management integration
- [ ] Team/group sessions
- [ ] Advanced analytics
- [ ] Wear OS support

---

## 👨‍💻 Developer

Created with ❤️ and ☕ by **[Avtansh Gupta](https://github.com/avtansh-code)**

- 🌐 Website: [pomodorotimer.in](https://pomodorotimer.in)
- 📧 Support: support@pomodorotimer.in
- 🐛 Issues: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)

---

## 🙏 Acknowledgments

- Inspired by Francesco Cirillo's Pomodoro Technique
- Built with modern development practices
- Community feedback and suggestions
- Open-source libraries and tools

---

## 📮 Support & Contact

- **Bug Reports:** [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Feature Requests:** [GitHub Discussions](https://github.com/avtansh-code/pomodoro_timer/discussions)
- **Email:** support@pomodorotimer.in
- **Response Time:** Within 48 hours

---

<div align="center">

**⭐ If you find Mr. Pomodoro helpful, please star this repository!**

**Made with ❤️ using SwiftUI & Jetpack Compose**

*Last Updated: October 28, 2025*

</div>
