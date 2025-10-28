package com.pomodoro.timer.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerSession
import com.pomodoro.timer.domain.repository.SessionRepository
import com.pomodoro.timer.domain.usecase.GetStatisticsUseCase
import com.pomodoro.timer.domain.usecase.GetStreakUseCase
import com.pomodoro.timer.domain.usecase.Statistics
import com.pomodoro.timer.domain.usecase.StatisticsPeriod
import com.pomodoro.timer.domain.usecase.StreakStatistics
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * ViewModel for the statistics screen.
 * Displays session history, streaks, and analytics.
 * 
 * Maps to iOS StatisticsView functionality.
 */
@HiltViewModel
class StatisticsViewModel @Inject constructor(
    private val sessionRepository: SessionRepository,
    private val getStatisticsUseCase: GetStatisticsUseCase,
    private val getStreakUseCase: GetStreakUseCase
) : ViewModel() {
    
    // Selected period
    private val _selectedPeriod = MutableStateFlow(StatisticsPeriod.TODAY)
    val selectedPeriod: StateFlow<StatisticsPeriod> = _selectedPeriod.asStateFlow()
    
    // Statistics data
    private val _statistics = MutableStateFlow<Statistics?>(null)
    val statistics: StateFlow<Statistics?> = _statistics.asStateFlow()
    
    // Streak data
    private val _streakStatistics = MutableStateFlow<StreakStatistics?>(null)
    val streakStatistics: StateFlow<StreakStatistics?> = _streakStatistics.asStateFlow()
    
    // Recent sessions
    private val _recentSessions = MutableStateFlow<List<TimerSession>>(emptyList())
    val recentSessions: StateFlow<List<TimerSession>> = _recentSessions.asStateFlow()
    
    // UI state
    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()
    
    private val _error = MutableStateFlow<String?>(null)
    val error: StateFlow<String?> = _error.asStateFlow()
    
    init {
        loadData()
    }
    
    /**
     * Load all statistics data
     */
    private fun loadData() {
        loadStatistics()
        loadStreakStatistics()
        loadRecentSessions()
    }
    
    /**
     * Load statistics for selected period
     */
    private fun loadStatistics() {
        viewModelScope.launch {
            _isLoading.value = true
            _error.value = null
            
            try {
                val stats = getStatisticsUseCase(_selectedPeriod.value)
                _statistics.value = stats
            } catch (e: Exception) {
                _error.value = "Failed to load statistics: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }
    
    /**
     * Load streak statistics
     */
    private fun loadStreakStatistics() {
        viewModelScope.launch {
            try {
                val streak = getStreakUseCase()
                _streakStatistics.value = streak
            } catch (e: Exception) {
                // Streak is optional, don't show error
            }
        }
    }
    
    /**
     * Load recent sessions (last 10)
     */
    private fun loadRecentSessions() {
        viewModelScope.launch {
            sessionRepository.getAllSessions().collect { sessions ->
                _recentSessions.value = sessions.take(10)
            }
        }
    }
    
    /**
     * Change selected period
     */
    fun selectPeriod(period: StatisticsPeriod) {
        if (_selectedPeriod.value != period) {
            _selectedPeriod.value = period
            loadStatistics()
        }
    }
    
    /**
     * Refresh all data
     */
    fun refresh() {
        loadData()
    }
    
    /**
     * Delete a session
     */
    fun deleteSession(session: TimerSession) {
        viewModelScope.launch {
            try {
                sessionRepository.deleteSession(session)
                // Data will auto-refresh via Flow
                loadStatistics()
                loadStreakStatistics()
            } catch (e: Exception) {
                _error.value = "Failed to delete session: ${e.message}"
            }
        }
    }
    
    /**
     * Delete all sessions
     */
    fun deleteAllSessions() {
        viewModelScope.launch {
            try {
                sessionRepository.deleteAllSessions()
                loadData()
            } catch (e: Exception) {
                _error.value = "Failed to delete sessions: ${e.message}"
            }
        }
    }
    
    /**
     * Clear error message
     */
    fun clearError() {
        _error.value = null
    }
    
    /**
     * Get available periods
     */
    fun getAvailablePeriods(): List<StatisticsPeriod> {
        return listOf(
            StatisticsPeriod.TODAY,
            StatisticsPeriod.WEEK,
            StatisticsPeriod.MONTH,
            StatisticsPeriod.ALL_TIME
        )
    }
    
    /**
     * Get period display name
     */
    fun getPeriodDisplayName(period: StatisticsPeriod): String {
        return when (period) {
            StatisticsPeriod.TODAY -> "Today"
            StatisticsPeriod.WEEK -> "This Week"
            StatisticsPeriod.MONTH -> "This Month"
            StatisticsPeriod.ALL_TIME -> "All Time"
        }
    }
    
    /**
     * Format duration in hours and minutes
     */
    fun formatDuration(seconds: Long): String {
        val hours = seconds / 3600
        val minutes = (seconds % 3600) / 60
        
        return when {
            hours > 0 -> "${hours}h ${minutes}m"
            minutes > 0 -> "${minutes}m"
            else -> "0m"
        }
    }
    
    /**
     * Format completion rate as percentage
     */
    fun formatCompletionRate(rate: Double): String {
        return "${(rate * 100).toInt()}%"
    }
    
    /**
     * Get chart data for session types
     */
    fun getSessionTypeChartData(): List<Pair<SessionType, Int>> {
        val stats = _statistics.value ?: return emptyList()
        
        return listOf(
            SessionType.FOCUS to stats.focusSessionsCount,
            SessionType.SHORT_BREAK to stats.shortBreakSessionsCount,
            SessionType.LONG_BREAK to stats.longBreakSessionsCount
        ).filter { it.second > 0 }
    }
    
    /**
     * Get chart data for completed vs skipped
     */
    fun getCompletionChartData(): List<Pair<String, Int>> {
        val stats = _statistics.value ?: return emptyList()
        
        return listOf(
            "Completed" to stats.completedSessionsCount,
            "Skipped" to stats.skippedSessionsCount
        ).filter { it.second > 0 }
    }
    
    /**
     * Get sessions grouped by date
     */
    fun getSessionsByDate(): Map<String, List<TimerSession>> {
        return _recentSessions.value.groupBy { session ->
            // Format date from timestamp
            val date = java.util.Date(session.completedAt * 1000)
            java.text.SimpleDateFormat("MMM dd, yyyy", java.util.Locale.getDefault())
                .format(date)
        }
    }
    
    /**
     * Check if there is any data
     */
    fun hasData(): Boolean {
        val stats = _statistics.value
        return stats != null && stats.totalSessions > 0
    }
    
    /**
     * Get empty state message
     */
    fun getEmptyStateMessage(): String {
        return when (_selectedPeriod.value) {
            StatisticsPeriod.TODAY -> "No sessions completed today. Start a focus session!"
            StatisticsPeriod.WEEK -> "No sessions this week. Time to get started!"
            StatisticsPeriod.MONTH -> "No sessions this month yet."
            StatisticsPeriod.ALL_TIME -> "No sessions recorded. Complete your first Pomodoro!"
        }
    }
}
