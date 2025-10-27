//
//  ThemeManager.swift
//  PomodoroTimer
//
//  Manages theme selection and persistence
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    @AppStorage("selectedThemeId") private var selectedThemeId: String = "forest_green"
    
    init() {
        // Initialize with default first
        self.currentTheme = .forestGreen
        
        // Then load saved theme if available
        if let theme = AppTheme.allThemes.first(where: { $0.id == self.selectedThemeId }) {
            self.currentTheme = theme
        }
    }
    
    /// Apply a new theme
    func applyTheme(_ theme: AppTheme) {
        withAnimation(.easeInOut(duration: 0.4)) {
            currentTheme = theme
            selectedThemeId = theme.id
        }
    }
    
    /// Get theme by ID
    func theme(forId id: String) -> AppTheme? {
        AppTheme.allThemes.first(where: { $0.id == id })
    }
    
    /// Get all available themes
    var availableThemes: [AppTheme] {
        AppTheme.allThemes
    }
}
