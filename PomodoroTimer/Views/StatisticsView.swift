//
//  StatisticsView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI

struct StatisticsView: View {
    @ObservedObject var timerManager: TimerManager
    @Environment(\.dismiss) var dismiss
    
    @State private var todaySessions: [TimerSession] = []
    @State private var weeklySessions: [TimerSession] = []
    @State private var currentStreak: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Current Streak Card
                    StreakCard(streak: currentStreak)
                    
                    // Today's Stats
                    StatsSection(
                        title: "Today",
                        sessions: todaySessions,
                        icon: "calendar"
                    )
                    
                    // Weekly Stats
                    StatsSection(
                        title: "This Week",
                        sessions: weeklySessions,
                        icon: "calendar.badge.clock"
                    )
                    
                    // Motivational Quote
                    MotivationalQuoteCard()
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadStatistics()
            }
        }
    }
    
    private func loadStatistics() {
        todaySessions = PersistenceManager.shared.getTodaySessions()
        weeklySessions = PersistenceManager.shared.getWeeklySessions()
        currentStreak = PersistenceManager.shared.getCurrentStreak()
    }
}

struct StreakCard: View {
    let streak: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
                .accessibilityHidden(true)
            
            Text("\(streak)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(streak == 1 ? "Day Streak" : "Days Streak")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Current streak: \(streak) \(streak == 1 ? "day" : "days")")
    }
}

struct StatsSection: View {
    let title: String
    let sessions: [TimerSession]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .accessibilityElement(children: .combine)
            
            if sessions.isEmpty {
                Text("No sessions yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
            } else {
                VStack(spacing: 12) {
                    StatRow(
                        label: "Total Sessions",
                        value: "\(sessions.count)",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    
                    StatRow(
                        label: "Focus Sessions",
                        value: "\(focusSessionCount)",
                        icon: "brain.head.profile",
                        color: .red
                    )
                    
                    StatRow(
                        label: "Total Focus Time",
                        value: totalFocusTimeString,
                        icon: "clock.fill",
                        color: .blue
                    )
                    
                    StatRow(
                        label: "Break Time",
                        value: totalBreakTimeString,
                        icon: "cup.and.saucer.fill",
                        color: .green
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
            }
        }
    }
    
    private var focusSessionCount: Int {
        sessions.filter { $0.type == .focus }.count
    }
    
    private var totalFocusTime: TimeInterval {
        sessions.filter { $0.type == .focus }.reduce(0) { $0 + $1.duration }
    }
    
    private var totalBreakTime: TimeInterval {
        sessions.filter { $0.type != .focus }.reduce(0) { $0 + $1.duration }
    }
    
    private var totalFocusTimeString: String {
        formatDuration(totalFocusTime)
    }
    
    private var totalBreakTimeString: String {
        formatDuration(totalBreakTime)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(label)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

struct MotivationalQuoteCard: View {
    private let quotes = [
        "Stay focused and never give up! 🎯",
        "Small progress is still progress. 🌱",
        "You're doing amazing! Keep going! 💪",
        "Consistency is key to success. 🔑",
        "Every session brings you closer to your goals. ⭐",
        "Believe in yourself and all that you are. 🌟",
        "Focus on progress, not perfection. 📈",
        "You've got this! One session at a time. 🚀"
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundColor(.yellow)
            
            Text(quotes.randomElement() ?? quotes[0])
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.yellow.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    StatisticsView(timerManager: TimerManager())
}
