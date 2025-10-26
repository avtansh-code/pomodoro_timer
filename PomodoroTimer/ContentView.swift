//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager(settings: PersistenceManager.shared.loadSettings())
    @State private var showSettings = false
    @State private var showStatistics = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient based on session type
                LinearGradient(
                    gradient: Gradient(colors: [
                        sessionBackgroundColor.opacity(0.1),
                        Color(.systemBackground)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                MainTimerView(timerManager: timerManager)
                    .navigationTitle("Mr. Pomodoro")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                showStatistics = true
                            }) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title3)
                            }
                            .accessibilityLabel("View statistics")
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showSettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.title3)
                            }
                            .accessibilityLabel("Open settings")
                        }
                    }
            }
        }
        .preferredColorScheme(timerManager.settings.selectedTheme.colorScheme)
        .sheet(isPresented: $showSettings) {
            SettingsView(timerManager: timerManager)
                .preferredColorScheme(timerManager.settings.selectedTheme.colorScheme)
        }
        .sheet(isPresented: $showStatistics) {
            StatisticsView(timerManager: timerManager)
        }
        .onAppear {
            timerManager.requestNotificationPermission()
            setupIntentObservers()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private var sessionBackgroundColor: Color {
        switch timerManager.currentSessionType {
        case .focus:
            return .red
        case .shortBreak:
            return .green
        case .longBreak:
            return .blue
        }
    }
    
    private func setupIntentObservers() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ShowStatisticsFromIntent"),
            object: nil,
            queue: .main
        ) { _ in
            showStatistics = true
        }
    }
}

#Preview {
    ContentView()
}
