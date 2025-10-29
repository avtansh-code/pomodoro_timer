package com.pomodoro.timer.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.Statistics
import com.pomodoro.timer.domain.model.StatisticsPeriod
import com.pomodoro.timer.domain.model.StreakStatistics
import com.pomodoro.timer.domain.model.TimerSession
import com.pomodoro.timer.domain.repository.SessionRepository
import com.pomodoro.timer.domain.usecase.GetStatisticsUseCase
import com.pomodoro.timer.domain.usecase.GetStreakUseCase
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
    
    // Statistics data for each period
    private val _todayStatistics = MutableStateFlow(Statistics())
    val todayStatistics: StateFlow<Statistics> = _todayStatistics.asStateFlow()
    
    private val _weekStatistics = MutableStateFlow(Statistics())
    val weekStatistics: StateFlow<Statistics> = _weekStatistics.asStateFlow()
    
    private val _monthStatistics = MutableStateFlow(Statistics())
    val monthStatistics: StateFlow<Statistics> = _monthStatistics.asStateFlow()
    
    private val _allTimeStatistics = MutableStateFlow(Statistics())
    val allTimeStatistics: StateFlow<Statistics> = _allTimeStatistics.asStateFlow()
    
    // Streak data
    private val _streakStatistics = MutableStateFlow<StreakStatistics?>(null)
    val streakStatistics: StateFlow<StreakStatistics?> = _streakStatistics.asStateFlow()
    
    // Current streak (convenience property)
    val currentStreak: StateFlow<Int> = _streakStatistics
        .asStateFlow()
        .let { flow ->
            MutableStateFlow(0).apply {
                viewModelScope.launch {
                    flow.collect { streak ->
                        value = streak?.currentStreak ?: 0
                    }
                }
            }
        }
    
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
        
        // Observe session changes and reload statistics
        viewModelScope.launch {
            sessionRepository.getAllSessions().collect { sessions ->
                // Reload statistics whenever sessions change
                loadAllStatistics()
                loadStreakStatistics()
                // Update recent sessions in the same collector to avoid duplicate Flow
                _recentSessions.value = sessions.take(10)
            }
        }
    }
    
    /**
     * Load all statistics data
     */
    private fun loadData() {
        loadAllStatistics()
        loadStreakStatistics()
        loadRecentSessions()
    }
    
    /**
     * Load statistics for all periods
     */
    private fun loadAllStatistics() {
        viewModelScope.launch {
            _isLoading.value = true
            _error.value = null
            
            try {
                // Load statistics for each period
                _todayStatistics.value = getStatisticsUseCase(StatisticsPeriod.TODAY)
                _weekStatistics.value = getStatisticsUseCase(StatisticsPeriod.WEEK)
                _monthStatistics.value = getStatisticsUseCase(StatisticsPeriod.MONTH)
                _allTimeStatistics.value = getStatisticsUseCase(StatisticsPeriod.ALL_TIME)
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
     * Note: This is handled in the init block to avoid duplicate Flow collection
     */
    private fun loadRecentSessions() {
        // No-op: Recent sessions are now loaded in the init block
        // to prevent duplicate Flow collectors which can cause OOM
    }
    
    /**
     * Change selected period
     */
    fun selectPeriod(period: StatisticsPeriod) {
        if (_selectedPeriod.value != period) {
            _selectedPeriod.value = period
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
                loadAllStatistics()
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
     * Get chart data for session types based on time spent (duration in minutes)
     */
    fun getSessionTypeChartData(): List<Pair<SessionType, Int>> {
        val stats = when (_selectedPeriod.value) {
            StatisticsPeriod.TODAY -> _todayStatistics.value
            StatisticsPeriod.WEEK -> _weekStatistics.value
            StatisticsPeriod.MONTH -> _monthStatistics.value
            StatisticsPeriod.ALL_TIME -> _allTimeStatistics.value
        }
        
        // Return durations in minutes (converted from seconds)
        return listOf(
            SessionType.FOCUS to (stats.focusDurationSeconds / 60).toInt(),
            SessionType.SHORT_BREAK to (stats.shortBreakDurationSeconds / 60).toInt(),
            SessionType.LONG_BREAK to (stats.longBreakDurationSeconds / 60).toInt()
        ).filter { it.second > 0 }
    }
    
    /**
     * Get chart data for completed vs skipped
     */
    fun getCompletionChartData(): List<Pair<String, Int>> {
        val stats = when (_selectedPeriod.value) {
            StatisticsPeriod.TODAY -> _todayStatistics.value
            StatisticsPeriod.WEEK -> _weekStatistics.value
            StatisticsPeriod.MONTH -> _monthStatistics.value
            StatisticsPeriod.ALL_TIME -> _allTimeStatistics.value
        }
        
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
        val stats = when (_selectedPeriod.value) {
            StatisticsPeriod.TODAY -> _todayStatistics.value
            StatisticsPeriod.WEEK -> _weekStatistics.value
            StatisticsPeriod.MONTH -> _monthStatistics.value
            StatisticsPeriod.ALL_TIME -> _allTimeStatistics.value
        }
        return stats.totalSessions > 0
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
    
    /**
     * Get daily sessions count for the last N days (for bar chart)
     */
    suspend fun getDailySessionsCount(days: Int): List<Float> {
        return try {
            val sessionsGrouped = sessionRepository.getSessionsGroupedByDate(days)
            
            // Create a list for the last N days
            val result = mutableListOf<Float>()
            val today = java.time.LocalDate.now()
            
            for (i in (days - 1) downTo 0) {
                val date = today.minusDays(i.toLong())
                val dateString = date.toString() // ISO format YYYY-MM-DD
                val count = sessionsGrouped[dateString]?.size ?: 0
                result.add(count.toFloat())
            }
            
            result
        } catch (e: Exception) {
            List(days) { 0f }
        }
    }
    
    /**
     * Get daily focus time in minutes for the last N days (for line chart)
     */
    suspend fun getDailyFocusTime(days: Int): List<Float> {
        return try {
            val sessionsGrouped = sessionRepository.getSessionsGroupedByDate(days)
            
            // Create a list for the last N days
            val result = mutableListOf<Float>()
            val today = java.time.LocalDate.now()
            
            for (i in (days - 1) downTo 0) {
                val date = today.minusDays(i.toLong())
                val dateString = date.toString() // ISO format YYYY-MM-DD
                
                // Calculate total focus time for this day
                val focusTime = sessionsGrouped[dateString]
                    ?.filter { it.type == SessionType.FOCUS }
                    ?.sumOf { it.duration } ?: 0L
                
                // Convert seconds to minutes
                result.add((focusTime / 60f))
            }
            
            result
        } catch (e: Exception) {
            List(days) { 0f }
        }
    }
}
