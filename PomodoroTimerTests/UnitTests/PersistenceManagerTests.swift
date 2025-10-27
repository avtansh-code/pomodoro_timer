//
//  PersistenceManagerTests.swift
//  PomodoroTimerTests
//
//  Comprehensive tests for PersistenceManager
//

import XCTest
@testable import PomodoroTimer

final class PersistenceManagerTests: XCTestCase {
    
    var persistenceManager: PersistenceManager!
    var mockUserDefaults: MockUserDefaults!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        persistenceManager = PersistenceManager.create(with: mockUserDefaults)
    }
    
    override func tearDown() {
        persistenceManager.clearAllSessions()
        mockUserDefaults = nil
        persistenceManager = nil
        super.tearDown()
    }
    
    // MARK: - Settings Persistence Tests
    
    func testSaveAndLoadSettings() {
        let settings = TimerSettingsFactory.createCustomSettings(
            focusDuration: 30 * 60,
            shortBreakDuration: 10 * 60,
            longBreakDuration: 20 * 60,
            sessionsUntilLongBreak: 3,
            autoStartBreaks: true,
            selectedTheme: .dark
        )
        
        persistenceManager.saveSettings(settings)
        let loadedSettings = persistenceManager.loadSettings()
        
        XCTAssertEqual(loadedSettings.focusDuration, settings.focusDuration)
        XCTAssertEqual(loadedSettings.shortBreakDuration, settings.shortBreakDuration)
        XCTAssertEqual(loadedSettings.longBreakDuration, settings.longBreakDuration)
        XCTAssertEqual(loadedSettings.sessionsUntilLongBreak, settings.sessionsUntilLongBreak)
        XCTAssertEqual(loadedSettings.autoStartBreaks, settings.autoStartBreaks)
        XCTAssertEqual(loadedSettings.selectedTheme, settings.selectedTheme)
    }
    
    func testLoadDefaultSettingsWhenNoneExist() {
        let loadedSettings = persistenceManager.loadSettings()
        
        // Should return default settings
        XCTAssertEqual(loadedSettings.focusDuration, 25 * 60)
        XCTAssertEqual(loadedSettings.shortBreakDuration, 5 * 60)
        XCTAssertEqual(loadedSettings.longBreakDuration, 15 * 60)
        XCTAssertEqual(loadedSettings.sessionsUntilLongBreak, 4)
        XCTAssertFalse(loadedSettings.autoStartBreaks)
        XCTAssertEqual(loadedSettings.selectedTheme, .system)
    }
    
    func testSaveSettingsWithAllProperties() {
        let settings = TimerSettingsFactory.createCustomSettings(
            focusDuration: 45 * 60,
            shortBreakDuration: 15 * 60,
            longBreakDuration: 30 * 60,
            sessionsUntilLongBreak: 5,
            autoStartBreaks: true,
            autoStartFocus: true,
            soundEnabled: false,
            hapticEnabled: false,
            notificationsEnabled: false,
            selectedTheme: .light,
            focusModeEnabled: true,
            syncWithFocusMode: true,
            iCloudSyncEnabled: true
        )
        
        persistenceManager.saveSettings(settings)
        let loadedSettings = persistenceManager.loadSettings()
        
        XCTAssertEqual(loadedSettings.focusDuration, 45 * 60)
        XCTAssertEqual(loadedSettings.shortBreakDuration, 15 * 60)
        XCTAssertEqual(loadedSettings.longBreakDuration, 30 * 60)
        XCTAssertEqual(loadedSettings.sessionsUntilLongBreak, 5)
        XCTAssertTrue(loadedSettings.autoStartBreaks)
        XCTAssertTrue(loadedSettings.autoStartFocus)
        XCTAssertFalse(loadedSettings.soundEnabled)
        XCTAssertFalse(loadedSettings.hapticEnabled)
        XCTAssertFalse(loadedSettings.notificationsEnabled)
        XCTAssertEqual(loadedSettings.selectedTheme, .light)
        XCTAssertTrue(loadedSettings.focusModeEnabled)
        XCTAssertTrue(loadedSettings.syncWithFocusMode)
        XCTAssertTrue(loadedSettings.iCloudSyncEnabled)
    }
    
    // MARK: - Session Persistence Tests
    
    func testSaveAndLoadSingleSession() {
        let session = TimerSessionFactory.createFocusSession()
        
        persistenceManager.saveSession(session)
        let sessions = persistenceManager.getAllSessions()
        
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.id, session.id)
        XCTAssertEqual(sessions.first?.type, session.type)
        XCTAssertEqual(sessions.first?.duration, session.duration)
    }
    
    func testSaveMultipleSessions() {
        let sessions = TimerSessionFactory.createMultipleSessions(count: 5)
        
        for session in sessions {
            persistenceManager.saveSession(session)
        }
        
        let loadedSessions = persistenceManager.getAllSessions()
        XCTAssertEqual(loadedSessions.count, 5)
    }
    
    func testSaveSessionsOfDifferentTypes() {
        let focusSession = TimerSessionFactory.createFocusSession()
        let shortBreakSession = TimerSessionFactory.createShortBreakSession()
        let longBreakSession = TimerSessionFactory.createLongBreakSession()
        
        persistenceManager.saveSession(focusSession)
        persistenceManager.saveSession(shortBreakSession)
        persistenceManager.saveSession(longBreakSession)
        
        let sessions = persistenceManager.getAllSessions()
        XCTAssertEqual(sessions.count, 3)
        
        let focusSessions = sessions.filter { $0.type == .focus }
        let shortBreakSessions = sessions.filter { $0.type == .shortBreak }
        let longBreakSessions = sessions.filter { $0.type == .longBreak }
        
        XCTAssertEqual(focusSessions.count, 1)
        XCTAssertEqual(shortBreakSessions.count, 1)
        XCTAssertEqual(longBreakSessions.count, 1)
    }
    
    func testClearAllSessions() {
        let sessions = TimerSessionFactory.createMultipleSessions(count: 3)
        
        for session in sessions {
            persistenceManager.saveSession(session)
        }
        
        XCTAssertEqual(persistenceManager.getAllSessions().count, 3)
        
        persistenceManager.clearAllSessions()
        
        XCTAssertTrue(persistenceManager.getAllSessions().isEmpty)
    }
    
    // MARK: - Statistics Tests
    
    func testGetTodaySessions() {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        // Create sessions for today and yesterday
        let todaySession = TimerSession(type: .focus, duration: 1500, completedAt: today)
        let yesterdaySession = TimerSession(type: .focus, duration: 1500, completedAt: yesterday)
        
        persistenceManager.saveSession(todaySession)
        persistenceManager.saveSession(yesterdaySession)
        
        let todaySessions = persistenceManager.getTodaySessions()
        
        XCTAssertEqual(todaySessions.count, 1)
        XCTAssertEqual(todaySessions.first?.id, todaySession.id)
    }
    
    func testGetWeeklySessions() {
        let calendar = Calendar.current
        let today = Date()
        let fiveDaysAgo = calendar.date(byAdding: .day, value: -5, to: today)!
        let tenDaysAgo = calendar.date(byAdding: .day, value: -10, to: today)!
        
        let recentSession = TimerSession(type: .focus, duration: 1500, completedAt: fiveDaysAgo)
        let oldSession = TimerSession(type: .focus, duration: 1500, completedAt: tenDaysAgo)
        
        persistenceManager.saveSession(recentSession)
        persistenceManager.saveSession(oldSession)
        
        let weeklySessions = persistenceManager.getWeeklySessions()
        
        XCTAssertEqual(weeklySessions.count, 1)
        XCTAssertEqual(weeklySessions.first?.id, recentSession.id)
    }
    
    func testGetMonthlySessions() {
        let calendar = Calendar.current
        let today = Date()
        let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: today)!
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: today)!
        
        let recentSession = TimerSession(type: .focus, duration: 1500, completedAt: twoWeeksAgo)
        let oldSession = TimerSession(type: .focus, duration: 1500, completedAt: twoMonthsAgo)
        
        persistenceManager.saveSession(recentSession)
        persistenceManager.saveSession(oldSession)
        
        let monthlySessions = persistenceManager.getMonthlySessions()
        
        XCTAssertEqual(monthlySessions.count, 1)
        XCTAssertEqual(monthlySessions.first?.id, recentSession.id)
    }
    
    func testGetCurrentStreak() {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        let fourDaysAgo = calendar.date(byAdding: .day, value: -4, to: today)! // Gap in streak
        
        // Create sessions for consecutive days
        let todaySession = TimerSession(type: .focus, duration: 1500, completedAt: today)
        let yesterdaySession = TimerSession(type: .focus, duration: 1500, completedAt: yesterday)
        let twoDaysAgoSession = TimerSession(type: .focus, duration: 1500, completedAt: twoDaysAgo)
        let fourDaysAgoSession = TimerSession(type: .focus, duration: 1500, completedAt: fourDaysAgo)
        
        persistenceManager.saveSession(todaySession)
        persistenceManager.saveSession(yesterdaySession)
        persistenceManager.saveSession(twoDaysAgoSession)
        persistenceManager.saveSession(fourDaysAgoSession)
        
        let streak = persistenceManager.getCurrentStreak()
        
        XCTAssertEqual(streak, 3) // Today, yesterday, and two days ago
    }
    
    func testGetCurrentStreakWithNoSessions() {
        let streak = persistenceManager.getCurrentStreak()
        XCTAssertEqual(streak, 0)
    }
    
    func testGetCurrentStreakWithOnlyTodaySession() {
        let todaySession = TimerSession(type: .focus, duration: 1500, completedAt: Date())
        persistenceManager.saveSession(todaySession)
        
        let streak = persistenceManager.getCurrentStreak()
        XCTAssertEqual(streak, 1)
    }
    
    func testGetCurrentStreakWithGapInDays() {
        let calendar = Calendar.current
        let today = Date()
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!
        
        let todaySession = TimerSession(type: .focus, duration: 1500, completedAt: today)
        let threeDaysAgoSession = TimerSession(type: .focus, duration: 1500, completedAt: threeDaysAgo)
        
        persistenceManager.saveSession(todaySession)
        persistenceManager.saveSession(threeDaysAgoSession)
        
        let streak = persistenceManager.getCurrentStreak()
        XCTAssertEqual(streak, 1) // Only today counts due to gap
    }
    
    // MARK: - iCloud Sync Integration Tests
    
    func testSyncWithCloudWhenDisabled() {
        let settings = TimerSettingsFactory.createCustomSettings(iCloudSyncEnabled: false)
        persistenceManager.saveSettings(settings)
        
        let expectation = expectation(description: "Sync completion")
        
        persistenceManager.syncWithCloud {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSyncWithCloudWhenEnabled() {
        let settings = TimerSettingsFactory.createCustomSettings(iCloudSyncEnabled: true)
        persistenceManager.saveSettings(settings)
        
        let expectation = expectation(description: "Sync completion")
        
        persistenceManager.syncWithCloud {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Edge Cases
    
    func testSaveSessionWithCustomDate() {
        let calendar = Calendar.current
        let customDate = calendar.date(byAdding: .hour, value: -2, to: Date())!
        let session = TimerSession(type: .focus, duration: 1500, completedAt: customDate)
        
        persistenceManager.saveSession(session)
        let sessions = persistenceManager.getAllSessions()
        
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.completedAt, customDate)
    }
    
    func testSaveSessionWithZeroDuration() {
        let session = TimerSession(type: .focus, duration: 0)
        
        persistenceManager.saveSession(session)
        let sessions = persistenceManager.getAllSessions()
        
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.duration, 0)
    }
    
    func testSaveSessionWithLargeDuration() {
        let largeDuration: TimeInterval = 24 * 60 * 60 // 24 hours
        let session = TimerSession(type: .focus, duration: largeDuration)
        
        persistenceManager.saveSession(session)
        let sessions = persistenceManager.getAllSessions()
        
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.duration, largeDuration)
    }
    
    func testCorruptedSettingsData() {
        // Manually set corrupted data
        mockUserDefaults.set("invalid json data", forKey: "TimerSettings")
        
        // Should return default settings when data is corrupted
        let settings = persistenceManager.loadSettings()
        XCTAssertEqual(settings.focusDuration, 25 * 60)
        XCTAssertEqual(settings.selectedTheme, .system)
    }
    
    func testCorruptedSessionsData() {
        // Manually set corrupted data
        mockUserDefaults.set("invalid json data", forKey: "SavedSessions")
        
        // Should return empty array when data is corrupted
        let sessions = persistenceManager.getAllSessions()
        XCTAssertTrue(sessions.isEmpty)
    }
    
    // MARK: - Performance Tests
    
    func testSavingManySessionsPerformance() {
        measure {
            for i in 0..<100 {
                let session = TimerSession(type: i % 3 == 0 ? .focus : .shortBreak, duration: 1500)
                persistenceManager.saveSession(session)
            }
        }
    }
    
    func testLoadingManySessionsPerformance() {
        // First save many sessions
        for i in 0..<100 {
            let session = TimerSession(type: i % 3 == 0 ? .focus : .shortBreak, duration: 1500)
            persistenceManager.saveSession(session)
        }
        
        measure {
            _ = persistenceManager.getAllSessions()
        }
    }
    
    // MARK: - Memory Management Tests
    
    func testMemoryUsageWithManySessions() {
        // Create many sessions to test memory usage
        for i in 0..<1000 {
            let session = TimerSession(type: i % 3 == 0 ? .focus : .shortBreak, duration: 1500)
            persistenceManager.saveSession(session)
        }
        
        let sessions = persistenceManager.getAllSessions()
        XCTAssertEqual(sessions.count, 1000)
        
        // Clear sessions and verify memory is released
        persistenceManager.clearAllSessions()
        let clearedSessions = persistenceManager.getAllSessions()
        XCTAssertTrue(clearedSessions.isEmpty)
    }
}
