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
    @Environment(\.appTheme) var theme
    
    @State private var showingClearStatsConfirmation = false
    @State private var showingResetAppConfirmation = false
    
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
            
            // Developer Tools (Debug only)
            #if DEBUG
            developerSection
            #endif
            
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
    
    // MARK: - Developer Tools Section
    
    private var developerSection: some View {
        Section {
            NavigationLink(destination: ScreenshotPreparationView().environmentObject(timerManager)) {
                HStack(spacing: 12) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.purple)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Screenshot Mode")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Prepare app for screenshot capture")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .accessibilityLabel("Screenshot preparation mode")
        } header: {
            Label("Developer Tools", systemImage: "wrench.and.screwdriver.fill")
        } footer: {
            Text("Tools for preparing the app for App Store screenshots with dummy data.")
                .font(theme.typography.caption)
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
            .accessibilityLabel("Reset App Completely")
            .accessibilityHint("Reset app to default settings and delete all statistics")
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
            .accessibilityLabel("Learn about Pomodoro")
            .accessibilityHint("Navigate to learn about the Pomodoro Technique")
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
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Version 1.1.0")
        } header: {
            Label("About", systemImage: "info.circle")
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
