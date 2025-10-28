# Screenshot Preparation Guide

This guide explains how to prepare your Pomodoro Timer app for capturing App Store screenshots with realistic dummy data and timer states.

## Overview

The Screenshot Preparation feature provides tools to:
1. Generate realistic statistics data spanning 30 days
2. Start focus/break sessions with random progress (30-70% complete)
3. Easy cleanup after screenshot capture

## Files Added

- **`PomodoroTimer/Services/ScreenshotHelper.swift`** - Utility class with static methods for screenshot preparation
- **`PomodoroTimer/Views/ScreenshotPreparationView.swift`** - User interface for screenshot preparation

## Accessing Screenshot Mode

1. Open the app
2. Navigate to **Settings**
3. Scroll to the **Developer Tools** section
4. Tap on **Screenshot Mode**

## Step-by-Step Screenshot Workflow

### 1. Prepare Statistics Data

Before capturing statistics screenshots:

```
Tap "Add Dummy Statistics"
```

This generates:
- **30 days** of session history
- Random **0-8 focus sessions** per day
- Corresponding **break sessions**
- Realistic timestamps (8 AM - 8 PM)
- Current streak calculation

**Output in console:**
```
✅ Added dummy statistics data for screenshots
📊 Total sessions: 150
📅 Today's sessions: 6
📅 This week's sessions: 35
🔥 Current streak: 5 days
```

### 2. Prepare Timer State

For timer screenshots, choose one:

#### Focus Session Screenshot
```
Tap "Start Focus Session"
```
- Sets timer to focus mode
- Random progress: 30-70% complete
- Timer runs automatically

#### Short Break Screenshot
```
Tap "Start Short Break"
```
- Sets timer to short break mode  
- Random progress: 30-70% complete
- Timer runs automatically

#### Long Break Screenshot
```
Tap "Start Long Break"
```
- Sets timer to long break mode
- Random progress: 30-70% complete
- Timer runs automatically

### 3. Capture Screenshots

1. Navigate to the view you want to screenshot
2. Use iOS screenshot capture (⌘+S in simulator, or device buttons)
3. Repeat for different screens as needed

### 4. Clean Up

After capturing all screenshots:

```
Tap "Clean Up & Reset"
```

This will:
- Stop any running timer
- Reset timer to idle state
- Clear all dummy statistics data
- Return app to normal state

## Programmatic Usage (Advanced)

You can also use the `ScreenshotHelper` class directly in code:

### Add Dummy Statistics
```swift
ScreenshotHelper.addDummyStatistics()
```

### Start Focus Session with Random Progress
```swift
ScreenshotHelper.startFocusSessionWithRandomProgress(timerManager: timerManager)
```

### Start Break Session with Random Progress
```swift
ScreenshotHelper.startBreakSessionWithRandomProgress(
    timerManager: timerManager,
    isLongBreak: false  // true for long break
)
```

### Complete Preparation (All-in-One)
```swift
ScreenshotHelper.prepareForScreenshot(
    timerManager: timerManager,
    sessionType: "focus",  // or "shortBreak", "longBreak"
    addStats: true
)
```

### Cleanup After Screenshots
```swift
ScreenshotHelper.cleanupAfterScreenshot(timerManager: timerManager)
```

## Tips for Best Screenshots

1. **Statistics Screen:**
   - Run "Add Dummy Statistics" first
   - Navigate to Statistics tab
   - Capture with realistic data visible

2. **Timer Screen (Focus):**
   - Start focus session from Screenshot Mode
   - Timer shows mid-session progress
   - Perfect for showing app in action

3. **Timer Screen (Break):**
   - Start break session from Screenshot Mode
   - Shows different color theme for breaks
   - Demonstrates full feature set

4. **Settings Screen:**
   - No special preparation needed
   - Shows all configuration options

5. **Theme Selection:**
   - Navigate to Theme Selection
   - Shows color customization options

## Console Output

The helper provides detailed console output for debugging:

```
✅ Started focus session for screenshot
⏱️  Time remaining: 12m 45s
📊 Progress: 51%
```

## Customization

To customize the random progress range, modify the `progress` parameter:

```swift
// Specific progress (0.0 = start, 1.0 = complete)
ScreenshotHelper.startFocusSessionWithRandomProgress(
    timerManager: timerManager,
    progress: 0.5  // Exactly 50% complete
)
```

## Data Generation Details

The dummy statistics generator creates:

- **Sessions per day:** 0-8 (random)
- **Time range:** 8:00 AM - 8:00 PM
- **Focus duration:** 25 minutes each
- **Short breaks:** 5 minutes (after sessions 1, 2, 3)
- **Long breaks:** 15 minutes (after every 4th session)
- **Date range:** Last 30 days from current date

## Troubleshooting

**Q: Statistics don't show after adding dummy data**
- Ensure you're on the Statistics tab
- The data spans 30 days, so check different time ranges

**Q: Timer doesn't start**
- Verify timerManager is properly initialized
- Check console for error messages

**Q: Need to reset app completely**
- Use Settings > Data Management > Reset App Completely
- This removes all data, not just screenshot data

## Safety

- Screenshot Mode only affects local data
- iCloud sync is temporarily disabled during screenshot preparation
- All changes are reversible with "Clean Up & Reset"
- Original user data is backed up automatically

## App Store Submission

After capturing screenshots:

1. Always run "Clean Up & Reset"
2. Verify app returns to normal state
3. Test all features work correctly
4. Screenshots saved to device/simulator Photos app

## Examples

### Quick Workflow for All Screenshots

```swift
// 1. Prepare everything
ScreenshotHelper.prepareForScreenshot(timerManager: timerManager, sessionType: "focus")

// 2. Capture Statistics screen

// 3. Capture Timer screen (already running)

// 4. Cleanup
ScreenshotHelper.cleanupAfterScreenshot(timerManager: timerManager)
```

## Notes

- Feature is debug/development only - can be removed before production if desired
- No user data is lost during screenshot preparation
- Safe to use repeatedly
- Designed for App Store screenshot requirements

---

**Last Updated:** October 27, 2025
**Version:** 1.1.0
