//
//  TimerPerformanceTests.swift
//  PomodoroTimerPerformanceTests
//
//  Comprehensive performance tests for the Pomodoro Timer
//

import XCTest
@testable import PomodoroTimer

@MainActor
final class TimerPerformanceTests: XCTestCase {
    
    var timerManager: TimerManager!
    var persistenceManager: PersistenceManager!
    
    // MARK: - Setup & Teardown
    
    override func setUp() async throws {
        try await super.setUp()
        persistenceManager = PersistenceManager.shared
        
        let settings = TimerSettings()
        settings.focusDuration = 5 // Short duration for faster tests
        settings.shortBreakDuration = 2
        settings.longBreakDuration = 3
        timerManager = TimerManager(settings: settings, persistenceManager: persistenceManager)
        
        persistenceManager.clearAllSessions()
    }
    
    override func tearDown() {
        timerManager?.resetTimer()
        timerManager = nil
        persistenceManager?.clearAllSessions()
        persistenceManager = nil
        super.tearDown()
    }
    
    // MARK: - Timer Performance Tests
    
    func testTimerInitializationPerformance() {
        measure {
            for _ in 0..<100 {
                let settings = TimerSettings()
                settings.focusDuration = 25 * 60
                settings.shortBreakDuration = 5 * 60
                settings.longBreakDuration = 15 * 60
                let manager = TimerManager(settings: settings)
                manager.resetTimer()
            }
        }
    }
    
    func testTimerStartStopPerformance() {
        measure {
            for _ in 0..<1000 {
                timerManager.startTimer()
                timerManager.pauseTimer()
                timerManager.resetTimer()
            }
        }
    }
    
    func testTimerStateTransitionPerformance() {
        measure {
            for _ in 0..<500 {
                timerManager.startTimer()
                timerManager.pauseTimer()
                timerManager.startTimer() // Resume
                timerManager.resetTimer()
            }
        }
    }
    
    func testSessionSkippingPerformance() {
        measure {
            for _ in 0..<200 {
                timerManager.skipSession()
            }
            timerManager.resetTimer()
        }
    }
    
    func testTimerAccuracyUnderLoad() {
        timerManager.timeRemaining = 10 // 10 seconds
        let startTime = Date()
        
        measure {
            timerManager.startTimer()
            
            // Simulate load with rapid state checks
            for _ in 0..<1000 {
                _ = timerManager.timerState
                _ = timerManager.timeRemaining
                _ = timerManager.currentSessionType
                _ = timerManager.completedFocusSessions
            }
            
            let elapsed = Date().timeIntervalSince(startTime)
            let expectedRemaining = max(0, 10 - elapsed)
            let actualRemaining = timerManager.timeRemaining
            
            // Accuracy should be maintained within reasonable bounds
            let accuracy = abs(actualRemaining - expectedRemaining)
            XCTAssertLessThan(accuracy, 2.0, "Timer accuracy should be maintained under load")
            
            timerManager.resetTimer()
        }
    }
    
    // MARK: - Background/Foreground Performance Tests
    
    func testBackgroundForegroundTransitionPerformance() {
        timerManager.timeRemaining = 30
        timerManager.startTimer()
        
        measure {
            for _ in 0..<100 {
                timerManager.appDidEnterBackground()
                Thread.sleep(forTimeInterval: 0.01) // 10ms
                timerManager.appWillEnterForeground()
            }
        }
        
        timerManager.resetTimer()
    }
    
    func testBackgroundTimerCalculationPerformance() {
        timerManager.timeRemaining = 600 // 10 minutes
        timerManager.startTimer()
        timerManager.appDidEnterBackground()
        
        measure {
            // Simulate various elapsed times
            for i in 0..<100 {
                let simulatedElapsed = TimeInterval(i % 60) // 0-59 seconds
                Thread.sleep(forTimeInterval: 0.001) // 1ms
                timerManager.appWillEnterForeground()
                timerManager.appDidEnterBackground()
            }
        }
        
        timerManager.resetTimer()
    }
    
    // MARK: - Settings Performance Tests
    
    func testSettingsUpdatePerformance() {
        measure {
            for i in 0..<1000 {
                timerManager.settings.focusDuration = TimeInterval((20 + i % 40) * 60)
                timerManager.settings.shortBreakDuration = TimeInterval((5 + i % 10) * 60)
                timerManager.settings.longBreakDuration = TimeInterval((15 + i % 20) * 60)
                timerManager.settings.sessionsUntilLongBreak = (i % 8) + 2
                timerManager.settings.autoStartBreaks = i % 2 == 0
                timerManager.settings.autoStartFocus = i % 3 == 0
                // Skip theme setting for performance tests
            }
        }
    }
    
    func testSettingsPersistencePerformance() {
        let settings = TimerSettings()
        settings.focusDuration = 25 * 60
        settings.autoStartBreaks = true
        
        measure {
            for _ in 0..<100 {
                persistenceManager.saveSettings(settings)
                _ = persistenceManager.loadSettings()
            }
        }
    }
    
    // MARK: - Session Persistence Performance Tests
    
    func testSingleSessionSavePerformance() {
        measure {
            for _ in 0..<100 {
                let session = TimerSession(type: .focus, duration: 1500)
                persistenceManager.saveSession(session)
            }
        }
    }
    
    func testBulkSessionSavePerformance() {
        var sessions: [TimerSession] = []
        for i in 0..<100 {
            let sessionType: SessionType = i % 3 == 0 ? .focus : (i % 3 == 1 ? .shortBreak : .longBreak)
            sessions.append(TimerSession(type: sessionType, duration: 1500))
        }
        
        measure {
            for session in sessions {
                persistenceManager.saveSession(session)
            }
        }
    }
    
    func testSessionLoadPerformance() {
        // Pre-populate with sessions
        for i in 0..<500 {
            let sessionType: SessionType = i % 3 == 0 ? .focus : (i % 3 == 1 ? .shortBreak : .longBreak)
            let session = TimerSession(type: sessionType, duration: 1500)
            persistenceManager.saveSession(session)
        }
        
        measure {
            _ = persistenceManager.getAllSessions()
        }
    }
    
    func testSessionFilteringPerformance() {
        // Pre-populate with many sessions across different time periods
        let calendar = Calendar.current
        let now = Date()
        
        for i in 0..<1000 {
            let daysAgo = calendar.date(byAdding: .day, value: -(i % 365), to: now)!
            let session = TimerSession(type: i % 3 == 0 ? .focus : .shortBreak, 
                                     duration: 1500, 
                                     completedAt: daysAgo)
            persistenceManager.saveSession(session)
        }
        
        measure {
            _ = persistenceManager.getTodaySessions()
            _ = persistenceManager.getWeeklySessions()
            _ = persistenceManager.getMonthlySessions()
        }
    }
    
    func testStreakCalculationPerformance() {
        // Create a long streak for performance testing
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<100 {
            let dayOffset = calendar.date(byAdding: .day, value: -i, to: today)!
            let session = TimerSession(type: .focus, duration: 1500, completedAt: dayOffset)
            persistenceManager.saveSession(session)
        }
        
        measure {
            _ = persistenceManager.getCurrentStreak()
        }
    }
    
    // MARK: - Memory Performance Tests
    
    func testMemoryUsageWithManyTimerOperations() {
        measure(metrics: [XCTMemoryMetric()]) {
            for _ in 0..<1000 {
                timerManager.startTimer()
                timerManager.pauseTimer()
                timerManager.skipSession()
                timerManager.resetTimer()
            }
        }
    }
    
    func testMemoryUsageWithManySessionsSaved() {
        measure(metrics: [XCTMemoryMetric()]) {
            for i in 0..<1000 {
                let session = TimerSession(
                    type: i % 3 == 0 ? .focus : (i % 3 == 1 ? .shortBreak : .longBreak),
                    duration: TimeInterval(1200 + (i % 600))
                )
                persistenceManager.saveSession(session)
            }
        }
    }
    
    func testMemoryUsageWithLargeDataLoad() {
        // Pre-populate with many sessions
        for i in 0..<5000 {
            let session = TimerSession(type: i % 3 == 0 ? .focus : .shortBreak, duration: 1500)
            persistenceManager.saveSession(session)
        }
        
        measure(metrics: [XCTMemoryMetric()]) {
            let sessions = persistenceManager.getAllSessions()
            
            // Process all sessions to simulate real usage
            let focusSessions = sessions.filter { $0.type == .focus }
            let breakSessions = sessions.filter { $0.type != .focus }
            let totalFocusTime = focusSessions.reduce(0) { $0 + $1.duration }
            let totalBreakTime = breakSessions.reduce(0) { $0 + $1.duration }
            
            XCTAssertGreaterThan(focusSessions.count, 0)
            XCTAssertGreaterThan(totalFocusTime, 0)
            XCTAssertGreaterThan(totalBreakTime, 0)
        }
    }
    
    // MARK: - CPU Performance Tests
    
    func testCPUUsageUnderNormalOperations() {
        measure(metrics: [XCTCPUMetric()]) {
            for _ in 0..<100 {
                timerManager.startTimer()
                
                // Simulate timer running with property access
                for _ in 0..<50 {
                    _ = timerManager.timerState
                    _ = timerManager.timeRemaining
                    _ = timerManager.currentSessionType
                }
                
                timerManager.pauseTimer()
                timerManager.resetTimer()
            }
        }
    }
    
    func testCPUUsageWithSessionManagement() {
        measure(metrics: [XCTCPUMetric()]) {
            for _ in 0..<50 {
                // Simulate completing sessions
                timerManager.skipSession()
                
                // Load and process sessions
                let sessions = timerManager.loadSessions()
                let focusCount = sessions.filter { $0.type == .focus }.count
                let breakCount = sessions.filter { $0.type != .focus }.count
                
                XCTAssertGreaterThanOrEqual(focusCount + breakCount, 0)
            }
        }
    }
    
    // MARK: - Concurrent Performance Tests
    
    func testConcurrentTimerOperations() {
        let expectation = XCTestExpectation(description: "Concurrent operations")
        expectation.expectedFulfillmentCount = 4
        
        measure {
            let queue = DispatchQueue.global(qos: .userInitiated)
            
            // Multiple concurrent operations
            queue.async {
                for _ in 0..<100 {
                    DispatchQueue.main.sync {
                        self.timerManager.startTimer()
                        self.timerManager.pauseTimer()
                    }
                }
                expectation.fulfill()
            }
            
            queue.async {
                for _ in 0..<100 {
                    DispatchQueue.main.sync {
                        _ = self.timerManager.timerState
                        _ = self.timerManager.timeRemaining
                    }
                }
                expectation.fulfill()
            }
            
            queue.async {
                for _ in 0..<50 {
                    let session = TimerSession(type: .focus, duration: 1500)
                    self.persistenceManager.saveSession(session)
                }
                expectation.fulfill()
            }
            
            queue.async {
                for _ in 0..<50 {
                    _ = self.persistenceManager.getAllSessions()
                }
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 10.0)
        }
    }
    
    // MARK: - Data Volume Performance Tests
    
    func testPerformanceWithLargeTimeValues() {
        measure {
            // Test with very large duration values
            let largeDuration: TimeInterval = 24 * 60 * 60 * 365 // 1 year in seconds
            
            for _ in 0..<100 {
                timerManager.settings.focusDuration = largeDuration
                timerManager.timeRemaining = largeDuration
                
                // Test calculations with large values
                timerManager.startTimer()
                timerManager.pauseTimer()
                timerManager.resetTimer()
            }
        }
    }
    
    func testPerformanceWithManySessionTypes() {
        measure {
            for i in 0..<300 {
                let sessionType: SessionType = i % 3 == 0 ? .focus : (i % 3 == 1 ? .shortBreak : .longBreak)
                let session = TimerSession(type: sessionType, duration: TimeInterval(900 + (i % 1200)))
                persistenceManager.saveSession(session)
                
                if i % 10 == 0 {
                    _ = persistenceManager.getAllSessions()
                }
            }
        }
    }
    
    // MARK: - Edge Case Performance Tests
    
    func testPerformanceWithRapidStateChanges() {
        measure {
            for _ in 0..<200 {
                timerManager.startTimer()
                timerManager.pauseTimer()
                timerManager.startTimer()
                timerManager.resetTimer()
                timerManager.skipSession()
                timerManager.startTimer()
                timerManager.resetTimer()
            }
        }
    }
    
    func testPerformanceWithZeroDurations() {
        measure {
            timerManager.settings.focusDuration = 0
            timerManager.settings.shortBreakDuration = 0
            timerManager.settings.longBreakDuration = 0
            
            for _ in 0..<1000 {
                timerManager.startTimer()
                timerManager.skipSession()
                timerManager.resetTimer()
            }
        }
    }
    
    // MARK: - Real-World Scenario Performance Tests
    
    func testDailyUsageScenarioPerformance() {
        measure {
            // Simulate a full day of Pomodoro usage (8 sessions)
            for session in 0..<8 {
                // Start focus session
                timerManager.startTimer()
                
                // Simulate some state checks during session
                for _ in 0..<10 {
                    _ = timerManager.timeRemaining
                    _ = timerManager.timerState
                }
                
                // Complete session
                timerManager.skipSession()
                
                // Start break
                timerManager.startTimer()
                timerManager.skipSession()
                
                // Check statistics periodically
                if session % 2 == 0 {
                    _ = persistenceManager.getTodaySessions()
                    _ = persistenceManager.getCurrentStreak()
                }
            }
        }
    }
    
    func testWeeklyDataProcessingPerformance() {
        // Pre-populate with a week's worth of sessions
        let calendar = Calendar.current
        let today = Date()
        
        for day in 0..<7 {
            let dayDate = calendar.date(byAdding: .day, value: -day, to: today)!
            
            for session in 0..<8 { // 8 sessions per day
                let sessionType: SessionType = session % 2 == 0 ? .focus : .shortBreak
                let sessionData = TimerSession(type: sessionType, duration: 1500, completedAt: dayDate)
                persistenceManager.saveSession(sessionData)
            }
        }
        
        measure {
            _ = persistenceManager.getWeeklySessions()
            _ = persistenceManager.getCurrentStreak()
            
            // Process weekly statistics
            let weeklySessions = persistenceManager.getWeeklySessions()
            let focusSessions = weeklySessions.filter { $0.type == .focus }
            let totalFocusTime = focusSessions.reduce(0) { $0 + $1.duration }
            let averageSessionsPerDay = Double(weeklySessions.count) / 7.0
            
            XCTAssertGreaterThan(totalFocusTime, 0)
            XCTAssertGreaterThan(averageSessionsPerDay, 0)
        }
    }
}
