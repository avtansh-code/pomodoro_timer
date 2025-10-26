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
    
    init(settings: TimerSettings = TimerSettings()) {
        self.settings = settings
        self.timeRemaining = settings.focusDuration
        setupAudioSession()
        setupIntentObservers()
    }
    
    // MARK: - Timer Controls
    
    func startTimer() {
        guard timerState != .running else { return }
        
        timerState = .running
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        // Keep timer running when app goes to background
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func pauseTimer() {
        guard timerState == .running else { return }
        
        timerState = .paused
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        timeRemaining = getDuration(for: currentSessionType)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func skipSession() {
        resetTimer()
        switchToNextSession()
    }
    
    // MARK: - Timer Logic
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            completeSession()
        }
    }
    
    private func completeSession() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        
        // Save completed session
        let session = TimerSession(type: currentSessionType, duration: getDuration(for: currentSessionType))
        saveSession(session)
        
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
    
    private func saveSession(_ session: TimerSession) {
        var sessions = loadSessions()
        sessions.append(session)
        
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "SavedSessions")
        }
    }
    
    func loadSessions() -> [TimerSession] {
        guard let data = UserDefaults.standard.data(forKey: "SavedSessions"),
              let sessions = try? JSONDecoder().decode([TimerSession].self, from: data) else {
            return []
        }
        return sessions
    }
    
    func clearAllSessions() {
        UserDefaults.standard.removeObject(forKey: "SavedSessions")
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

import UIKit
import AudioToolbox
