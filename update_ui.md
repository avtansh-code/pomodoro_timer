# 🎨 **Prompt: Redesign and Modernize Pomodoro Timer App UI (with Modular Theming System)**

## 🧭 **Objective**

You are **Claude-Sonnet 4.5**, the autonomous coding agent responsible for **revamping and refining the entire UI** of the **Pomodoro Timer iOS app** using **SwiftUI**, following Apple’s **Human Interface Guidelines** (HIG).
Your mission: deliver a **clean, modern, and adaptive UI** that reflects **focus, calmness, and productivity**, while introducing a **modular theming system** that supports dynamic appearance, customization, and long-term scalability.

🔗 Reference: [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)

---

## 🧩 **Core Redesign Goals**

1. Align with Apple’s design principles — **Clarity**, **Deference**, **Depth**, **Consistency**, and **Accessibility**.
2. Modernize all visual components for an intuitive, distraction-free experience.
3. Introduce a **custom theming engine** to allow effortless UI customization and brand evolution.
4. Maintain **SwiftUI idiomatic design patterns** and **MVVM** separation.

---

## 🎯 **UI Enhancement Breakdown**

### **1. Main Timer Screen**

* Center-aligned circular progress ring (animated with SwiftUI’s `TimelineView` or `Canvas`).
* Prominent timer label with readable typography.
* Clearly separated session type (Focus / Break / Long Break).
* Rounded, tactile action buttons (Start / Pause / Reset) using SF Symbols.
* Background gradient adapting to session type:

  * **Focus:** Warm red → orange
  * **Break:** Green → teal
  * **Long Break:** Purple → blue
* Smooth transitions between states (`.easeInOut(duration: 0.4)`).

---

### **2. Settings Screen**

* Use SwiftUI `Form` with grouped sections.
* Organize logically:

  * Timer durations
  * Auto-transition toggle
  * Theme selection
  * Notification preferences
* Use native components (toggle, picker, slider) for HIG consistency.
* Add real-time preview of selected theme colors and fonts.

---

### **3. Statistics Screen**

* Card-based layout with shadows and rounded corners.
* Use Swift Charts for focus/break trends.
* Integrate circular streak counter and bar chart.
* Provide daily, weekly, and monthly filters.

---

### **4. Navigation**

* Bottom TabView with three tabs: **Timer | Stats | Settings**.
* Consistent iconography using SF Symbols (e.g., clock, chart.bar, gear).
* Adaptive padding, safe area usage, and accessibility spacing.

---

## 🎨 **5. Theming System Integration**

Create a modular **Theming Engine** that defines and applies visual identity consistently across all app views.

### ✅ **Functional Requirements**

* Centralized theme definition structure:

  ```swift
  struct AppTheme {
      let name: String
      let primaryColor: Color
      let secondaryColor: Color
      let accentColor: Color
      let backgroundGradient: LinearGradient
      let font: Font
  }
  ```
* Support **multiple predefined themes**:

  * `Classic Red` (default)
  * `Ocean Blue`
  * `Forest Green`
  * `Midnight Dark`
* Enable dynamic switching between themes in **Settings**.
* Store selected theme in `UserDefaults` or `AppStorage`.
* Auto-adapt to **Light / Dark mode** (`ColorScheme` aware).
* Ensure full accessibility compliance (contrast ratio ≥ 4.5:1).

### ✅ **Stretch Goals**

* Add **seasonal or mood-based themes** (e.g., “Focus Flow”, “Calm Night”).
* Enable future support for **user-defined custom colors**.
* Integrate **SwiftUI Environment** property for theme propagation:

  ```swift
  @EnvironmentObject var themeManager: ThemeManager
  ```

### ✅ **Example Implementation Outline**

```swift
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = AppTheme.default
    func applyTheme(_ theme: AppTheme) { self.currentTheme = theme }
}
```

* Apply across UI components via `@EnvironmentObject`.

---

## ⚙️ **Technical Implementation Requirements**

* Language: Swift 5.10+
* Framework: SwiftUI (latest stable)
* Architecture: MVVM
* Code style: Apple Swift API Design Guidelines
* Accessibility: Dynamic Type, VoiceOver, reduced motion compliance
* Layout: Auto-layout adaptive (iPhone SE → iPad Pro)

---

## 🧠 **Agent Workflow**

1. **Audit Current UI**

   * Identify outdated or cluttered elements.
   * Note all hard-coded colors, fonts, and spacing.

2. **Propose Visual Redesign**

   * Suggest visual hierarchy, spacing, and component simplification.
   * Define color, typography, and spacing system.

3. **Implement Theming Engine**

   * Introduce `AppTheme` and `ThemeManager`.
   * Replace static styles with dynamic, theme-driven values.

4. **Refactor SwiftUI Views**

   * Convert all screens to use theme system.
   * Simplify navigation and improve alignment.

5. **Apply Accessibility Enhancements**

   * Test contrast ratios, font scaling, and button tap areas.

6. **Preview & Validate**

   * Generate SwiftUI Previews for each theme and screen.
   * Verify light/dark mode consistency.

7. **Document**

   * Update `README.md` with design decisions and theming guide.

---

## 📘 **Deliverables**

* ✅ Redesigned SwiftUI layout for Timer, Stats, and Settings screens.
* ✅ Modular, reusable `ThemeManager` and `AppTheme` system.
* ✅ Dynamic theme switching (persistent).
* ✅ Adaptive colors and typography.
* ✅ Accessibility compliance and device adaptability.
* ✅ Visual documentation (screenshots, previews).

---

## ▶️ **Kickoff Command**

> Begin the **UI Redesign and Theming Phase** for the Pomodoro Timer iOS app.
>
> 1. Analyze current UI structure and define aesthetic improvements per HIG.
> 2. Implement the modular theming system (`ThemeManager` + `AppTheme`).
> 3. Refactor all SwiftUI screens to adopt theme-driven design.
> 4. Validate for accessibility, dark mode, and dynamic type.
> 5. Provide screenshots and summary of visual improvements.
