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
 * Maps to iOS TimerManager.swift functionality.
 * 
 * Uses Kotlin coroutines for precise timing and cancellation.
 */
@Singleton
class TimerManager @Inject constructor() {
    
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
    
    private var timerJob: Job? = null
    private var timerScope: CoroutineScope? = null
    
    /**
     * Initialize timer with scope for coroutines
     */
    fun initialize(scope: CoroutineScope) {
        timerScope = scope
    }
    
    /**
     * Start timer with specified duration
     */
    fun start(sessionType: SessionType, durationSeconds: Long) {
        if (_state.value != TimerState.IDLE) return
        
        _sessionType.value = sessionType
        _totalSeconds.value = durationSeconds
        _remainingSeconds.value = durationSeconds
        _state.value = TimerState.RUNNING
        
        startCountdown()
    }
    
    /**
     * Pause the running timer
     */
    fun pause() {
        if (_state.value != TimerState.RUNNING) return
        
        _state.value = TimerState.PAUSED
        timerJob?.cancel()
        timerJob = null
    }
    
    /**
     * Resume paused timer
     */
    fun resume() {
        if (_state.value != TimerState.PAUSED) return
        
        _state.value = TimerState.RUNNING
        startCountdown()
    }
    
    /**
     * Reset timer to idle state
     */
    fun reset() {
        timerJob?.cancel()
        timerJob = null
        
        _state.value = TimerState.IDLE
        _remainingSeconds.value = _totalSeconds.value
    }
    
    /**
     * Skip current session
     */
    fun skip() {
        timerJob?.cancel()
        timerJob = null
        
        _state.value = TimerState.IDLE
        _remainingSeconds.value = 0
    }
    
    /**
     * Get progress as percentage (0.0 to 1.0)
     */
    fun getProgress(): Float {
        val total = _totalSeconds.value
        val remaining = _remainingSeconds.value
        
        if (total <= 0) return 0f
        
        return ((total - remaining).toFloat() / total.toFloat()).coerceIn(0f, 1f)
    }
    
    /**
     * Increment completed sessions counter
     */
    fun incrementCompletedSessions() {
        _completedSessions.value += 1
    }
    
    /**
     * Reset completed sessions counter
     */
    fun resetCompletedSessions() {
        _completedSessions.value = 0
    }
    
    /**
     * Start the countdown coroutine
     */
    private fun startCountdown() {
        timerJob = timerScope?.launch {
            while (_remainingSeconds.value > 0 && _state.value == TimerState.RUNNING) {
                delay(1000) // 1 second tick
                
                if (_state.value == TimerState.RUNNING) {
                    _remainingSeconds.value -= 1
                    
                    // Timer completed
                    if (_remainingSeconds.value <= 0) {
                        onTimerComplete()
                    }
                }
            }
        }
    }
    
    /**
     * Handle timer completion
     */
    private fun onTimerComplete() {
        _state.value = TimerState.IDLE
        _remainingSeconds.value = 0
        
        // Increment completed sessions if it was a focus session
        if (_sessionType.value == SessionType.FOCUS) {
            incrementCompletedSessions()
        }
    }
    
    /**
     * Format remaining time as MM:SS
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
     * Check if timer is running
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
}
