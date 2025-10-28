package com.pomodoro.timer.presentation.viewmodel

import android.content.Context
import android.content.Intent
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerSettings
import com.pomodoro.timer.domain.model.TimerState
import com.pomodoro.timer.domain.repository.SettingsRepository
import com.pomodoro.timer.service.TimerService
import com.pomodoro.timer.util.DynamicShortcutManager
import com.pomodoro.timer.util.TimerManager
import dagger.hilt.android.lifecycle.HiltViewModel
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * ViewModel for the main timer screen.
 * Manages timer state, controls timer service, and handles settings.
 * 
 * Maps to iOS MainTimerView functionality with Observable state.
 */
@HiltViewModel
class TimerViewModel @Inject constructor(
    @ApplicationContext private val context: Context,
    private val timerManager: TimerManager,
    private val settingsRepository: SettingsRepository
) : ViewModel() {
    
    // Dynamic shortcut manager
    private val shortcutManager = DynamicShortcutManager(context)
    
    // Timer state from TimerManager
    val timerState: StateFlow<TimerState> = timerManager.state
    val sessionType: StateFlow<SessionType> = timerManager.sessionType
    val remainingSeconds: StateFlow<Long> = timerManager.remainingSeconds
    val totalSeconds: StateFlow<Long> = timerManager.totalSeconds
    val completedSessions: StateFlow<Int> = timerManager.completedSessions
    
    // Convenience aliases for UI compatibility
    val currentSessionType: StateFlow<SessionType> = sessionType
    val timeRemaining: StateFlow<Long> = remainingSeconds
    val completedFocusSessions: StateFlow<Int> = completedSessions
    
    // Settings from repository
    private val _settings = MutableStateFlow(TimerSettings.DEFAULT)
    val settings: StateFlow<TimerSettings> = _settings.asStateFlow()
    
    // UI state
    private val _isServiceRunning = MutableStateFlow(false)
    val isServiceRunning: StateFlow<Boolean> = _isServiceRunning.asStateFlow()
    
    // Computed properties
    private val _progress = MutableStateFlow(0f)
    val progress: StateFlow<Float> = _progress.asStateFlow()
    
    private val _formattedTime = MutableStateFlow("00:00")
    val formattedTime: StateFlow<String> = _formattedTime.asStateFlow()
    
    init {
        // Initialize timer manager with viewModel scope
        timerManager.initialize(viewModelScope)
        
        // Observe settings
        viewModelScope.launch {
            settingsRepository.getSettings().collect { newSettings ->
                _settings.value = newSettings
            }
        }
        
        // Update computed values
        viewModelScope.launch {
            combine(remainingSeconds, totalSeconds) { remaining, total ->
                if (total > 0) {
                    ((total - remaining).toFloat() / total.toFloat()).coerceIn(0f, 1f)
                } else {
                    0f
                }
            }.collect { newProgress ->
                _progress.value = newProgress
            }
        }
        
        viewModelScope.launch {
            remainingSeconds.collect { seconds ->
                _formattedTime.value = timerManager.formatTime(seconds)
            }
        }
        
        // Update dynamic shortcuts when timer state changes
        viewModelScope.launch {
            combine(timerState, isServiceRunning) { state, running ->
                state to running
            }.collect { (state, running) ->
                shortcutManager.updateShortcuts(state, running)
            }
        }
    }
    
    /**
     * Start a new timer session
     */
    fun startTimer(sessionType: SessionType = SessionType.FOCUS) {
        viewModelScope.launch {
            val currentSettings = settings.value
            val duration = currentSettings.getDuration(sessionType)
            
            // Start service
            val intent = Intent(context, TimerService::class.java).apply {
                action = TimerService.ACTION_START
                putExtra(TimerService.EXTRA_SESSION_TYPE, sessionType.name)
                putExtra(TimerService.EXTRA_DURATION, duration)
            }
            context.startService(intent)
            _isServiceRunning.value = true
        }
    }
    
    /**
     * Pause the running timer
     */
    fun pauseTimer() {
        val intent = Intent(context, TimerService::class.java).apply {
            action = TimerService.ACTION_PAUSE
        }
        context.startService(intent)
    }
    
    /**
     * Resume the paused timer
     */
    fun resumeTimer() {
        val intent = Intent(context, TimerService::class.java).apply {
            action = TimerService.ACTION_RESUME
        }
        context.startService(intent)
    }
    
    /**
     * Reset the timer
     */
    fun resetTimer() {
        val intent = Intent(context, TimerService::class.java).apply {
            action = TimerService.ACTION_RESET
        }
        context.startService(intent)
        _isServiceRunning.value = false
    }
    
    /**
     * Skip current session
     */
    fun skipTimer() {
        val intent = Intent(context, TimerService::class.java).apply {
            action = TimerService.ACTION_SKIP
        }
        context.startService(intent)
        _isServiceRunning.value = false
    }
    
    /**
     * Skip session (alias for compatibility)
     */
    fun skipSession() {
        skipTimer()
    }
    
    /**
     * Get next session type based on completed sessions
     */
    fun getNextSessionType(): SessionType {
        val currentSettings = settings.value
        val completed = completedSessions.value
        
        return when {
            sessionType.value != SessionType.FOCUS -> SessionType.FOCUS
            completed > 0 && completed % currentSettings.sessionsUntilLongBreak == 0 -> {
                SessionType.LONG_BREAK
            }
            else -> SessionType.SHORT_BREAK
        }
    }
    
    /**
     * Auto-start next session if enabled in settings
     */
    fun autoStartNext() {
        viewModelScope.launch {
            val currentSettings = settings.value
            val currentSession = sessionType.value
            
            val shouldAutoStart = when (currentSession) {
                SessionType.FOCUS -> currentSettings.autoStartBreaks
                SessionType.SHORT_BREAK, SessionType.LONG_BREAK -> currentSettings.autoStartFocus
            }
            
            if (shouldAutoStart) {
                val nextType = getNextSessionType()
                startTimer(nextType)
            }
        }
    }
    
    /**
     * Check if timer can be started
     */
    fun canStartTimer(): Boolean {
        return timerState.value == TimerState.IDLE
    }
    
    /**
     * Check if timer can be paused
     */
    fun canPauseTimer(): Boolean {
        return timerState.value == TimerState.RUNNING
    }
    
    /**
     * Check if timer can be resumed
     */
    fun canResumeTimer(): Boolean {
        return timerState.value == TimerState.PAUSED
    }
    
    /**
     * Get session display name
     */
    fun getSessionDisplayName(type: SessionType): String {
        return type.displayName
    }
    
    /**
     * Get current session duration in minutes
     */
    fun getCurrentDurationMinutes(): Int {
        return (totalSeconds.value / 60).toInt()
    }
    
    override fun onCleared() {
        super.onCleared()
        // Service will handle cleanup
    }
}
