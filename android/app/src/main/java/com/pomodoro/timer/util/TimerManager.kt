package com.pomodoro.timer.util

import com.pomodoro.timer.domain.model.SessionType
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
 * Core timer manager handling countdown logic.
 * Complete rewrite with proper state management for:
 * - Start/Pause/Resume/Reset/Skip operations
 * - Focus/Short Break/Long Break transitions
 * - Completed sessions tracking
 */
@Singleton
class TimerManager @Inject constructor() {
    
    // Timer state flows
    private val _state = MutableStateFlow(TimerState.IDLE)
    val state: StateFlow<TimerState> = _state.asStateFlow()
    
    private val _sessionType = MutableStateFlow(SessionType.FOCUS)
    val sessionType: StateFlow<SessionType> = _sessionType.asStateFlow()
    
    private val _remainingSeconds = MutableStateFlow(25 * 60L)
    val remainingSeconds: StateFlow<Long> = _remainingSeconds.asStateFlow()
    
    private val _totalSeconds = MutableStateFlow(25 * 60L)
    val totalSeconds: StateFlow<Long> = _totalSeconds.asStateFlow()
    
    private val _completedSessions = MutableStateFlow(0)
    val completedSessions: StateFlow<Int> = _completedSessions.asStateFlow()
    
    // Coroutine management
    private var timerJob: Job? = null
    private var timerScope: CoroutineScope? = null
    
    /**
     * Initialize timer with coroutine scope
     */
    fun initialize(scope: CoroutineScope) {
        timerScope = scope
    }
    
    /**
     * Start a new timer session
     * Can be called from any state (IDLE, PAUSED, or even RUNNING to restart)
     */
    fun start(sessionType: SessionType, durationSeconds: Long) {
        // Cancel any running timer
        cancelTimer()
        
        // Set up new session
        _sessionType.value = sessionType
        _totalSeconds.value = durationSeconds
        _remainingSeconds.value = durationSeconds
        _state.value = TimerState.RUNNING
        
        // Start countdown
        startCountdown()
    }
    
    /**
     * Pause the running timer
     * Only works if timer is RUNNING
     */
    fun pause() {
        if (_state.value != TimerState.RUNNING) return
        
        // Cancel countdown but keep time
        cancelTimer()
        _state.value = TimerState.PAUSED
    }
    
    /**
     * Resume a paused timer
     * Only works if timer is PAUSED
     */
    fun resume() {
        if (_state.value != TimerState.PAUSED) return
        
        _state.value = TimerState.RUNNING
        startCountdown()
    }
    
    /**
     * Reset timer to initial state of current session
     * Keeps session type and total duration, resets remaining time
     */
    fun reset() {
        cancelTimer()
        
        _state.value = TimerState.IDLE
        _remainingSeconds.value = _totalSeconds.value
    }
    
    /**
     * Skip current session
     * Sets remaining time to 0 and moves to IDLE state
     * Note: Session transition logic handled by TimerService
     */
    fun skip() {
        cancelTimer()
        
        _remainingSeconds.value = 0
        _state.value = TimerState.IDLE
    }
    
    /**
     * Prepare next session without starting
     * Used after skip when auto-start is disabled
     */
    fun prepareSession(sessionType: SessionType, durationSeconds: Long) {
        cancelTimer()
        
        _sessionType.value = sessionType
        _totalSeconds.value = durationSeconds
        _remainingSeconds.value = durationSeconds
        _state.value = TimerState.IDLE
    }
    
    /**
     * Increment completed focus sessions counter
     * Called when a focus session completes or is skipped
     */
    fun incrementCompletedSessions() {
        _completedSessions.value += 1
    }
    
    /**
     * Reset completed sessions counter
     * Can be called manually or when cycle resets
     */
    fun resetCompletedSessions() {
        _completedSessions.value = 0
    }
    
    /**
     * Get current progress as percentage (0.0 to 1.0)
     */
    fun getProgress(): Float {
        val total = _totalSeconds.value
        val remaining = _remainingSeconds.value
        
        if (total <= 0) return 0f
        
        val elapsed = total - remaining
        return (elapsed.toFloat() / total.toFloat()).coerceIn(0f, 1f)
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
        return formatTime(_remainingSeconds.value)
    }
    
    /**
     * Check if timer is currently running
     */
    fun isRunning(): Boolean = _state.value == TimerState.RUNNING
    
    /**
     * Check if timer is paused
     */
    fun isPaused(): Boolean = _state.value == TimerState.PAUSED
    
    /**
     * Check if timer is idle
     */
    fun isIdle(): Boolean = _state.value == TimerState.IDLE
    
    /**
     * Start the countdown coroutine
     * Ticks every second until timer completes or is cancelled
     */
    private fun startCountdown() {
        timerJob = timerScope?.launch {
            while (_remainingSeconds.value > 0 && _state.value == TimerState.RUNNING) {
                delay(1000L) // Wait 1 second
                
                // Double-check state after delay
                if (_state.value == TimerState.RUNNING) {
                    _remainingSeconds.value -= 1
                    
                    // Check if timer completed
                    if (_remainingSeconds.value <= 0) {
                        handleTimerCompletion()
                    }
                }
            }
        }
    }
    
    /**
     * Handle timer completion
     * Increments counter for focus sessions
     * Transitions to IDLE for service to handle next steps
     */
    private fun handleTimerCompletion() {
        _state.value = TimerState.IDLE
        _remainingSeconds.value = 0
        
        // Auto-increment completed sessions for focus sessions
        if (_sessionType.value == SessionType.FOCUS) {
            incrementCompletedSessions()
        }
    }
    
    /**
     * Cancel the timer coroutine job
     * Helper method to ensure clean cancellation
     */
    private fun cancelTimer() {
        timerJob?.cancel()
        timerJob = null
    }
}
