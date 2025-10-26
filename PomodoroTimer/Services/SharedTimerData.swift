//
//  SharedTimerData.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import Foundation

/// Shared data structure for widget communication
struct SharedTimerData: Codable {
    let currentSessionType: String // "Focus", "Short Break", "Long Break"
    let timeRemaining: TimeInterval
    let isRunning: Bool
    let completedSessionsToday: Int
    let totalFocusTimeToday: TimeInterval // in seconds
    let currentStreak: Int
    let lastUpdated: Date
    
    static var `default`: SharedTimerData {
        SharedTimerData(
            currentSessionType: "Focus",
            timeRemaining: 25 * 60,
            isRunning: false,
            completedSessionsToday: 0,
            totalFocusTimeToday: 0,
            currentStreak: 0,
            lastUpdated: Date()
        )
    }
}

/// Manager for sharing data between app and widget using App Groups
class SharedTimerDataManager {
    static let shared = SharedTimerDataManager()
    
    // IMPORTANT: This App Group ID must be added to both the app and widget targets
    // Go to Signing & Capabilities -> Add App Groups -> Create "group.com.yourteam.pomodoro"
    private let appGroupID = "group.com.avtanshgupta.pomodoro"
    private let timerDataKey = "sharedTimerData"
    
    private var userDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }
    
    private init() {}
    
    /// Save timer data for widget access
    func saveTimerData(_ data: SharedTimerData) {
        guard let defaults = userDefaults else {
            print("⚠️ App Group not configured. Widget data will not be available.")
            return
        }
        
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: timerDataKey)
            defaults.synchronize()
        }
    }
    
    /// Load timer data (used by widget)
    func loadTimerData() -> SharedTimerData {
        guard let defaults = userDefaults,
              let data = defaults.data(forKey: timerDataKey),
              let decoded = try? JSONDecoder().decode(SharedTimerData.self, from: data) else {
            return .default
        }
        return decoded
    }
    
    /// Check if App Group is properly configured
    func isAppGroupConfigured() -> Bool {
        return userDefaults != nil
    }
}
