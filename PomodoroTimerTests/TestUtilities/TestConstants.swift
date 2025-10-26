//
//  TestConstants.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import Foundation

struct TestConstants {
    // Timer Durations
    static let defaultFocusDuration: TimeInterval = 25 * 60
    static let defaultShortBreakDuration: TimeInterval = 5 * 60
    static let defaultLongBreakDuration: TimeInterval = 15 * 60
    static let testShortDuration: TimeInterval = 5 // 5 seconds for quick tests
    
    // Session Counts
    static let defaultSessionsUntilLongBreak = 4
    
    // Test Delays
    static let shortDelay: TimeInterval = 0.1
    static let mediumDelay: TimeInterval = 0.5
    static let longDelay: TimeInterval = 2.0
    
    // Test Data
    static let testSessionCount = 10
    static let largeSessionCount = 1000
    
    // Performance Thresholds
    static let timerAccuracyThreshold: TimeInterval = 1.0
    static let loadPerformanceThreshold: TimeInterval = 0.1
    static let statisticsPerformanceThreshold: TimeInterval = 0.5
}
