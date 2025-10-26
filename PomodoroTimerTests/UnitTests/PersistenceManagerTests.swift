//
//  PersistenceManagerTests.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import XCTest
@testable import PomodoroTimer

final class PersistenceManagerTests: XCTestCase {
    
    var mockUserDefaults: MockUserDefaults!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        
        // Clear any existing data
        mockUserDefaults.clear()
    }
    
    override func tearDown() {
        mockUserDefaults.clear()
        mockUserDefaults = nil
        
        // Also clear actual UserDefaults used by PersistenceManager
        PersistenceManager.shared.clearAllSessions()
        
        super.tearDown()
    }
    
    // MARK: - Settings Persistence Tests
    
    func testSaveSettings() {
        let settings = TimerSettingsFactory.createCustomSettings(
            focusDuration: 30 * 60,
            selectedTheme: .dark
        )
        
        PersistenceManager.shared.saveSettings(settings)
        
        let loadedSettings = PersistenceManager.shared.loadSettings()
        
        XCTAssertEqual(loadedSettings.focusDuration, settings.focusDuration)
        XCTAssertEqual(loadedSettings.selectedTheme, settings.selectedTheme)
    }
    
    func testLoadDefaultSettingsWhenNoneExist() {
        let loadedSettings = PersistenceManager.shared.loadSettings()
        
        // Should return default settings
        XCTAssertEqual(loadedSettings.focusDuration, 25 * 60)
        XCTAssertEqual(loadedSettings.shortBreakDuration, 5 * 60)
        XCTAssertEqual(loadedSettings.longBreakDuration, 15 * 60)
    }
    
    func testOverwriteExistingSettings() {
        let settings1 = TimerSettingsFactory.createCustomSettings(focusDuration: 20 * 60)
        PersistenceManager.shared.saveSettings(settings1)
        
        let settings2 = TimerSettingsFactory.createCustomSettings(focusDuration: 30 * 60)
        PersistenceManager.shared.saveSettings(settings2)
        
        let loadedSettings = PersistenceManager.shared.loadSettings()
        
        XCTAssertEqual(loadedSettings.focusDuration, 30 * 60)
    }
    
    // MARK: - Session Storage Tests
    
    func testSaveSession() {
        let session = TimerSessionFactory.createFocusSession()
        
        PersistenceManager.shared.saveSession(session)
        
        let sessions = PersistenceManager.shared.getAllSessions()
        
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.id, session.id)
        XCTAssertEqual(sessions.first?.type, session.type)
    }
    
    func testSaveMultipleSessions() {
        let sessions = [
            TimerSessionFactory.createFocusSession(),
            TimerSessionFactory.createShortBreakSession(),
            TimerSessionFactory.createLongBreakSession()
        ]
        
        for session in sessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        let loadedSessions = PersistenceManager.shared.getAllSessions()
        
        XCTAssertEqual(loadedSessions.count, 3)
    }
    
    func testGetAllSessions() {
        let sessionCount = 5
        let sessions = TimerSessionFactory.createMultipleSessions(count: sessionCount)
        
        for session in sessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        let allSessions = PersistenceManager.shared.getAllSessions()
        
        XCTAssertEqual(allSessions.count, sessionCount)
    }
    
    func testGetAllSessionsWhenEmpty() {
        let sessions = PersistenceManager.shared.getAllSessions()
        
        XCTAssertTrue(sessions.isEmpty)
    }
    
    func testClearAllSessions() {
        let sessions = TimerSessionFactory.createMultipleSessions(count: 5)
        
        for session in sessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        XCTAssertFalse(PersistenceManager.shared.getAllSessions().isEmpty)
        
        PersistenceManager.shared.clearAllSessions()
        
        XCTAssertTrue(PersistenceManager.shared.getAllSessions().isEmpty)
    }
    
    // MARK: - Statistics Tests
    
    func testGetTodaySessions() {
        let todaySessions = TimerSessionFactory.createTodaySessions(count: 3)
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let yesterdaySession = TimerSession(type: .focus, duration: 1500, completedAt: yesterday)
        
        for session in todaySessions {
            PersistenceManager.shared.saveSession(session)
        }
        PersistenceManager.shared.saveSession(yesterdaySession)
        
        let retrievedTodaySessions = PersistenceManager.shared.getTodaySessions()
        
        XCTAssertEqual(retrievedTodaySessions.count, 3)
    }
    
    func testGetWeeklySessions() {
        let weeklySessions = TimerSessionFactory.createWeeklySessions()
        let calendar = Calendar.current
        let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: Date())!
        let oldSession = TimerSession(type: .focus, duration: 1500, completedAt: twoWeeksAgo)
        
        for session in weeklySessions {
            PersistenceManager.shared.saveSession(session)
        }
        PersistenceManager.shared.saveSession(oldSession)
        
        let retrievedWeeklySessions = PersistenceManager.shared.getWeeklySessions()
        
        XCTAssertEqual(retrievedWeeklySessions.count, 7)
    }
    
    func testGetMonthlySessions() {
        let calendar = Calendar.current
        let now = Date()
        
        // Create sessions within the last month
        var monthlySessions: [TimerSession] = []
        for day in 0..<15 {
            let date = calendar.date(byAdding: .day, value: -day, to: now)!
            monthlySessions.append(TimerSession(type: .focus, duration: 1500, completedAt: date))
        }
        
        // Create session older than a month
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: now)!
        let oldSession = TimerSession(type: .focus, duration: 1500, completedAt: twoMonthsAgo)
        
        for session in monthlySessions {
            PersistenceManager.shared.saveSession(session)
        }
        PersistenceManager.shared.saveSession(oldSession)
        
        let retrievedMonthlySessions = PersistenceManager.shared.getMonthlySessions()
        
        XCTAssertEqual(retrievedMonthlySessions.count, 15)
    }
    
    // MARK: - Streak Calculation Tests
    
    func testGetCurrentStreakWithNoSessions() {
        let streak = PersistenceManager.shared.getCurrentStreak()
        
        XCTAssertEqual(streak, 0)
    }
    
    func testGetCurrentStreakWithOneDayStreak() {
        let today = Date()
        let session = TimerSession(type: .focus, duration: 1500, completedAt: today)
        
        PersistenceManager.shared.saveSession(session)
        
        let streak = PersistenceManager.shared.getCurrentStreak()
        
        XCTAssertEqual(streak, 1)
    }
    
    func testGetCurrentStreakWithMultipleDays() {
        let sessions = TimerSessionFactory.createStreakSessions(streakDays: 5)
        
        for session in sessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        let streak = PersistenceManager.shared.getCurrentStreak()
        
        XCTAssertEqual(streak, 5)
    }
    
    func testGetCurrentStreakWithBrokenStreak() {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        
        let todaySession = TimerSession(type: .focus, duration: 1500, completedAt: today)
        let yesterdaySession = TimerSession(type: .focus, duration: 1500, completedAt: yesterday)
        let oldSession = TimerSession(type: .focus, duration: 1500, completedAt: threeDaysAgo)
        
        PersistenceManager.shared.saveSession(todaySession)
        PersistenceManager.shared.saveSession(yesterdaySession)
        PersistenceManager.shared.saveSession(oldSession)
        
        let streak = PersistenceManager.shared.getCurrentStreak()
        
        XCTAssertEqual(streak, 2, "Streak should be 2 (today and yesterday)")
    }
    
    func testGetCurrentStreakWithMultipleSessionsPerDay() {
        let calendar = Calendar.current
        let today = Date()
        
        // Multiple sessions today
        for _ in 0..<3 {
            PersistenceManager.shared.saveSession(TimerSession(type: .focus, duration: 1500, completedAt: today))
        }
        
        // Multiple sessions yesterday
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        for _ in 0..<2 {
            PersistenceManager.shared.saveSession(TimerSession(type: .focus, duration: 1500, completedAt: yesterday))
        }
        
        let streak = PersistenceManager.shared.getCurrentStreak()
        
        XCTAssertEqual(streak, 2, "Streak should count days, not individual sessions")
    }
    
    // MARK: - Data Integrity Tests
    
    func testSessionOrderPreserved() {
        let sessions = [
            TimerSessionFactory.createFocusSession(),
            TimerSessionFactory.createShortBreakSession(),
            TimerSessionFactory.createLongBreakSession()
        ]
        
        for session in sessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        let loadedSessions = PersistenceManager.shared.getAllSessions()
        
        XCTAssertEqual(loadedSessions.count, sessions.count)
        for (index, session) in sessions.enumerated() {
            XCTAssertEqual(loadedSessions[index].id, session.id)
        }
    }
    
    func testLargeDatasetHandling() {
        let largeCount = 100
        let sessions = TimerSessionFactory.createMultipleSessions(count: largeCount)
        
        for session in sessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        let loadedSessions = PersistenceManager.shared.getAllSessions()
        
        XCTAssertEqual(loadedSessions.count, largeCount)
    }
    
    // MARK: - Edge Cases
    
    func testSaveSessionWithSameID() {
        let id = UUID()
        let session1 = TimerSession(id: id, type: .focus, duration: 1500)
        let session2 = TimerSession(id: id, type: .shortBreak, duration: 300)
        
        PersistenceManager.shared.saveSession(session1)
        PersistenceManager.shared.saveSession(session2)
        
        let sessions = PersistenceManager.shared.getAllSessions()
        
        // Both should be saved (no duplicate checking in current implementation)
        XCTAssertEqual(sessions.count, 2)
    }
    
    func testSessionsWithFutureDates() {
        let futureDate = Date(timeIntervalSinceNow: 3600 * 24) // Tomorrow
        let session = TimerSession(type: .focus, duration: 1500, completedAt: futureDate)
        
        PersistenceManager.shared.saveSession(session)
        
        let sessions = PersistenceManager.shared.getAllSessions()
        
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.completedAt, futureDate)
    }
}
