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
    
    private func loadAllSessions() -> [TimerSession] {
        guard let data = UserDefaults.standard.data(forKey: "SavedSessions"),
              let sessions = try? JSONDecoder().decode([TimerSession].self, from: data) else {
            return []
        }
        return sessions
    }
}
