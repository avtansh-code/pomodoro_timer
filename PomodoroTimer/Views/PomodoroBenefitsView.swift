//
//  PomodoroBenefitsView.swift
//  PomodoroTimer
//
//  Educational view explaining the Pomodoro Technique
//

import SwiftUI

struct PomodoroBenefitsView: View {
    @Environment(\.appTheme) var theme
    @Environment(\.dismiss) var dismiss
    @State private var selectedSection: BenefitSection? = nil
    @State private var shouldDismissToTimer = false
    
    var body: some View {
        ZStack {
            // Animated background gradient
            theme.focusGradient
                .opacity(0.08)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header Section
                    headerSection
                    
                    // Introduction & History
                    historySection
                    
                    // How It Works
                    howItWorksSection
                    
                    // Benefits
                    benefitsSection
                    
                    // Considerations
                    considerationsSection
                    
                    // CTA Section
                    ctaSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            }
            .accessibilityIdentifier("BenefitsScrollView")
        }
        .navigationTitle("The Pomodoro Way")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // Empty - allows automatic back button
                EmptyView()
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Tomato icon
            ZStack {
                Circle()
                    .fill(theme.primaryColor.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "timer")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundColor(theme.primaryColor)
            }
            
            Text("The Power of Pomodoro")
                .font(theme.typography.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("The Power of Pomodoro")
                .accessibilityLabel("The Power of Pomodoro")
            
            Text("Focus deeper. Work smarter. Rest better.")
                .font(theme.typography.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }
    
    // MARK: - History Section
    
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(icon: "book.fill", title: "The Origin Story", color: theme.primaryColor)
            
            InfoCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Pomodoro Technique was created in the late 1980s by **Francesco Cirillo**, an Italian university student seeking a better way to study and manage his time.")
                        .font(theme.typography.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityLabel("The Pomodoro Technique was created in the late 1980s by Francesco Cirillo, an Italian university student seeking a better way to study and manage his time.")
                    
                    Text("Named after the tomato-shaped kitchen timer (*pomodoro* means \"tomato\" in Italian) he used to track his work intervals, this simple yet powerful method has since helped millions worldwide achieve better focus and productivity.")
                        .font(theme.typography.body)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.orange)
                        Text("Born from necessity, perfected through practice")
                            .font(theme.typography.callout)
                            .italic()
                    }
                    .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - How It Works Section
    
    private var howItWorksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(icon: "gearshape.fill", title: "How It Works", color: .blue)
            
            Text("The technique is simple, sustainable, and scientifically backed:")
                .font(theme.typography.callout)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                StepCard(
                    number: 1,
                    title: "Choose Your Task",
                    description: "Select a single task or project you want to focus on.",
                    icon: "checkmark.circle.fill",
                    color: theme.primaryColor
                )
                
                StepCard(
                    number: 2,
                    title: "Set the Timer",
                    description: "Start a 25-minute focus session (one \"pomodoro\").",
                    icon: "timer",
                    color: theme.primaryColor
                )
                
                StepCard(
                    number: 3,
                    title: "Work Without Distraction",
                    description: "Focus entirely on your task until the timer rings.",
                    icon: "brain.head.profile",
                    color: theme.primaryColor
                )
                
                StepCard(
                    number: 4,
                    title: "Take a Short Break",
                    description: "Rest for 5 minutes. Stretch, hydrate, or relax.",
                    icon: "cup.and.saucer.fill",
                    color: .green
                )
                
                StepCard(
                    number: 5,
                    title: "Repeat & Recharge",
                    description: "After 4 pomodoros, take a longer 15-30 minute break.",
                    icon: "arrow.clockwise.circle.fill",
                    color: .blue
                )
            }
        }
    }
    
    // MARK: - Benefits Section
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(icon: "star.fill", title: "Why It Works", color: .orange)
            
            Text("Research and millions of users have found these key benefits:")
                .font(theme.typography.callout)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                BenefitCard(
                    icon: "eye.fill",
                    title: "Enhanced Focus",
                    description: "Short, timed sessions help maintain deep concentration and prevent mental drift.",
                    color: theme.primaryColor
                )
                
                BenefitCard(
                    icon: "battery.100",
                    title: "Reduced Mental Fatigue",
                    description: "Regular breaks prevent burnout and keep your mind fresh throughout the day.",
                    color: .green
                )
                
                BenefitCard(
                    icon: "clock.badge.checkmark",
                    title: "Better Time Awareness",
                    description: "Learn to accurately estimate how long tasks take and plan more effectively.",
                    color: .blue
                )
                
                BenefitCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Increased Motivation",
                    description: "Small wins and completed sessions create positive momentum and build confidence.",
                    color: .purple
                )
                
                BenefitCard(
                    icon: "figure.walk",
                    title: "Sustainable Work Rhythm",
                    description: "Balance focused work with restorative breaks for long-term productivity.",
                    color: .cyan
                )
                
                BenefitCard(
                    icon: "hand.raised.fill",
                    title: "Distraction Management",
                    description: "The commitment to 25 minutes helps you defer interruptions and stay on track.",
                    color: .orange
                )
            }
        }
    }
    
    // MARK: - Considerations Section
    
    private var considerationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(icon: "exclamationmark.triangle.fill", title: "Things to Keep in Mind", color: .orange)
                .accessibilityAddTraits(.isHeader)
            
            InfoCard {
                VStack(alignment: .leading, spacing: 12) {
                    ConsiderationRow(
                        icon: "flowchart.fill",
                        text: "May interrupt deep creative flow states that benefit from longer unbroken periods."
                    )
                    
                    Divider()
                    
                    ConsiderationRow(
                        icon: "calendar.badge.clock",
                        text: "The rigid structure might not suit all task types or work environments."
                    )
                    
                    Divider()
                    
                    ConsiderationRow(
                        icon: "person.2.fill",
                        text: "Collaborative work may require flexibility with timing to accommodate others."
                    )
                    
                    Divider()
                    
                    ConsiderationRow(
                        icon: "slider.horizontal.3",
                        text: "Feel free to adjust session lengths to find what works best for you!"
                    )
                }
            }
            
            Text("The Pomodoro Technique is a tool, not a rule. Adapt it to your needs and workflow.")
                .font(theme.typography.footnote)
                .foregroundColor(.secondary)
                .italic()
                .padding(.horizontal, 4)
        }
    }
    
    // MARK: - CTA Section
    
    private var ctaSection: some View {
        VStack(spacing: 16) {
            Text("Ready to experience the benefits?")
                .font(theme.typography.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Button(action: {
                // Dismiss the view and post notification to switch to timer tab
                shouldDismissToTimer = true
                dismiss()
                // Post notification to switch to timer tab
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    NotificationCenter.default.post(name: NSNotification.Name("SwitchToTimerTab"), object: nil)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                    Text("Start Your First Pomodoro")
                        .fontWeight(.semibold)
                }
                .font(theme.typography.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: theme.primaryColor.opacity(0.3), radius: 8, y: 4)
            }
            .accessibilityIdentifier("Start Your First Pomodoro")
            .padding(.horizontal, 8)
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}

// MARK: - Supporting Views

struct SectionHeader: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
        }
    }
}

struct InfoCard<Content: View>: View {
    @Environment(\.appTheme) var theme
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}

struct StepCard: View {
    let number: Int
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Step number circle
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Text("\(number)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color)
                    
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
                
                Text(description)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

struct BenefitCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                
                Text(description)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

struct ConsiderationRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.orange)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

// MARK: - Supporting Types

enum BenefitSection: String, CaseIterable {
    case history = "History"
    case howItWorks = "How It Works"
    case benefits = "Benefits"
    case considerations = "Considerations"
}

// MARK: - Preview

#Preview {
    NavigationView {
        PomodoroBenefitsView()
            .appTheme(.classicRed)
    }
}
