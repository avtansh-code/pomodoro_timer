//
//  TimerSessionFactory.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import Foundation
@testable import PomodoroTimer

struct TimerSessionFactory {
    static func createFocusSession(
        completedAt: Date = Date(),
        duration: TimeInterval = TestConstants.defaultFocusDuration
    ) -> TimerSession {
        return TimerSession(
            type: .focus,
            duration: duration,
            completedAt: completedAt
        )
    }
    
    static func createShortBreakSession(
        completedAt: Date = Date(),
        duration: TimeInterval = TestConstants.defaultShortBreakDuration
    ) -> TimerSession {
        return TimerSession(
            type: .shortBreak,
            duration: duration,
            completedAt: completedAt
        )
    }
    
    static func createLongBreakSession(
        completedAt: Date = Date(),
        duration: TimeInterval = TestConstants.defaultLongBreakDuration
    ) -> TimerSession {
        return TimerSession(
            type: .longBreak,
            duration: duration,
            completedAt: completedAt
        )
    }
    
    static func createMultipleSessions(count: Int, type: SessionType = .focus) -> [TimerSession] {
        var sessions: [TimerSession] = []
        let calendar = Calendar.current
        
        for i in 0..<count {
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            sessions.append(TimerSession(
                type: type,
                duration: TestConstants.defaultFocusDuration,
                completedAt: date
            ))
        }
        
        return sessions
    }
    
    static func createTodaySessions(count: Int) -> [TimerSession] {
        var sessions: [TimerSession] = []
        let now = Date()
        
        for i in 0..<count {
            let date = now.addingTimeInterval(TimeInterval(-i * 60))
            sessions.append(TimerSession(
                type: .focus,
                duration: TestConstants.defaultFocusDuration,
                completedAt: date
            ))
        }
        
        return sessions
    }
    
    static func createWeeklySessions() -> [TimerSession] {
        var sessions: [TimerSession] = []
        let calendar = Calendar.current
        
        for day in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            sessions.append(TimerSession(
                type: .focus,
                duration: TestConstants.defaultFocusDuration,
                completedAt: date
            ))
        }
        
        return sessions
    }
    
    static func createStreakSessions(streakDays: Int) -> [TimerSession] {
        var sessions: [TimerSession] = []
        let calendar = Calendar.current
        
        for day in 0..<streakDays {
            let date = calendar.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            sessions.append(TimerSession(
                type: .focus,
                duration: TestConstants.defaultFocusDuration,
                completedAt: date
            ))
        }
        
        return sessions
    }
}
