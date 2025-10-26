//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var timerManager: TimerManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                // Duration Settings
                Section(header: Text("Session Durations")) {
                    DurationPicker(
                        title: "Focus",
                        duration: $timerManager.settings.focusDuration,
                        icon: "brain.head.profile"
                    )
                    
                    DurationPicker(
                        title: "Short Break",
                        duration: $timerManager.settings.shortBreakDuration,
                        icon: "cup.and.saucer.fill"
                    )
                    
                    DurationPicker(
                        title: "Long Break",
                        duration: $timerManager.settings.longBreakDuration,
                        icon: "bed.double.fill"
                    )
                    
                    Stepper("Sessions until long break: \(timerManager.settings.sessionsUntilLongBreak)",
                            value: $timerManager.settings.sessionsUntilLongBreak,
                            in: 2...10)
                    .accessibilityLabel("Sessions until long break")
                    .accessibilityValue("\(timerManager.settings.sessionsUntilLongBreak)")
                }
                
                // Auto-start Settings
                Section(header: Text("Auto-Start")) {
                    Toggle(isOn: $timerManager.settings.autoStartBreaks) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(.green)
                            Text("Auto-start breaks")
                        }
                    }
                    .accessibilityLabel("Auto-start breaks")
                    
                    Toggle(isOn: $timerManager.settings.autoStartFocus) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(.red)
                            Text("Auto-start focus")
                        }
                    }
                    .accessibilityLabel("Auto-start focus sessions")
                }
                
                // Notifications & Feedback
                Section(header: Text("Notifications & Feedback")) {
                    Toggle(isOn: $timerManager.settings.notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                            Text("Notifications")
                        }
                    }
                    .accessibilityLabel("Enable notifications")
                    
                    Toggle(isOn: $timerManager.settings.soundEnabled) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.purple)
                            Text("Sound")
                        }
                    }
                    .accessibilityLabel("Enable sound")
                    
                    Toggle(isOn: $timerManager.settings.hapticEnabled) {
                        HStack {
                            Image(systemName: "waveform")
                                .foregroundColor(.orange)
                            Text("Haptic Feedback")
                        }
                    }
                    .accessibilityLabel("Enable haptic feedback")
                }
                
                // Theme Settings
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $timerManager.settings.selectedTheme) {
                        ForEach(TimerSettings.AppTheme.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityLabel("Theme selector")
                }
                
                // Data Management
                Section(header: Text("Data")) {
                    Button(role: .destructive) {
                        timerManager.clearAllSessions()
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Clear All Statistics")
                        }
                    }
                    .accessibilityLabel("Clear all statistics")
                }
                
                // App Info
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        saveSettings()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveSettings() {
        PersistenceManager.shared.saveSettings(timerManager.settings)
    }
}

struct DurationPicker: View {
    let title: String
    @Binding var duration: TimeInterval
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            Text(title)
            
            Spacer()
            
            Stepper("\(Int(duration / 60)) min",
                    value: Binding(
                        get: { duration / 60 },
                        set: { duration = $0 * 60 }
                    ),
                    in: 1...120)
            .accessibilityLabel("\(title) duration")
            .accessibilityValue("\(Int(duration / 60)) minutes")
        }
    }
}

#Preview {
    SettingsView(timerManager: TimerManager())
}
