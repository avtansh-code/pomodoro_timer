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
        ZStack {
            // Animated background gradient
            theme.focusGradient
                .opacity(0.12)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
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
        }
        .navigationTitle("App Theme")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Theme Card

struct ThemeCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Color preview circles
                HStack(spacing: 6) {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 28, height: 28)
                    Circle()
                        .fill(theme.secondaryColor)
                        .frame(width: 28, height: 28)
                    Circle()
                        .fill(theme.accentColor)
                        .frame(width: 28, height: 28)
                }
                
                // Theme name
                Text(theme.name)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                // Checkmark for selected theme
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.primaryColor)
                        .font(.system(size: 24, weight: .medium))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
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
                        isSelected ? theme.primaryColor : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
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
