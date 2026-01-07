package avtanshgupta.PomodoroTimer.data.repository

import avtanshgupta.PomodoroTimer.data.local.database.SessionDao
import avtanshgupta.PomodoroTimer.data.local.database.entity.SessionEntity
import avtanshgupta.PomodoroTimer.domain.model.SessionType
import avtanshgupta.PomodoroTimer.domain.model.TimerSession
import avtanshgupta.PomodoroTimer.domain.repository.SessionRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Implementation of SessionRepository using Room database.
 * Maps to iOS PersistenceManager session functionality.
 */
@Singleton
class SessionRepositoryImpl @Inject constructor(
    private val sessionDao: SessionDao
) : SessionRepository {
    
    override suspend fun saveSession(session: TimerSession) {
        val entity = SessionEntity.fromDomainModel(session)
        sessionDao.insertSession(entity)
    }
    
    override fun getAllSessions(): Flow<List<TimerSession>> {
        // Use limited query to prevent OOM errors with large datasets
        return sessionDao.getRecentSessionsFlow(limit = 100).map { entities ->
            entities.map { it.toDomainModel() }
        }
    }
    
    override suspend fun getTodaySessions(): List<TimerSession> {
        val now = Instant.now()
        val startOfDay = LocalDate.now(ZoneId.systemDefault())
            .atStartOfDay(ZoneId.systemDefault())
            .toInstant()
        val endOfDay = startOfDay.plusSeconds(86400) // 24 hours
        
        return getSessionsInRange(startOfDay, endOfDay)
    }
    
    override suspend fun getWeeklySessions(): List<TimerSession> {
        val now = Instant.now()
        val oneWeekAgo = now.minusSeconds(7 * 86400) // 7 days
        
        return getSessionsInRange(oneWeekAgo, now)
    }
    
    override suspend fun getMonthlySessions(): List<TimerSession> {
        val now = Instant.now()
        val oneMonthAgo = now.minusSeconds(30 * 86400) // 30 days
        
        return getSessionsInRange(oneMonthAgo, now)
    }
    
    override suspend fun getSessionsInRange(start: Instant, end: Instant): List<TimerSession> {
        val entities = sessionDao.getSessionsInRange(start.epochSecond, end.epochSecond)
        return entities.map { it.toDomainModel() }
    }
    
    override suspend fun getSessionsByType(type: SessionType): List<TimerSession> {
        val entities = sessionDao.getSessionsByType(type.name)
        return entities.map { it.toDomainModel() }
    }
    
    override suspend fun getCurrentStreak(): Int {
        val distinctDays = sessionDao.getDistinctDays()
        if (distinctDays.isEmpty()) return 0
        
        // Get today's epoch day
        val todayEpochDay = Instant.now().epochSecond / 86400
        
        // Check if there's a session today or yesterday
        val mostRecentDay = distinctDays.first()
        if (mostRecentDay < todayEpochDay - 1) {
            // Last session was more than yesterday, streak is broken
            return 0
        }
        
        // Calculate streak by counting consecutive days
        var streak = 0
        var expectedDay = if (mostRecentDay == todayEpochDay) todayEpochDay else todayEpochDay - 1
        
        for (day in distinctDays) {
            if (day == expectedDay) {
                streak++
                expectedDay--
            } else if (day < expectedDay) {
                // Gap found, stop counting
                break
            }
        }
        
        return streak
    }
    
    override suspend fun getTotalFocusTime(): Long {
        return sessionDao.getTotalFocusTime() ?: 0L
    }
    
    override suspend fun getTotalCompletedSessions(): Int {
        return sessionDao.getTotalCompletedSessions()
    }
    
    override suspend fun clearAllSessions() {
        sessionDao.deleteAllSessions()
    }
    
    override suspend fun deleteSession(sessionId: String) {
        sessionDao.deleteSession(sessionId)
    }
    
    override suspend fun getSessionsGroupedByDate(days: Int): Map<String, List<TimerSession>> {
        val startTime = Instant.now().minusSeconds(days * 86400L).epochSecond
        val sessions = sessionDao.getRecentSessions(startTime).map { it.toDomainModel() }
        
        // Group sessions by date (YYYY-MM-DD format)
        return sessions.groupBy { session ->
            val instant = Instant.ofEpochSecond(session.completedAt)
            val zonedDateTime = instant.atZone(ZoneId.systemDefault())
            val date = zonedDateTime.toLocalDate()
            date.toString() // ISO format: YYYY-MM-DD
        }
    }
}
