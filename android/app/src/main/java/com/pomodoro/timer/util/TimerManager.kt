package com.pomodoro.timer.util

import android.util.Log
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerSettings
import com.pomodoro.timer.domain.model.TimerState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
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
        Log.d("TimerManager", "=== initialize() called ===")
        timerScope = scope
        Log.d("TimerManager", "TimerScope set, current state: ${_timerState.value}")
    }
    
    /**
     * Update settings
     */
    fun updateSettings(newSettings: TimerSettings) {
        Log.d("TimerManager", ">>> updateSettings() called")
        Log.d("TimerManager", "focusDuration: ${newSettings.focusDuration}, shortBreakDuration: ${newSettings.shortBreakDuration}, longBreakDuration: ${newSettings.longBreakDuration}")
        
        _settings.value = newSettings
        // If idle, update time remaining to match new duration
        if (_timerState.value == TimerState.IDLE) {
            val newDuration = getDuration(_currentSessionType.value)
            Log.d("TimerManager", "Timer is IDLE, updating timeRemaining to: $newDuration")
            _timeRemaining.value = newDuration
        }
    }
    
    // MARK: - Timer Controls
    
    /**
     * Start the timer (matches iOS startTimer())
     */
    fun startTimer() {
        Log.d("TimerManager", ">>> startTimer() called")
        Log.d("TimerManager", "Current state: ${_timerState.value}")
        Log.d("TimerManager", "Current timeRemaining: ${_timeRemaining.value}")
        Log.d("TimerManager", "Current sessionType: ${_currentSessionType.value}")
        Log.d("TimerManager", "timerScope is null: ${timerScope == null}")
        
        if (_timerState.value == TimerState.RUNNING) {
            Log.d("TimerManager", "Timer already running, returning")
            return
        }
        
        // Important: Set state to RUNNING BEFORE starting countdown so the loop condition passes
        Log.d("TimerManager", "Setting state to RUNNING")
        _timerState.value = TimerState.RUNNING
        Log.d("TimerManager", "State is now: ${_timerState.value}")
        
        Log.d("TimerManager", "Starting countdown coroutine...")
        startCountdown()
    }
    
    /**
     * Pause the timer (matches iOS pauseTimer())
     */
    fun pauseTimer() {
        Log.d("TimerManager", ">>> pauseTimer() called")
        Log.d("TimerManager", "Current state: ${_timerState.value}")
        
        if (_timerState.value != TimerState.RUNNING) {
            Log.d("TimerManager", "Timer not running, returning")
            return
        }
        
        Log.d("TimerManager", "Setting state to PAUSED and canceling job")
        _timerState.value = TimerState.PAUSED
        timerJob?.cancel()
        timerJob = null
        Log.d("TimerManager", "State is now: ${_timerState.value}")
    }
    
    /**
     * Reset timer (matches iOS resetTimer())
     */
    fun resetTimer() {
        Log.d("TimerManager", ">>> resetTimer() called")
        Log.d("TimerManager", "Current state: ${_timerState.value}")
        
        timerJob?.cancel()
        timerJob = null
        
        Log.d("TimerManager", "Setting state to IDLE")
        _timerState.value = TimerState.IDLE
        
        val newDuration = getDuration(_currentSessionType.value)
        Log.d("TimerManager", "Resetting timeRemaining to: $newDuration")
        _timeRemaining.value = newDuration
        Log.d("TimerManager", "Reset complete, state: ${_timerState.value}, timeRemaining: ${_timeRemaining.value}")
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
            // Only log every 10 seconds to avoid spam
            if (_timeRemaining.value % 10 == 0L) {
                Log.d("TimerManager", "Tick: timeRemaining = ${_timeRemaining.value}")
            }
        } else {
            Log.d("TimerManager", "Timer reached 0, completing session")
            completeSession()
        }
    }
    
    /**
     * Complete current session (matches iOS completeSession())
     * Returns true if session completed, false otherwise
     */
    private fun completeSession(): Boolean {
        Log.d("TimerManager", ">>> completeSession() called")
        Log.d("TimerManager", "Current sessionType: ${_currentSessionType.value}")
        
        timerJob?.cancel()
        timerJob = null
        
        Log.d("TimerManager", "Setting state to IDLE after completion")
        _timerState.value = TimerState.IDLE
        
        Log.d("TimerManager", "Session completed successfully")
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
        Log.d("TimerManager", ">>> startCountdown() called")
        Log.d("TimerManager", "timerScope is null: ${timerScope == null}")
        
        if (timerScope == null) {
            Log.e("TimerManager", "ERROR: timerScope is null! Cannot start countdown")
            return
        }
        
        timerJob = timerScope?.launch(Dispatchers.Default) {
            Log.d("TimerManager", "Countdown coroutine launched on Default dispatcher")
            Log.d("TimerManager", "Starting countdown loop with timeRemaining=${_timeRemaining.value}, state=${_timerState.value}")
            
            try {
                while (_timeRemaining.value > 0 && _timerState.value == TimerState.RUNNING) {
                    delay(1000L) // Wait 1 second
                    
                    // Double-check state after delay
                    if (_timerState.value == TimerState.RUNNING) {
                        tick()
                    }
                }
                
                Log.d("TimerManager", "Countdown loop ended normally")
            } catch (e: kotlinx.coroutines.CancellationException) {
                // Expected when timer is paused or reset - not an error
                Log.d("TimerManager", "Countdown cancelled (paused or reset)")
                throw e  // Re-throw to properly cancel the coroutine
            } catch (e: Exception) {
                Log.e("TimerManager", "Unexpected exception in countdown loop", e)
            }
        }
        
        Log.d("TimerManager", "timerJob created: ${timerJob != null}")
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
