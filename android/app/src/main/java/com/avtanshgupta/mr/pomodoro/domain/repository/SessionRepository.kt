package com.avtanshgupta.mr.pomodoro.domain.repository

import com.avtanshgupta.mr.pomodoro.domain.model.SessionType
import com.avtanshgupta.mr.pomodoro.domain.model.TimerSession
import kotlinx.coroutines.flow.Flow
import java.time.Instant

/**
 * Repository interface for managing timer sessions.
 * Maps to session-related functionality in iOS PersistenceManager.swift
 */
interface SessionRepository {
    
    /**
     * Save a completed session
     */
    suspend fun saveSession(session: TimerSession)
    
    /**
     * Get all sessions as a Flow (reactive)
     */
    fun getAllSessions(): Flow<List<TimerSession>>
    
    /**
     * Get sessions for today
     */
    suspend fun getTodaySessions(): List<TimerSession>
    
    /**
     * Get sessions for the past week
     */
    suspend fun getWeeklySessions(): List<TimerSession>
    
    /**
     * Get sessions for the past month
     */
    suspend fun getMonthlySessions(): List<TimerSession>
    
    /**
     * Get sessions within a date range
     */
    suspend fun getSessionsInRange(start: Instant, end: Instant): List<TimerSession>
    
    /**
     * Get sessions by type
     */
    suspend fun getSessionsByType(type: SessionType): List<TimerSession>
    
    /**
     * Get current streak (consecutive days with at least one completed session)
     */
    suspend fun getCurrentStreak(): Int
    
    /**
     * Get total focus time in seconds
     */
    suspend fun getTotalFocusTime(): Long
    
    /**
     * Get total number of completed sessions
     */
    suspend fun getTotalCompletedSessions(): Int
    
    /**
     * Clear all sessions
     */
    suspend fun clearAllSessions()
    
    /**
     * Delete a specific session by ID
     */
    suspend fun deleteSession(sessionId: String)
    
    /**
     * Delete a specific session (convenience method)
     */
    suspend fun deleteSession(session: TimerSession) {
        deleteSession(session.id)
    }
    
    /**
     * Delete all sessions
     */
    suspend fun deleteAllSessions() {
        clearAllSessions()
    }
    
    /**
     * Get sessions grouped by date (for charts/statistics)
     */
    suspend fun getSessionsGroupedByDate(days: Int): Map<String, List<TimerSession>>
}
