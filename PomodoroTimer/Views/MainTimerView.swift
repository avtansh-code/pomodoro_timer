//
//  MainTimerView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

struct MainTimerView: View {
    @ObservedObject var timerManager: TimerManager
    @Environment(\.appTheme) var theme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Animated background gradient
                theme.gradientFor(sessionType: timerManager.currentSessionType)
                    .opacity(backgroundOpacity)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.6), value: timerManager.currentSessionType)
                
                VStack(spacing: 0) {
                    // Session Type Header
                    sessionHeader
                        .padding(.top, 20)
                    
                    Spacer(minLength: 40)
                    
                    // Circular Progress Timer
                    circularTimer
                    
                    Spacer(minLength: 40)
                    
                    // Control Buttons
                    controlButtons
                        .padding(.horizontal, 24)
                    
                    // Skip Button
                    skipButton
                        .padding(.top, 24)
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Session Header
    
    private var sessionHeader: some View {
        VStack(spacing: 8) {
            Text(timerManager.currentSessionType.rawValue)
                .font(theme.typography.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.colorFor(sessionType: timerManager.currentSessionType))
                .accessibilityLabel("Current session: \(timerManager.currentSessionType.rawValue)")
            
            Text("Session \(timerManager.completedFocusSessions + 1)")
                .font(theme.typography.subheadline)
                .foregroundColor(.secondary)
                .accessibilityLabel("Session number \(timerManager.completedFocusSessions + 1)")
        }
        .animation(.easeInOut(duration: 0.4), value: timerManager.currentSessionType)
    }
    
    // MARK: - Circular Timer
    
    private var circularTimer: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    theme.colorFor(sessionType: timerManager.currentSessionType).opacity(0.2),
                    lineWidth: 20
                )
                .frame(width: 280, height: 280)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    theme.colorFor(sessionType: timerManager.currentSessionType),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
            
            // Timer display
            VStack(spacing: 12) {
                Text(timeString)
                    .font(theme.typography.timerFont)
                    .monospacedDigit()
                    .foregroundColor(.primary)
                    .accessibilityLabel("Time remaining: \(timeString)")
                
                // State indicator
                stateIndicator
            }
        }
        .shadow(color: theme.colorFor(sessionType: timerManager.currentSessionType).opacity(0.15), radius: 20, x: 0, y: 10)
    }
    
    private var stateIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(stateIndicatorColor)
                .frame(width: 8, height: 8)
            
            Text(stateText)
                .font(theme.typography.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color(.systemGray6))
        )
    }
    
    private var stateIndicatorColor: Color {
        switch timerManager.timerState {
        case .running:
            return .green
        case .paused:
            return .orange
        case .idle:
            return .gray
        }
    }
    
    private var stateText: String {
        switch timerManager.timerState {
        case .running:
            return "Active"
        case .paused:
            return "Paused"
        case .idle:
            return "Ready"
        }
    }
    
    // MARK: - Control Buttons
    
    private var controlButtons: some View {
        HStack(spacing: 16) {
            if timerManager.timerState == .idle {
                startButton
                    .transition(.scale.combined(with: .opacity))
            } else if timerManager.timerState == .running {
                pauseButton
                    .transition(.scale.combined(with: .opacity))
            } else {
                resumeButton
                    .transition(.scale.combined(with: .opacity))
            }
            
            resetButton
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: timerManager.timerState)
    }
    
    private var startButton: some View {
        ActionButton(
            title: "Start",
            icon: "play.fill",
            backgroundColor: theme.colorFor(sessionType: timerManager.currentSessionType),
            foregroundColor: .white,
            action: {
                HapticManager.impact(style: .medium)
                timerManager.startTimer()
            }
        )
        .accessibilityLabel("Start timer")
        .accessibilityIdentifier("startTimerButton")
    }
    
    private var pauseButton: some View {
        ActionButton(
            title: "Pause",
            icon: "pause.fill",
            backgroundColor: .orange,
            foregroundColor: .white,
            action: {
                HapticManager.impact(style: .medium)
                timerManager.pauseTimer()
            }
        )
        .accessibilityLabel("Pause timer")
        .accessibilityIdentifier("pauseTimerButton")
    }
    
    private var resumeButton: some View {
        ActionButton(
            title: "Resume",
            icon: "play.fill",
            backgroundColor: theme.colorFor(sessionType: timerManager.currentSessionType),
            foregroundColor: .white,
            action: {
                HapticManager.impact(style: .medium)
                timerManager.startTimer()
            }
        )
        .accessibilityLabel("Resume timer")
        .accessibilityIdentifier("resumeTimerButton")
    }
    
    private var resetButton: some View {
        ActionButton(
            title: "Reset",
            icon: "arrow.counterclockwise",
            backgroundColor: theme.colorFor(sessionType: timerManager.currentSessionType).opacity(0.15),
            foregroundColor: theme.colorFor(sessionType: timerManager.currentSessionType),
            action: {
                HapticManager.impact(style: .light)
                timerManager.resetTimer()
            }
        )
        .accessibilityLabel("Reset timer")
        .accessibilityIdentifier("resetTimerButton")
    }
    
    // MARK: - Skip Button
    
    private var skipButton: some View {
        Button(action: {
            HapticManager.impact(style: .light)
            timerManager.skipSession()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "forward.fill")
                    .font(.system(size: 14, weight: .semibold))
                Text("Skip to \(nextSessionName)")
                    .font(theme.typography.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color(.systemGray5))
            )
        }
        .accessibilityLabel("Skip to \(nextSessionName)")
        .accessibilityIdentifier("skipSessionButton")
    }
    
    // MARK: - Computed Properties
    
    private var backgroundOpacity: Double {
        switch timerManager.currentSessionType {
        case .focus:
            return 0.15  // Slightly more prominent for focus mode
        case .shortBreak:
            return 0.10  // Lighter for short break
        case .longBreak:
            return 0.08  // Even lighter for long break
        }
    }
    
    private var progress: CGFloat {
        let currentDuration: TimeInterval
        
        switch timerManager.currentSessionType {
        case .focus:
            currentDuration = timerManager.settings.focusDuration
        case .shortBreak:
            currentDuration = timerManager.settings.shortBreakDuration
        case .longBreak:
            currentDuration = timerManager.settings.longBreakDuration
        }
        
        return CGFloat(1 - (timerManager.timeRemaining / currentDuration))
    }
    
    private var timeString: String {
        let minutes = Int(timerManager.timeRemaining) / 60
        let seconds = Int(timerManager.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var nextSessionName: String {
        switch timerManager.currentSessionType {
        case .focus:
            if (timerManager.completedFocusSessions + 1) % timerManager.settings.sessionsUntilLongBreak == 0 {
                return "Long Break"
            } else {
                return "Short Break"
            }
        case .shortBreak, .longBreak:
            return "Focus"
        }
    }
}

// MARK: - Action Button Component

struct ActionButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .cornerRadius(16)
            .shadow(color: backgroundColor.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Haptic Manager

struct HapticManager {
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

#Preview {
    MainTimerView(timerManager: TimerManager())
        .appTheme(.classicRed)
}
