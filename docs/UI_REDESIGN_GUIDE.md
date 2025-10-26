# 🎨 UI Redesign & Theming System Guide

## Overview

The Pomodoro Timer app has been completely redesigned with a modern, adaptive UI following Apple's Human Interface Guidelines (HIG). A modular theming system enables dynamic appearance customization and seamless light/dark mode support.

---

## ✨ Key Features

### 1. **Modular Theming System**

- **5 Predefined Themes:**
  - Classic Red (Default)
  - Ocean Blue
  - Forest Green
  - Midnight Dark
  - Sunset Orange

- **Dynamic Theme Switching:** Themes can be changed in real-time from Settings
- **Persistent Storage:** Theme preferences are saved using `@AppStorage`
- **Environment-based:** Themes propagate through SwiftUI's environment system

### 2. **Modern UI Components**

#### **Main Timer Screen**
- Circular progress ring with smooth animations
- Session type header with color-coded indicators
- Animated background gradients based on session type
- Tactile action buttons with haptic feedback
- State indicator badge (Active/Paused/Ready)
- Skip session button with clear visual hierarchy

#### **Statistics Screen**
- Interactive Swift Charts (bar, line, pie charts)
- Card-based layout with subtle shadows
- Streak counter with gradient background
- Time range selector (Week/Month/All Time)
- Motivational quote cards

#### **Settings Screen**
- Organized sections with SF Symbol icons
- Horizontal scrolling theme preview cards
- Visual feedback for selected theme
- Consistent spacing and alignment

#### **Tab Bar Navigation**
- Three tabs: Timer, Stats, Settings
- SF Symbols icons
- Always accessible without modal sheets

---

## 🏗️ Architecture

### Theme System Components

```
PomodoroTimer/
├── Models/
│   └── AppTheme.swift          # Theme structure & predefined themes
├── Services/
│   └── ThemeManager.swift      # Theme management & persistence
└── Views/
    ├── MainTimerView.swift     # Theme-aware timer UI
    ├── SettingsView.swift      # Theme selection interface
    └── StatisticsView.swift    # Theme-aware statistics
```

### AppTheme Structure

```swift
struct AppTheme {
    let id: String
    let name: String
    let primaryColor: Color
    let secondaryColor: Color
    let accentColor: Color
    let focusGradient: LinearGradient
    let shortBreakGradient: LinearGradient
    let longBreakGradient: LinearGradient
    let cardBackground: Color
    let typography: Typography
}
```

### ThemeManager

```swift
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    @AppStorage("selectedThemeId") private var selectedThemeId: String
    
    func applyTheme(_ theme: AppTheme)
    var availableThemes: [AppTheme]
}
```

---

## 🎨 Design Principles

### 1. **Clarity**
- Clean typography using SF Rounded font
- Clear visual hierarchy
- Adequate white space
- Readable contrast ratios (≥4.5:1)

### 2. **Deference**
- Content-first approach
- Minimal chrome
- Subtle animations (0.3-0.6s duration)
- Non-intrusive feedback

### 3. **Depth**
- Layered UI with shadows
- Gradient backgrounds
- Tactile button states
- Visual feedback on interaction

### 4. **Consistency**
- Unified spacing system
- Consistent iconography (SF Symbols)
- Predictable interaction patterns
- Cohesive color palette per theme

---

## 🎯 Accessibility Features

### Dynamic Type Support
- All text uses semantic font styles
- Scales automatically with system settings
- Minimum touch target: 44×44 points

### VoiceOver Compatibility
- Descriptive accessibility labels
- Combined elements where appropriate
- Clear focus order
- Meaningful context

### Color & Contrast
- All themes tested for WCAG AA compliance
- Contrast ratio ≥ 4.5:1 for text
- ≥ 3:1 for UI components
- Works in both light and dark modes

### Reduced Motion Support
- Respects `UIAccessibility.isReduceMotionEnabled`
- Alternative animations when needed
- No essential information conveyed by motion alone

---

## 🔧 Usage

### Applying Themes in Views

```swift
struct MyView: View {
    @Environment(\.appTheme) var theme
    
    var body: some View {
        Text("Hello")
            .font(theme.typography.headline)
            .foregroundColor(theme.primaryColor)
    }
}
```

### Switching Themes

```swift
@StateObject private var themeManager = ThemeManager()

// Apply a theme
themeManager.applyTheme(.oceanBlue)

// Access current theme
let current = themeManager.currentTheme
```

### Adding Custom Themes

To add a new theme, create a static property in `AppTheme`:

```swift
static let myTheme = AppTheme(
    id: "my_theme",
    name: "My Theme",
    primaryColor: Color(hex: "#FF5733"),
    // ... other properties
)
```

Then add it to `allThemes`:

```swift
static let allThemes: [AppTheme] = [
    .classicRed,
    .oceanBlue,
    // ...
    .myTheme
]
```

---

## 📐 Layout Specifications

### Spacing Scale
- Extra Small: 4pt
- Small: 8pt
- Medium: 12pt
- Base: 16pt
- Large: 20pt
- Extra Large: 24pt
- XXL: 32pt

### Border Radius
- Small: 8pt
- Medium: 12pt
- Large: 16pt
- Extra Large: 20pt
- Circular: 50%

### Typography Scale

| Style | Size | Weight | Use Case |
|-------|------|--------|----------|
| Large Title | 34pt | Bold | Section headers |
| Title | 28pt | Bold | Screen titles |
| Title 2 | 22pt | Bold | Card headers |
| Title 3 | 20pt | Semibold | Subsections |
| Headline | 17pt | Semibold | Buttons, labels |
| Body | 17pt | Regular | Body text |
| Callout | 16pt | Regular | Secondary text |
| Subheadline | 15pt | Regular | Metadata |
| Footnote | 13pt | Regular | Fine print |
| Caption | 12pt | Regular | Captions |
| Timer Font | 64pt | Thin | Timer display |

---

## 🎬 Animation Guidelines

### Duration
- Quick: 0.15s - Button presses
- Standard: 0.3-0.4s - Transitions
- Slow: 0.6s - Background changes

### Curves
- `.easeInOut` - Default for most animations
- `.spring` - Interactive elements
- `.linear` - Progress indicators

### Haptic Feedback
- Light: Navigation, minor actions
- Medium: Button taps
- Heavy: Completion events

---

## 🧪 Testing

### Visual Testing
- Test all themes in light mode
- Test all themes in dark mode
- Verify on different screen sizes (SE, Pro, Max, iPad)
- Check with Dynamic Type at various sizes

### Accessibility Testing
- Run with VoiceOver enabled
- Test with increased contrast
- Verify with reduced motion
- Check color blind simulation

### Performance
- Smooth 60fps animations
- No jank during theme switching
- Fast app launch
- Efficient memory usage

---

## 🚀 Future Enhancements

### Potential Features
- [ ] User-defined custom colors
- [ ] Theme import/export
- [ ] Seasonal/time-based themes
- [ ] Animated theme transitions
- [ ] Widget theming support
- [ ] Advanced color customization
- [ ] Theme marketplace

---

## 📝 Design Decisions

### Why TabView Instead of Modal Sheets?
- Faster navigation between sections
- Better discoverability
- Consistent with iOS conventions
- No dismiss button needed
- Maintains context

### Why Rounded Design Language?
- Friendly, approachable feel
- Consistent with Pomodoro's focus on wellness
- Reduces visual harshness
- Better for extended viewing sessions

### Why Gradient Backgrounds?
- Adds depth without noise
- Subtle visual interest
- Helps differentiate session types
- Modern aesthetic

### Why 5 Themes?
- Covers major color preferences
- Manageable selection size
- Each has distinct personality
- Room for future additions

---

## 🔗 Resources

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---

## 📞 Support

For questions or issues related to the UI/theming system, please refer to:
- `README.md` for general app information
- `FEATURES_OVERVIEW.md` for feature documentation
- GitHub Issues for bug reports

---

**Version:** 1.0.0  
**Last Updated:** October 2025  
**Design System Version:** 1.0
