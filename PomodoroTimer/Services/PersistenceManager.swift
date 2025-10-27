//
//  PersistenceManager.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import Foundation

class PersistenceManager {
    nonisolated(unsafe) static let shared = PersistenceManager()
    
    private let settingsKey = "TimerSettings"
    private let sessionsKey = "SavedSessions"
    private let userDefaults: UserDefaults
    
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // For testing purposes only
    static func create(with userDefaults: UserDefaults) -> PersistenceManager {
        return PersistenceManager(userDefaults: userDefaults)
    }
    
    // MARK: - Settings Persistence
    
    func saveSettings(_ settings: TimerSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: settingsKey)
        }
    }
    
    func loadSettings() -> TimerSettings {
        guard let data = userDefaults.data(forKey: settingsKey),
              let settings = try? JSONDecoder().decode(TimerSettings.self, from: data) else {
            return TimerSettings()
        }
        return settings
    }
    
    // MARK: - Statistics
    
    func getTodaySessions() -> [TimerSession] {
        let allSessions = loadAllSessions()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return allSessions.filter { session in
            calendar.isDate(session.completedAt, inSameDayAs: today)
        }
    }
    
    func getWeeklySessions() -> [TimerSession] {
        let allSessions = loadAllSessions()
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        return allSessions.filter { session in
            session.completedAt >= weekAgo
        }
    }
    
    func getMonthlySessions() -> [TimerSession] {
        let allSessions = loadAllSessions()
        let calendar = Calendar.current
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        return allSessions.filter { session in
            session.completedAt >= monthAgo
        }
    }
    
    func getAllSessions() -> [TimerSession] {
        return loadAllSessions()
    }
    
    func getCurrentStreak() -> Int {
        let allSessions = loadAllSessions()
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        while true {
            let dayStart = calendar.startOfDay(for: currentDate)
            let hasSessions = allSessions.contains { session in
                calendar.isDate(session.completedAt, inSameDayAs: dayStart)
            }
            
            if hasSessions {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                    break
                }
                currentDate = previousDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    func saveSession(_ session: TimerSession) {
        var sessions = loadAllSessions()
        sessions.append(session)
        
        if let encoded = try? JSONEncoder().encode(sessions) {
            userDefaults.set(encoded, forKey: sessionsKey)
        }
        
        // Sync to iCloud if enabled (skip during unit tests to avoid memory issues)
        let settings = loadSettings()
        if settings.iCloudSyncEnabled && !isRunningTests {
            CloudSyncManager.shared.syncSession(session)
        }
    }
    
    // Helper to detect if running in test environment
    private var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    private func loadAllSessions() -> [TimerSession] {
        guard let data = userDefaults.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([TimerSession].self, from: data) else {
            return []
        }
        return sessions
    }
    
    func clearAllSessions() {
        userDefaults.removeObject(forKey: sessionsKey)
    }
    
    // MARK: - iCloud Sync Integration
    
    func syncWithCloud(completion: @escaping () -> Void) {
        let settings = loadSettings()
        guard settings.iCloudSyncEnabled else {
            completion()
            return
        }
        
        // Start automatic sync if enabled
        CloudSyncManager.shared.startAutomaticSync()
        
        // Merge settings
        CloudSyncManager.shared.mergeWithCloud(localSettings: settings) { [weak self] mergedSettings in
            guard let self = self else {
                completion()
                return
            }
            
            self.saveSettings(mergedSettings)
            
            // Merge sessions
            let localSessions = self.loadAllSessions()
            CloudSyncManager.shared.mergeSessions(localSessions: localSessions) { [weak self] mergedSessions in
                guard let self = self else {
                    completion()
                    return
                }
                
                // Save merged sessions
                if let encoded = try? JSONEncoder().encode(mergedSessions) {
                    self.userDefaults.set(encoded, forKey: self.sessionsKey)
                }
                
                completion()
            }
        }
    }
}
