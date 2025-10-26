//
//  TimerSettingsFactory.swift
//  PomodoroTimerTests
//
//  Created by XCTest Suite
//

import Foundation
@testable import PomodoroTimer

struct TimerSettingsFactory {
    static func createDefaultSettings() -> TimerSettings {
        return TimerSettings()
    }
    
    static func createCustomSettings(
        focusDuration: TimeInterval = 25 * 60,
        shortBreakDuration: TimeInterval = 5 * 60,
        longBreakDuration: TimeInterval = 15 * 60,
        sessionsUntilLongBreak: Int = 4,
        autoStartBreaks: Bool = false,
        autoStartFocus: Bool = false,
        soundEnabled: Bool = true,
        hapticEnabled: Bool = true,
        notificationsEnabled: Bool = true,
        selectedTheme: TimerSettings.AppTheme = .system,
        focusModeEnabled: Bool = false,
        syncWithFocusMode: Bool = false,
        iCloudSyncEnabled: Bool = false
    ) -> TimerSettings {
        return TimerSettings(
            focusDuration: focusDuration,
            shortBreakDuration: shortBreakDuration,
            longBreakDuration: longBreakDuration,
            sessionsUntilLongBreak: sessionsUntilLongBreak,
            autoStartBreaks: autoStartBreaks,
            autoStartFocus: autoStartFocus,
            soundEnabled: soundEnabled,
            hapticEnabled: hapticEnabled,
            notificationsEnabled: notificationsEnabled,
            selectedTheme: selectedTheme,
            focusModeEnabled: focusModeEnabled,
            syncWithFocusMode: syncWithFocusMode,
            iCloudSyncEnabled: iCloudSyncEnabled
        )
    }
    
    static func createShortDurationSettings() -> TimerSettings {
        return TimerSettings(
            focusDuration: TestConstants.testShortDuration,
            shortBreakDuration: TestConstants.testShortDuration,
            longBreakDuration: TestConstants.testShortDuration,
            sessionsUntilLongBreak: 2
        )
    }
    
    static func createAutoStartSettings() -> TimerSettings {
        return TimerSettings(
            autoStartBreaks: true,
            autoStartFocus: true
        )
    }
    
    static func createDisabledNotificationsSettings() -> TimerSettings {
        return TimerSettings(
            soundEnabled: false,
            hapticEnabled: false,
            notificationsEnabled: false
        )
    }
    
    static func createFocusModeEnabledSettings() -> TimerSettings {
        return TimerSettings(
            focusModeEnabled: true,
            syncWithFocusMode: true
        )
    }
    
    static func createiCloudEnabledSettings() -> TimerSettings {
        return TimerSettings(
            iCloudSyncEnabled: true
        )
    }
}
