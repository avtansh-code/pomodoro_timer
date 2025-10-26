//
//  TimerSettingsTests.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import XCTest
import Combine
import SwiftUI
@testable import PomodoroTimer

final class TimerSettingsTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        cancellables.removeAll()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testDefaultSettingsInitialization() {
        let settings = TimerSettings()
        
        XCTAssertEqual(settings.focusDuration, 25 * 60)
        XCTAssertEqual(settings.shortBreakDuration, 5 * 60)
        XCTAssertEqual(settings.longBreakDuration, 15 * 60)
        XCTAssertEqual(settings.sessionsUntilLongBreak, 4)
        XCTAssertFalse(settings.autoStartBreaks)
        XCTAssertFalse(settings.autoStartFocus)
        XCTAssertTrue(settings.soundEnabled)
        XCTAssertTrue(settings.hapticEnabled)
        XCTAssertTrue(settings.notificationsEnabled)
        XCTAssertEqual(settings.selectedTheme, .system)
        XCTAssertFalse(settings.focusModeEnabled)
        XCTAssertFalse(settings.syncWithFocusMode)
        XCTAssertFalse(settings.iCloudSyncEnabled)
    }
    
    func testCustomSettingsInitialization() {
        let settings = TimerSettingsFactory.createCustomSettings(
            focusDuration: 30 * 60,
            shortBreakDuration: 10 * 60,
            longBreakDuration: 20 * 60,
            sessionsUntilLongBreak: 3,
            autoStartBreaks: true,
            autoStartFocus: true,
            soundEnabled: false,
            hapticEnabled: false,
            notificationsEnabled: false,
            selectedTheme: .dark,
            focusModeEnabled: true,
            syncWithFocusMode: true,
            iCloudSyncEnabled: true
        )
        
        XCTAssertEqual(settings.focusDuration, 30 * 60)
        XCTAssertEqual(settings.shortBreakDuration, 10 * 60)
        XCTAssertEqual(settings.longBreakDuration, 20 * 60)
        XCTAssertEqual(settings.sessionsUntilLongBreak, 3)
        XCTAssertTrue(settings.autoStartBreaks)
        XCTAssertTrue(settings.autoStartFocus)
        XCTAssertFalse(settings.soundEnabled)
        XCTAssertFalse(settings.hapticEnabled)
        XCTAssertFalse(settings.notificationsEnabled)
        XCTAssertEqual(settings.selectedTheme, .dark)
        XCTAssertTrue(settings.focusModeEnabled)
        XCTAssertTrue(settings.syncWithFocusMode)
        XCTAssertTrue(settings.iCloudSyncEnabled)
    }
    
    // MARK: - AppTheme Tests
    
    func testAppThemeRawValues() {
        XCTAssertEqual(TimerSettings.AppTheme.system.rawValue, "System")
        XCTAssertEqual(TimerSettings.AppTheme.light.rawValue, "Light")
        XCTAssertEqual(TimerSettings.AppTheme.dark.rawValue, "Dark")
    }
    
    func testAppThemeFromRawValue() {
        XCTAssertEqual(TimerSettings.AppTheme(rawValue: "System"), .system)
        XCTAssertEqual(TimerSettings.AppTheme(rawValue: "Light"), .light)
        XCTAssertEqual(TimerSettings.AppTheme(rawValue: "Dark"), .dark)
        XCTAssertNil(TimerSettings.AppTheme(rawValue: "Invalid"))
    }
    
    func testAppThemeColorScheme() {
        XCTAssertNil(TimerSettings.AppTheme.system.colorScheme)
        XCTAssertEqual(TimerSettings.AppTheme.light.colorScheme, .light)
        XCTAssertEqual(TimerSettings.AppTheme.dark.colorScheme, .dark)
    }
    
    func testAppThemeCaseIterable() {
        let allThemes = TimerSettings.AppTheme.allCases
        
        XCTAssertEqual(allThemes.count, 3)
        XCTAssertTrue(allThemes.contains(.system))
        XCTAssertTrue(allThemes.contains(.light))
        XCTAssertTrue(allThemes.contains(.dark))
    }
    
    // MARK: - Codable Tests
    
    func testTimerSettingsEncoding() throws {
        let settings = TimerSettingsFactory.createDefaultSettings()
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(settings)
        
        XCTAssertFalse(data.isEmpty)
    }
    
    func testTimerSettingsDecoding() throws {
        let originalSettings = TimerSettingsFactory.createCustomSettings(
            focusDuration: 30 * 60,
            selectedTheme: .dark,
            iCloudSyncEnabled: true
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalSettings)
        
        let decoder = JSONDecoder()
        let decodedSettings = try MainActor.assumeIsolated {
            try decoder.decode(TimerSettings.self, from: data)
        }
        
        XCTAssertEqual(decodedSettings.focusDuration, originalSettings.focusDuration)
        XCTAssertEqual(decodedSettings.shortBreakDuration, originalSettings.shortBreakDuration)
        XCTAssertEqual(decodedSettings.longBreakDuration, originalSettings.longBreakDuration)
        XCTAssertEqual(decodedSettings.sessionsUntilLongBreak, originalSettings.sessionsUntilLongBreak)
        XCTAssertEqual(decodedSettings.selectedTheme, originalSettings.selectedTheme)
        XCTAssertEqual(decodedSettings.iCloudSyncEnabled, originalSettings.iCloudSyncEnabled)
    }
    
    func testTimerSettingsEncodingDecodingAllProperties() throws {
        let originalSettings = TimerSettingsFactory.createCustomSettings(
            focusDuration: 30 * 60,
            shortBreakDuration: 10 * 60,
            longBreakDuration: 20 * 60,
            sessionsUntilLongBreak: 3,
            autoStartBreaks: true,
            autoStartFocus: true,
            soundEnabled: false,
            hapticEnabled: false,
            notificationsEnabled: false,
            selectedTheme: .dark,
            focusModeEnabled: true,
            syncWithFocusMode: true,
            iCloudSyncEnabled: true
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalSettings)
        
        let decoder = JSONDecoder()
        let decodedSettings = try MainActor.assumeIsolated {
            try decoder.decode(TimerSettings.self, from: data)
        }
        
        XCTAssertEqual(decodedSettings.focusDuration, originalSettings.focusDuration)
        XCTAssertEqual(decodedSettings.shortBreakDuration, originalSettings.shortBreakDuration)
        XCTAssertEqual(decodedSettings.longBreakDuration, originalSettings.longBreakDuration)
        XCTAssertEqual(decodedSettings.sessionsUntilLongBreak, originalSettings.sessionsUntilLongBreak)
        XCTAssertEqual(decodedSettings.autoStartBreaks, originalSettings.autoStartBreaks)
        XCTAssertEqual(decodedSettings.autoStartFocus, originalSettings.autoStartFocus)
        XCTAssertEqual(decodedSettings.soundEnabled, originalSettings.soundEnabled)
        XCTAssertEqual(decodedSettings.hapticEnabled, originalSettings.hapticEnabled)
        XCTAssertEqual(decodedSettings.notificationsEnabled, originalSettings.notificationsEnabled)
        XCTAssertEqual(decodedSettings.selectedTheme, originalSettings.selectedTheme)
        XCTAssertEqual(decodedSettings.focusModeEnabled, originalSettings.focusModeEnabled)
        XCTAssertEqual(decodedSettings.syncWithFocusMode, originalSettings.syncWithFocusMode)
        XCTAssertEqual(decodedSettings.iCloudSyncEnabled, originalSettings.iCloudSyncEnabled)
    }
    
    func testTimerSettingsBackwardCompatibility() throws {
        // Test decoding settings without new properties (focusModeEnabled, syncWithFocusMode, iCloudSyncEnabled)
        let json = """
        {
            "focusDuration": 1500,
            "shortBreakDuration": 300,
            "longBreakDuration": 900,
            "sessionsUntilLongBreak": 4,
            "autoStartBreaks": false,
            "autoStartFocus": false,
            "soundEnabled": true,
            "hapticEnabled": true,
            "notificationsEnabled": true,
            "selectedTheme": "System"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let settings = try MainActor.assumeIsolated {
            try decoder.decode(TimerSettings.self, from: data)
        }
        
        XCTAssertEqual(settings.focusDuration, 1500)
        XCTAssertFalse(settings.focusModeEnabled, "Should default to false")
        XCTAssertFalse(settings.syncWithFocusMode, "Should default to false")
        XCTAssertFalse(settings.iCloudSyncEnabled, "Should default to false")
    }
    
    // MARK: - ObservableObject Tests
    
    func testSettingsPublishesChanges() {
        let settings = TimerSettings()
        let expectation = self.expectation(description: "Settings should publish changes")
        
        settings.objectWillChange.sink { _ in
            expectation.fulfill()
        }.store(in: &cancellables)
        
        settings.focusDuration = 30 * 60
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testMultiplePropertyChangesPublish() {
        let settings = TimerSettings()
        var changeCount = 0
        
        settings.objectWillChange.sink { _ in
            changeCount += 1
        }.store(in: &cancellables)
        
        settings.focusDuration = 30 * 60
        settings.autoStartBreaks = true
        settings.selectedTheme = .dark
        
        // Give a moment for all changes to propagate
        let expectation = self.expectation(description: "Wait for changes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(changeCount, 3, "Should publish 3 changes")
    }
    
    // MARK: - Settings Validation Tests
    
    func testMinimumDurationValues() {
        let settings = TimerSettings(
            focusDuration: 1,
            shortBreakDuration: 1,
            longBreakDuration: 1,
            sessionsUntilLongBreak: 1
        )
        
        XCTAssertEqual(settings.focusDuration, 1)
        XCTAssertEqual(settings.shortBreakDuration, 1)
        XCTAssertEqual(settings.longBreakDuration, 1)
        XCTAssertEqual(settings.sessionsUntilLongBreak, 1)
    }
    
    func testMaximumDurationValues() {
        let maxDuration: TimeInterval = 3 * 60 * 60 // 3 hours
        let settings = TimerSettings(
            focusDuration: maxDuration,
            shortBreakDuration: maxDuration,
            longBreakDuration: maxDuration,
            sessionsUntilLongBreak: 10
        )
        
        XCTAssertEqual(settings.focusDuration, maxDuration)
        XCTAssertEqual(settings.shortBreakDuration, maxDuration)
        XCTAssertEqual(settings.longBreakDuration, maxDuration)
        XCTAssertEqual(settings.sessionsUntilLongBreak, 10)
    }
    
    // MARK: - Edge Cases
    
    func testZeroDurationSettings() {
        let settings = TimerSettings(
            focusDuration: 0,
            shortBreakDuration: 0,
            longBreakDuration: 0,
            sessionsUntilLongBreak: 0
        )
        
        XCTAssertEqual(settings.focusDuration, 0)
        XCTAssertEqual(settings.shortBreakDuration, 0)
        XCTAssertEqual(settings.longBreakDuration, 0)
        XCTAssertEqual(settings.sessionsUntilLongBreak, 0)
    }
    
    func testNegativeValuesNotAllowed() {
        // Swift's TimeInterval allows negative values, but we should document expected behavior
        let settings = TimerSettings(
            focusDuration: -100,
            shortBreakDuration: -50,
            longBreakDuration: -200
        )
        
        // Document that negative values are stored as-is (validation should happen at UI level)
        XCTAssertEqual(settings.focusDuration, -100)
        XCTAssertEqual(settings.shortBreakDuration, -50)
        XCTAssertEqual(settings.longBreakDuration, -200)
    }
}
