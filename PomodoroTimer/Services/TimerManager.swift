//
//  TimerManager.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import Foundation
import Combine
import UserNotifications
import AVFoundation

enum TimerState {
    case idle
    case running
    case paused
}

class TimerManager: ObservableObject {
    @Published var currentSessionType: SessionType = .focus
    @Published var timerState: TimerState = .idle
    @Published var timeRemaining: TimeInterval = 25 * 60
    @Published var completedFocusSessions: Int = 0
    @Published var settings: TimerSettings
    
    private var timer: Timer?
    private var backgroundTime: Date?
    private var audioPlayer: AVAudioPlayer?
    private var focusModeManager: Any? // Will be FocusModeManager for iOS 16.1+
    
    init(settings: TimerSettings = TimerSettings()) {
        self.settings = settings
        self.timeRemaining = settings.focusDuration
        setupAudioSession()
        setupIntentObservers()
        setupFocusModeIfAvailable()
    }
    
    // MARK: - Timer Controls
    
    func startTimer() {
        guard timerState != .running else { return }
        
        timerState = .running
        
        // Enable Focus Mode if settings allow and it's a focus session
        if settings.focusModeEnabled && currentSessionType == .focus {
            enableFocusModeIfAvailable()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        // Keep timer running when app goes to background
        RunLoop.current.add(timer!, forMode: .common)
        
        // Update shared data for widget
        updateSharedData()
    }
    
    func pauseTimer() {
        guard timerState == .running else { return }
        
        timerState = .paused
        timer?.invalidate()
        timer = nil
        
        // Update shared data for widget
        updateSharedData()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        timeRemaining = getDuration(for: currentSessionType)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Update shared data for widget
        updateSharedData()
    }
    
    func skipSession() {
        resetTimer()
        switchToNextSession()
    }
    
    // MARK: - Timer Logic
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            
            // Update shared data for widget every 10 seconds
            if Int(timeRemaining) % 10 == 0 {
                updateSharedData()
            }
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        
        // Disable Focus Mode when session completes
        if settings.focusModeEnabled && currentSessionType == .focus {
            disableFocusModeIfAvailable()
        }
        
        // Save completed session
        let session = TimerSession(type: currentSessionType, duration: getDuration(for: currentSessionType))
        PersistenceManager.shared.saveSession(session)
        
        // Play sound and haptic feedback
        if settings.soundEnabled {
            playCompletionSound()
        }
        
        if settings.hapticEnabled {
            triggerHapticFeedback()
        }
        
        // Send notification
        if settings.notificationsEnabled {
            sendCompletionNotification()
        }
        
        // Move to next session
        switchToNextSession()
        
        // Auto-start if enabled
        if shouldAutoStart() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.startTimer()
            }
        }
    }
    
    private func switchToNextSession() {
        switch currentSessionType {
        case .focus:
            completedFocusSessions += 1
            
            if completedFocusSessions % settings.sessionsUntilLongBreak == 0 {
                currentSessionType = .longBreak
                timeRemaining = settings.longBreakDuration
            } else {
                currentSessionType = .shortBreak
                timeRemaining = settings.shortBreakDuration
            }
            
        case .shortBreak, .longBreak:
            currentSessionType = .focus
            timeRemaining = settings.focusDuration
        }
    }
    
    private func shouldAutoStart() -> Bool {
        switch currentSessionType {
        case .focus:
            return settings.autoStartFocus
        case .shortBreak, .longBreak:
            return settings.autoStartBreaks
        }
    }
    
    private func getDuration(for type: SessionType) -> TimeInterval {
        switch type {
        case .focus:
            return settings.focusDuration
        case .shortBreak:
            return settings.shortBreakDuration
        case .longBreak:
            return settings.longBreakDuration
        }
    }
    
    // MARK: - Audio & Haptics
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func playCompletionSound() {
        // Use system sound
        AudioServicesPlaySystemSound(1013) // Simple beep
    }
    
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Notifications
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    private func sendCompletionNotification() {
        let content = UNMutableNotificationContent()
        
        switch currentSessionType {
        case .focus:
            content.title = "Focus Session Complete! 🎉"
            content.body = "Great work! Time for a break."
        case .shortBreak:
            content.title = "Break Complete! ⏰"
            content.body = "Ready to focus again?"
        case .longBreak:
            content.title = "Long Break Complete! 🌟"
            content.body = "You've earned it! Ready for more?"
        }
        
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
    
    // MARK: - Persistence
    
    func loadSessions() -> [TimerSession] {
        return PersistenceManager.shared.getAllSessions()
    }
    
    func clearAllSessions() {
        PersistenceManager.shared.clearAllSessions()
        completedFocusSessions = 0
    }
    
    // MARK: - Background Handling
    
    func appDidEnterBackground() {
        backgroundTime = Date()
        
        // Schedule notification for when timer completes
        if timerState == .running && settings.notificationsEnabled {
            scheduleBackgroundNotification()
        }
    }
    
    func appWillEnterForeground() {
        guard let backgroundTime = backgroundTime else { return }
        
        let elapsedTime = Date().timeIntervalSince(backgroundTime)
        
        if timerState == .running {
            timeRemaining = max(0, timeRemaining - elapsedTime)
            
            if timeRemaining <= 0 {
                completeSession()
            }
        }
        
        self.backgroundTime = nil
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func scheduleBackgroundNotification() {
        let content = UNMutableNotificationContent()
        content.title = "\(currentSessionType.rawValue) Complete!"
        content.body = "Return to the app to continue your productivity."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeRemaining, repeats: false)
        let request = UNNotificationRequest(identifier: "TimerComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - AppIntents Support
    
    private func setupIntentObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleStartPomodoroIntent(_:)),
            name: NSNotification.Name("StartPomodoroFromIntent"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePauseTimerIntent),
            name: NSNotification.Name("PauseTimerFromIntent"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleResumeTimerIntent),
            name: NSNotification.Name("ResumeTimerFromIntent"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleResetTimerIntent),
            name: NSNotification.Name("ResetTimerFromIntent"),
            object: nil
        )
    }
    
    @objc private func handleStartPomodoroIntent(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Handle custom duration if provided
            if let userInfo = notification.userInfo,
               let customDuration = userInfo["duration"] as? Int {
                let durationInSeconds = TimeInterval(customDuration * 60)
                self.timeRemaining = durationInSeconds
            } else {
                // Use default duration for current session type
                if self.timerState == .idle {
                    self.currentSessionType = .focus
                    self.timeRemaining = self.settings.focusDuration
                }
            }
            
            self.startTimer()
        }
    }
    
    @objc private func handlePauseTimerIntent() {
        DispatchQueue.main.async { [weak self] in
            self?.pauseTimer()
        }
    }
    
    @objc private func handleResumeTimerIntent() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.timerState == .paused else { return }
            self.startTimer()
        }
    }
    
    @objc private func handleResetTimerIntent() {
        DispatchQueue.main.async { [weak self] in
            self?.resetTimer()
        }
    }
    
    // MARK: - Widget Data Sharing
    
    private func updateSharedData() {
        let sessions = loadSessions()
        let todaySessions = sessions.filter { Calendar.current.isDateInToday($0.completedAt) }
        let focusSessions = todaySessions.filter { $0.type == .focus }
        
        let completedToday = focusSessions.count
        let totalFocusTime = focusSessions.reduce(0.0) { $0 + $1.duration }
        let streak = calculateCurrentStreak()
        
        let sharedData = SharedTimerData(
            currentSessionType: currentSessionType.rawValue,
            timeRemaining: timeRemaining,
            isRunning: timerState == .running,
            completedSessionsToday: completedToday,
            totalFocusTimeToday: totalFocusTime,
            currentStreak: streak,
            lastUpdated: Date()
        )
        
        SharedTimerDataManager.shared.saveTimerData(sharedData)
    }
    
    private func calculateCurrentStreak() -> Int {
        let sessions = loadSessions()
        guard !sessions.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        // Count consecutive days with at least one focus session
        while true {
            let hasSessions = sessions.contains { session in
                session.type == .focus &&
                calendar.isDate(session.completedAt, inSameDayAs: currentDate)
            }
            
            if hasSessions {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    // MARK: - Focus Mode Integration
    
    private func setupFocusModeIfAvailable() {
        if #available(iOS 16.1, *) {
            focusModeManager = FocusModeManager.shared
        }
    }
    
    private func enableFocusModeIfAvailable() {
        if #available(iOS 16.1, *) {
            if let manager = focusModeManager as? FocusModeManager {
                manager.enableFocusMode()
                
                // Show hint to user about Focus Mode
                if settings.syncWithFocusMode {
                    sendFocusModeHint()
                }
            }
        }
    }
    
    private func disableFocusModeIfAvailable() {
        if #available(iOS 16.1, *) {
            if let manager = focusModeManager as? FocusModeManager {
                manager.disableFocusMode()
            }
        }
    }
    
    private func sendFocusModeHint() {
        guard settings.notificationsEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Focus Mode Tip 💡"
        content.body = "Enable Focus Mode from Control Center to minimize distractions during your Pomodoro session."
        content.sound = nil
        content.interruptionLevel = .passive
        
        let request = UNNotificationRequest(
            identifier: "FocusModeHint",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

import UIKit
import AudioToolbox
