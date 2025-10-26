# 🍅 Pomodoro Timer - iOS App

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
- **Theme Selection** - Choose between System, Light, or Dark mode
- **Notification Controls** - Enable/disable sounds, haptics, and push notifications

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
│   └── TimerSettings.swift     # User preferences model
├── Services/
│   ├── TimerManager.swift      # Core timer logic and state management
│   └── PersistenceManager.swift # Data persistence (UserDefaults)
├── Views/
│   ├── MainTimerView.swift     # Main timer interface
│   ├── SettingsView.swift      # Configuration screen
│   └── StatisticsView.swift    # Stats and analytics
├── ContentView.swift           # Root view coordinator
└── PomodoroTimerApp.swift      # App entry point with lifecycle handling
```

## 🚀 Getting Started

### Prerequisites
- **Xcode 15.0+**
- **iOS 17.0+**
- **macOS Sonoma** (for development)

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

## 🔧 Technical Details

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
- **Color-Coded Sessions** - Visual distinction between session types (Red = Focus, Green = Short Break, Blue = Long Break)
- **Smooth Animations** - Polished transitions and progress animations
- **Apple HIG Compliance** - Follows iOS Human Interface Guidelines
- **Accessibility First** - Designed to be usable by everyone

## 🗣️ Siri Shortcuts

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

## 📝 Future Enhancements

Potential features for future versions:
- ⌚ Apple Watch companion app
- ☁️ iCloud sync across devices
- 🎯 Focus Mode API integration
- 📊 More detailed analytics and charts
- 🏆 Achievement system and badges
- 📱 WidgetKit support for home screen

## 🔒 Privacy

- **Local-only data** - All data stays on your device
- **No analytics** - No tracking or data collection
- **No account required** - Use immediately without sign-up
- **Full control** - Delete all data anytime from settings

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

**Version**: 1.0.0  
**Last Updated**: October 2025

Made with ❤️ and ☕ using SwiftUI
