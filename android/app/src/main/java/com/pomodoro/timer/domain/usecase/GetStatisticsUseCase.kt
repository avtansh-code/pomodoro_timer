package com.pomodoro.timer.domain.usecase

import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerSession
import com.pomodoro.timer.domain.repository.SessionRepository
import javax.inject.Inject

/**
 * Use case for retrieving and calculating session statistics.
 * Encapsulates business logic for statistics screen.
 */
class GetStatisticsUseCase @Inject constructor(
    private val sessionRepository: SessionRepository
) {
    
    /**
     * Get comprehensive statistics for a time period
     */
    suspend fun invoke(period: Period): Statistics {
        val sessions = when (period) {
            Period.TODAY -> sessionRepository.getTodaySessions()
            Period.WEEK -> sessionRepository.getWeeklySessions()
            Period.MONTH -> sessionRepository.getMonthlySessions()
            Period.ALL_TIME -> sessionRepository.getAllSessions().let { flow ->
                // Convert Flow to List for all-time stats
                val allSessions = mutableListOf<TimerSession>()
                flow.collect { allSessions.addAll(it) }
                allSessions
            }
        }
        
        return calculateStatistics(sessions)
    }
    
    /**
     * Get current streak
     */
    suspend fun getCurrentStreak(): Int {
        return sessionRepository.getCurrentStreak()
    }
    
    /**
     * Get sessions grouped by date for charts
     */
    suspend fun getSessionsGroupedByDate(days: Int): Map<String, List<TimerSession>> {
        return sessionRepository.getSessionsGroupedByDate(days)
    }
    
    private fun calculateStatistics(sessions: List<TimerSession>): Statistics {
        val totalSessions = sessions.size
        val completedSessions = sessions.count { it.wasCompleted }
        val skippedSessions = sessions.count { !it.wasCompleted }
        
        val focusSessions = sessions.filter { it.type == SessionType.FOCUS }
        val shortBreakSessions = sessions.filter { it.type == SessionType.SHORT_BREAK }
        val longBreakSessions = sessions.filter { it.type == SessionType.LONG_BREAK }
        
        val totalFocusTime = focusSessions.sumOf { it.duration }
        val totalBreakTime = (shortBreakSessions + longBreakSessions).sumOf { it.duration }
        val totalTime = sessions.sumOf { it.duration }
        
        val averageSessionDuration = if (sessions.isNotEmpty()) {
            totalTime / sessions.size
        } else {
            0L
        }
        
        return Statistics(
            totalSessions = totalSessions,
            completedSessions = completedSessions,
            skippedSessions = skippedSessions,
            focusSessionCount = focusSessions.size,
            shortBreakCount = shortBreakSessions.size,
            longBreakCount = longBreakSessions.size,
            totalFocusTime = totalFocusTime,
            totalBreakTime = totalBreakTime,
            totalTime = totalTime,
            averageSessionDuration = averageSessionDuration,
            completionRate = if (totalSessions > 0) {
                (completedSessions.toFloat() / totalSessions.toFloat()) * 100
            } else {
                0f
            }
        )
    }
    
    enum class Period {
        TODAY,
        WEEK,
        MONTH,
        ALL_TIME
    }
}

/**
 * Calculated statistics data class
 */
data class Statistics(
    val totalSessions: Int,
    val completedSessions: Int,
    val skippedSessions: Int,
    val focusSessionCount: Int,
    val shortBreakCount: Int,
    val longBreakCount: Int,
    val totalFocusTime: Long, // seconds
    val totalBreakTime: Long, // seconds
    val totalTime: Long, // seconds
    val averageSessionDuration: Long, // seconds
    val completionRate: Float // percentage (0-100)
) {
    val totalFocusTimeMinutes: Int
        get() = (totalFocusTime / 60).toInt()
    
    val totalFocusTimeHours: Float
        get() = totalFocusTime / 3600f
    
    val totalBreakTimeMinutes: Int
        get() = (totalBreakTime / 60).toInt()
    
    val averageSessionMinutes: Int
        get() = (averageSessionDuration / 60).toInt()
}
