//
//  StatisticsView.swift
//  PomodoroTimer
//
//  Created by Avtansh Gupta on 04/10/25.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var timerManager: TimerManager
    @Environment(\.appTheme) var theme
    
    @State private var todaySessions: [TimerSession] = []
    @State private var weeklySessions: [TimerSession] = []
    @State private var monthlySessions: [TimerSession] = []
    @State private var allSessions: [TimerSession] = []
    @State private var currentStreak: Int = 0
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated background gradient
                theme.focusGradient
                    .opacity(0.12)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                    // Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Current Streak Card
                    StreakCard(streak: currentStreak)
                    
                    // Weekly Sessions Chart
                    if #available(iOS 16.0, *) {
                        WeeklySessionsChart(sessions: currentSessions)
                    }
                    
                    // Focus Time Trend Chart
                    if #available(iOS 16.0, *) {
                        FocusTimeTrendChart(sessions: currentSessions)
                    }
                    
                    // Session Type Distribution
                    if #available(iOS 16.0, *) {
                        SessionTypeDistributionChart(sessions: currentSessions)
                    }
                    
                    // Today's Stats
                    StatsSection(
                        title: "Today",
                        sessions: todaySessions,
                        icon: "calendar"
                    )
                    
                    // Summary Stats based on selected range
                    StatsSection(
                        title: selectedTimeRange.rawValue,
                        sessions: currentSessions,
                        icon: "calendar.badge.clock"
                    )
                    
                    // Motivational Quote
                    MotivationalQuoteCard()
                    }
                    .padding()
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadStatistics()
            }
            .onChange(of: selectedTimeRange) { oldValue, newValue in
                // Stats will update automatically through computed property
            }
        }
    }
    
    private var currentSessions: [TimerSession] {
        switch selectedTimeRange {
        case .week:
            return weeklySessions
        case .month:
            return monthlySessions
        case .all:
            return allSessions
        }
    }
    
    private func loadStatistics() {
        todaySessions = PersistenceManager.shared.getTodaySessions()
        weeklySessions = PersistenceManager.shared.getWeeklySessions()
        monthlySessions = PersistenceManager.shared.getMonthlySessions()
        allSessions = PersistenceManager.shared.getAllSessions()
        currentStreak = PersistenceManager.shared.getCurrentStreak()
    }
}

// MARK: - Weekly Sessions Chart

@available(iOS 16.0, *)
struct WeeklySessionsChart: View {
    let sessions: [TimerSession]
    @Environment(\.appTheme) var theme
    
    private var dailyData: [(day: String, count: Int)] {
        let calendar = Calendar.current
        let today = Date()
        var data: [(String, Int)] = []
        
        // Get last 7 days
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            let sessionsOnDay = sessions.filter { calendar.isDate($0.completedAt, inSameDayAs: date) }.count
            data.append((dayName, sessionsOnDay))
        }
        
        return data.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(theme.primaryColor)
                Text("Sessions per Day")
                    .font(theme.typography.title2)
                    .fontWeight(.bold)
            }
            
            Chart(dailyData, id: \.day) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Sessions", item.count)
                )
                .foregroundStyle(theme.primaryColor.gradient)
                .cornerRadius(8)
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.cardBackground)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Bar chart showing sessions per day for the past week")
    }
}

// MARK: - Focus Time Trend Chart

@available(iOS 16.0, *)
struct FocusTimeTrendChart: View {
    let sessions: [TimerSession]
    @Environment(\.appTheme) var theme
    
    private var trendData: [(date: Date, minutes: Double)] {
        let calendar = Calendar.current
        let today = Date()
        var data: [(Date, Double)] = []
        
        // Get last 7 days
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let focusTime = sessions
                .filter { $0.type == .focus && calendar.isDate($0.completedAt, inSameDayAs: date) }
                .reduce(0.0) { $0 + $1.duration }
            data.append((date, focusTime / 60.0)) // Convert to minutes
        }
        
        return data.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(theme.primaryColor)
                Text("Focus Time Trend")
                    .font(theme.typography.title2)
                    .fontWeight(.bold)
            }
            
            if trendData.allSatisfy({ $0.minutes == 0 }) {
                Text("No focus sessions yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 80)
            } else {
                Chart(trendData, id: \.date) { item in
                    LineMark(
                        x: .value("Date", item.date, unit: .day),
                        y: .value("Minutes", item.minutes)
                    )
                    .foregroundStyle(theme.primaryColor.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", item.date, unit: .day),
                        y: .value("Minutes", item.minutes)
                    )
                    .foregroundStyle(theme.primaryColor.opacity(0.2).gradient)
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let minutes = value.as(Double.self) {
                                Text("\(Int(minutes))m")
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                Text(date, format: .dateTime.weekday(.abbreviated))
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.cardBackground)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Line chart showing focus time trend over the past week")
    }
}

// MARK: - Session Type Distribution Chart

@available(iOS 16.0, *)
struct SessionTypeDistributionChart: View {
    let sessions: [TimerSession]
    @Environment(\.appTheme) var theme
    
    private var distributionData: [(type: String, count: Int, color: Color)] {
        let focusCount = sessions.filter { $0.type == .focus }.count
        let shortBreakCount = sessions.filter { $0.type == .shortBreak }.count
        let longBreakCount = sessions.filter { $0.type == .longBreak }.count
        
        return [
            ("Focus", focusCount, theme.primaryColor),
            ("Short Break", shortBreakCount, Color(red: 0.20, green: 0.78, blue: 0.35)),
            ("Long Break", longBreakCount, Color(red: 0.35, green: 0.34, blue: 0.84))
        ].filter { $0.count > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(theme.accentColor)
                Text("Session Distribution")
                    .font(theme.typography.title2)
                    .fontWeight(.bold)
            }
            
            if distributionData.isEmpty {
                Text("No sessions yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 80)
            } else {
                HStack(spacing: 20) {
                    // Pie Chart
                    Chart(distributionData, id: \.type) { item in
                        SectorMark(
                            angle: .value("Count", item.count),
                            innerRadius: .ratio(0.5),
                            angularInset: 2
                        )
                        .foregroundStyle(item.color.gradient)
                        .cornerRadius(4)
                    }
                    .frame(width: 120, height: 120)
                    
                    // Legend
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(distributionData, id: \.type) { item in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(item.color)
                                    .frame(width: 12, height: 12)
                                
                                Text(item.type)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Text("\(item.count)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.cardBackground)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Pie chart showing distribution of session types")
    }
}

// MARK: - Supporting Views

struct StreakCard: View {
    let streak: Int
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
                .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                .accessibilityHidden(true)
            
            Text("\(streak)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(streak == 1 ? "Day Streak" : "Days Streak")
                .font(theme.typography.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.orange.opacity(0.15),
                            Color.orange.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.orange.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.orange.opacity(0.1), radius: 10, x: 0, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Current streak: \(streak) \(streak == 1 ? "day" : "days")")
    }
}

struct StatsSection: View {
    let title: String
    let sessions: [TimerSession]
    let icon: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(theme.accentColor)
                Text(title)
                    .font(theme.typography.title2)
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
                        color: Color(red: 0.20, green: 0.78, blue: 0.35)
                    )
                    
                    StatRow(
                        label: "Focus Sessions",
                        value: "\(focusSessionCount)",
                        icon: "brain.head.profile",
                        color: theme.primaryColor
                    )
                    
                    StatRow(
                        label: "Total Focus Time",
                        value: totalFocusTimeString,
                        icon: "clock.fill",
                        color: theme.accentColor
                    )
                    
                    StatRow(
                        label: "Break Time",
                        value: totalBreakTimeString,
                        icon: "cup.and.saucer.fill",
                        color: Color(red: 0.20, green: 0.78, blue: 0.35)
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(theme.cardBackground)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
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
    @Environment(\.appTheme) var theme
    
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
                .font(theme.typography.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.yellow.opacity(0.15),
                            Color.yellow.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.yellow.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.yellow.opacity(0.1), radius: 8, x: 0, y: 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationView {
        StatisticsView(timerManager: TimerManager())
            .appTheme(.classicRed)
    }
}
