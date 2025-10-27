//
//  ContentView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager(settings: PersistenceManager.shared.loadSettings(), persistenceManager: PersistenceManager.shared)
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Timer Tab
            TimerTabView(timerManager: timerManager)
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(0)
            
            // Statistics Tab
            StatisticsTabView(timerManager: timerManager)
                .tabItem {
                    Label("Stats", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(1)
            
            // Settings Tab
            SettingsTabView(timerManager: timerManager, themeManager: themeManager)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                .tag(2)
        }
        .appTheme(themeManager.currentTheme)
        .preferredColorScheme(timerManager.settings.selectedTheme.colorScheme)
        .task {
            // Defer non-critical initializations
            await MainActor.run {
                timerManager.requestNotificationPermission()
                setupIntentObservers()
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func setupIntentObservers() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("ShowStatisticsFromIntent"),
            object: nil,
            queue: .main
        ) { _ in
            // Statistics tab is now always visible
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("SwitchToTimerTab"),
            object: nil,
            queue: .main
        ) { _ in
            selectedTab = 0
        }
    }
}

// MARK: - Timer Tab View

struct TimerTabView: View {
    @ObservedObject var timerManager: TimerManager
    @Environment(\.appTheme) var theme
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                theme.gradientFor(sessionType: timerManager.currentSessionType)
                    .opacity(0.08)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.6), value: timerManager.currentSessionType)
                
                MainTimerView(timerManager: timerManager)
            }
            .navigationTitle("Focus Timer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Statistics Tab View

struct StatisticsTabView: View {
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        NavigationView {
            StatisticsView(timerManager: timerManager)
        }
    }
}

// MARK: - Settings Tab View

struct SettingsTabView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            SettingsView(timerManager: timerManager, themeManager: themeManager)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
