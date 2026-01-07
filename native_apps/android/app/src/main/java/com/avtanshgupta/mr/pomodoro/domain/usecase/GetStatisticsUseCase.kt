package avtanshgupta.PomodoroTimer.domain.usecase

import avtanshgupta.PomodoroTimer.domain.model.SessionType
import avtanshgupta.PomodoroTimer.domain.model.Statistics
import avtanshgupta.PomodoroTimer.domain.model.StatisticsPeriod
import avtanshgupta.PomodoroTimer.domain.model.TimerSession
import avtanshgupta.PomodoroTimer.domain.repository.SessionRepository
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
    suspend operator fun invoke(period: StatisticsPeriod): Statistics {
        val sessions = when (period) {
            StatisticsPeriod.TODAY -> sessionRepository.getTodaySessions()
            StatisticsPeriod.WEEK -> sessionRepository.getWeeklySessions()
            StatisticsPeriod.MONTH -> sessionRepository.getMonthlySessions()
            StatisticsPeriod.ALL_TIME -> sessionRepository.getAllSessions().let { flow ->
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
        
        val totalTime = sessions.sumOf { it.duration }
        val totalMinutes = (totalTime / 60).toInt()
        
        // Calculate total duration for each session type (using actual elapsed time)
        val focusDuration = focusSessions.sumOf { it.duration }
        val shortBreakDuration = shortBreakSessions.sumOf { it.duration }
        val longBreakDuration = longBreakSessions.sumOf { it.duration }
        
        val averageSessionDuration = if (sessions.isNotEmpty()) {
            totalTime.toDouble() / sessions.size / 60.0 // in minutes
        } else {
            0.0
        }
        
        return Statistics(
            totalSessions = totalSessions,
            focusSessionsCount = focusSessions.size,
            shortBreakSessionsCount = shortBreakSessions.size,
            longBreakSessionsCount = longBreakSessions.size,
            completedSessionsCount = completedSessions,
            skippedSessionsCount = skippedSessions,
            totalMinutes = totalMinutes,
            averageSessionMinutes = averageSessionDuration,
            focusDurationSeconds = focusDuration,
            shortBreakDurationSeconds = shortBreakDuration,
            longBreakDurationSeconds = longBreakDuration
        )
    }
}
