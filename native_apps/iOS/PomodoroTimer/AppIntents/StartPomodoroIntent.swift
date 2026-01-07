//
//  StartPomodoroIntent.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import AppIntents
import Foundation

@available(iOS 16.0, *)
struct StartPomodoroIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Pomodoro"
    static var description = IntentDescription("Starts a new Pomodoro focus session")
    
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Duration (minutes)", description: "Custom duration for this session", default: nil)
    var duration: Int?
    
    func perform() async throws -> some IntentResult {
        // Post notification to start timer
        NotificationCenter.default.post(
            name: NSNotification.Name("StartPomodoroFromIntent"),
            object: nil,
            userInfo: duration != nil ? ["duration": duration!] : nil
        )
        
        return .result()
    }
}
