//
//  PomodoroShortcuts.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import AppIntents

@available(iOS 16.0, *)
struct PomodoroShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartPomodoroIntent(),
            phrases: [
                "Start a \(.applicationName)",
                "Begin \(.applicationName) session",
                "Start focus time with \(.applicationName)",
                "Start pomodoro in \(.applicationName)"
            ],
            shortTitle: "Start Pomodoro",
            systemImageName: "timer"
        )
        
        AppShortcut(
            intent: PauseTimerIntent(),
            phrases: [
                "Pause \(.applicationName)",
                "Pause my timer in \(.applicationName)",
                "Stop \(.applicationName) timer"
            ],
            shortTitle: "Pause Timer",
            systemImageName: "pause.circle"
        )
        
        AppShortcut(
            intent: ResumeTimerIntent(),
            phrases: [
                "Resume \(.applicationName)",
                "Continue my timer in \(.applicationName)",
                "Resume pomodoro in \(.applicationName)"
            ],
            shortTitle: "Resume Timer",
            systemImageName: "play.circle"
        )
        
        AppShortcut(
            intent: ResetTimerIntent(),
            phrases: [
                "Reset \(.applicationName)",
                "Restart timer in \(.applicationName)",
                "Reset pomodoro in \(.applicationName)"
            ],
            shortTitle: "Reset Timer",
            systemImageName: "arrow.counterclockwise"
        )
        
        AppShortcut(
            intent: ShowStatisticsIntent(),
            phrases: [
                "Show my \(.applicationName) stats",
                "Open statistics in \(.applicationName)",
                "Check my progress in \(.applicationName)"
            ],
            shortTitle: "Show Stats",
            systemImageName: "chart.bar"
        )
    }
}
