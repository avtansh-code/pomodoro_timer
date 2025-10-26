//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject private var cloudSyncManager = CloudSyncManager.shared
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var systemColorScheme
    
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
                    .onChange(of: timerManager.settings.iCloudSyncEnabled) { oldValue, newValue in
                        if newValue {
                            cloudSyncManager.startAutomaticSync()
                        } else {
                            cloudSyncManager.stopAutomaticSync()
                        }
                    }
                    
                    if timerManager.settings.iCloudSyncEnabled {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.orange)
                            Text("Last Sync")
                            Spacer()
                            if let lastSync = cloudSyncManager.lastSyncDate {
                                Text(formatTimeSinceSync(lastSync))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Never")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.blue)
                            Text("Next Sync")
                            Spacer()
                            if cloudSyncManager.isSyncing {
                                HStack(spacing: 4) {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .scaleEffect(0.7)
                                    Text("Syncing...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            } else if let nextSync = cloudSyncManager.nextSyncDate {
                                Text(formatTimeUntilSync(nextSync))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Not scheduled")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text("Your settings and session history automatically sync once daily across all your devices signed in with the same iCloud account.")
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
    
    private func formatTimeSinceSync(_ date: Date) -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        // Convert to whole number minutes
        let totalMinutes = Int(timeInterval / 60)
        
        if totalMinutes < 1 {
            return "Just now"
        } else if totalMinutes < 60 {
            // Less than 60 minutes, show in minutes
            return "\(totalMinutes) min ago"
        } else if totalMinutes < 1440 { // Less than 24 hours (60 * 24 = 1440)
            // Show in hours
            let hours = totalMinutes / 60
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else {
            // Show in days
            let days = totalMinutes / 1440
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
    }
    
    private func formatTimeUntilSync(_ date: Date) -> String {
        let now = Date()
        let timeInterval = date.timeIntervalSince(now)
        
        // Convert to whole number minutes
        let totalMinutes = Int(timeInterval / 60)
        
        if totalMinutes < 1 {
            return "In < 1 min"
        } else if totalMinutes < 60 {
            // Less than 60 minutes, show in minutes
            return "In \(totalMinutes) min"
        } else if totalMinutes < 1440 { // Less than 24 hours (60 * 24 = 1440)
            // Show in hours
            let hours = totalMinutes / 60
            return "In \(hours) hour\(hours == 1 ? "" : "s")"
        } else {
            // Show in days
            let days = totalMinutes / 1440
            return "In \(days) day\(days == 1 ? "" : "s")"
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
