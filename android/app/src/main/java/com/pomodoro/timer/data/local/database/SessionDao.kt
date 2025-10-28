package com.pomodoro.timer.data.local.database

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.pomodoro.timer.data.local.database.entity.SessionEntity
import kotlinx.coroutines.flow.Flow

/**
 * Data Access Object for timer sessions.
 * Provides methods to interact with the sessions table.
 */
@Dao
interface SessionDao {
    
    /**
     * Insert a new session
     */
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSession(session: SessionEntity)
    
    /**
     * Get all sessions ordered by completion time (newest first)
     */
    @Query("SELECT * FROM sessions ORDER BY completedAt DESC")
    fun getAllSessions(): Flow<List<SessionEntity>>
    
    /**
     * Get all sessions as a list (one-time read)
     */
    @Query("SELECT * FROM sessions ORDER BY completedAt DESC")
    suspend fun getAllSessionsList(): List<SessionEntity>
    
    /**
     * Get sessions within a date range
     */
    @Query("SELECT * FROM sessions WHERE completedAt >= :startTime AND completedAt <= :endTime ORDER BY completedAt DESC")
    suspend fun getSessionsInRange(startTime: Long, endTime: Long): List<SessionEntity>
    
    /**
     * Get sessions by type
     */
    @Query("SELECT * FROM sessions WHERE type = :type ORDER BY completedAt DESC")
    suspend fun getSessionsByType(type: String): List<SessionEntity>
    
    /**
     * Get total focus time (sum of all focus session durations)
     */
    @Query("SELECT SUM(duration) FROM sessions WHERE type = 'FOCUS'")
    suspend fun getTotalFocusTime(): Long?
    
    /**
     * Get total completed sessions count
     */
    @Query("SELECT COUNT(*) FROM sessions WHERE wasCompleted = 1")
    suspend fun getTotalCompletedSessions(): Int
    
    /**
     * Get sessions for a specific day (start and end timestamps)
     */
    @Query("SELECT * FROM sessions WHERE completedAt >= :dayStart AND completedAt < :dayEnd ORDER BY completedAt DESC")
    suspend fun getSessionsForDay(dayStart: Long, dayEnd: Long): List<SessionEntity>
    
    /**
     * Get distinct dates that have sessions (for streak calculation)
     * Returns epoch days (completedAt / 86400)
     */
    @Query("SELECT DISTINCT(completedAt / 86400) as day FROM sessions ORDER BY day DESC")
    suspend fun getDistinctDays(): List<Long>
    
    /**
     * Delete a specific session
     */
    @Query("DELETE FROM sessions WHERE id = :sessionId")
    suspend fun deleteSession(sessionId: String)
    
    /**
     * Delete all sessions
     */
    @Query("DELETE FROM sessions")
    suspend fun deleteAllSessions()
    
    /**
     * Get session count
     */
    @Query("SELECT COUNT(*) FROM sessions")
    suspend fun getSessionCount(): Int
    
    /**
     * Get sessions grouped by date for statistics
     * Returns sessions for the last N days
     */
    @Query("""
        SELECT * FROM sessions 
        WHERE completedAt >= :startTime 
        ORDER BY completedAt DESC
    """)
    suspend fun getRecentSessions(startTime: Long): List<SessionEntity>
}
