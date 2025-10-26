//
//  PrivacyPolicyView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 26/10/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTheme) var theme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Privacy Policy")
                        .font(theme.typography.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Mr. Pomodoro")
                        .font(theme.typography.title3)
                        .foregroundColor(theme.primaryColor)
                    
                    Text("Effective Date: October 26, 2025")
                        .font(theme.typography.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Last Updated: October 26, 2025")
                        .font(theme.typography.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)
                
                Divider()
                
                // Introduction
                PolicySection(
                    title: "Our Commitment to Privacy",
                    content: "Mr. Pomodoro is designed with privacy as a core principle. We believe your productivity data should remain yours, stored securely on your device with optional iCloud sync that you control."
                )
                
                // What We Collect
                VStack(alignment: .leading, spacing: 12) {
                    Text("What Data We Collect")
                        .font(theme.typography.title2)
                        .fontWeight(.bold)
                    
                    Text("Locally Stored Data")
                        .font(theme.typography.headline)
                        .foregroundColor(theme.primaryColor)
                    
                    Text("The app stores the following information **locally on your device only**:")
                        .font(theme.typography.body)
                    
                    BulletPoint(text: "Timer Settings: Your preferences for focus duration, break lengths, sound/haptic settings, and theme")
                    BulletPoint(text: "Session History: Records of completed Pomodoro sessions")
                    BulletPoint(text: "Statistics: Calculated metrics from your session history")
                    BulletPoint(text: "Focus Mode Settings: iOS Focus Mode integration preferences")
                    
                    Text("Optional iCloud Sync")
                        .font(theme.typography.headline)
                        .foregroundColor(theme.primaryColor)
                        .padding(.top, 8)
                    
                    Text("If you enable iCloud sync:")
                        .font(theme.typography.body)
                    
                    BulletPoint(text: "Data syncs to **your private iCloud account**")
                    BulletPoint(text: "We do not have access to your iCloud data")
                    BulletPoint(text: "Data is encrypted using Apple's security infrastructure")
                    BulletPoint(text: "You can disable sync at any time")
                }
                
                Divider()
                
                // What We DON'T Collect
                VStack(alignment: .leading, spacing: 12) {
                    Text("What We DO NOT Collect")
                        .font(theme.typography.title2)
                        .fontWeight(.bold)
                    
                    PrivacyFeature(icon: "nosign", text: "No Analytics or Tracking", color: .red)
                    PrivacyFeature(icon: "nosign", text: "No Third-Party Services", color: .red)
                    PrivacyFeature(icon: "nosign", text: "No Advertising", color: .red)
                    PrivacyFeature(icon: "nosign", text: "No Account Creation Required", color: .red)
                    PrivacyFeature(icon: "nosign", text: "No Network Requests (except iCloud)", color: .red)
                    PrivacyFeature(icon: "nosign", text: "No Location Data", color: .red)
                    PrivacyFeature(icon: "nosign", text: "No Contact Information", color: .red)
                    PrivacyFeature(icon: "nosign", text: "No Camera or Photos Access", color: .red)
                }
                
                Divider()
                
                // How Data is Used
                PolicySection(
                    title: "How Your Data Is Used",
                    content: "All data collected is used solely to:\n\n• Display your timer settings and preferences\n• Show your productivity statistics\n• Calculate streaks and performance metrics\n• Sync across your devices (if enabled)\n• Enable Siri Shortcuts integration"
                )
                
                Divider()
                
                // Data Security
                VStack(alignment: .leading, spacing: 12) {
                    Text("Data Storage & Security")
                        .font(theme.typography.title2)
                        .fontWeight(.bold)
                    
                    SecurityFeature(icon: "lock.shield.fill", title: "Local Storage", description: "Protected by iOS sandboxing and your device's security features")
                    SecurityFeature(icon: "icloud.fill", title: "iCloud Storage", description: "Encrypted using Apple's security protocols in your private iCloud account")
                    SecurityFeature(icon: "checkmark.shield.fill", title: "No Server Storage", description: "We do not store any data on our servers")
                }
                
                Divider()
                
                // Your Rights
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Rights & Control")
                        .font(theme.typography.title2)
                        .fontWeight(.bold)
                    
                    Text("You have complete control over your data:")
                        .font(theme.typography.body)
                    
                    ControlFeature(icon: "eye.fill", title: "Access", description: "View all settings and session history")
                    ControlFeature(icon: "pencil", title: "Modify", description: "Edit or update preferences anytime")
                    ControlFeature(icon: "trash.fill", title: "Delete", description: "Clear session history or reset all data")
                    ControlFeature(icon: "arrow.down.doc.fill", title: "Export", description: "View session data in Statistics screen")
                    ControlFeature(icon: "xmark.icloud.fill", title: "Opt-Out", description: "Disable iCloud sync at any time")
                }
                
                Divider()
                
                // Compliance
                VStack(alignment: .leading, spacing: 12) {
                    Text("Compliance")
                        .font(theme.typography.title2)
                        .fontWeight(.bold)
                    
                    ComplianceBadge(title: "GDPR", subtitle: "EU Privacy Rights", icon: "checkmark.seal.fill", color: .blue)
                    ComplianceBadge(title: "CCPA", subtitle: "California Privacy Rights", icon: "checkmark.seal.fill", color: .green)
                    ComplianceBadge(title: "Apple App Store", subtitle: "Privacy Guidelines", icon: "checkmark.seal.fill", color: .purple)
                }
                
                Divider()
                
                // Children's Privacy
                PolicySection(
                    title: "Children's Privacy",
                    content: "Pomodoro Timer is not directed at children under 13 years of age. We do not knowingly collect personal information from children."
                )
                
                Divider()
                
                // Contact
                VStack(alignment: .leading, spacing: 12) {
                    Text("Contact Us")
                        .font(theme.typography.title2)
                        .fontWeight(.bold)
                    
                    Text("If you have questions or concerns about this Privacy Policy:")
                        .font(theme.typography.body)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(theme.primaryColor)
                        Text("support@pomodorotimer.in")
                            .font(theme.typography.body)
                            .foregroundColor(theme.primaryColor)
                    }
                    .padding(.vertical, 8)
                    
                    Text("Response Time: We aim to respond within 48 hours")
                        .font(theme.typography.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Summary Box
                VStack(alignment: .leading, spacing: 12) {
                    Text("Summary")
                        .font(theme.typography.headline)
                        .fontWeight(.bold)
                    
                    SummaryItem(label: "What We Collect", value: "Timer settings and session history stored locally")
                    SummaryItem(label: "What We Don't Collect", value: "No analytics, no tracking, no personal information")
                    SummaryItem(label: "Your Control", value: "Full control to view, modify, and delete all data")
                    SummaryItem(label: "iCloud Sync", value: "Optional, stored in your private iCloud account")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(theme.cardBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.primaryColor.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                
                // Footer
                Text("This Privacy Policy reflects our commitment to protecting your privacy. If you have questions or need clarification, please don't hesitate to contact us.")
                    .font(theme.typography.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Privacy Policy")
    }
}

// MARK: - Supporting Views

struct PolicySection: View {
    let title: String
    let content: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(theme.typography.title2)
                .fontWeight(.bold)
            
            Text(content)
                .font(theme.typography.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct BulletPoint: View {
    let text: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(theme.typography.body)
                .foregroundColor(theme.primaryColor)
            
            Text(text)
                .font(theme.typography.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct PrivacyFeature: View {
    let icon: String
    let text: String
    let color: Color
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(text)
                .font(theme.typography.body)
        }
        .padding(.vertical, 4)
    }
}

struct SecurityFeature: View {
    let icon: String
    let title: String
    let description: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(theme.typography.title3)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(theme.typography.headline)
                
                Text(description)
                    .font(theme.typography.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ControlFeature: View {
    let icon: String
    let title: String
    let description: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(theme.primaryColor)
                .font(theme.typography.body)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(theme.typography.body)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(theme.typography.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ComplianceBadge: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(theme.typography.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(theme.typography.headline)
                    .fontWeight(.bold)
                
                Text(subtitle)
                    .font(theme.typography.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct SummaryItem: View {
    let label: String
    let value: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(theme.typography.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(theme.typography.body)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        PrivacyPolicyView()
            .appTheme(.classicRed)
    }
}
