//
//  HapticManager.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 28/10/25.
//

import UIKit

/// HapticManager provides centralized haptic feedback functionality.
/// Matches Android HapticManager behavior for consistent cross-platform tactile feedback.
///
/// Usage:
/// ```swift
/// // With settings check
/// HapticManager.shared.configure(isEnabled: settings.hapticEnabled)
/// HapticManager.shared.impact(style: .medium)
///
/// // Direct usage (bypasses settings)
/// HapticManager.impact(style: .medium, checkSettings: false)
/// ```
@MainActor
class HapticManager {
    static let shared = HapticManager()
    
    private var isEnabled: Bool = true
    
    private init() {}
    
    /// Configure whether haptic feedback is enabled globally
    /// - Parameter isEnabled: Whether haptic feedback should be active
    func configure(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    // MARK: - Instance Methods (with settings check)
    
    /// Light selection feedback - used for UI element selection, theme changes, etc.
    /// Equivalent to Android's HapticManager.selection()
    func selection() {
        guard isEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    /// Impact feedback with configurable intensity
    /// Equivalent to Android's HapticManager.lightImpact(), impact(), heavyImpact()
    /// - Parameter style: The intensity of the impact (light, medium, or heavy)
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// Light impact feedback - used for subtle interactions
    /// Equivalent to Android's HapticManager.lightImpact()
    func lightImpact() {
        impact(style: .light)
    }
    
    /// Medium impact feedback - used for button presses, toggle switches
    /// Equivalent to Android's HapticManager.impact()
    func mediumImpact() {
        impact(style: .medium)
    }
    
    /// Heavy impact feedback - used for important actions
    /// Equivalent to Android's HapticManager.heavyImpact()
    func heavyImpact() {
        impact(style: .heavy)
    }
    
    /// Notification feedback with configurable type
    /// Equivalent to Android's HapticManager.success(), warning(), error()
    /// - Parameter type: The type of notification (success, warning, or error)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// Success notification feedback - used for successful completions
    /// Equivalent to Android's HapticManager.success()
    func success() {
        notification(type: .success)
    }
    
    /// Warning notification feedback - used for warnings
    /// Equivalent to Android's HapticManager.warning()
    func warning() {
        notification(type: .warning)
    }
    
    /// Error notification feedback - used for errors or failures
    /// Equivalent to Android's HapticManager.error()
    func error() {
        notification(type: .error)
    }
    
    /// Timer completion feedback - special feedback for timer completions
    /// Equivalent to Android's HapticManager.timerComplete()
    /// Uses a distinctive pattern to signal timer end
    func timerComplete() {
        guard isEnabled else { return }
        // Use success notification for timer completion (feels satisfying)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    // MARK: - Static Methods (for backward compatibility and direct usage)
    
    /// Static impact method for direct usage
    /// - Parameters:
    ///   - style: The intensity of the impact
    ///   - checkSettings: Whether to check the global isEnabled setting (default: true)
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle, checkSettings: Bool = true) {
        if checkSettings {
            shared.impact(style: style)
        } else {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
    
    /// Static notification method for direct usage
    /// - Parameters:
    ///   - type: The type of notification
    ///   - checkSettings: Whether to check the global isEnabled setting (default: true)
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType, checkSettings: Bool = true) {
        if checkSettings {
            shared.notification(type: type)
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type)
        }
    }
    
    /// Static selection method for direct usage
    /// - Parameter checkSettings: Whether to check the global isEnabled setting (default: true)
    static func selection(checkSettings: Bool = true) {
        if checkSettings {
            shared.selection()
        } else {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
