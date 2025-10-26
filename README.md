# 🍅 Mr. Pomodoro - iOS App

A clean, customizable, and user-friendly Pomodoro timer built with SwiftUI for iOS. This app helps boost productivity using the proven Pomodoro Technique with flexible configuration options and elegant design.

## ✨ Features

### 🕒 Core Functionality
- **Start, Pause, and Reset** - Full control over your Pomodoro sessions
- **Auto-transition** - Optional automatic transitions between work and break sessions
- **Multiple Session Types**:
  - Focus sessions (default: 25 minutes)
  - Short breaks (default: 5 minutes)
  - Long breaks (default: 15 minutes, after 4 focus sessions)

### 🎛️ Customization
- **Adjustable Durations** - Customize focus, short break, and long break durations (1-120 minutes)
- **Configurable Cycles** - Set the number of sessions before a long break (2-10)
- **Auto-Start Options** - Toggle auto-start for breaks and focus sessions
- **Theme Selection** - Choose from 5 beautiful themes:
  - Classic Red (Default)
  - Ocean Blue
  - Forest Green
  - Midnight Dark
  - Sunset Orange
- **Dynamic Theme Switching** - Change themes instantly with live preview
- **Dark Mode Support** - All themes adapt perfectly to light and dark mode
- **Notification Controls** - Enable/disable sounds, haptics, and push notifications

### ☁️ iCloud Sync (Optional)
- **Cross-Device Sync** - Seamlessly sync settings and session history across all your Apple devices
- **Private & Secure** - Data stored in your private iCloud account, encrypted by Apple
- **Automatic Sync** - Settings sync automatically; sessions sync daily or on-demand
- **Manual Control** - Sync now button and ability to enable/disable sync anytime
- **Conflict Resolution** - Smart merging of data from multiple devices
- **Data Management** - View sync status, last sync time, and delete cloud data from Settings

### 🌙 Focus Mode Integration
- **iOS Focus Mode** - Suggests enabling Focus Mode when starting focus sessions
- **Minimize Distractions** - Automatically helps block notifications during work sessions
- **Seamless Integration** - Works with your existing Focus Mode configurations
- **User Control** - Enable/disable integration with toggle in Settings
- **Bidirectional Sync** - Optional sync with iOS Focus status (iOS 16.1+)
- **Privacy-First** - Suggestions only, app never automatically controls Focus Mode

### 📊 Statistics & Tracking
- **Daily Statistics** - Track completed sessions and focus time for today
- **Weekly Overview** - View your productivity over the past 7 days
- **Streak Tracking** - Monitor your consecutive days of productivity
- **Session History** - Detailed breakdown of focus time vs. break time
- **Motivational Quotes** - Random inspirational messages to keep you motivated

### 🔔 Notifications & Feedback
- **Local Notifications** - Get notified when sessions complete (even when app is backgrounded)
- **Sound Alerts** - Audio feedback on session completion
- **Haptic Feedback** - Tactile response for better UX
- **Background Support** - Timer continues running when app is in background

### ♿ Accessibility
- **VoiceOver Support** - Full screen reader compatibility
- **Accessibility Labels** - Descriptive labels for all interactive elements
- **Dynamic Type** - Respects system font size preferences
- **High Contrast** - Clear visual hierarchy and color usage

## 🏗️ Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern with a clean, modular structure:

```
PomodoroTimer/
├── Models/
│   ├── TimerSession.swift      # Session data model
│   ├── TimerSettings.swift     # User preferences model
│   └── AppTheme.swift          # Theme definitions and typography
├── Services/
│   ├── TimerManager.swift      # Core timer logic and state management
│   ├── PersistenceManager.swift # Data persistence (UserDefaults)
│   ├── ThemeManager.swift      # Theme management and persistence
│   ├── CloudSyncManager.swift  # iCloud sync functionality
│   └── FocusModeManager.swift  # iOS Focus Mode integration
├── Views/
│   ├── MainTimerView.swift     # Main timer interface
│   ├── SettingsView.swift      # Configuration screen
│   ├── StatisticsView.swift    # Stats and analytics
│   └── PrivacyPolicyView.swift # Privacy policy display
├── ContentView.swift           # Root view with TabView navigation
└── PomodoroTimerApp.swift      # App entry point with lifecycle handling
```

## 🚀 Getting Started

### Prerequisites
- **Xcode 26.0.1** (or later)
- **iOS 18.0+** (Minimum deployment target)
- **Swift 5.0+** with modern concurrency

### Installation

1. **Clone or open the project**:
   ```bash
   cd /path/to/PomodoroTimer
   open PomodoroTimer.xcodeproj
   ```

2. **Build and Run**:
   - Select a target device or simulator
   - Press `⌘ + R` to build and run
   - Grant notification permissions when prompted

3. **Testing on Device**:
   - Connect your iPhone/iPad
   - Select your device in Xcode
   - Build and run (you may need to configure signing)

## 📱 Usage

### Starting a Session
1. Tap the **Start** button on the main screen
2. The circular progress indicator shows your progress
3. The timer counts down until the session completes

### Pausing & Resuming
- Tap **Pause** to pause the current session
- Tap **Resume** to continue from where you left off

### Resetting
- Tap **Reset** to return to the beginning of the current session

### Skipping Sessions
- Tap **Skip to [Next Session]** to move to the next phase

### Configuring Settings
1. Tap the **gear icon** in the top-right
2. Adjust durations, auto-start preferences, notifications, and theme
3. Tap **Done** to save changes

### Viewing Statistics
1. Tap the **chart icon** in the top-left
2. View your streak, daily stats, and weekly progress
3. See motivational quotes to stay inspired

## 📸 Screenshots

### Focus Session
![Focus Timer](screenshots/focus.png)

The main timer interface during a focus session. Features a clean, minimalist design with a circular progress indicator, large countdown display, and intuitive controls. The red color scheme helps maintain focus and indicates an active work session.

### Break Time
![Break Timer](screenshots/break.png)

Break session view with a calming green color scheme. The interface clearly shows when you're on a break, encouraging you to step away and recharge. Auto-transition options help maintain your productivity rhythm without manual intervention.

### Statistics Dashboard
![Statistics View 1](screenshots/stats_1.png)

Comprehensive statistics showing your productivity metrics including current streak, today's completed sessions, total focus time, and a weekly overview chart. Track your progress and stay motivated with daily performance insights.

![Statistics View 2](screenshots/stats_2.png)

Additional statistics features displaying your session breakdown, focus vs. break time ratio, and inspirational quotes to keep you motivated. The visual data representation helps you understand your productivity patterns.

## 📱 iOS 18 & iPhone 17 Support

This app is **fully optimized for iOS 18** and the **iPhone 17** lineup:

### iOS 18 Features
- ✅ **CloudKit API Updates** - Uses iOS 18's new Result-based fetch APIs
- ✅ **Swift 6 Ready** - Modern concurrency patterns with strict sendability
- ✅ **Latest SDK** - Built with iOS SDK 26.0 (Xcode 26.0.1)
- ✅ **Modern SwiftUI** - Leverages iOS 18 SwiftUI enhancements
- ✅ **App Intents** - Full Siri shortcuts integration with iOS 18 improvements

### iPhone 17 Compatibility
- 📱 **iPhone 17** - Full support for standard model
- 📱 **iPhone 17 Pro** - Optimized for Pro features
- 📱 **iPhone 17 Pro Max** - Large screen layouts
- 📱 **iPhone Air** - Lightweight experience optimized

### Device Requirements
- **Minimum iOS**: 18.0
- **Deployment Target**: iOS 18.0
- **SDK Version**: iOS 26.0
- **Xcode**: 26.0.1 or later
- **Supported Platforms**: iPhone and iPad

### Build Configuration
```
IPHONEOS_DEPLOYMENT_TARGET = 18.0
SDKROOT = auto (iOS 26.0)
TARGETED_DEVICE_FAMILY = 1,2 (iPhone and iPad)
MARKETING_VERSION = 1.0.2
CURRENT_PROJECT_VERSION = 3
SWIFT_VERSION = 5.0
SWIFT_APPROACHABLE_CONCURRENCY = YES
SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor
```

## � Technical Details

### Data Persistence
- **UserDefaults** - Stores user settings and session history
- **Automatic Save** - Settings saved when app enters background
- **State Restoration** - Timer state preserved across app launches

### Background Behavior
- Timer continues counting when app is backgrounded
- Local notifications scheduled for session completion
- Time elapsed calculated accurately when returning to foreground

### Notifications
- Uses `UserNotifications` framework
- Permission requested on first launch
- Custom messages for each session type completion

### Audio & Haptics
- System sound for completion alerts (AudioServicesPlaySystemSound)
- UINotificationFeedbackGenerator for success haptics
- AVAudioSession configured for playback

## 🎨 Design Philosophy

- **Minimalist UI** - Focus on the timer, minimize distractions
- **Modern Design System** - Clean, rounded design language with depth
- **Color-Coded Sessions** - Visual distinction between session types with gradient backgrounds
- **Modular Theming** - 5 predefined themes with consistent design tokens
- **Smooth Animations** - Spring animations and haptic feedback (0.3-0.6s durations)
- **Apple HIG Compliance** - Follows iOS Human Interface Guidelines
- **Accessibility First** - WCAG AA compliant, VoiceOver support, Dynamic Type
- **Adaptive Interface** - TabView navigation for better discoverability

### 🎨 Theming System

The app features a comprehensive theming system that provides:

- **5 Beautiful Themes** - Each with unique color palettes and gradients
- **Persistent Preferences** - Theme selection saved using `@AppStorage`
- **Environment Propagation** - Themes flow through SwiftUI environment
- **Typography Scale** - Consistent font hierarchy (SF Rounded)
- **Design Tokens** - Spacing (4-32pt), border radius (8-20pt), shadows
- **Theme Preview Cards** - Visual theme selection in Settings
- **Full Dark Mode** - All themes optimized for light and dark appearances

For detailed design specifications, see **[UI Redesign Guide](docs/UI_REDESIGN_GUIDE.md)**

### 🖼️ Launch Screen

The app features a modern, professional launch screen with:

- **Brand Color Background** - Classic red (#ED4242) matching app theme
- **Circular Design Element** - Semi-transparent white circle with tomato icon 🍅
- **App Branding** - "Mr. Pomodoro" in bold, clean typography
- **Tagline** - "Focus • Breathe • Achieve" reinforcing the app's purpose
- **Version Display** - Subtle version indicator at bottom
- **Universal Sizing** - Optimized for all iPhone and iPad devices
- **Storyboard-Based** - Configured via `LaunchScreen.storyboard`

## �🗣️ Siri Shortcuts

Control your Pomodoro timer hands-free using Siri or the Shortcuts app!

### Available Commands

- **"Start a Pomodoro Timer"** - Begins a new focus session
- **"Pause Pomodoro Timer"** - Pauses the current timer
- **"Resume Pomodoro Timer"** - Resumes a paused timer
- **"Reset Pomodoro Timer"** - Resets the timer to the beginning
- **"Show my Pomodoro Timer stats"** - Opens your statistics

### How to Use

1. **With Siri**: Simply say "Hey Siri" followed by any command above
2. **Shortcuts App**: 
   - Open the Shortcuts app
   - Tap the "+" button to create a new shortcut
   - Search for "Pomodoro Timer" to see all available actions
   - Add actions to your custom workflows

### Custom Duration

You can also start a Pomodoro with a custom duration:
- Use the Start Pomodoro action in Shortcuts
- Specify the duration in minutes (optional parameter)

### Example Shortcuts

- **Morning Routine**: Start Pomodoro → Set Focus Mode → Open Calendar
- **Deep Work**: Start Pomodoro → Enable Do Not Disturb → Open IDE
- **Quick Break**: Show stats → Start break timer

## 📚 Additional Documentation

For detailed information about specific features:

- **[UI Redesign Guide](docs/UI_REDESIGN_GUIDE.md)** - Complete design system documentation and theming guide
- **[Focus Mode Integration Guide](docs/FOCUS_MODE_GUIDE.md)** - Complete guide to using Focus Mode with the app
- **[iCloud Sync Setup Guide](docs/ICLOUD_SETUP_GUIDE.md)** - How to enable and configure iCloud sync
- **[Features Overview](docs/FEATURES_OVERVIEW.md)** - Comprehensive feature documentation
- **[App Store Privacy Metadata](docs/APP_STORE_PRIVACY_METADATA.md)** - Privacy practices and data handling

## 🚀 Future Enhancements

Potential features for future versions:
- ⌚ Apple Watch companion app
- 📊 More detailed analytics with Charts framework
- 🏆 Achievement system and badges
- 🎯 Live Activities support (iOS 16.1+)
- 🔔 Rich notifications with action buttons
- 📈 Weekly/monthly productivity reports
- 🎨 User-defined custom themes and colors
- 🌍 Seasonal/mood-based theme variations
- 📤 Theme import/export functionality

## 🔒 Privacy & Data Protection

Your privacy is our top priority. Mr. Pomodoro is designed with a privacy-first approach.

### What We Collect

**Local Device Storage Only:**
- ✅ Timer settings and preferences
- ✅ Session history and statistics
- ✅ Focus Mode preferences

**Optional iCloud Sync:**
- ☁️ If enabled, data syncs to **your private iCloud account**
- 🔐 Encrypted using Apple's security infrastructure
- 🎛️ You control sync - enable/disable anytime
- 🗑️ You can delete iCloud data from Settings

### What We DON'T Collect

- ❌ **No Analytics** - We don't track your usage
- ❌ **No Third-Party Services** - No external data sharing
- ❌ **No Advertising** - No ads, no ad tracking
- ❌ **No Account Creation** - No email, username, or personal info required
- ❌ **No Network Requests** - Except optional iCloud sync via Apple's secure infrastructure
- ❌ **No Location Data** - We never access your location
- ❌ **No Personal Information** - We don't collect or store any personal data

### Your Rights & Control

- 👁️ **Access**: View all your data within the app
- ✏️ **Modify**: Edit settings and preferences anytime
- 🗑️ **Delete**: Clear session history or reset all data from Settings
- 🔒 **Secure**: Protected by iOS sandboxing and device security
- 📤 **Export**: View session data in Statistics screen

### Compliance

- **GDPR Compliant** - Respects EU privacy rights
- **CCPA Compliant** - Honors California privacy rights
- **Apple Guidelines** - Follows App Store privacy requirements
- **Children's Privacy** - Not directed at children under 13

### Privacy Policy

For complete details about our privacy practices, see:
- 📄 **[Full Privacy Policy](PrivacyPolicy.md)** - Comprehensive documentation
- 📱 **In-App**: Settings → About → Privacy Policy

**Privacy Summary**: All data stored locally on your device. Optional iCloud sync to your private account. No tracking, no analytics, no third parties. You control everything.

## 📄 License

This project is available for personal and educational use.

## 👨‍💻 Developer

Created by **Avtansh Gupta** using SwiftUI and modern iOS development practices.

## 🤝 Contributing

Suggestions and improvements are welcome! Feel free to:
- Report bugs
- Request features
- Submit pull requests
- Share feedback

## 📚 References

- [The Pomodoro Technique](https://francescocirillo.com/pages/pomodoro-technique)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)

---

**Version**: 1.0.2 (Build 3)  
**Last Updated**: January 2026  
**Minimum iOS**: 18.0  
**Built with**: Xcode 26.0.1 / iOS SDK 26.0

Made with ❤️ and ☕ using SwiftUI
