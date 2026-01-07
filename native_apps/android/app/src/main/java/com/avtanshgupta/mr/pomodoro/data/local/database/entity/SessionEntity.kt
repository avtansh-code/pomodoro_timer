package avtanshgupta.PomodoroTimer.data.local.database.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import avtanshgupta.PomodoroTimer.domain.model.SessionType
import avtanshgupta.PomodoroTimer.domain.model.TimerSession

/**
 * Room database entity for storing timer sessions.
 * Maps domain model TimerSession to database representation.
 */
@Entity(tableName = "sessions")
data class SessionEntity(
    @PrimaryKey
    val id: String,
    val type: String, // Stored as string for simplicity
    val duration: Long, // Duration in seconds
    val completedAt: Long, // Unix timestamp (epoch seconds)
    val wasCompleted: Boolean
) {
    /**
     * Convert database entity to domain model
     */
    fun toDomainModel(): TimerSession {
        return TimerSession(
            id = id,
            type = SessionType.valueOf(type),
            duration = duration,
            completedAt = completedAt,
            wasCompleted = wasCompleted
        )
    }

    companion object {
        /**
         * Convert domain model to database entity
         */
        fun fromDomainModel(session: TimerSession): SessionEntity {
            return SessionEntity(
                id = session.id,
                type = session.type.name,
                duration = session.duration,
                completedAt = session.completedAt,
                wasCompleted = session.wasCompleted
            )
        }
    }
}
