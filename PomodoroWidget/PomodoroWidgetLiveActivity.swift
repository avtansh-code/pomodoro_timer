//
//  PomodoroWidgetLiveActivity.swift
//  PomodoroWidget
//
//  Created by Avtansh Gupta on 26/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

// MARK: - Live Activity Attributes

@available(iOS 16.1, *)
struct PomodoroTimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var sessionType: String
        var timeRemaining: TimeInterval
        var isRunning: Bool
        var completedSessionsToday: Int
    }
    
    var sessionStartTime: Date
    var totalDuration: TimeInterval
}

// MARK: - Live Activity Widget

@available(iOS 16.2, *)
struct PomodoroTimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroTimerAttributes.self) { context in
            // Lock screen/banner UI
            LiveActivityView(context: context)
                .activityBackgroundTint(sessionColor(for: context.state.sessionType).opacity(0.2))
                .activitySystemActionForegroundColor(sessionColor(for: context.state.sessionType))
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: iconName(for: context.state.sessionType))
                            .foregroundColor(sessionColor(for: context.state.sessionType))
                        Text(context.state.sessionType)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timeString(from: context.state.timeRemaining))
                        .font(.title2)
                        .fontWeight(.bold)
                        .monospacedDigit()
                }
                
                DynamicIslandExpandedRegion(.center) {
                    ProgressView(value: progress(context: context))
                        .progressViewStyle(.linear)
                        .tint(sessionColor(for: context.state.sessionType))
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 20) {
                        Image(systemName: context.state.isRunning ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.isRunning ? "timer" : "pause.circle")
                    .foregroundColor(sessionColor(for: context.state.sessionType))
            } compactTrailing: {
                Text(timeString(from: context.state.timeRemaining))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .monospacedDigit()
            } minimal: {
                Image(systemName: "timer")
                    .foregroundColor(sessionColor(for: context.state.sessionType))
            }
            .widgetURL(URL(string: "pomodoro://timer"))
            .keylineTint(sessionColor(for: context.state.sessionType))
        }
    }
    
    private func progress(context: ActivityViewContext<PomodoroTimerAttributes>) -> Double {
        let elapsed = context.attributes.totalDuration - context.state.timeRemaining
        return elapsed / context.attributes.totalDuration
    }
    
    private func timeString(from seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    private func sessionColor(for type: String) -> Color {
        switch type {
        case "Focus": return .red
        case "Short Break": return .green
        case "Long Break": return .blue
        default: return .gray
        }
    }
    
    private func iconName(for type: String) -> String {
        switch type {
        case "Focus": return "brain.head.profile"
        case "Short Break": return "cup.and.saucer.fill"
        case "Long Break": return "powersleep"
        default: return "timer"
        }
    }
}

// MARK: - Live Activity View

@available(iOS 16.1, *)
struct LiveActivityView: View {
    let context: ActivityViewContext<PomodoroTimerAttributes>
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: iconName(for: context.state.sessionType))
                        .foregroundColor(sessionColor(for: context.state.sessionType))
                    Text(context.state.sessionType)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                if context.state.isRunning {
                    Image(systemName: "timer")
                        .foregroundColor(sessionColor(for: context.state.sessionType))
                        .font(.caption)
                }
            }
            
            HStack(alignment: .lastTextBaseline) {
                Text(timeString(from: context.state.timeRemaining))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Label("\(context.state.completedSessionsToday)", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text("Today")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(sessionColor(for: context.state.sessionType))
        }
        .padding()
    }
    
    private var progress: Double {
        let elapsed = context.attributes.totalDuration - context.state.timeRemaining
        return elapsed / context.attributes.totalDuration
    }
    
    private func timeString(from seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    private func sessionColor(for type: String) -> Color {
        switch type {
        case "Focus": return .red
        case "Short Break": return .green
        case "Long Break": return .blue
        default: return .gray
        }
    }
    
    private func iconName(for type: String) -> String {
        switch type {
        case "Focus": return "brain.head.profile"
        case "Short Break": return "cup.and.saucer.fill"
        case "Long Break": return "powersleep"
        default: return "timer"
        }
    }
}
