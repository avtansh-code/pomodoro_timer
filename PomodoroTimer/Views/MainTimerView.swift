//
//  MainTimerView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

struct MainTimerView: View {
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        VStack(spacing: 30) {
            // Session Type Header
            Text(timerManager.currentSessionType.rawValue)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(sessionColor)
                .accessibilityLabel("Current session: \(timerManager.currentSessionType.rawValue)")
            
            // Circular Progress Timer
            ZStack {
                Circle()
                    .stroke(sessionColor.opacity(0.2), lineWidth: 20)
                    .frame(width: 280, height: 280)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(sessionColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 280, height: 280)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)
                
                VStack(spacing: 8) {
                    Text(timeString)
                        .font(.system(size: 64, weight: .thin, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.primary)
                        .accessibilityLabel("Time remaining: \(timeString)")
                    
                    Text("Session \(timerManager.completedFocusSessions + 1)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Session number \(timerManager.completedFocusSessions + 1)")
                }
            }
            .padding(.vertical, 40)
            
            // Control Buttons
            HStack(spacing: 20) {
                if timerManager.timerState == .idle {
                    // Start Button
                    Button(action: {
                        timerManager.startTimer()
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 56)
                        .background(sessionColor)
                        .cornerRadius(28)
                    }
                    .accessibilityLabel("Start timer")
                    
                } else if timerManager.timerState == .running {
                    // Pause Button
                    Button(action: {
                        timerManager.pauseTimer()
                    }) {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 56)
                        .background(Color.orange)
                        .cornerRadius(28)
                    }
                    .accessibilityLabel("Pause timer")
                    
                } else {
                    // Resume Button
                    Button(action: {
                        timerManager.startTimer()
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Resume")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 56)
                        .background(sessionColor)
                        .cornerRadius(28)
                    }
                    .accessibilityLabel("Resume timer")
                }
                
                // Reset Button
                Button(action: {
                    timerManager.resetTimer()
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .font(.headline)
                    .foregroundColor(sessionColor)
                    .frame(width: 140, height: 56)
                    .background(sessionColor.opacity(0.15))
                    .cornerRadius(28)
                }
                .accessibilityLabel("Reset timer")
            }
            
            // Skip Button
            Button(action: {
                timerManager.skipSession()
            }) {
                HStack {
                    Image(systemName: "forward.fill")
                    Text("Skip to \(nextSessionName)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .accessibilityLabel("Skip to \(nextSessionName)")
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Computed Properties
    
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
    
    private var sessionColor: Color {
        switch timerManager.currentSessionType {
        case .focus:
            return .red
        case .shortBreak:
            return .green
        case .longBreak:
            return .blue
        }
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

#Preview {
    MainTimerView(timerManager: TimerManager())
}
