//
//  ResetTimerIntent.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import AppIntents
import Foundation

@available(iOS 16.0, *)
struct ResetTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Reset Pomodoro"
    static var description = IntentDescription("Resets the current Pomodoro timer to the beginning")
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult {
        // Post notification to reset timer
        NotificationCenter.default.post(
            name: NSNotification.Name("ResetTimerFromIntent"),
            object: nil
        )
        
        return .result()
    }
}
