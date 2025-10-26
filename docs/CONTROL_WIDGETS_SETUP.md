# 🎮 Control Widgets Setup Guide

## Adding AppIntents to Widget Target

To enable full Control Widget functionality with the actual app intents, you need to add the AppIntent files to the widget target.

### Step 1: Add AppIntent Files to Widget Target

1. In Xcode, select each of these files in the Project Navigator:
   - `PomodoroTimer/AppIntents/StartPomodoroIntent.swift`
   - `PomodoroTimer/AppIntents/PauseTimerIntent.swift`
   - `PomodoroTimer/AppIntents/ResumeTimerIntent.swift`
   - `PomodoroTimer/AppIntents/ResetTimerIntent.swift`

2. For each file:
   - Open the **File Inspector** (⌥⌘1)
   - Under **Target Membership** section
   - ✅ Check **PomodoroWidgetExtension**
   - Keep **PomodoroTimer** checked as well

### Step 2: Update Control Widgets Implementation

Once the AppIntent files are added to the widget target, update `PomodoroWidget/PomodoroWidgetControl.swift`:

```swift
//
//  PomodoroWidgetControl.swift
//  PomodoroWidget
//
//  Created by Avtansh Gupta on 26/10/25.
//

import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Control Widget (iOS 18+)

@available(iOS 18.0, *)
struct PomodoroWidgetControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.pomodoro.timer.control"
        ) {
            ControlWidgetButton(action: StartPomodoroIntent()) {
                Label("Start Timer", systemImage: "timer")
            }
        }
        .displayName("Pomodoro Timer")
        .description("Quick start timer control")
    }
}

// MARK: - Additional Control Widgets

@available(iOS 18.0, *)
struct StartButtonControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.pomodoro.timer.start"
        ) {
            ControlWidgetButton(action: StartPomodoroIntent()) {
                Label("Start", systemImage: "play.circle.fill")
            }
        }
        .displayName("Start Pomodoro")
        .description("Start a new Pomodoro session")
    }
}

@available(iOS 18.0, *)
struct PauseButtonControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.pomodoro.timer.pause"
        ) {
            ControlWidgetButton(action: PauseTimerIntent()) {
                Label("Pause", systemImage: "pause.circle.fill")
            }
        }
        .displayName("Pause Timer")
        .description("Pause the current session")
    }
}

@available(iOS 18.0, *)
struct ResetButtonControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.pomodoro.timer.reset"
        ) {
            ControlWidgetButton(action: ResetTimerIntent()) {
                Label("Reset", systemImage: "arrow.counterclockwise.circle.fill")
            }
        }
        .displayName("Reset Timer")
        .description("Reset the current session")
    }
}
```

### Step 3: Build and Test

1. Clean the build folder: **⇧⌘K**
2. Build the project: **⌘B**
3. Run on iOS 18 device/simulator
4. Add Control Widgets:
   - Open Control Center
   - Tap "Edit" or customize button
   - Search for "Pomodoro" controls
   - Add timer controls

### Benefits of Full Implementation

With AppIntents added to the widget target:
- ✅ **Direct Control**: Control widgets directly control the timer
- ✅ **Background Actions**: Timer starts/stops without opening app
- ✅ **Live Feedback**: Widgets update immediately after actions
- ✅ **Better UX**: Seamless integration with iOS system controls

### Troubleshooting

**Issue**: Build errors about missing intents
- **Solution**: Ensure all AppIntent files are added to widget target

**Issue**: Control widgets don't appear
- **Solution**: Only available on iOS 18+, check device version

**Issue**: Actions open app instead of controlling timer
- **Solution**: Verify AppIntents are properly linked to widget target

---

## Alternative: Simplified Control Widgets

If you prefer to keep the simplified implementation (widgets just open the app), the current code will work fine. Users can still quickly access the timer from Control Center.

The simplified version:
- ✅ Works without additional configuration
- ✅ Simpler codebase
- ⚠️ Opens app instead of direct control
- ⚠️ No background timer control

Choose based on your app's requirements!
