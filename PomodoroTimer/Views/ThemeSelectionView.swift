//
//  ThemeSelectionView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 27/10/25.
//

import SwiftUI
import UIKit

struct ThemeSelectionView: View {
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.appTheme) var theme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(AppTheme.allThemes) { themeOption in
                    ThemeCard(
                        theme: themeOption,
                        isSelected: themeManager.currentTheme.id == themeOption.id,
                        onSelect: {
                            HapticManager.selection()
                            themeManager.applyTheme(themeOption)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .navigationTitle("App Theme")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Theme Card

struct ThemeCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 16) {
                // Color preview circles
                HStack(spacing: 8) {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 32, height: 32)
                    Circle()
                        .fill(theme.secondaryColor)
                        .frame(width: 32, height: 32)
                    Circle()
                        .fill(theme.accentColor)
                        .frame(width: 32, height: 32)
                }
                
                Text(theme.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? theme.primaryColor : .primary)
                    .lineLimit(1)
                
                if isSelected {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(theme.primaryColor)
                            .font(.system(size: 16, weight: .medium))
                        Text("Selected")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(theme.primaryColor)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: .black.opacity(0.05),
                        radius: 8,
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected ? theme.primaryColor : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(theme.name) theme")
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to select this theme")
    }
}

#Preview {
    NavigationView {
        ThemeSelectionView(themeManager: ThemeManager())
            .appTheme(.classicRed)
    }
}
