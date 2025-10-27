//
//  TimerManagerTests.swift
//  PomodoroTimerTests
//
//  Rewritten for comprehensive test coverage
//

import XCTest
import Combine
@testable import PomodoroTimer

@MainActor
final class TimerManagerTests: XCTestCase {
    
    var timerManager: TimerManager!
    var mockUserDefaults: MockUserDefaults!
    var mockPersistenceManager: PersistenceManager!
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup & Teardown
    
    override func setUp() async throws {
        try await super.setUp()
        cancellables.removeAll()
        
        // Setup mock dependencies
        mockUserDefaults = MockUserDefaults()
        mockPersistenceManager = PersistenceManager.create(with: mockUserDefaults)
        
        // Use short durations for faster tests
        let settings = TimerSettingsFactory.createShortDurationSettings()
        timerManager = TimerManager(settings: settings, persistenceManager: mockPersistenceManager)
        
        // Clear any existing sessions and notifications
        mockPersistenceManager.clearAllSessions()
        clearAllNotifications()
    }
    
    override func tearDown() {
        timerManager?.resetTimer()
        timerManager = nil
        mockPersistenceManager = nil
        mockUserDefaults = nil
        cancellables.removeAll()
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
        let customSettings = TimerSettingsFactory.createCustomSettings(
            focusDuration: 30 * 60,
            shortBreakDuration: 10 * 60,
            longBreakDuration: 25 * 60,
            sessionsUntilLongBreak: 3
        )
        let manager = TimerManager(settings: customSettings)
        
        XCTAssertEqual(manager.timeRemaining, 30 * 60)
        XCTAssertEqual(manager.settings.focusDuration, 30 * 60)
        XCTAssertEqual(manager.settings.shortBreakDuration, 10 * 60)
        XCTAssertEqual(manager.settings.longBreakDuration, 25 * 60)
        XCTAssertEqual(manager.settings.sessionsUntilLongBreak, 3)
    }
    
    // MARK: - Timer Control Tests
    
    func testStartTimer() {
        XCTAssertEqual(timerManager.timerState, .idle)
        
        timerManager.startTimer()
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .running)
        }
    }
    
    func testStartTimerWhenAlreadyRunning() {
        timerManager.startTimer()
        let initialState = MainActor.assumeIsolated { timerManager.timerState }
        
        // Try to start again
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
        
        timerManager.startTimer() // Should resume
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .running)
        }
    }
    
    func testResetTimer() {
        timerManager.startTimer()
        
        // Wait for timer to tick
        let expectation = expectation(description: "Wait for timer tick")
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
            XCTAssertEqual(timerManager.timeRemaining, timerManager.settings.shortBreakDuration)
        }
    }
    
    // MARK: - Timer Tick Tests
    
    func testTimerDecrementsTimeRemaining() {
        let initialTime = timerManager.timeRemaining
        timerManager.startTimer()
        
        let expectation = expectation(description: "Wait for timer to tick")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2.0)
        
        XCTAssertLessThan(timerManager.timeRemaining, initialTime)
    }
    
    func testTimerStopsAtZero() {
        timerManager.timeRemaining = 2
        timerManager.startTimer()
        
        let expectation = expectation(description: "Wait for timer to complete")
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
        
        // Complete second focus session - should trigger long break
        timerManager.skipSession() // Focus -> Long Break
        
        XCTAssertEqual(timerManager.currentSessionType, .longBreak)
        XCTAssertEqual(timerManager.completedFocusSessions, 2)
        XCTAssertEqual(timerManager.timeRemaining, timerManager.settings.longBreakDuration)
    }
    
    func testFocusSessionCountIncrement() {
        XCTAssertEqual(timerManager.completedFocusSessions, 0)
        
        timerManager.skipSession() // Complete focus
        
        XCTAssertEqual(timerManager.completedFocusSessions, 1)
        
        timerManager.skipSession() // Complete break
        timerManager.skipSession() // Complete another focus
        
        XCTAssertEqual(timerManager.completedFocusSessions, 2)
    }
    
    // MARK: - Session Completion Tests
    
    func testSessionCompletion() {
        timerManager.timeRemaining = 1
        timerManager.startTimer()
        
        let expectation = expectation(description: "Wait for session completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3.0)
        
        // Session should be completed and saved
        let sessions = mockPersistenceManager.getAllSessions()
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.type, .focus)
        
        // Should have switched to next session
        XCTAssertEqual(timerManager.currentSessionType, .shortBreak)
        XCTAssertEqual(timerManager.timerState, .idle)
    }
    
    // MARK: - Auto-Start Tests
    
    func testAutoStartBreaks() {
        timerManager.settings.autoStartBreaks = true
        timerManager.timeRemaining = 1
        timerManager.startTimer()
        
        let expectation = expectation(description: "Wait for auto-start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        // Should have switched to break and started automatically
        XCTAssertEqual(timerManager.currentSessionType, .shortBreak)
        
        // Give time for auto-start to kick in
        let autoStartExpectation = XCTestExpectation(description: "Wait for auto start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            autoStartExpectation.fulfill()
        }
        waitForExpectations(timeout: 3.0)
    }
    
    func testAutoStartFocus() {
        timerManager.settings.autoStartFocus = true
        timerManager.skipSession() // Go to break
        timerManager.timeRemaining = 1
        timerManager.startTimer()
        
        let expectation = expectation(description: "Wait for auto-start focus")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        XCTAssertEqual(timerManager.currentSessionType, .focus)
    }
    
    func testNoAutoStartWhenDisabled() {
        timerManager.settings.autoStartBreaks = false
        timerManager.settings.autoStartFocus = false
        timerManager.timeRemaining = 1
        timerManager.startTimer()
        
        let expectation = expectation(description: "Wait for completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        // Should be idle after completion
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
    }
    
    // MARK: - Background Handling Tests
    
    func testAppDidEnterBackground() {
        timerManager.startTimer()
        let timeBeforeBackground = timerManager.timeRemaining
        
        timerManager.appDidEnterBackground()
        
        // Time should not change immediately
        XCTAssertEqual(timerManager.timeRemaining, timeBeforeBackground)
    }
    
    func testAppWillEnterForegroundWithRunningTimer() {
        timerManager.timeRemaining = 10
        timerManager.startTimer()
        timerManager.appDidEnterBackground()
        
        // Simulate 3 seconds passing
        Thread.sleep(forTimeInterval: 3.0)
        
        timerManager.appWillEnterForeground()
        
        // Time should have decreased by approximately 3 seconds
        XCTAssertLessThan(timerManager.timeRemaining, 10)
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
    
    func testAppWillEnterForegroundWhenPaused() {
        timerManager.timeRemaining = 10
        timerManager.startTimer()
        timerManager.pauseTimer()
        timerManager.appDidEnterBackground()
        
        Thread.sleep(forTimeInterval: 3.0)
        
        timerManager.appWillEnterForeground()
        
        // Time should not have changed when paused
        XCTAssertEqual(timerManager.timeRemaining, 10)
    }
    
    // MARK: - Published Property Tests
    
    func testTimerStatePublishes() {
        let expectation = expectation(description: "Timer state publishes")
        
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
        let expectation = expectation(description: "Time remaining publishes")
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
    
    func testCurrentSessionTypePublishes() {
        let expectation = expectation(description: "Session type publishes")
        
        timerManager.$currentSessionType
            .dropFirst()
            .sink { sessionType in
                if sessionType == .shortBreak {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        timerManager.skipSession()
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Settings Integration Tests
    
    func testSettingsChangesDuration() {
        let newDuration: TimeInterval = 30 * 60
        timerManager.settings.focusDuration = newDuration
        
        timerManager.resetTimer()
        
        XCTAssertEqual(timerManager.timeRemaining, newDuration)
    }
    
    func testSettingsChangesSessionsUntilLongBreak() {
        timerManager.settings.sessionsUntilLongBreak = 3
        
        // Complete 3 focus sessions
        timerManager.skipSession() // Focus -> Break
        timerManager.skipSession() // Break -> Focus
        timerManager.skipSession() // Focus -> Break
        timerManager.skipSession() // Break -> Focus
        timerManager.skipSession() // Focus -> Should be Long Break
        
        XCTAssertEqual(timerManager.currentSessionType, .longBreak)
        XCTAssertEqual(timerManager.completedFocusSessions, 3)
    }
    
    // MARK: - Persistence Integration Tests
    
    func testSessionSavedOnCompletion() {
        timerManager.timeRemaining = 2
        timerManager.startTimer()
        
        let expectation = expectation(description: "Wait for session completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4.0)
        
        let sessions = timerManager.loadSessions()
        XCTAssertEqual(sessions.count, 1)
        XCTAssertEqual(sessions.first?.type, .focus)
        XCTAssertEqual(sessions.first?.duration, timerManager.settings.focusDuration)
    }
    
    func testLoadSessions() {
        let testSessions = TimerSessionFactory.createMultipleSessions(count: 3)
        for session in testSessions {
            mockPersistenceManager.saveSession(session)
        }
        
        let loadedSessions = timerManager.loadSessions()
        
        XCTAssertEqual(loadedSessions.count, 3)
    }
    
    func testClearAllSessions() {
        let testSessions = TimerSessionFactory.createMultipleSessions(count: 3)
        for session in testSessions {
            mockPersistenceManager.saveSession(session)
        }
        
        timerManager.completedFocusSessions = 5
        
        timerManager.clearAllSessions()
        
        XCTAssertTrue(timerManager.loadSessions().isEmpty)
        XCTAssertEqual(timerManager.completedFocusSessions, 0)
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
    
    func testZeroTimeRemaining() {
        timerManager.timeRemaining = 0
        timerManager.startTimer()
        
        // Should complete immediately
        let expectation = expectation(description: "Immediate completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        MainActor.assumeIsolated {
            XCTAssertEqual(timerManager.timerState, .idle)
        }
    }
    
    // MARK: - Notification Tests (Mock Testing)
    
    func testRequestNotificationPermission() {
        // This test verifies the method can be called without crashing
        timerManager.requestNotificationPermission()
        XCTAssertTrue(true)
    }
}
