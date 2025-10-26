//
//  PersistenceManager.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let settingsKey = "TimerSettings"
    private let sessionsKey = "SavedSessions"
    
    private init() {}
    
    // MARK: - Settings Persistence
    
    func saveSettings(_ settings: TimerSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    func loadSettings() -> TimerSettings {
        guard let data = UserDefaults.standard.data(forKey: settingsKey),
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
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
        
        // Sync to iCloud if enabled
        let settings = loadSettings()
        if settings.iCloudSyncEnabled {
            CloudSyncManager.shared.syncSession(session)
        }
    }
    
    private func loadAllSessions() -> [TimerSession] {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey),
              let sessions = try? JSONDecoder().decode([TimerSession].self, from: data) else {
            return []
        }
        return sessions
    }
    
    func clearAllSessions() {
        UserDefaults.standard.removeObject(forKey: sessionsKey)
    }
    
    // MARK: - iCloud Sync Integration
    
    func syncWithCloud(completion: @escaping () -> Void) {
        let settings = loadSettings()
        guard settings.iCloudSyncEnabled else {
            completion()
            return
        }
        
        // Merge settings
        CloudSyncManager.shared.mergeWithCloud(localSettings: settings) { [weak self] mergedSettings in
            self?.saveSettings(mergedSettings)
            
            // Merge sessions
            let localSessions = self?.loadAllSessions() ?? []
            CloudSyncManager.shared.mergeSessions(localSessions: localSessions) { mergedSessions in
                // Save merged sessions
                if let encoded = try? JSONEncoder().encode(mergedSessions) {
                    UserDefaults.standard.set(encoded, forKey: self?.sessionsKey ?? "SavedSessions")
                }
                
                completion()
            }
        }
    }
}
