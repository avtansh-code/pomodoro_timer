package com.pomodoro.timer.domain.model

/**
 * Statistics data for a specific time period
 */
data class Statistics(
    val totalSessions: Int = 0,
    val focusSessionsCount: Int = 0,
    val shortBreakSessionsCount: Int = 0,
    val longBreakSessionsCount: Int = 0,
    val completedSessionsCount: Int = 0,
    val skippedSessionsCount: Int = 0,
    val totalMinutes: Int = 0,
    val averageSessionMinutes: Double = 0.0
)
