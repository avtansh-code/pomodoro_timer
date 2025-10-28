package com.pomodoro.timer.util

import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerSettings
import com.pomodoro.timer.domain.model.TimerState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Core timer manager based on iOS TimerManager.swift logic.
 * Handles timer countdown, session management, and state transitions.
 * 
 * This is a complete rewrite matching the iOS implementation for consistency.
 */
@Singleton
class TimerManager @Inject constructor() {
    
    // Published state flows (equivalent to @Published in iOS)
    private val _currentSessionType = MutableStateFlow(SessionType.FOCUS)
    val currentSessionType: StateFlow<SessionType> = _currentSessionType.asStateFlow()
    
    private val _timerState = MutableStateFlow(TimerState.IDLE)
    val timerState: StateFlow<TimerState> = _timerState.asStateFlow()
    
    private val _timeRemaining = MutableStateFlow(25 * 60L) // 25 minutes in seconds
    val timeRemaining: StateFlow<Long> = _timeRemaining.asStateFlow()
    
    private val _completedFocusSessions = MutableStateFlow(0)
    val completedFocusSessions: StateFlow<Int> = _completedFocusSessions.asStateFlow()
    
    private val _settings = MutableStateFlow(TimerSettings.DEFAULT)
    val settings: StateFlow<TimerSettings> = _settings.asStateFlow()
    
    // Private properties
    private var timerJob: Job? = null
    private var timerScope: CoroutineScope? = null
    private var backgroundTime: Long? = null
    
    /**
     * Initialize timer with coroutine scope (called from TimerService)
     */
    fun initialize(scope: CoroutineScope) {
        timerScope = scope
    }
    
    /**
     * Update settings
     */
    fun updateSettings(newSettings: TimerSettings) {
        _settings.value = newSettings
        // If idle, update time remaining to match new duration
        if (_timerState.value == TimerState.IDLE) {
            _timeRemaining.value = getDuration(_currentSessionType.value)
        }
    }
    
    // MARK: - Timer Controls
    
    /**
     * Start the timer (matches iOS startTimer())
     */
    fun startTimer() {
        if (_timerState.value == TimerState.RUNNING) return
        
        // Important: Start countdown BEFORE changing state to ensure coroutine is ready
        startCountdown()
        _timerState.value = TimerState.RUNNING
    }
    
    /**
     * Pause the timer (matches iOS pauseTimer())
     */
    fun pauseTimer() {
        if (_timerState.value != TimerState.RUNNING) return
        
        _timerState.value = TimerState.PAUSED
        timerJob?.cancel()
        timerJob = null
    }
    
    /**
     * Reset timer (matches iOS resetTimer())
     */
    fun resetTimer() {
        timerJob?.cancel()
        timerJob = null
        _timerState.value = TimerState.IDLE
        _timeRemaining.value = getDuration(_currentSessionType.value)
    }
    
    /**
     * Skip current session (matches iOS skipSession())
     * Returns elapsed time for session saving
     */
    fun skipSession(): Long {
        val elapsedTime = getDuration(_currentSessionType.value) - _timeRemaining.value
        
        resetTimer()
        switchToNextSession()
        
        return elapsedTime
    }
    
    // MARK: - Timer Logic
    
    /**
     * Countdown tick (matches iOS tick())
     */
    private fun tick() {
        if (_timeRemaining.value > 0) {
            _timeRemaining.value -= 1
        } else {
            completeSession()
        }
    }
    
    /**
     * Complete current session (matches iOS completeSession())
     * Returns true if session completed, false otherwise
     */
    private fun completeSession(): Boolean {
        timerJob?.cancel()
        timerJob = null
        _timerState.value = TimerState.IDLE
        
        // Session completed successfully
        return true
    }
    
    /**
     * Switch to next session type (matches iOS switchToNextSession())
     */
    fun switchToNextSession() {
        when (_currentSessionType.value) {
            SessionType.FOCUS -> {
                _completedFocusSessions.value += 1
                
                if (_completedFocusSessions.value % _settings.value.sessionsUntilLongBreak == 0) {
                    _currentSessionType.value = SessionType.LONG_BREAK
                    _timeRemaining.value = _settings.value.longBreakDuration
                } else {
                    _currentSessionType.value = SessionType.SHORT_BREAK
                    _timeRemaining.value = _settings.value.shortBreakDuration
                }
            }
            SessionType.SHORT_BREAK, SessionType.LONG_BREAK -> {
                _currentSessionType.value = SessionType.FOCUS
                _timeRemaining.value = _settings.value.focusDuration
            }
        }
    }
    
    /**
     * Check if should auto-start next session (matches iOS shouldAutoStart())
     */
    fun shouldAutoStart(): Boolean {
        return when (_currentSessionType.value) {
            SessionType.FOCUS -> _settings.value.autoStartFocus
            SessionType.SHORT_BREAK, SessionType.LONG_BREAK -> _settings.value.autoStartBreaks
        }
    }
    
    /**
     * Get duration for session type (matches iOS getDuration())
     */
    private fun getDuration(type: SessionType): Long {
        return when (type) {
            SessionType.FOCUS -> _settings.value.focusDuration
            SessionType.SHORT_BREAK -> _settings.value.shortBreakDuration
            SessionType.LONG_BREAK -> _settings.value.longBreakDuration
        }
    }
    
    // MARK: - Background Handling
    
    /**
     * Handle app entering background (matches iOS appDidEnterBackground())
     */
    fun appDidEnterBackground() {
        backgroundTime = System.currentTimeMillis()
    }
    
    /**
     * Handle app entering foreground (matches iOS appWillEnterForeground())
     * Returns true if session completed while in background
     */
    fun appWillEnterForeground(): Boolean {
        val bgTime = backgroundTime ?: return false
        
        val elapsedSeconds = (System.currentTimeMillis() - bgTime) / 1000
        
        if (_timerState.value == TimerState.RUNNING) {
            _timeRemaining.value = maxOf(0, _timeRemaining.value - elapsedSeconds)
            
            if (_timeRemaining.value <= 0) {
                completeSession()
                backgroundTime = null
                return true
            }
        }
        
        backgroundTime = null
        return false
    }
    
    // MARK: - Helper Methods
    
    /**
     * Start the countdown coroutine
     */
    private fun startCountdown() {
        timerJob = timerScope?.launch {
            while (_timeRemaining.value > 0 && _timerState.value == TimerState.RUNNING) {
                delay(1000L) // Wait 1 second
                
                // Double-check state after delay
                if (_timerState.value == TimerState.RUNNING) {
                    tick()
                }
            }
        }
    }
    
    /**
     * Format time in seconds to MM:SS format
     */
    fun formatTime(seconds: Long): String {
        val minutes = seconds / 60
        val secs = seconds % 60
        return String.format("%02d:%02d", minutes, secs)
    }
    
    /**
     * Get formatted remaining time
     */
    fun getFormattedRemainingTime(): String {
        return formatTime(_timeRemaining.value)
    }
    
    /**
     * Get current progress as percentage (0.0 to 1.0)
     */
    fun getProgress(): Float {
        val total = getDuration(_currentSessionType.value)
        val remaining = _timeRemaining.value
        
        if (total <= 0) return 0f
        
        val elapsed = total - remaining
        return (elapsed.toFloat() / total.toFloat()).coerceIn(0f, 1f)
    }
    
    /**
     * Check if timer is currently running
     */
    fun isRunning(): Boolean = _timerState.value == TimerState.RUNNING
    
    /**
     * Check if timer is paused
     */
    fun isPaused(): Boolean = _timerState.value == TimerState.PAUSED
    
    /**
     * Check if timer is idle
     */
    fun isIdle(): Boolean = _timerState.value == TimerState.IDLE
    
    /**
     * Reset completed sessions counter
     */
    fun resetCompletedSessions() {
        _completedFocusSessions.value = 0
    }
    
    /**
     * Prepare a new session without starting it
     */
    fun prepareSession(sessionType: SessionType) {
        timerJob?.cancel()
        timerJob = null
        
        _currentSessionType.value = sessionType
        _timeRemaining.value = getDuration(sessionType)
        _timerState.value = TimerState.IDLE
    }
    
    /**
     * Check if session just completed (for TimerService to detect completion)
     */
    fun isSessionComplete(): Boolean {
        return _timerState.value == TimerState.IDLE && _timeRemaining.value == 0L
    }
}
