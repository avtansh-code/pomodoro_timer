//
//  PersistencePerformanceTests.swift
//  PomodoroTimerPerformanceTests
//
//  Created by XCTest Suite
//

import XCTest
@testable import PomodoroTimer

final class PersistencePerformanceTests: XCTestCase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        PersistenceManager.shared.clearAllSessions()
    }
    
    override func tearDown() {
        PersistenceManager.shared.clearAllSessions()
        super.tearDown()
    }
    
    // MARK: - Settings Performance
    
    func testSettingsSavePerformance() {
        let settings = TimerSettings()
        
        measure {
            for _ in 0..<100 {
                PersistenceManager.shared.saveSettings(settings)
            }
        }
    }
    
    func testSettingsLoadPerformance() {
        let settings = TimerSettings()
        PersistenceManager.shared.saveSettings(settings)
        
        measure {
            for _ in 0..<1000 {
                _ = PersistenceManager.shared.loadSettings()
            }
        }
    }
    
    // MARK: - Session Save Performance
    
    func testSingleSessionSavePerformance() {
        let session = TimerSession(type: .focus, duration: 1500)
        
        measure {
            PersistenceManager.shared.saveSession(session)
        }
        
        PersistenceManager.shared.clearAllSessions()
    }
    
    func testMultipleSessionsSavePerformance() {
        measure {
            for _ in 0..<100 {
                let session = TimerSession(type: .focus, duration: 1500)
                PersistenceManager.shared.saveSession(session)
            }
        }
        
        PersistenceManager.shared.clearAllSessions()
    }
    
    func testLargeDatasetSavePerformance() {
        let sessions = (0..<1000).map { _ in TimerSession(type: .focus, duration: 1500) }
        
        measure {
            for session in sessions {
                PersistenceManager.shared.saveSession(session)
            }
        }
        
        PersistenceManager.shared.clearAllSessions()
    }
    
    // MARK: - Session Load Performance
    
    func testLoadAllSessionsPerformance() {
        // Prepare data
        for _ in 0..<100 {
            let session = TimerSession(type: .focus, duration: 1500)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            _ = PersistenceManager.shared.getAllSessions()
        }
    }
    
    func testLoadAllSessionsWithLargeDataset() {
        // Prepare large dataset
        for _ in 0..<1000 {
            let session = TimerSession(type: .focus, duration: 1500)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            let loadedSessions = PersistenceManager.shared.getAllSessions()
            XCTAssertEqual(loadedSessions.count, 1000)
        }
    }
    
    // MARK: - Statistics Calculation Performance
    
    func testGetTodaySessionsPerformance() {
        // Prepare data with mixed dates
        let calendar = Calendar.current
        for i in 0..<250 {
            let daysAgo = i < 50 ? 0 : (i / 10)
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            let session = TimerSession(type: .focus, duration: 1500, completedAt: date)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            _ = PersistenceManager.shared.getTodaySessions()
        }
    }
    
    func testGetWeeklySessionsPerformance() {
        let calendar = Calendar.current
        for i in 0..<500 {
            let daysAgo = i / 20
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            let session = TimerSession(type: .focus, duration: 1500, completedAt: date)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            _ = PersistenceManager.shared.getWeeklySessions()
        }
    }
    
    func testGetMonthlySessionsPerformance() {
        let calendar = Calendar.current
        for i in 0..<1000 {
            let daysAgo = i / 30
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date())!
            let session = TimerSession(type: .focus, duration: 1500, completedAt: date)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            let monthlySessions = PersistenceManager.shared.getMonthlySessions()
            XCTAssertGreaterThan(monthlySessions.count, 0)
        }
    }
    
    // MARK: - Streak Calculation Performance
    
    func testStreakCalculationPerformance() {
        let calendar = Calendar.current
        for day in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -day, to: Date())!
            let session = TimerSession(type: .focus, duration: 1500, completedAt: date)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            _ = PersistenceManager.shared.getCurrentStreak()
        }
    }
    
    func testStreakCalculationWithLargeDataset() {
        let calendar = Calendar.current
        for day in 0..<100 {
            let date = calendar.date(byAdding: .day, value: -day, to: Date())!
            let session = TimerSession(type: .focus, duration: 1500, completedAt: date)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            let streak = PersistenceManager.shared.getCurrentStreak()
            XCTAssertEqual(streak, 101) // 0 to 100 days = 101 days
        }
    }
    
    // MARK: - Clear Performance
    
    func testClearAllSessionsPerformance() {
        // Prepare large dataset
        for _ in 0..<500 {
            let session = TimerSession(type: .focus, duration: 1500)
            PersistenceManager.shared.saveSession(session)
        }
        
        measure {
            PersistenceManager.shared.clearAllSessions()
        }
    }
    
    // MARK: - Memory Performance
    
    func testMemoryUsageWithLargeDataset() {
        measure(metrics: [XCTMemoryMetric()]) {
            for _ in 0..<1000 {
                let session = TimerSession(type: .focus, duration: 1500)
                PersistenceManager.shared.saveSession(session)
            }
            
            _ = PersistenceManager.shared.getAllSessions()
            
            PersistenceManager.shared.clearAllSessions()
        }
    }
    
    // MARK: - Combined Operations Performance
    
    func testMixedOperationsPerformance() {
        measure {
            // Save sessions
            for _ in 0..<10 {
                let session = TimerSession(type: .focus, duration: 1500)
                PersistenceManager.shared.saveSession(session)
            }
            
            // Load and filter
            _ = PersistenceManager.shared.getAllSessions()
            _ = PersistenceManager.shared.getTodaySessions()
            _ = PersistenceManager.shared.getWeeklySessions()
            
            // Calculate statistics
            _ = PersistenceManager.shared.getCurrentStreak()
        }
        
        PersistenceManager.shared.clearAllSessions()
    }
}
