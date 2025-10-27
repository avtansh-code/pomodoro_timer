//
//  AppTheme.swift
//  PomodoroTimer
//
//  Theme system for consistent UI styling across the app
//

import SwiftUI

/// Represents a complete visual theme for the app
struct AppTheme: Identifiable {
    let id: String
    let name: String
    let primaryColor: Color
    let secondaryColor: Color
    let accentColor: Color
    let focusGradient: LinearGradient
    let shortBreakGradient: LinearGradient
    let longBreakGradient: LinearGradient
    let cardBackground: Color
    let typography: Typography
    
    struct Typography {
        let largeTitle: Font
        let title: Font
        let title2: Font
        let title3: Font
        let headline: Font
        let body: Font
        let callout: Font
        let subheadline: Font
        let footnote: Font
        let caption: Font
        let timerFont: Font
        
        static let `default` = Typography(
            largeTitle: .system(size: 34, weight: .bold, design: .rounded),
            title: .system(size: 28, weight: .bold, design: .rounded),
            title2: .system(size: 22, weight: .bold, design: .rounded),
            title3: .system(size: 20, weight: .semibold, design: .rounded),
            headline: .system(size: 17, weight: .semibold, design: .rounded),
            body: .system(size: 17, weight: .regular, design: .rounded),
            callout: .system(size: 16, weight: .regular, design: .rounded),
            subheadline: .system(size: 15, weight: .regular, design: .rounded),
            footnote: .system(size: 13, weight: .regular, design: .rounded),
            caption: .system(size: 12, weight: .regular, design: .rounded),
            timerFont: .system(size: 64, weight: .thin, design: .rounded)
        )
    }
    
    // MARK: - Predefined Themes
    
    static let classicRed = AppTheme(
        id: "classic_red",
        name: "Classic Red",
        primaryColor: Color(red: 0.93, green: 0.26, blue: 0.26), // #ED4242
        secondaryColor: Color(red: 0.98, green: 0.45, blue: 0.26), // #FA7343
        accentColor: Color(red: 0.93, green: 0.26, blue: 0.26),
        focusGradient: LinearGradient(
            colors: [
                Color(red: 0.93, green: 0.26, blue: 0.26),
                Color(red: 0.98, green: 0.45, blue: 0.26)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        shortBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.20, green: 0.78, blue: 0.35),
                Color(red: 0.16, green: 0.65, blue: 0.60)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        longBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.35, green: 0.34, blue: 0.84),
                Color(red: 0.20, green: 0.67, blue: 0.86)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: Color(.systemGray6),
        typography: .default
    )
    
    static let oceanBlue = AppTheme(
        id: "ocean_blue",
        name: "Ocean Blue",
        primaryColor: Color(red: 0.20, green: 0.60, blue: 0.86), // #3399DB
        secondaryColor: Color(red: 0.20, green: 0.80, blue: 0.93), // #33CCED
        accentColor: Color(red: 0.20, green: 0.60, blue: 0.86),
        focusGradient: LinearGradient(
            colors: [
                Color(red: 0.20, green: 0.60, blue: 0.86),
                Color(red: 0.20, green: 0.80, blue: 0.93)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        shortBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.40, green: 0.85, blue: 0.92),
                Color(red: 0.60, green: 0.93, blue: 0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        longBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.15, green: 0.45, blue: 0.70),
                Color(red: 0.30, green: 0.65, blue: 0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: Color(.systemGray6),
        typography: .default
    )
    
    static let forestGreen = AppTheme(
        id: "forest_green",
        name: "Forest Green",
        primaryColor: Color(red: 0.20, green: 0.60, blue: 0.40), // #339966
        secondaryColor: Color(red: 0.30, green: 0.78, blue: 0.52), // #4DC785
        accentColor: Color(red: 0.20, green: 0.60, blue: 0.40),
        focusGradient: LinearGradient(
            colors: [
                Color(red: 0.20, green: 0.60, blue: 0.40),
                Color(red: 0.30, green: 0.78, blue: 0.52)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        shortBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.50, green: 0.82, blue: 0.65),
                Color(red: 0.65, green: 0.90, blue: 0.70)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        longBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.15, green: 0.45, blue: 0.30),
                Color(red: 0.25, green: 0.60, blue: 0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: Color(.systemGray6),
        typography: .default
    )
    
    static let midnightDark = AppTheme(
        id: "midnight_dark",
        name: "Midnight Dark",
        primaryColor: Color(red: 0.45, green: 0.42, blue: 0.76), // #736BC2
        secondaryColor: Color(red: 0.60, green: 0.55, blue: 0.85), // #998CD9
        accentColor: Color(red: 0.45, green: 0.42, blue: 0.76),
        focusGradient: LinearGradient(
            colors: [
                Color(red: 0.45, green: 0.42, blue: 0.76),
                Color(red: 0.60, green: 0.55, blue: 0.85)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        shortBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.35, green: 0.70, blue: 0.75),
                Color(red: 0.50, green: 0.80, blue: 0.82)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        longBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.30, green: 0.28, blue: 0.55),
                Color(red: 0.45, green: 0.42, blue: 0.70)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: Color(.systemGray6),
        typography: .default
    )
    
    static let sunsetOrange = AppTheme(
        id: "sunset_orange",
        name: "Sunset Orange",
        primaryColor: Color(red: 0.98, green: 0.50, blue: 0.20), // #FA8033
        secondaryColor: Color(red: 1.00, green: 0.65, blue: 0.30), // #FFA64D
        accentColor: Color(red: 0.98, green: 0.50, blue: 0.20),
        focusGradient: LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.50, blue: 0.20),
                Color(red: 1.00, green: 0.65, blue: 0.30)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        shortBreakGradient: LinearGradient(
            colors: [
                Color(red: 1.00, green: 0.75, blue: 0.40),
                Color(red: 1.00, green: 0.85, blue: 0.60)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        longBreakGradient: LinearGradient(
            colors: [
                Color(red: 0.85, green: 0.40, blue: 0.15),
                Color(red: 0.95, green: 0.55, blue: 0.25)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        cardBackground: Color(.systemGray6),
        typography: .default
    )
    
    static let allThemes: [AppTheme] = [
        .classicRed,
        .oceanBlue,
        .forestGreen,
        .midnightDark,
        .sunsetOrange
    ]
    
    // MARK: - Helper Methods
    
    func gradientFor(sessionType: SessionType) -> LinearGradient {
        switch sessionType {
        case .focus:
            return focusGradient
        case .shortBreak:
            return shortBreakGradient
        case .longBreak:
            return longBreakGradient
        }
    }
    
    func colorFor(sessionType: SessionType) -> Color {
        switch sessionType {
        case .focus:
            return primaryColor
        case .shortBreak:
            return Color(red: 0.20, green: 0.78, blue: 0.35) // Green
        case .longBreak:
            return Color(red: 0.35, green: 0.34, blue: 0.84) // Blue
        }
    }
}

// MARK: - Environment Key

struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .forestGreen
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    func appTheme(_ theme: AppTheme) -> some View {
        environment(\.appTheme, theme)
    }
}
