//
//  TimerPerformanceTests.swift
//  PomodoroTimerPerformanceTests
//
//  Created by XCTest Suite
//

import XCTest
@testable import PomodoroTimer

final class TimerPerformanceTests: XCTestCase {
    
    var timerManager: TimerManager!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        let settings = TimerSettings()
        timerManager = TimerManager(settings: settings)
        PersistenceManager.shared.clearAllSessions()
    }
    
    override func tearDown() {
        timerManager?.resetTimer()
        timerManager = nil
        PersistenceManager.shared.clearAllSessions()
        super.tearDown()
    }
    
    // MARK: - Timer Accuracy Tests
    
    func testTimerAccuracyOver25Minutes() {
        let expectedDuration: TimeInterval = 25 * 60 // 25 minutes
        timerManager.timeRemaining = expectedDuration
        
        measure {
            let startTime = Date()
            timerManager.startTimer()
            
            // Run for a shorter period in test (5 seconds)
            let testDuration: TimeInterval = 5.0
            Thread.sleep(forTimeInterval: testDuration)
            
            let elapsed = Date().timeIntervalSince(startTime)
            let expectedRemaining = expectedDuration - elapsed
            let actualRemaining = timerManager.timeRemaining
            let accuracy = abs(actualRemaining - expectedRemaining)
            
            // Accuracy should be within 1 second
            XCTAssertLessThanOrEqual(accuracy, 1.0)
            
            timerManager.resetTimer()
        }
    }
    
    func testTimerPerformanceUnderLoad() {
        measure {
            timerManager.startTimer()
            
            // Simulate rapid state checks
            for _ in 0..<1000 {
                _ = timerManager.timerState
                _ = timerManager.timeRemaining
                _ = timerManager.currentSessionType
            }
            
            timerManager.resetTimer()
        }
    }
    
    // MARK: - Session Switching Performance
    
    func testSessionSwitchingPerformance() {
        measure {
            for _ in 0..<100 {
                timerManager.skipSession()
            }
            timerManager.resetTimer()
        }
    }
    
    func testMultipleTimerCycles() {
        measure {
            for _ in 0..<50 {
                timerManager.startTimer()
                timerManager.pauseTimer()
                timerManager.startTimer()
                timerManager.resetTimer()
            }
        }
    }
    
    // MARK: - Memory Performance
    
    func testMemoryUsageDuringLongSession() {
        measure(metrics: [XCTMemoryMetric()]) {
            timerManager.startTimer()
            
            // Simulate timer running for extended period
            for _ in 0..<60 {
                Thread.sleep(forTimeInterval: 0.1)
                _ = timerManager.timeRemaining
            }
            
            timerManager.resetTimer()
        }
    }
    
    // MARK: - Notification Performance
    
    func testNotificationSchedulingPerformance() {
        let settings = TimerSettings()
        settings.notificationsEnabled = true
        let manager = TimerManager(settings: settings)
        
        measure {
            for _ in 0..<10 {
                manager.appDidEnterBackground()
                manager.appWillEnterForeground()
            }
        }
    }
    
    // MARK: - Background/Foreground Performance
    
    func testBackgroundForegroundTransitionPerformance() {
        timerManager.startTimer()
        
        measure {
            for _ in 0..<100 {
                timerManager.appDidEnterBackground()
                timerManager.appWillEnterForeground()
            }
        }
        
        timerManager.resetTimer()
    }
    
    // MARK: - Settings Update Performance
    
    func testSettingsUpdatePerformance() {
        measure {
            for i in 0..<1000 {
                timerManager.settings.focusDuration = TimeInterval(20 + i % 40) * 60
                timerManager.settings.autoStartBreaks = i % 2 == 0
                timerManager.settings.selectedTheme = i % 3 == 0 ? .dark : .light
            }
        }
    }
}
