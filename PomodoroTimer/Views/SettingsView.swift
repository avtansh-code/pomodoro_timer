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
                
                // Focus Mode Integration
                if #available(iOS 16.1, *) {
                    Section(header: Text("Focus Mode")) {
                        Toggle(isOn: $timerManager.settings.focusModeEnabled) {
                            HStack {
                                Image(systemName: "moon.circle.fill")
                                    .foregroundColor(.indigo)
                                Text("Enable Focus Mode")
                            }
                        }
                        .accessibilityLabel("Enable Focus Mode during Pomodoro")
                        
                        if timerManager.settings.focusModeEnabled {
                            Toggle(isOn: $timerManager.settings.syncWithFocusMode) {
                                HStack {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .foregroundColor(.purple)
                                    Text("Sync with iOS Focus")
                                }
                            }
                            .accessibilityLabel("Sync timer with iOS Focus Mode")
                            
                            Text("Note: Focus Mode will be suggested during focus sessions. You can enable it manually from Control Center.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
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
                
                // iCloud Sync
                Section(header: Text("iCloud Sync")) {
                    Toggle(isOn: $timerManager.settings.iCloudSyncEnabled) {
                        HStack {
                            Image(systemName: "icloud.fill")
                                .foregroundColor(.blue)
                            Text("Enable iCloud Sync")
                        }
                    }
                    .accessibilityLabel("Enable iCloud sync")
                    
                    if timerManager.settings.iCloudSyncEnabled {
                        HStack {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.green)
                            Text("Sync Status")
                            Spacer()
                            Text(CloudSyncManager.shared.syncStatus.message)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if let lastSync = CloudSyncManager.shared.lastSyncDate {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.orange)
                                Text("Last Sync")
                                Spacer()
                                Text(lastSync, style: .relative)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Button {
                            syncNow()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Sync Now")
                            }
                        }
                        .disabled(CloudSyncManager.shared.isSyncing)
                        
                        Text("Your settings and session history will be synced across all your devices signed in with the same iCloud account.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
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
                    
                    if timerManager.settings.iCloudSyncEnabled {
                        Button(role: .destructive) {
                            deleteCloudData()
                        } label: {
                            HStack {
                                Image(systemName: "icloud.slash.fill")
                                Text("Delete iCloud Data")
                            }
                        }
                        .accessibilityLabel("Delete all iCloud data")
                    }
                }
                
                // App Info
                Section(header: Text("About")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                                .foregroundColor(.blue)
                            Text("Privacy Policy")
                        }
                    }
                    .accessibilityLabel("View Privacy Policy")
                    
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
        
        // Sync to iCloud if enabled
        if timerManager.settings.iCloudSyncEnabled {
            CloudSyncManager.shared.syncSettings(timerManager.settings)
        }
    }
    
    private func syncNow() {
        CloudSyncManager.shared.syncSettings(timerManager.settings)
        
        let sessions = PersistenceManager.shared.getAllSessions()
        CloudSyncManager.shared.syncAllSessions(sessions)
    }
    
    private func deleteCloudData() {
        CloudSyncManager.shared.deleteAllCloudData { success in
            if success {
                print("iCloud data deleted successfully")
            } else {
                print("Failed to delete iCloud data")
            }
        }
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
