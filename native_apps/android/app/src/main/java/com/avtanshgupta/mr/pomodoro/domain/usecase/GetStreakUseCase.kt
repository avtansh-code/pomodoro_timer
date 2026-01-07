package avtanshgupta.PomodoroTimer.domain.usecase

import avtanshgupta.PomodoroTimer.domain.model.StreakStatistics
import avtanshgupta.PomodoroTimer.domain.repository.SessionRepository
import javax.inject.Inject

/**
 * Use case for calculating the current streak of consecutive days with completed sessions.
 * Maps to getCurrentStreak() functionality in iOS PersistenceManager.swift
 */
class GetStreakUseCase @Inject constructor(
    private val sessionRepository: SessionRepository
) {
    
    /**
     * Get the current streak (consecutive days with at least one completed session)
     */
    suspend operator fun invoke(): StreakStatistics {
        val currentStreak = sessionRepository.getCurrentStreak()
        // TODO: Implement longest streak calculation in repository
        // For now, return current as longest
        return StreakStatistics(
            currentStreak = currentStreak,
            longestStreak = currentStreak, // Placeholder
            lastSessionDate = null // TODO: Get from repository
        )
    }
}
