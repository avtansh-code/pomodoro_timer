//
//  PomodoroWidgetBundle.swift
//  PomodoroWidget
//
//  Created by Avtansh Gupta on 26/10/25.
//

import WidgetKit
import SwiftUI

@main
struct PomodoroWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Home Screen Widgets
        PomodoroWidget()
        
        // Lock Screen Widgets (iOS 16+)
        if #available(iOS 16.0, *) {
            PomodoroLockScreenWidget()
        }
        
        // Live Activities (iOS 16.2+)
        if #available(iOS 16.2, *) {
            PomodoroTimerLiveActivity()
        }
        
        // Control Widgets (iOS 18+)
        if #available(iOS 18.0, *) {
            PomodoroWidgetControl()
            StartButtonControl()
            PauseButtonControl()
            ResetButtonControl()
        }
    }
}
