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
        PomodoroWidget()
        if #available(iOS 16.0, *) {
            PomodoroLockScreenWidget()
        }
    }
}
