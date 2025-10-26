//
//  PauseTimerIntent.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import AppIntents
import Foundation

@available(iOS 16.0, *)
struct PauseTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Pause Pomodoro"
    static var description = IntentDescription("Pauses the currently running Pomodoro timer")
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult {
        // Post notification to pause timer
        NotificationCenter.default.post(
            name: NSNotification.Name("PauseTimerFromIntent"),
            object: nil
        )
        
        return .result()
    }
}
