//
//  TimerSession.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import Foundation

enum SessionType: String, Codable, Sendable {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
}

struct TimerSession: Identifiable, Codable, Sendable {
    let id: UUID
    let type: SessionType
    let duration: TimeInterval
    let completedAt: Date
    let wasCompleted: Bool // Track if session was completed or skipped
    
    init(id: UUID = UUID(), type: SessionType, duration: TimeInterval, completedAt: Date = Date(), wasCompleted: Bool = true) {
        self.id = id
        self.type = type
        self.duration = duration
        self.completedAt = completedAt
        self.wasCompleted = wasCompleted
    }
}
