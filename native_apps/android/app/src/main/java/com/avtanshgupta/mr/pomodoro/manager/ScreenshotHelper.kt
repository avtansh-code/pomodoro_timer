package com.avtanshgupta.mr.pomodoro.manager

import com.avtanshgupta.mr.pomodoro.domain.model.SessionType
import com.avtanshgupta.mr.pomodoro.domain.model.TimerSession
import com.avtanshgupta.mr.pomodoro.domain.repository.SessionRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.temporal.ChronoUnit
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.random.Random

/**
 * Screenshot Helper - Developer tool for preparing app screenshots
 * 
 * Maps to iOS ScreenshotHelper.swift
 * 
 * Provides:
 * - Generate dummy session data for realistic screenshots
 * - Populate statistics with 60 days of session history
 * - Create varied session patterns (3-8 sessions per day)
 * - Cleanup functionality to remove test data
 */
@Singleton
class ScreenshotHelper @Inject constructor(
    private val sessionRepository: SessionRepository
) {
    
    /**
     * Generate comprehensive dummy statistics data
     * Creates 60 days of realistic session history
     */
    suspend fun generateDummyStatistics() = withContext(Dispatchers.IO) {
        val sessions = mutableListOf<TimerSession>()
        val today = LocalDate.now()
        
        // Generate 60 days of session data
        for (daysAgo in 0 until 60) {
            val date = today.minusDays(daysAgo.toLong())
            val sessionsForDay = generateSessionsForDay(date)
            sessions.addAll(sessionsForDay)
        }
        
        // Save all sessions to database
        sessions.forEach { session ->
            sessionRepository.saveSession(session)
        }
    }
    
    /**
     * Generate realistic sessions for a specific day
     * Creates 3-8 sessions with varied completion rates
     */
    private fun generateSessionsForDay(date: LocalDate): List<TimerSession> {
        val sessions = mutableListOf<TimerSession>()
        val sessionCount = Random.nextInt(3, 9) // 3-8 sessions per day
        
        // Start time around 9 AM
        var currentHour = 9
        var currentMinute = Random.nextInt(0, 30)
        
        repeat(sessionCount) { index ->
            // Determine session type (mostly focus sessions)
            val sessionType = when {
                index % 4 == 3 -> SessionType.LONG_BREAK
                index % 2 == 1 -> SessionType.SHORT_BREAK
                else -> SessionType.FOCUS
            }
            
            // Session duration based on type
            val duration = when (sessionType) {
                SessionType.FOCUS -> 25 * 60L // 25 minutes
                SessionType.SHORT_BREAK -> 5 * 60L // 5 minutes
                SessionType.LONG_BREAK -> 15 * 60L // 15 minutes
            }
            
            // Most sessions are completed (90% completion rate)
            val isCompleted = Random.nextDouble() < 0.9
            
            // Create timestamp for this session (in seconds, not milliseconds)
            val startTime = date.atTime(currentHour, currentMinute)
                .atZone(ZoneId.systemDefault())
                .toInstant()
                .epochSecond
            
            val session = TimerSession(
                id = java.util.UUID.randomUUID().toString(),
                type = sessionType,
                completedAt = startTime,
                duration = duration,
                wasCompleted = isCompleted
            )
            
            sessions.add(session)
            
            // Advance time for next session (add duration + break)
            val minutesToAdd = (duration / 60).toInt() + Random.nextInt(5, 20)
            currentMinute += minutesToAdd
            
            if (currentMinute >= 60) {
                currentHour += currentMinute / 60
                currentMinute %= 60
            }
            
            // Stop if we've reached evening (8 PM)
            if (currentHour >= 20) {
                return sessions
            }
        }
        
        return sessions
    }
    
    /**
     * Generate dummy data optimized for week view screenshots
     * Creates data for the current week with high session counts
     */
    suspend fun generateWeekViewData() = withContext(Dispatchers.IO) {
        val sessions = mutableListOf<TimerSession>()
        val today = LocalDate.now()
        
        // Generate data for last 7 days
        for (daysAgo in 0 until 7) {
            val date = today.minusDays(daysAgo.toLong())
            val sessionsForDay = generateSessionsForDay(date)
            sessions.addAll(sessionsForDay)
        }
        
        sessions.forEach { session ->
            sessionRepository.saveSession(session)
        }
    }
    
    /**
     * Generate dummy data optimized for month view screenshots
     * Creates data for the current month with consistent patterns
     */
    suspend fun generateMonthViewData() = withContext(Dispatchers.IO) {
        val sessions = mutableListOf<TimerSession>()
        val today = LocalDate.now()
        val startOfMonth = today.withDayOfMonth(1)
        val daysInMonth = today.lengthOfMonth()
        
        // Generate data for entire current month
        for (day in 1..daysInMonth) {
            val date = startOfMonth.withDayOfMonth(day)
            if (date.isAfter(today)) break
            
            val sessionsForDay = generateSessionsForDay(date)
            sessions.addAll(sessionsForDay)
        }
        
        sessions.forEach { session ->
            sessionRepository.saveSession(session)
        }
    }
    
    /**
     * Generate sessions for "in progress" timer screenshot
     * Creates a focus session that appears to be in progress
     * 
     * @param progressPercentage How far along the session should appear (0.0 to 1.0)
     */
    suspend fun generateInProgressSession(progressPercentage: Float = 0.5f) = withContext(Dispatchers.IO) {
        val duration = 25 * 60L // 25 minutes
        val elapsed = (duration * progressPercentage).toLong()
        
        val startTime = Instant.now()
            .minus(elapsed, ChronoUnit.SECONDS)
            .epochSecond
        
        val session = TimerSession(
            id = java.util.UUID.randomUUID().toString(),
            type = SessionType.FOCUS,
            completedAt = startTime,
            duration = duration,
            wasCompleted = false
        )
        
        sessionRepository.saveSession(session)
    }
    
    /**
     * Generate sessions for break mode screenshot
     * Creates a short break session in progress
     */
    suspend fun generateBreakSession() = withContext(Dispatchers.IO) {
        val duration = 5 * 60L // 5 minutes
        val elapsed = duration / 2 // 50% complete
        
        val startTime = Instant.now()
            .minus(elapsed, ChronoUnit.SECONDS)
            .epochSecond
        
        val session = TimerSession(
            id = java.util.UUID.randomUUID().toString(),
            type = SessionType.SHORT_BREAK,
            completedAt = startTime,
            duration = duration,
            wasCompleted = false
        )
        
        sessionRepository.saveSession(session)
    }
    
    /**
     * Clear all session data
     * Use this to cleanup test data after taking screenshots
     */
    suspend fun clearAllSessions() = withContext(Dispatchers.IO) {
        sessionRepository.clearAllSessions()
    }
    
    /**
     * Clear only sessions from the last N days
     * Useful for partial cleanup
     */
    suspend fun clearRecentSessions(days: Int = 7) = withContext(Dispatchers.IO) {
        val cutoffDate = LocalDate.now()
            .minusDays(days.toLong())
            .atStartOfDay(ZoneId.systemDefault())
            .toInstant()
            .epochSecond
        
        // Note: This requires a new repository method
        // For now, we'll clear all sessions
        sessionRepository.clearAllSessions()
    }
    
    /**
     * Get session count
     * Useful for verifying data generation
     */
    suspend fun getSessionCount(): Int = withContext(Dispatchers.IO) {
        // This would need a count method in repository
        // For now, return -1 as placeholder
        -1
    }
    
    companion object {
        private const val TAG = "ScreenshotHelper"
        
        // Screenshot scenarios
        const val SCENARIO_FOCUS_IN_PROGRESS = "focus_in_progress"
        const val SCENARIO_BREAK_MODE = "break_mode"
        const val SCENARIO_WEEK_STATS = "week_stats"
        const val SCENARIO_MONTH_STATS = "month_stats"
        const val SCENARIO_FULL_STATS = "full_stats"
    }
}
