//
//  PomodoroWidget.swift
//  PomodoroWidget
//
//  Created by Avtansh Gupta on 26/10/25.
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
            if #available(iOS 17.0, *) {
                PomodoroWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PomodoroWidgetEntryView(entry: entry)
                    .padding()
                    .background(Color(UIColor.systemBackground))
            }
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

// MARK: - Previews
// Note: Widget previews are disabled for iOS 16 compatibility
// To test widgets, run the widget extension target in Xcode
