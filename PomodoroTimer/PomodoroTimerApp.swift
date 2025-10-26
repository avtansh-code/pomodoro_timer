//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

@main
struct PomodoroTimerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var timerManager = TimerManager(settings: PersistenceManager.shared.loadSettings())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .background:
                timerManager.appDidEnterBackground()
                PersistenceManager.shared.saveSettings(timerManager.settings)
            case .active:
                timerManager.appWillEnterForeground()
                // Sync with iCloud when app becomes active
                PersistenceManager.shared.syncWithCloud {
                    print("iCloud sync completed")
                }
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
