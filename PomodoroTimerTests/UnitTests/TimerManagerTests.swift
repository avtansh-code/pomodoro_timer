//
//  TimerManagerTests.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import XCTest
import Combine
@testable import PomodoroTimer

final class TimerManagerTests: XCTestCase {
    
    var timerManager: TimerManager!
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        cancellables.removeAll()
        
        // Use short durations for faster tests
        let settings = TimerSettingsFactory.createShortDurationSettings()
        timerManager = TimerManager(settings: settings)
        
        // Clear any existing sessions
        PersistenceManager.shared.clearAllSessions()
        clearAllNotifications()
    }
    
    override func tearDown() {
        timerManager?.resetTimer()
        timerManager = nil
        cancellables.removeAll()
        PersistenceManager.shared.clearAllSessions()
        clearAllNotifications()
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testTimerManagerInitialization() {
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
            XCTAssertEqual(timerManager.currentSessionType, .focus)
            XCTAssertEqual(timerManager.completedFocusSessions, 0)
            XCTAssertEqual(timerManager.timeRemaining, timerManager.settings.focusDuration)
        }
    }
    
    func testTimerManagerInitializationWithCustomSettings() {
        let customSettings = TimerSettingsFactory.createCustomSettings(focusDuration: 30 * 60)
        let manager = TimerManager(settings: customSettings)
        
        XCTAssertEqual(manager.timeRemaining, 30 * 60)
        XCTAssertEqual(manager.settings.focusDuration, 30 * 60)
    }
    
    // MARK: - Timer Control Tests
    
    func testStartTimer() {
        timerManager.startTimer()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .running)
        }
    }
    
    func testStartTimerWhenAlreadyRunning() {
        timerManager.startTimer()
        let initialState = MainActor.assumeIsolated { timerManager.timerState }
        
        timerManager.startTimer()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, initialState)
        }
    }
    
    func testPauseTimer() {
        timerManager.startTimer()
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .running)
        }
        
        timerManager.pauseTimer()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .paused)
        }
    }
    
    func testPauseTimerWhenIdle() {
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
        
        timerManager.pauseTimer()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
    }
    
    func testResumeTimer() {
        timerManager.startTimer()
        timerManager.pauseTimer()
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .paused)
        }
        
        timerManager.startTimer()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .running)
        }
    }
    
    func testResetTimer() {
        timerManager.startTimer()
        
        // Wait a moment for timer to tick
        let expectation = self.expectation(description: "Wait for timer tick")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
        
        let initialDuration = timerManager.settings.focusDuration
        XCTAssertLessThan(timerManager.timeRemaining, initialDuration)
        
        timerManager.resetTimer()
        
        XCTAssertEqual(timerManager.timerState, .idle)
        XCTAssertEqual(timerManager.timeRemaining, initialDuration)
    }
    
    func testSkipSession() {
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.currentSessionType, .focus)
        }
        
        timerManager.skipSession()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
            XCTAssertEqual(timerManager.currentSessionType, .shortBreak)
        }
    }
    
    // MARK: - Timer Tick Tests
    
    func testTimerDecrementsTimeRemaining() {
        let initialTime = timerManager.timeRemaining
        timerManager.startTimer()
        
        let expectation = self.expectation(description: "Wait for timer to tick")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
        
        XCTAssertLessThan(timerManager.timeRemaining, initialTime)
    }
    
    func testTimerStopsAtZero() {
        timerManager.timeRemaining = 2 // 2 seconds
        timerManager.startTimer()
        
        let expectation = self.expectation(description: "Wait for timer to complete")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
    }
    
    // MARK: - Session Switching Tests
    
    func testSwitchFromFocusToShortBreak() {
        XCTAssertEqual(timerManager.currentSessionType, .focus)
        
        timerManager.skipSession()
        
        XCTAssertEqual(timerManager.currentSessionType, .shortBreak)
        XCTAssertEqual(timerManager.timeRemaining, timerManager.settings.shortBreakDuration)
    }
    
    func testSwitchFromShortBreakToFocus() {
        timerManager.skipSession() // Focus -> Short Break
        XCTAssertEqual(timerManager.currentSessionType, .shortBreak)
        
        timerManager.skipSession() // Short Break -> Focus
        
        XCTAssertEqual(timerManager.currentSessionType, .focus)
        XCTAssertEqual(timerManager.timeRemaining, timerManager.settings.focusDuration)
    }
    
    func testSwitchToLongBreakAfterConfiguredSessions() {
        timerManager.settings.sessionsUntilLongBreak = 2
        
        // Complete first focus session
        timerManager.skipSession() // Focus -> Short Break
        timerManager.skipSession() // Short Break -> Focus
        
        // Complete second focus session
        timerManager.skipSession() // Focus -> Long Break (should trigger)
        
        XCTAssertEqual(timerManager.currentSessionType, .longBreak)
        XCTAssertEqual(timerManager.completedFocusSessions, 2)
    }
    
    func testFocusSessionCountIncrement() {
        XCTAssertEqual(timerManager.completedFocusSessions, 0)
        
        timerManager.skipSession() // Complete focus
        
        XCTAssertEqual(timerManager.completedFocusSessions, 1)
    }
    
    // MARK: - Session Persistence Tests
    
    func testSessionSavedOnCompletion() {
        timerManager.timeRemaining = 2
        timerManager.startTimer()
        
        let expectation = self.expectation(description: "Wait for session completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        let sessions = timerManager.loadSessions()
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.type, .focus)
    }
    
    func testLoadSessions() {
        let testSessions = TimerSessionFactory.createMultipleSessions(count: 3)
        for session in testSessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        let loadedSessions = timerManager.loadSessions()
        
        XCTAssertEqual(loadedSessions.count, 3)
    }
    
    func testClearAllSessions() {
        let testSessions = TimerSessionFactory.createMultipleSessions(count: 3)
        for session in testSessions {
            PersistenceManager.shared.saveSession(session)
        }
        
        timerManager.completedFocusSessions = 5
        
        timerManager.clearAllSessions()
        
        XCTAssertTrue(timerManager.loadSessions().isEmpty)
        XCTAssertEqual(timerManager.completedFocusSessions, 0)
    }
    
    // MARK: - Background Handling Tests
    
    func testAppDidEnterBackground() {
        timerManager.startTimer()
        
        let timeBeforeBackground = timerManager.timeRemaining
        timerManager.appDidEnterBackground()
        
        // Time should not change immediately
        XCTAssertEqual(timerManager.timeRemaining, timeBeforeBackground)
    }
    
    func testAppWillEnterForeground() {
        timerManager.timeRemaining = 10
        timerManager.startTimer()
        timerManager.appDidEnterBackground()
        
        // Simulate 3 seconds passing
        Thread.sleep(forTimeInterval: 3.0)
        
        timerManager.appWillEnterForeground()
        
        // Time should have decreased by approximately 3 seconds
        XCTAssertLessThan(timerManager.timeRemaining, 10)
        // Allow 0.5 second tolerance for timer precision
        XCTAssertGreaterThanOrEqual(timerManager.timeRemaining, 6.5)
        XCTAssertLessThanOrEqual(timerManager.timeRemaining, 7.5)
    }
    
    func testAppWillEnterForegroundWithCompletedTimer() {
        timerManager.timeRemaining = 2
        timerManager.startTimer()
        timerManager.appDidEnterBackground()
        
        // Simulate time passing beyond timer duration
        Thread.sleep(forTimeInterval: 3.0)
        
        timerManager.appWillEnterForeground()
        
        // Timer should have completed
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
    }
    
    // MARK: - Auto-Start Tests
    
    func testAutoStartBreaks() {
        timerManager.settings.autoStartBreaks = true
        timerManager.timeRemaining = 1
        timerManager.startTimer()
        
        let expectation = self.expectation(description: "Wait for auto-start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        // Should have switched to break and started automatically
        XCTAssertEqual(timerManager.currentSessionType, .shortBreak)
    }
    
    func testNoAutoStartWhenDisabled() {
        timerManager.settings.autoStartBreaks = false
        timerManager.timeRemaining = 1
        timerManager.startTimer()
        
        let expectation = self.expectation(description: "Wait for completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        // Should be idle after completion
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
    }
    
    // MARK: - Notification Tests
    
    func testRequestNotificationPermission() {
        timerManager.requestNotificationPermission()
        
        // This test verifies the method can be called without crashing
        // Actual permission testing requires UI interaction
        XCTAssertTrue(true)
    }
    
    // MARK: - Published Property Tests
    
    func testTimerStatePublishes() {
        let expectation = self.expectation(description: "Timer state publishes")
        
        timerManager.$timerState
            .dropFirst()
            .sink { state in
                if state == .running {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        timerManager.startTimer()
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testTimeRemainingPublishes() {
        let expectation = self.expectation(description: "Time remaining publishes")
        var changeCount = 0
        
        timerManager.$timeRemaining
            .dropFirst()
            .sink { _ in
                changeCount += 1
                if changeCount >= 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        timerManager.startTimer()
        
        waitForExpectations(timeout: 3.0)
    }
    
    // MARK: - Settings Integration Tests
    
    func testSettingsChangesDuration() {
        let newDuration: TimeInterval = 30 * 60
        timerManager.settings.focusDuration = newDuration
        
        timerManager.resetTimer()
        
        XCTAssertEqual(timerManager.timeRemaining, newDuration)
    }
    
    // MARK: - Edge Cases
    
    func testMultipleStartStopCycles() {
        for _ in 0..<5 {
            timerManager.startTimer()
            MainActor.assumeIsolated {
                XCTAssertEqual(timerManager.timerState, .running)
            }
            
            timerManager.pauseTimer()
            MainActor.assumeIsolated {
                XCTAssertEqual(timerManager.timerState, .paused)
            }
            
            timerManager.resetTimer()
            MainActor.assumeIsolated {
                XCTAssertEqual(timerManager.timerState, .idle)
            }
        }
    }
    
    func testRapidStateChanges() {
        timerManager.startTimer()
        timerManager.pauseTimer()
        timerManager.startTimer()
        timerManager.resetTimer()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
    }
}
