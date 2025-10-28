//
//  TimerSettings.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class TimerSettings: ObservableObject, Codable {
    @Published var focusDuration: TimeInterval
    @Published var shortBreakDuration: TimeInterval
    @Published var longBreakDuration: TimeInterval
    @Published var sessionsUntilLongBreak: Int
    @Published var autoStartBreaks: Bool
    @Published var autoStartFocus: Bool
    @Published var soundEnabled: Bool
    @Published var hapticEnabled: Bool
    @Published var notificationsEnabled: Bool
    @Published var selectedTheme: AppTheme
    @Published var focusModeEnabled: Bool
    @Published var syncWithFocusMode: Bool
    
    enum AppTheme: String, Codable, CaseIterable, Sendable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"
        
        var colorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light: return .light
            case .dark: return .dark
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case focusDuration
        case shortBreakDuration
        case longBreakDuration
        case sessionsUntilLongBreak
        case autoStartBreaks
        case autoStartFocus
        case soundEnabled
        case hapticEnabled
        case notificationsEnabled
        case selectedTheme
        case focusModeEnabled
        case syncWithFocusMode
    }
    
    init(
        focusDuration: TimeInterval = 25 * 60,
        shortBreakDuration: TimeInterval = 5 * 60,
        longBreakDuration: TimeInterval = 15 * 60,
        sessionsUntilLongBreak: Int = 4,
        autoStartBreaks: Bool = false,
        autoStartFocus: Bool = false,
        soundEnabled: Bool = true,
        hapticEnabled: Bool = true,
        notificationsEnabled: Bool = true,
        selectedTheme: AppTheme = .system,
        focusModeEnabled: Bool = false,
        syncWithFocusMode: Bool = false
    ) {
        self.focusDuration = focusDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.sessionsUntilLongBreak = sessionsUntilLongBreak
        self.autoStartBreaks = autoStartBreaks
        self.autoStartFocus = autoStartFocus
        self.soundEnabled = soundEnabled
        self.hapticEnabled = hapticEnabled
        self.notificationsEnabled = notificationsEnabled
        self.selectedTheme = selectedTheme
        self.focusModeEnabled = focusModeEnabled
        self.syncWithFocusMode = syncWithFocusMode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        focusDuration = try container.decode(TimeInterval.self, forKey: .focusDuration)
        shortBreakDuration = try container.decode(TimeInterval.self, forKey: .shortBreakDuration)
        longBreakDuration = try container.decode(TimeInterval.self, forKey: .longBreakDuration)
        sessionsUntilLongBreak = try container.decode(Int.self, forKey: .sessionsUntilLongBreak)
        autoStartBreaks = try container.decode(Bool.self, forKey: .autoStartBreaks)
        autoStartFocus = try container.decode(Bool.self, forKey: .autoStartFocus)
        soundEnabled = try container.decode(Bool.self, forKey: .soundEnabled)
        hapticEnabled = try container.decode(Bool.self, forKey: .hapticEnabled)
        notificationsEnabled = try container.decode(Bool.self, forKey: .notificationsEnabled)
        selectedTheme = try container.decode(AppTheme.self, forKey: .selectedTheme)
        focusModeEnabled = try container.decodeIfPresent(Bool.self, forKey: .focusModeEnabled) ?? false
        syncWithFocusMode = try container.decodeIfPresent(Bool.self, forKey: .syncWithFocusMode) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(focusDuration, forKey: .focusDuration)
        try container.encode(shortBreakDuration, forKey: .shortBreakDuration)
        try container.encode(longBreakDuration, forKey: .longBreakDuration)
        try container.encode(sessionsUntilLongBreak, forKey: .sessionsUntilLongBreak)
        try container.encode(autoStartBreaks, forKey: .autoStartBreaks)
        try container.encode(autoStartFocus, forKey: .autoStartFocus)
        try container.encode(soundEnabled, forKey: .soundEnabled)
        try container.encode(hapticEnabled, forKey: .hapticEnabled)
        try container.encode(notificationsEnabled, forKey: .notificationsEnabled)
        try container.encode(selectedTheme, forKey: .selectedTheme)
        try container.encode(focusModeEnabled, forKey: .focusModeEnabled)
        try container.encode(syncWithFocusMode, forKey: .syncWithFocusMode)
    }
}
