//
//  ResumeTimerIntent.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import AppIntents
import Foundation

@available(iOS 16.0, *)
struct ResumeTimerIntent: AppIntent {
    static var title: LocalizedStringResource = "Resume Pomodoro"
    static var description = IntentDescription("Resumes the paused Pomodoro timer")
    
    static var openAppWhenRun: Bool = false
    
    func perform() async throws -> some IntentResult {
        // Post notification to resume timer
        NotificationCenter.default.post(
            name: NSNotification.Name("ResumeTimerFromIntent"),
            object: nil
        )
        
        return .result()
    }
}
