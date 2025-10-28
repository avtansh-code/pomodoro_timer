package com.pomodoro.timer.domain.usecase

import com.pomodoro.timer.domain.repository.SessionRepository
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
    suspend operator fun invoke(): Int {
        return sessionRepository.getCurrentStreak()
    }
    
    /**
     * Get streak statistics including longest streak
     */
    suspend fun getStreakStatistics(): StreakStatistics {
        val currentStreak = sessionRepository.getCurrentStreak()
        // TODO: Implement longest streak calculation in repository
        // For now, return current as longest
        return StreakStatistics(
            currentStreak = currentStreak,
            longestStreak = currentStreak // Placeholder
        )
    }
}

/**
 * Streak statistics data class
 */
data class StreakStatistics(
    val currentStreak: Int,
    val longestStreak: Int
)
