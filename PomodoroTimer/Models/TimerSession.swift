//
//  TimerSession.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import Foundation

enum SessionType: String, Codable {
    case focus = "Focus"
    case shortBreak = "Short Break"
    case longBreak = "Long Break"
}

struct TimerSession: Identifiable, Codable {
    let id: UUID
    let type: SessionType
    let duration: TimeInterval
    let completedAt: Date
    
    init(id: UUID = UUID(), type: SessionType, duration: TimeInterval, completedAt: Date = Date()) {
        self.id = id
        self.type = type
        self.duration = duration
        self.completedAt = completedAt
    }
}
