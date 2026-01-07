//
//  ShowStatisticsIntent.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import AppIntents
import Foundation

@available(iOS 16.0, *)
struct ShowStatisticsIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Pomodoro Statistics"
    static var description = IntentDescription("Opens the Pomodoro Timer app and shows your statistics")
    
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Post notification to show statistics
        NotificationCenter.default.post(
            name: NSNotification.Name("ShowStatisticsFromIntent"),
            object: nil
        )
        
        return .result(dialog: "Opening your Pomodoro statistics")
    }
}
