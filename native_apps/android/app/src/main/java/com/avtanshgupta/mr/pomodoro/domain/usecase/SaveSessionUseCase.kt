package avtanshgupta.PomodoroTimer.domain.usecase

import avtanshgupta.PomodoroTimer.domain.model.SessionType
import avtanshgupta.PomodoroTimer.domain.model.TimerSession
import avtanshgupta.PomodoroTimer.domain.repository.SessionRepository
import java.time.Instant
import javax.inject.Inject

/**
 * Use case for saving completed timer sessions.
 * Encapsulates business logic for session persistence.
 */
class SaveSessionUseCase @Inject constructor(
    private val sessionRepository: SessionRepository
) {
    
    /**
     * Save a completed session
     *
     * @param type Type of session (Focus, Short Break, Long Break)
     * @param duration Duration of the session in seconds
     * @param wasCompleted Whether the session was completed (true) or skipped (false)
     */
    suspend operator fun invoke(
        type: SessionType,
        duration: Long,
        wasCompleted: Boolean = true
    ) {
        val session = TimerSession(
            type = type,
            duration = duration,
            completedAt = Instant.now().epochSecond,
            wasCompleted = wasCompleted
        )
        
        sessionRepository.saveSession(session)
    }
    
    /**
     * Save a session with custom completion time
     */
    suspend fun saveWithCustomTime(
        type: SessionType,
        duration: Long,
        completedAt: Instant,
        wasCompleted: Boolean = true
    ) {
        val session = TimerSession(
            type = type,
            duration = duration,
            completedAt = completedAt.epochSecond,
            wasCompleted = wasCompleted
        )
        
        sessionRepository.saveSession(session)
    }
}
