//
//  ScreenshotPreparationView.swift
//  PomodoroTimer
//
//  View for preparing the app for screenshot capture
//

import SwiftUI

struct ScreenshotPreparationView: View {
    @EnvironmentObject var timerManager: TimerManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSuccessMessage = false
    @State private var successMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Prepare your app for capturing beautiful screenshots with realistic data.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } header: {
                    Text("Screenshot Mode")
                }
                
                Section {
                    Button(action: { addDummyStats() }) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Add Dummy Statistics")
                                    .foregroundColor(.primary)
                                Text("Generates 30 days of session data")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Step 1: Statistics")
                }
                
                Section {
                    Button(action: { prepareFocusSession() }) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.red)
                            VStack(alignment: .leading) {
                                Text("Start Focus Session")
                                    .foregroundColor(.primary)
                                Text("Random progress 30-70%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Button(action: { prepareShortBreak() }) {
                        HStack {
                            Image(systemName: "cup.and.saucer.fill")
                                .foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Start Short Break")
                                    .foregroundColor(.primary)
                                Text("Random progress 30-70%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Button(action: { prepareLongBreak() }) {
                        HStack {
                            Image(systemName: "figure.walk")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Start Long Break")
                                    .foregroundColor(.primary)
                                Text("Random progress 30-70%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Step 2: Timer State")
                }
                
                Section {
                    Button(role: .destructive, action: { cleanup() }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Clean Up & Reset")
                        }
                    }
                } header: {
                    Text("Cleanup")
                } footer: {
                    Text("Removes dummy data and resets the timer after screenshot capture.")
                }
                
                if showSuccessMessage {
                    Section {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(successMessage)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Screenshot Prep")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func addDummyStats() {
        ScreenshotHelper.addDummyStatistics()
        showMessage("✅ Added 30 days of statistics data")
    }
    
    private func prepareFocusSession() {
        ScreenshotHelper.startFocusSessionWithRandomProgress(timerManager: timerManager)
        showMessage("🧠 Focus session started with random progress")
    }
    
    private func prepareShortBreak() {
        ScreenshotHelper.startBreakSessionWithRandomProgress(timerManager: timerManager, isLongBreak: false)
        showMessage("☕️ Short break started with random progress")
    }
    
    private func prepareLongBreak() {
        ScreenshotHelper.startBreakSessionWithRandomProgress(timerManager: timerManager, isLongBreak: true)
        showMessage("🚶 Long break started with random progress")
    }
    
    private func cleanup() {
        ScreenshotHelper.cleanupAfterScreenshot(timerManager: timerManager)
        showMessage("🧹 Cleaned up all dummy data")
    }
    
    private func showMessage(_ message: String) {
        successMessage = message
        showSuccessMessage = true
        
        // Hide message after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showSuccessMessage = false
            }
        }
    }
}

#Preview {
    ScreenshotPreparationView()
        .environmentObject(TimerManager())
}
