//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject private var cloudSyncManager = CloudSyncManager.shared
    @Environment(\.appTheme) var theme
    
    @State private var showingClearStatsConfirmation = false
    @State private var showingResetAppConfirmation = false
    @State private var showingDeleteCloudConfirmation = false
    
    var body: some View {
        ZStack {
            // Animated background gradient
            theme.focusGradient
                .opacity(0.12)
                .ignoresSafeArea()
            
            Form {
                // Learn about Pomodoro - Featured at top
                learnSection
                
                // Theme Selection
                themeSection
            
            // Duration Settings
            durationSection
            
            // Auto-start Settings
            autoStartSection
            
            // Focus Mode Integration
            if #available(iOS 16.1, *) {
                focusModeSection
            }
            
            // Notifications & Feedback
            notificationSection
            
            // iCloud Sync
            iCloudSection
            
            // Data Management
            dataSection
            
            // App Info
            aboutSection
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Theme Section
    
    private var themeSection: some View {
        Section {
            NavigationLink(destination: ThemeSelectionView(themeManager: themeManager)) {
                HStack(spacing: 12) {
                    Image(systemName: "paintbrush.fill")
                        .foregroundColor(theme.primaryColor)
                        .frame(width: 24)
                    
                    Text("App Theme")
                    
                    Spacer()
                    
                    // Current theme preview
                    HStack(spacing: 4) {
                        Circle()
                            .fill(themeManager.currentTheme.primaryColor)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(themeManager.currentTheme.secondaryColor)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(themeManager.currentTheme.accentColor)
                            .frame(width: 12, height: 12)
                    }
                    
                    Text(themeManager.currentTheme.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .accessibilityLabel("Change app theme, currently \(themeManager.currentTheme.name)")
        } header: {
            Label("Appearance", systemImage: "paintbrush.fill")
        }
    }
    
    // MARK: - Duration Section
    
    private var durationSection: some View {
        Section {
            DurationPicker(
                title: "Focus",
                duration: $timerManager.settings.focusDuration,
                icon: "brain.head.profile",
                color: theme.primaryColor
            )
            
            DurationPicker(
                title: "Short Break",
                duration: $timerManager.settings.shortBreakDuration,
                icon: "cup.and.saucer.fill",
                color: .green
            )
            
            DurationPicker(
                title: "Long Break",
                duration: $timerManager.settings.longBreakDuration,
                icon: "bed.double.fill",
                color: .blue
            )
            
            Stepper(
                value: $timerManager.settings.sessionsUntilLongBreak,
                in: 2...10
            ) {
                HStack {
                    Image(systemName: "repeat")
                        .foregroundColor(theme.accentColor)
                        .frame(width: 24)
                    Text("Sessions until long break")
                    Spacer()
                    Text("\(timerManager.settings.sessionsUntilLongBreak)")
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                }
            }
            .accessibilityLabel("Sessions until long break: \(timerManager.settings.sessionsUntilLongBreak)")
        } header: {
            Label("Session Durations", systemImage: "clock.fill")
        }
    }
    
    // MARK: - Auto-start Section
    
    private var autoStartSection: some View {
        Section {
            Toggle(isOn: $timerManager.settings.autoStartBreaks) {
                HStack(spacing: 12) {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.green)
                        .frame(width: 24)
                    Text("Auto-start breaks")
                }
            }
            .accessibilityLabel("Auto-start breaks")
            
            Toggle(isOn: $timerManager.settings.autoStartFocus) {
                HStack(spacing: 12) {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(theme.primaryColor)
                        .frame(width: 24)
                    Text("Auto-start focus")
                }
            }
            .accessibilityLabel("Auto-start focus sessions")
        } header: {
            Label("Auto-Start", systemImage: "play.circle")
        } footer: {
            Text("Automatically begin the next session when the current one completes.")
                .font(theme.typography.caption)
        }
    }
    
    // MARK: - Focus Mode Section
    
    @available(iOS 16.1, *)
    private var focusModeSection: some View {
        Section {
            Toggle(isOn: $timerManager.settings.focusModeEnabled) {
                HStack(spacing: 12) {
                    Image(systemName: "moon.circle.fill")
                        .foregroundColor(.indigo)
                        .frame(width: 24)
                    Text("Enable Focus Mode")
                }
            }
            .accessibilityLabel("Enable Focus Mode during Pomodoro")
            
            if timerManager.settings.focusModeEnabled {
                Toggle(isOn: $timerManager.settings.syncWithFocusMode) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.purple)
                            .frame(width: 24)
                        Text("Sync with iOS Focus")
                    }
                }
                .accessibilityLabel("Sync timer with iOS Focus Mode")
            }
        } header: {
            Label("Focus Mode", systemImage: "moon.fill")
        } footer: {
            Text("Focus Mode will be suggested during focus sessions. Enable it manually from Control Center.")
                .font(theme.typography.caption)
        }
    }
    
    // MARK: - Notification Section
    
    private var notificationSection: some View {
        Section {
            Toggle(isOn: $timerManager.settings.notificationsEnabled) {
                HStack(spacing: 12) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    Text("Notifications")
                }
            }
            .accessibilityLabel("Enable notifications")
            
            Toggle(isOn: $timerManager.settings.soundEnabled) {
                HStack(spacing: 12) {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.purple)
                        .frame(width: 24)
                    Text("Sound")
                }
            }
            .accessibilityLabel("Enable sound")
            
            Toggle(isOn: $timerManager.settings.hapticEnabled) {
                HStack(spacing: 12) {
                    Image(systemName: "waveform")
                        .foregroundColor(.orange)
                        .frame(width: 24)
                    Text("Haptic Feedback")
                }
            }
            .accessibilityLabel("Enable haptic feedback")
        } header: {
            Label("Notifications & Feedback", systemImage: "bell.badge.fill")
        }
    }
    
    // MARK: - iCloud Section
    
    private var iCloudSection: some View {
        Section {
            Toggle(isOn: $timerManager.settings.iCloudSyncEnabled) {
                HStack(spacing: 12) {
                    Image(systemName: "icloud.fill")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    Text("Enable iCloud Sync")
                }
            }
            .accessibilityLabel("Enable iCloud sync")
            .onChange(of: timerManager.settings.iCloudSyncEnabled) { oldValue, newValue in
                if newValue {
                    cloudSyncManager.startAutomaticSync()
                    // Trigger immediate sync when enabled
                    cloudSyncManager.syncSettings(timerManager.settings)
                    let sessions = PersistenceManager.shared.getAllSessions()
                    if !sessions.isEmpty {
                        cloudSyncManager.syncAllSessions(sessions)
                    }
                } else {
                    cloudSyncManager.stopAutomaticSync()
                }
            }
            
            if timerManager.settings.iCloudSyncEnabled {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.orange)
                        .frame(width: 24)
                    Text("Last Sync")
                    Spacer()
                    if let lastSync = cloudSyncManager.lastSyncDate {
                        Text(formatTimeSinceSync(lastSync))
                            .font(theme.typography.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Never")
                            .font(theme.typography.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    Text("Next Sync")
                    Spacer()
                    if cloudSyncManager.isSyncing {
                        HStack(spacing: 4) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(0.7)
                            Text("Syncing...")
                                .font(theme.typography.caption)
                                .foregroundColor(.secondary)
                        }
                    } else if let nextSync = cloudSyncManager.nextSyncDate {
                        Text(formatTimeUntilSync(nextSync))
                            .font(theme.typography.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Not scheduled")
                            .font(theme.typography.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        } header: {
            Label("iCloud Sync", systemImage: "icloud")
        } footer: {
            if timerManager.settings.iCloudSyncEnabled {
                Text("Settings and session history sync once daily across all devices signed in with the same iCloud account.")
                    .font(theme.typography.caption)
            }
        }
    }
    
    // MARK: - Data Section
    
    private var dataSection: some View {
        Section {
            Button(role: .destructive) {
                showingClearStatsConfirmation = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "trash.fill")
                        .frame(width: 24)
                    Text("Clear All Statistics")
                }
            }
            .accessibilityLabel("Clear all statistics")
            .confirmationDialog(
                "Clear All Statistics",
                isPresented: $showingClearStatsConfirmation,
                titleVisibility: .visible
            ) {
                Button("Clear Statistics", role: .destructive) {
                    timerManager.clearAllSessions()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all your session history and statistics. This action cannot be undone.")
            }
            
            Button(role: .destructive) {
                showingResetAppConfirmation = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .frame(width: 24)
                    Text("Reset App Completely")
                }
            }
            .accessibilityLabel("Reset app to default settings")
            .confirmationDialog(
                "Reset App Completely",
                isPresented: $showingResetAppConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset Everything", role: .destructive) {
                    timerManager.resetAppCompletely()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset all settings to defaults and delete all statistics. The app will return to its initial state. This action cannot be undone.")
            }
            
            if timerManager.settings.iCloudSyncEnabled {
                Button(role: .destructive) {
                    showingDeleteCloudConfirmation = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "icloud.slash.fill")
                            .frame(width: 24)
                        Text("Delete iCloud Data")
                    }
                }
                .accessibilityLabel("Delete all iCloud data")
                .confirmationDialog(
                    "Delete iCloud Data",
                    isPresented: $showingDeleteCloudConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Delete iCloud Data", role: .destructive) {
                        deleteCloudData()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will permanently delete all your data stored in iCloud. This action cannot be undone.")
                }
            }
        } header: {
            Label("Data Management", systemImage: "externaldrive.fill")
        } footer: {
            Text("Use these options to manage your app data. All destructive actions require confirmation.")
                .font(theme.typography.caption)
        }
    }
    
    // MARK: - Learn Section
    
    private var learnSection: some View {
        Section {
            NavigationLink(destination: PomodoroBenefitsView()) {
                HStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.orange)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Learn about Pomodoro")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Discover the science behind focused work")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .accessibilityIdentifier("Learn about Pomodoro")
            .accessibilityLabel("Learn about the Pomodoro Technique")
        } header: {
            Label("Get Started", systemImage: "book.fill")
        }
    }
    
    // MARK: - About Section
    
    private var aboutSection: some View {
        Section {
            NavigationLink(destination: PrivacyPolicyView()) {
                HStack(spacing: 12) {
                    Image(systemName: "hand.raised.fill")
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    Text("Privacy Policy")
                }
            }
            .accessibilityLabel("View Privacy Policy")
            
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.gray)
                    .frame(width: 24)
                Text("Version")
                Spacer()
                Text("1.1.0")
                    .foregroundColor(.secondary)
            }
        } header: {
            Label("About", systemImage: "info.circle")
        }
    }
    
    // MARK: - Helper Methods
    
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
        let totalMinutes = Int(timeInterval / 60)
        
        if totalMinutes < 1 {
            return "Just now"
        } else if totalMinutes < 60 {
            return "\(totalMinutes) min ago"
        } else if totalMinutes < 1440 {
            let hours = totalMinutes / 60
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else {
            let days = totalMinutes / 1440
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
    }
    
    private func formatTimeUntilSync(_ date: Date) -> String {
        let now = Date()
        let timeInterval = date.timeIntervalSince(now)
        let totalMinutes = Int(timeInterval / 60)
        
        if totalMinutes < 1 {
            return "In < 1 min"
        } else if totalMinutes < 60 {
            return "In \(totalMinutes) min"
        } else if totalMinutes < 1440 {
            let hours = totalMinutes / 60
            return "In \(hours) hour\(hours == 1 ? "" : "s")"
        } else {
            let days = totalMinutes / 1440
            return "In \(days) day\(days == 1 ? "" : "s")"
        }
    }
}


// MARK: - Duration Picker

struct DurationPicker: View {
    let title: String
    @Binding var duration: TimeInterval
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
            
            Spacer()
            
            Stepper(
                value: Binding(
                    get: { duration / 60 },
                    set: { duration = $0 * 60 }
                ),
                in: 1...120
            ) {
                Text("\(Int(duration / 60)) min")
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
            .accessibilityLabel("\(title) duration: \(Int(duration / 60)) minutes")
        }
    }
}

#Preview {
    NavigationView {
        SettingsView(timerManager: TimerManager(), themeManager: ThemeManager())
            .appTheme(.classicRed)
    }
}
