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
