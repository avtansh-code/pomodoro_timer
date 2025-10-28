//
//  ScreenshotHelper.swift
//  PomodoroTimer
//
//  Created for screenshot preparation
//

import Foundation

/// Helper class to prepare the app for screenshot capture
/// This adds dummy statistics data and starts timers with random progress
@MainActor
class ScreenshotHelper {
    
    // MARK: - Public Methods
    
    /// Adds comprehensive dummy statistics data for screenshots
    /// Call this before taking statistics screenshots
    static func addDummyStatistics() {
        let persistence = PersistenceManager.shared
        
        // Clear existing data first
        persistence.clearAllSessions()
        
        // Add sessions over the past 60 days to show difference between week and month views
        let calendar = Calendar.current
        let now = Date()
        
        // Generate sessions for the last 60 days with realistic patterns
        for dayOffset in 0..<60 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            
            // Decide how many focus sessions for this day with varied patterns
            let focusSessions: Int
            if dayOffset == 0 {
                // Today: always have 3-6 sessions to show activity
                focusSessions = Int.random(in: 3...6)
            } else if dayOffset <= 7 {
                // Last 7 days (Week view): ensure consistent high activity (4-8 sessions)
                focusSessions = Int.random(in: 4...8)
            } else if dayOffset <= 30 {
                // Days 8-30 (Month view): moderate activity (2-6 sessions)
                focusSessions = Int.random(in: 2...6)
            } else {
                // Days 31-60: lower activity with some zero days (0-4 sessions)
                focusSessions = Int.random(in: 0...4)
            }
            
            for sessionIndex in 0..<focusSessions {
                // Spread sessions throughout the day
                let hourOffset = Int.random(in: 8...20) // Between 8 AM and 8 PM
                let minuteOffset = Int.random(in: 0...59)
                
                guard let sessionTime = calendar.date(bySettingHour: hourOffset, minute: minuteOffset, second: 0, of: date) else { continue }
                
                // Add focus session
                let focusSession = TimerSession(
                    type: .focus,
                    duration: 25 * 60, // 25 minutes
                    completedAt: sessionTime
                )
                persistence.saveSession(focusSession)
                
                // Add corresponding break session
                let breakDuration: TimeInterval
                let breakType: SessionType
                
                if (sessionIndex + 1) % 4 == 0 {
                    // Long break every 4 sessions
                    breakType = .longBreak
                    breakDuration = 15 * 60
                } else {
                    // Short break
                    breakType = .shortBreak
                    breakDuration = 5 * 60
                }
                
                if let breakTime = calendar.date(byAdding: .minute, value: 26, to: sessionTime) {
                    let breakSession = TimerSession(
                        type: breakType,
                        duration: breakDuration,
                        completedAt: breakTime
                    )
                    persistence.saveSession(breakSession)
                }
            }
        }
        
        print("✅ Added dummy statistics data for screenshots")
        print("📊 Total sessions: \(persistence.getAllSessions().count)")
        print("📅 Today's sessions: \(persistence.getTodaySessions().count)")
        print("📅 This week's sessions: \(persistence.getWeeklySessions().count)")
        print("🔥 Current streak: \(persistence.getCurrentStreak()) days")
    }
    
    /// Starts a focus session with random progress for screenshots
    /// - Parameter timerManager: The timer manager to configure
    /// - Parameter progress: Optional specific progress (0.0-1.0). If nil, random progress is used
    static func startFocusSessionWithRandomProgress(timerManager: TimerManager, progress: Double? = nil) {
        // Set to focus session
        timerManager.currentSessionType = .focus
        
        // Calculate random or specified progress
        let progressValue = progress ?? Double.random(in: 0.3...0.7) // 30% to 70% complete
        let totalDuration = timerManager.settings.focusDuration
        let timeElapsed = totalDuration * progressValue
        let timeRemaining = totalDuration - timeElapsed
        
        // Set the time remaining
        timerManager.timeRemaining = timeRemaining
        
        // Start the timer
        timerManager.timerState = .running
        timerManager.startTimer()
        
        let minutesRemaining = Int(timeRemaining / 60)
        let secondsRemaining = Int(timeRemaining.truncatingRemainder(dividingBy: 60))
        
        print("✅ Started focus session for screenshot")
        print("⏱️  Time remaining: \(minutesRemaining)m \(secondsRemaining)s")
        print("📊 Progress: \(Int(progressValue * 100))%")
    }
    
    /// Starts a break session with random progress for screenshots
    /// - Parameters:
    ///   - timerManager: The timer manager to configure
    ///   - isLongBreak: Whether to start a long break (default: false for short break)
    ///   - progress: Optional specific progress (0.0-1.0). If nil, random progress is used
    static func startBreakSessionWithRandomProgress(timerManager: TimerManager, isLongBreak: Bool = false, progress: Double? = nil) {
        // Set session type
        timerManager.currentSessionType = isLongBreak ? .longBreak : .shortBreak
        
        // Calculate random or specified progress
        let progressValue = progress ?? Double.random(in: 0.3...0.7) // 30% to 70% complete
        let totalDuration = isLongBreak ? timerManager.settings.longBreakDuration : timerManager.settings.shortBreakDuration
        let timeElapsed = totalDuration * progressValue
        let timeRemaining = totalDuration - timeElapsed
        
        // Set the time remaining
        timerManager.timeRemaining = timeRemaining
        
        // Start the timer
        timerManager.timerState = .running
        timerManager.startTimer()
        
        let minutesRemaining = Int(timeRemaining / 60)
        let secondsRemaining = Int(timeRemaining.truncatingRemainder(dividingBy: 60))
        
        print("✅ Started \(isLongBreak ? "long" : "short") break session for screenshot")
        print("⏱️  Time remaining: \(minutesRemaining)m \(secondsRemaining)s")
        print("📊 Progress: \(Int(progressValue * 100))%")
    }
    
    /// Configures the app for a complete screenshot session
    /// - Parameters:
    ///   - timerManager: The timer manager to configure
    ///   - sessionType: The type of session to prepare ("focus", "shortBreak", or "longBreak")
    ///   - addStats: Whether to add dummy statistics (default: true)
    static func prepareForScreenshot(timerManager: TimerManager, sessionType: String = "focus", addStats: Bool = true) {
        // Add dummy statistics if requested
        if addStats {
            addDummyStatistics()
        }
        
        // Configure the appropriate session type
        switch sessionType.lowercased() {
        case "focus":
            startFocusSessionWithRandomProgress(timerManager: timerManager)
        case "shortbreak", "short":
            startBreakSessionWithRandomProgress(timerManager: timerManager, isLongBreak: false)
        case "longbreak", "long":
            startBreakSessionWithRandomProgress(timerManager: timerManager, isLongBreak: true)
        default:
            print("⚠️  Unknown session type: \(sessionType). Using focus session.")
            startFocusSessionWithRandomProgress(timerManager: timerManager)
        }
        
        print("📸 App is ready for screenshot capture!")
    }
    
    /// Resets the app back to normal state after screenshot capture
    /// - Parameter timerManager: The timer manager to reset
    static func cleanupAfterScreenshot(timerManager: TimerManager) {
        // Stop the timer
        timerManager.resetTimer()
        
        // Clear dummy data
        PersistenceManager.shared.clearAllSessions()
        
        print("🧹 Cleaned up screenshot preparation")
    }
}
