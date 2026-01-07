package avtanshgupta.PomodoroTimer.domain.model

/**
 * Streak statistics for user's consistency tracking
 */
data class StreakStatistics(
    val currentStreak: Int = 0,
    val longestStreak: Int = 0,
    val lastSessionDate: Long? = null
)
