# 🎨 Mr. Pomodoro - Design System Guide

**Version:** 1.0.2  
**Last Updated:** January 26, 2026  
**Design System Version:** 1.0

This guide documents the complete design system for the Pomodoro Timer app, including theming architecture, visual specifications, component library, and design principles.

---

## 📖 Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Theming System](#theming-system)
3. [Typography & Colors](#typography--colors)
4. [Layout Specifications](#layout-specifications)
5. [Component Library](#component-library)
6. [Animation Guidelines](#animation-guidelines)
7. [Accessibility Standards](#accessibility-standards)
8. [Design Tokens](#design-tokens)
9. [Implementation Guide](#implementation-guide)

---

## Design Philosophy

### Core Principles

#### 1. **Clarity**
- Clean typography using SF Rounded font
- Clear visual hierarchy
- Adequate white space
- Readable contrast ratios (≥4.5:1)
- Content-first approach

#### 2. **Deference**
- Content takes center stage
- Minimal chrome and decoration
- Subtle animations (0.3-0.6s duration)
- Non-intrusive feedback
- Respects system preferences

#### 3. **Depth**
- Layered UI with subtle shadows
- Gradient backgrounds for context
- Tactile button states
- Visual feedback on interaction
- Dimensionality without clutter

#### 4. **Consistency**
- Unified spacing system (8pt grid)
- Consistent iconography (SF Symbols)
- Predictable interaction patterns
- Cohesive color palette per theme
- Platform conventions

### Design Goals

**Focused Experience**
- Minimize distractions
- Emphasize the timer
- Clean interface
- Easy navigation

**Personalization**
- 5 distinct themes
- User preference respect
- Adaptive to light/dark mode
- Customizable durations

**Accessibility**
- VoiceOver compatible
- Dynamic Type support
- High contrast options
- Large touch targets (44pt min)

**Performance**
- Smooth 60fps animations
- Fast transitions
- Efficient rendering
- Responsive interactions

---

## Theming System

### Architecture

The app features a modular theming system that enables dynamic appearance customization with seamless light/dark mode support.

#### Components

```swift
// Theme Structure
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

#### Theme Manager

```swift
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    @AppStorage("selectedThemeId") private var selectedThemeId: String
    
    func applyTheme(_ theme: AppTheme)
    var availableThemes: [AppTheme]
}
```

### Available Themes

#### 1. Classic Red (Default)
```
Primary Color: #ED4242 (Tomato Red)
Secondary Color: #C53030
Accent Color: #FF6B6B

Focus Gradient: Red to Orange
Short Break Gradient: Mint to Green
Long Break Gradient: Sky to Ocean Blue

Best For: Traditional Pomodoro experience
Mood: Energetic, focused, classic
Personality: Timeless, motivating, warm
```

#### 2. Ocean Blue
```
Primary Color: #2E5EAA (Deep Blue)
Secondary Color: #1E4080
Accent Color: #4A90E2

Focus Gradient: Navy to Azure
Short Break Gradient: Teal to Aqua
Long Break Gradient: Deep Blue to Cyan

Best For: Calm, analytical work
Mood: Professional, serene, stable
Personality: Trustworthy, focused, cool
```

#### 3. Forest Green
```
Primary Color: #2D5F3F (Forest Green)
Secondary Color: #1F4B2F
Accent Color: #48BB78

Focus Gradient: Forest to Lime
Short Break Gradient: Sage to Mint
Long Break Gradient: Teal to Green

Best For: Creative tasks, writing
Mood: Natural, balanced, growth
Personality: Refreshing, calm, organic
```

#### 4. Midnight Dark
```
Primary Color: #2C3E50 (Charcoal)
Secondary Color: #1A252F
Accent Color: #5DADE2

Focus Gradient: Charcoal to Slate
Short Break Gradient: Gray to Silver
Long Break Gradient: Navy to Steel

Best For: Night work, coding
Mood: Sophisticated, minimal, focused
Personality: Elegant, modern, sleek
```

#### 5. Sunset Orange
```
Primary Color: #E67E22 (Warm Orange)
Secondary Color: #D35400
Accent Color: #F39C12

Focus Gradient: Orange to Coral
Short Break Gradient: Peach to Yellow
Long Break Gradient: Orange to Pink

Best For: Creative work, brainstorming
Mood: Energetic, inspiring, warm
Personality: Creative, vibrant, optimistic
```

### Theme Properties

#### Light Mode Adaptations
- Lighter backgrounds
- Higher contrast text
- Softer shadows
- Reduced saturation

#### Dark Mode Adaptations
- Darker backgrounds
- Lower contrast (for comfort)
- Elevated elements
- Richer colors

### Theme Selection UI

**Horizontal Scrolling Cards**
- Preview of theme colors
- Theme name displayed
- Current theme highlighted
- Live preview on selection
- Smooth animation transitions

---

## Typography & Colors

### Typography Scale

Using **SF Rounded** font family for friendly, approachable feel:

| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| Timer Display | 64pt | Thin | 72pt | Main countdown timer |
| Large Title | 34pt | Bold | 41pt | Screen headers |
| Title | 28pt | Bold | 34pt | Section titles |
| Title 2 | 22pt | Bold | 28pt | Card headers |
| Title 3 | 20pt | Semibold | 25pt | Subsections |
| Headline | 17pt | Semibold | 22pt | Buttons, important labels |
| Body | 17pt | Regular | 22pt | Body text, descriptions |
| Callout | 16pt | Regular | 21pt | Secondary text |
| Subheadline | 15pt | Regular | 20pt | Metadata, timestamps |
| Footnote | 13pt | Regular | 18pt | Fine print, hints |
| Caption | 12pt | Regular | 16pt | Image captions |
| Caption 2 | 11pt | Regular | 13pt | Smallest text |

### Dynamic Type Support

All text scales with user's system preferences:

```swift
// Semantic text styles
Text("Focus Session")
    .font(.headline)  // Automatically scales

Text("25:00")
    .font(.system(size: 64, weight: .thin, design: .rounded))
    .minimumScaleFactor(0.5)  // Allows scaling down
```

### Color System

#### Semantic Colors

**Text Colors**
- Primary Text: Adapts to theme
- Secondary Text: 70% opacity
- Tertiary Text: 50% opacity
- Disabled Text: 30% opacity

**Background Colors**
- Primary Background: Theme-aware
- Secondary Background: Card backgrounds
- Tertiary Background: Subtle highlights

**Interactive Colors**
- Primary Button: Theme primary color
- Secondary Button: Theme secondary color
- Destructive: System red
- Success: System green

#### Color Accessibility

All color combinations tested for WCAG AA compliance:
- Text: ≥4.5:1 contrast ratio
- UI Elements: ≥3:1 contrast ratio
- Works in both light and dark mode

---

## Layout Specifications

### Spacing System

Based on 8pt grid for consistency:

```
Extra Small: 4pt   (0.5x)
Small: 8pt         (1x)
Medium: 12pt       (1.5x)
Base: 16pt         (2x)
Large: 20pt        (2.5x)
Extra Large: 24pt  (3x)
XXL: 32pt          (4x)
XXXL: 48pt         (6x)
```

### Border Radius

Rounded design language throughout:

```
Small: 8pt         // Buttons, small cards
Medium: 12pt       // Standard cards
Large: 16pt        // Large cards, modals
Extra Large: 20pt  // Timer container
Circular: 50%      // Progress rings, avatars
```

### Shadows

Subtle depth without heaviness:

```swift
// Light shadow
.shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

// Medium shadow
.shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)

// Heavy shadow
.shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 6)
```

### Safe Areas & Margins

```
Screen Edges: 16pt horizontal padding
Card Padding: 16pt internal
Section Spacing: 24pt vertical
Element Spacing: 12pt between related items
Group Spacing: 32pt between unrelated groups
```

---

## Component Library

### Primary Components

#### 1. Timer Display

**Circular Progress Ring**
```swift
Structure:
- 280pt diameter circle
- 20pt stroke width
- Animated progress fill
- Central time display (64pt)
- Session type label (17pt headline)
```

**States:**
- Ready: Gray ring, full opacity
- Active: Animated fill, pulsing glow
- Paused: Static fill, reduced opacity
- Complete: Full ring, success color

#### 2. Action Buttons

**Primary Button (Start/Pause/Resume)**
```swift
Specifications:
- Height: 56pt
- Padding: 16pt horizontal
- Font: 17pt headline
- Border Radius: 12pt
- Shadow: Medium depth
```

**States:**
- Normal: Theme primary color
- Pressed: 90% opacity + scale 0.95
- Disabled: 40% opacity
- Loading: Spinner animation

**Secondary Buttons (Reset/Skip)**
```swift
Specifications:
- Height: 48pt
- Padding: 12pt horizontal
- Font: 15pt subheadline
- Border Radius: 10pt
- Border: 2pt stroke
```

#### 3. Statistics Cards

**Card Container**
```swift
Specifications:
- Padding: 16pt
- Border Radius: 16pt
- Background: Theme card color
- Shadow: Light depth
```

**Content:**
- Title: 20pt bold
- Value: 34pt bold (numeric)
- Subtitle: 15pt regular
- Icon: 24×24pt SF Symbol

#### 4. Theme Selector

**Theme Card**
```swift
Specifications:
- Width: 140pt
- Height: 100pt
- Border Radius: 12pt
- Gradient preview
- Selected: 3pt border + glow
```

**Layout:**
- Horizontal ScrollView
- 12pt spacing between cards
- Snap to alignment
- Smooth scrolling

#### 5. Settings Rows

**Toggle Row**
```swift
Specifications:
- Height: 56pt minimum
- Padding: 16pt horizontal
- Icon: 24×24pt SF Symbol
- Label: 17pt body
- Toggle: System default
```

**Stepper Row**
```swift
Specifications:
- Height: 56pt minimum
- Padding: 16pt horizontal
- Label + value display
- Stepper: System default
- Range indication
```

### Secondary Components

#### Navigation

**Tab Bar**
```swift
Items: 3 tabs
- Timer (🍅)
- Statistics (📊)
- Settings (⚙️)

Specifications:
- Icon size: 24×24pt
- Active tint: Theme primary
- Inactive tint: Gray
- Background: System
```

**Navigation Bar**
```swift
Title: 28pt large title
Background: Transparent
Actions: SF Symbol icons
Spacing: System default
```

#### Indicators

**Session Badge**
```swift
Specifications:
- Padding: 8pt × 16pt
- Font: 13pt footnote semibold
- Border Radius: 8pt
- Background: Theme gradient (20% opacity)
```

**Streak Counter**
```swift
Specifications:
- 🔥 Icon + number
- Font: 22pt bold
- Gradient background
- Rounded container
```

---

## Animation Guidelines

### Duration Standards

```swift
// Interaction feedback
Extra Fast: 0.15s  // Button presses, switches
Fast: 0.2s         // Small transitions
Standard: 0.3s     // Default animations
Medium: 0.4s       // Modal presentations
Slow: 0.6s         // Background changes
Extra Slow: 1.0s   // Progress animations
```

### Easing Curves

```swift
// Default smooth motion
.easeInOut         // Most animations

// Quick start, smooth end
.easeOut          // Entrances, expansions

// Smooth start, quick end
.easeIn           // Exits, collapses

// Bouncy, playful
.spring(          // Interactive elements
    response: 0.3,
    dampingFraction: 0.7
)

// Continuous motion
.linear           // Progress bars, timers
```

### Animation Examples

**Button Press**
```swift
.scaleEffect(isPressed ? 0.95 : 1.0)
.opacity(isPressed ? 0.8 : 1.0)
.animation(.easeInOut(duration: 0.15), value: isPressed)
```

**Theme Change**
```swift
.transition(.opacity)
.animation(.easeInOut(duration: 0.3), value: currentTheme)
```

**Timer Completion**
```swift
.scaleEffect(isComplete ? 1.1 : 1.0)
.opacity(isComplete ? 0 : 1.0)
.animation(
    .spring(response: 0.6, dampingFraction: 0.6),
    value: isComplete
)
```

### Haptic Feedback

**Timing:**
- Button press: Light impact
- Session complete: Success notification
- Skip/reset: Medium impact
- Error: Error notification

```swift
// Implementation
let haptic = UIImpactFeedbackGenerator(style: .light)
haptic.impactOccurred()
```

---

## Accessibility Standards

### VoiceOver Support

**All Interactive Elements:**
```swift
.accessibilityLabel("Start focus session")
.accessibilityHint("Begins a 25-minute focus timer")
.accessibilityValue("25 minutes remaining")
```

**Combined Elements:**
```swift
.accessibilityElement(children: .combine)
```

**Focus Order:**
- Logical top-to-bottom, left-to-right
- Skip decorative elements
- Group related items

### Dynamic Type

**Text Scaling:**
- All text uses semantic styles
- Minimum scale factor for constraints
- Layout adapts to text size
- No truncation of important text

```swift
Text("Focus Session")
    .font(.headline)
    .minimumScaleFactor(0.8)
    .lineLimit(2)
```

### Color & Contrast

**Compliance:**
- ✅ WCAG AA: ≥4.5:1 for text
- ✅ WCAG AA: ≥3:1 for UI elements
- ✅ Tested with color blindness simulators
- ✅ Works in Increase Contrast mode

**Testing Tools:**
- Accessibility Inspector
- Color Oracle (simulator)
- Contrast Checker

### Reduced Motion

**Respects Preference:**
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

if reduceMotion {
    // Simpler animation or instant change
    .transition(.opacity)
} else {
    // Full animation
    .transition(.scale.combined(with: .opacity))
}
```

### Touch Targets

**Minimum Size:**
- 44 × 44 points minimum
- Generous padding around small elements
- Visual size can be smaller with expanded hit area

```swift
Button("×") { }
    .frame(width: 32, height: 32)  // Visual
    .contentShape(Rectangle())
    .frame(width: 44, height: 44)  // Touch target
```

---

## Design Tokens

### Core Tokens

```swift
// Spacing
struct Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let base: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 48
}

// Border Radius
struct Radius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let round: CGFloat = 9999
}

// Shadow
struct Shadow {
    static let light = Color.black.opacity(0.1)
    static let medium = Color.black.opacity(0.15)
    static let heavy = Color.black.opacity(0.2)
}

// Animation
struct Duration {
    static let extraFast: Double = 0.15
    static let fast: Double = 0.2
    static let standard: Double = 0.3
    static let medium: Double = 0.4
    static let slow: Double = 0.6
}
```

### Theme-Specific Tokens

```swift
// Defined per theme
struct ThemeColors {
    let primary: Color
    let secondary: Color
    let accent: Color
    let background: Color
    let surface: Color
    let text: Color
    let textSecondary: Color
}
```

---

## Implementation Guide

### Applying Themes in Views

```swift
struct MyView: View {
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack {
            Text("Hello")
                .font(theme.typography.headline)
                .foregroundColor(theme.primaryColor)
        }
        .background(theme.cardBackground)
    }
}
```

### Switching Themes

```swift
@StateObject private var themeManager = ThemeManager()

// Apply theme
themeManager.applyTheme(.oceanBlue)

// Access current
let current = themeManager.currentTheme
```

### Creating Custom Themes

```swift
static let myTheme = AppTheme(
    id: "my_theme",
    name: "My Theme",
    primaryColor: Color(hex: "#FF5733"),
    secondaryColor: Color(hex: "#C70039"),
    accentColor: Color(hex: "#FFC300"),
    focusGradient: LinearGradient(
        colors: [Color(hex: "#FF5733"), Color(hex: "#FFC300")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    ),
    // ... other properties
)
```

### Best Practices

**DO:**
- ✅ Use semantic color names
- ✅ Respect system preferences
- ✅ Test in both light/dark mode
- ✅ Use design tokens consistently
- ✅ Follow accessibility guidelines
- ✅ Animate with purpose

**DON'T:**
- ❌ Hard-code colors
- ❌ Use arbitrary spacing values
- ❌ Ignore Dynamic Type
- ❌ Over-animate
- ❌ Skip accessibility testing
- ❌ Forget about performance

---

## Design Decisions

### Why TabView Instead of Modal Sheets?

**Benefits:**
- Faster navigation
- Better discoverability
- Consistent with iOS conventions
- No dismiss button needed
- Maintains context
- User expectations

### Why Rounded Design Language?

**Benefits:**
- Friendly, approachable feel
- Consistent with wellness focus
- Reduces visual harshness
- Better for extended viewing
- Modern aesthetic
- Softer interaction

### Why Gradient Backgrounds?

**Benefits:**
- Adds depth without noise
- Subtle visual interest
- Helps differentiate session types
- Modern, polished look
- Creates atmosphere
- Not distracting

### Why 5 Themes?

**Benefits:**
- Covers major color preferences
- Manageable selection size
- Each has distinct personality
- Room for future additions
- Not overwhelming
- Quality over quantity

---

## Future Enhancements

### Planned Features
- [ ] User-defined custom colors
- [ ] Theme import/export
- [ ] Seasonal/time-based auto-switching
- [ ] Animated theme transitions
- [ ] Widget theming support
- [ ] Advanced color customization
- [ ] Theme marketplace (community themes)
- [ ] Dynamic color extraction from photos

### Under Consideration
- Theme presets for specific workflows
- Accessibility theme variations
- Holiday/seasonal themes
- Productivity-based theme suggestions
- Time-of-day automatic switching
- Integration with system wallpapers

---

## Resources

### Apple Documentation
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Accessibility Guidelines](https://developer.apple.com/accessibility/)

### Design Tools
- [Figma](https://www.figma.com/) - Design mockups
- [SF Symbols App](https://developer.apple.com/sf-symbols/) - Icon browsing
- [Color Oracle](https://colororacle.org/) - Color blindness simulator
- [Contrast Checker](https://webaim.org/resources/contrastchecker/) - WCAG testing

### Accessibility
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Apple Accessibility](https://www.apple.com/accessibility/)
- [Inclusive Design Principles](https://inclusivedesignprinciples.org/)

---

## Support

For questions or issues related to the design system:
- See `USER_GUIDE.md` for user-facing features
- See `DEVELOPER_GUIDE.md` for implementation details
- Check GitHub Issues for known design bugs
- Contact design team for clarifications

---

**Last Updated:** January 26, 2026  
**Design System Version:** 1.0  
**App Version:** 1.0.2

*This design system is a living document and will evolve with the app.*
