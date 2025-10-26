# 📱 Widget Setup Guide for Pomodoro Timer

This guide will help you add WidgetKit support to the Pomodoro Timer app.

## 🎯 Overview

Widgets will display:
- **Small Widget**: Current timer countdown with session type
- **Medium Widget**: Timer + today's completed sessions
- **Large Widget**: Timer + sessions + streak counter
- **Lock Screen Widgets**: Minimal timer display (iOS 16+)

## 📋 Prerequisites

- Xcode 15.0+
- iOS 16.0+ deployment target
- Understanding of Widget Extension targets

---

## 🔧 Step 1: Add App Groups Capability

### For Main App Target

1. Open `PomodoroTimer.xcodeproj` in Xcode
2. Select the **PomodoroTimer** target
3. Go to **Signing & Capabilities** tab
4. Click **+ Capability**
5. Add **App Groups**
6. Click **+** to add a new group
7. Enter: `group.com.avtanshgupta.pomodoro`
8. Enable the checkbox for this group

### Important Notes
- The App Group ID must match the one in `SharedTimerData.swift`
- If you want to use a different ID, update it in `SharedTimerDataManager`
- App Groups allow data sharing between the app and widget

---

## 🎨 Step 2: Create Widget Extension Target

1. In Xcode, go to **File** → **New** → **Target**
2. Select **Widget Extension**
3. Configure:
   - **Product Name**: `PomodoroWidget`
   - **Include Configuration Intent**: ❌ (unchecked for now)
   - **Finish**
4. When prompted "Activate PomodoroWidget scheme?", click **Activate**

---

## ⚙️ Step 3: Configure Widget Target

### Add App Groups to Widget Target

1. Select the **PomodoroWidget** target
2. Go to **Signing & Capabilities**
3. Click **+ Capability**
4. Add **App Groups**
5. Enable `group.com.avtanshgupta.pomodoro` (same as main app)

### Set Deployment Target

1. In **General** tab
2. Set **Minimum Deployments** to **iOS 16.0** (or higher)

---

## 📦 Step 4: Add Shared Files to Widget Target

You need to add these files to **both** the app and widget targets:

1. In Xcode's Project Navigator, select these files:
   - `PomodoroTimer/Models/TimerSession.swift`
   - `PomodoroTimer/Services/SharedTimerData.swift`

2. For each file:
   - Open **File Inspector** (⌥⌘1)
   - Under **Target Membership**
   - ✅ Check **PomodoroWidget**

---

## 🎨 Step 5: Create Widget Views

Replace the contents of `PomodoroWidget/PomodoroWidget.swift` with the following code:

```swift
//
//  PomodoroWidget.swift
//  PomodoroWidget
//
//  Created by Your Name
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Entry

struct PomodoroEntry: TimelineEntry {
    let date: Date
    let timerData: SharedTimerData
}

// MARK: - Timeline Provider

struct PomodoroTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> PomodoroEntry {
        PomodoroEntry(date: Date(), timerData: .default)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PomodoroEntry) -> Void) {
        let data = SharedTimerDataManager.shared.loadTimerData()
        let entry = PomodoroEntry(date: Date(), timerData: data)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PomodoroEntry>) -> Void) {
        let data = SharedTimerDataManager.shared.loadTimerData()
        let currentDate = Date()
        
        // Create entry for current time
        let entry = PomodoroEntry(date: currentDate, timerData: data)
        
        // Update every 10 seconds when timer is running, otherwise every 5 minutes
        let refreshInterval: TimeInterval = data.isRunning ? 10 : 300
        let nextUpdate = currentDate.addingTimeInterval(refreshInterval)
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Widget Views

struct SmallWidgetView: View {
    let entry: PomodoroEntry
    
    var body: some View {
        ZStack {
            sessionColor.opacity(0.2)
            
            VStack(spacing: 8) {
                Text(entry.timerData.currentSessionType)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(sessionColor)
                
                Text(timeString)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .monospacedDigit()
                
                if entry.timerData.isRunning {
                    Image(systemName: "timer")
                        .font(.caption2)
                        .foregroundColor(sessionColor)
                }
            }
            .padding()
        }
    }
    
    private var timeString: String {
        let minutes = Int(entry.timerData.timeRemaining) / 60
        let seconds = Int(entry.timerData.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var sessionColor: Color {
        switch entry.timerData.currentSessionType {
        case "Focus": return .red
        case "Short Break": return .green
        case "Long Break": return .blue
        default: return .gray
        }
    }
}

struct MediumWidgetView: View {
    let entry: PomodoroEntry
    
    var body: some View {
        HStack {
            SmallWidgetView(entry: entry)
                .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Label("\(entry.timerData.completedSessionsToday)", systemImage: "checkmark.circle.fill")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Today")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if entry.timerData.totalFocusTimeToday > 0 {
                    Text(focusTimeString)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    
    private var focusTimeString: String {
        let hours = Int(entry.timerData.totalFocusTimeToday) / 3600
        let minutes = (Int(entry.timerData.totalFocusTimeToday) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m focused"
        } else {
            return "\(minutes)m focused"
        }
    }
}

struct LargeWidgetView: View {
    let entry: PomodoroEntry
    
    var body: some View {
        VStack(spacing: 16) {
            SmallWidgetView(entry: entry)
                .frame(height: 120)
            
            Divider()
            
            HStack(spacing: 32) {
                StatCard(
                    value: "\(entry.timerData.completedSessionsToday)",
                    label: "Today",
                    icon: "checkmark.circle.fill"
                )
                
                StatCard(
                    value: "\(entry.timerData.currentStreak)",
                    label: "Streak",
                    icon: "flame.fill"
                )
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Label(value, systemImage: icon)
                .font(.title)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Widget Configuration

struct PomodoroWidget: Widget {
    let kind: String = "PomodoroWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PomodoroTimelineProvider()) { entry in
            PomodoroWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pomodoro Timer")
        .description("Track your focus sessions at a glance")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct PomodoroWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: PomodoroEntry
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Lock Screen Widgets (iOS 16+)

@available(iOS 16.0, *)
struct PomodoroLockScreenWidget: Widget {
    let kind: String = "PomodoroLockScreen"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PomodoroTimelineProvider()) { entry in
            PomodoroLockScreenView(entry: entry)
        }
        .configurationDisplayName("Pomodoro")
        .description("Quick timer view")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

@available(iOS 16.0, *)
struct PomodoroLockScreenView: View {
    @Environment(\.widgetFamily) var family
    let entry: PomodoroEntry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularLockScreenView(entry: entry)
        case .accessoryRectangular:
            RectangularLockScreenView(entry: entry)
        case .accessoryInline:
            InlineLockScreenView(entry: entry)
        default:
            EmptyView()
        }
    }
}

@available(iOS 16.0, *)
struct CircularLockScreenView: View {
    let entry: PomodoroEntry
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 0) {
                Text(timeString)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .monospacedDigit()
                
                if entry.timerData.isRunning {
                    Image(systemName: "timer")
                        .font(.system(size: 10))
                }
            }
        }
    }
    
    private var timeString: String {
        let minutes = Int(entry.timerData.timeRemaining) / 60
        let seconds = Int(entry.timerData.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

@available(iOS 16.0, *)
struct RectangularLockScreenView: View {
    let entry: PomodoroEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.timerData.currentSessionType)
                    .font(.caption)
                    .fontWeight(.semibold)
                Spacer()
                if entry.timerData.isRunning {
                    Image(systemName: "timer")
                }
            }
            
            Text(timeString)
                .font(.title2)
                .fontWeight(.bold)
                .monospacedDigit()
        }
    }
    
    private var timeString: String {
        let minutes = Int(entry.timerData.timeRemaining) / 60
        let seconds = Int(entry.timerData.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

@available(iOS 16.0, *)
struct InlineLockScreenView: View {
    let entry: PomodoroEntry
    
    var body: some View {
        Text("\(entry.timerData.currentSessionType): \(timeString)")
    }
    
    private var timeString: String {
        let minutes = Int(entry.timerData.timeRemaining) / 60
        let seconds = Int(entry.timerData.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Widget Bundle

@main
struct PomodoroWidgetBundle: WidgetBundle {
    var body: some Widget {
        PomodoroWidget()
        if #available(iOS 16.0, *) {
            PomodoroLockScreenWidget()
        }
    }
}

// MARK: - Previews

struct PomodoroWidget_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEntry = PomodoroEntry(
            date: Date(),
            timerData: SharedTimerData(
                currentSessionType: "Focus",
                timeRemaining: 1500,
                isRunning: true,
                completedSessionsToday: 3,
                totalFocusTimeToday: 3600,
                currentStreak: 5,
                lastUpdated: Date()
            )
        )
        
        Group {
            PomodoroWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            PomodoroWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            PomodoroWidgetEntryView(entry: sampleEntry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
```

---

## ✅ Step 6: Build and Test

1. Select the **PomodoroWidget** scheme in Xcode
2. Choose a simulator or device
3. Press **⌘ + R** to run
4. The widget will appear on the home screen
5. Long-press the widget to see all sizes

### Testing Tips

- Run the main app first to generate some data
- Complete a few focus sessions
- Then run the widget to see live data
- Try different widget sizes

---

## 🔄 Step 7: Add Widget to Home Screen (on Device/Simulator)

1. Long-press on empty home screen area
2. Tap **+** button in top-left
3. Search for "Pomodoro Timer"
4. Choose widget size (Small, Medium, or Large)
5. Tap **Add Widget**
6. Position and tap **Done**

### Lock Screen Widgets (iOS 16+)

1. Long-press lock screen
2. Tap **Customize**
3. Tap widget area
4. Search for "Pomodoro"
5. Add circular, rectangular, or inline widget

---

## 🐛 Troubleshooting

### Widget Shows "No Data"
- Ensure App Groups are configured for **both** targets
- Verify App Group ID matches in code
- Run the main app and start a timer
- Check Console for App Group configuration warnings

### Widget Not Updating
- Widgets update based on timeline policy (every 10 seconds when running)
- Background restrictions may delay updates
- Restart the widget: Remove and re-add it

### Build Errors
- Ensure `TimerSession.swift` and `SharedTimerData.swift` are added to widget target
- Check that deployment target is iOS 16.0+
- Clean build folder: **⇧⌘K**

---

## 📱 Widget Features Summary

✅ **Home Screen Widgets**
- Small: Timer countdown
- Medium: Timer + sessions today
- Large: Timer + sessions + streak

✅ **Lock Screen Widgets** (iOS 16+)
- Circular: Compact timer
- Rectangular: Timer with session type
- Inline: Text-only status

✅ **Live Updates**
- Updates every 10 seconds when timer is running
- Updates every 5 minutes when idle
- Real-time data from main app

✅ **Battery Efficient**
- Smart update intervals
- Minimal data transfer
- Optimized rendering

---

## 🎉 Next Steps

After widgets are working:
1. Test on multiple devices
2. Try different widget sizes
3. Monitor battery usage
4. Consider adding widget configuration options
5. Test with Live Activities (iOS 16.1+)

---

**Need Help?** Check the main README.md or create an issue in the repository.
