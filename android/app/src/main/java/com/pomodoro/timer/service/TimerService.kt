package com.pomodoro.timer.service

import android.app.Service
import android.content.Intent
import android.os.IBinder
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerState
import com.pomodoro.timer.domain.repository.SettingsRepository
import com.pomodoro.timer.domain.usecase.SaveSessionUseCase
import com.pomodoro.timer.util.TimerManager
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Foreground service for running the Pomodoro timer.
 * Based on iOS TimerManager logic for session management and transitions.
 * 
 * This service acts as a bridge between Android's service lifecycle
 * and the core timer logic in TimerManager.
 */
@AndroidEntryPoint
class TimerService : Service() {
    
    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    
    @Inject
    lateinit var timerManager: TimerManager
    
    @Inject
    lateinit var notificationHelper: NotificationHelper
    
    @Inject
    lateinit var saveSessionUseCase: SaveSessionUseCase
    
    @Inject
    lateinit var settingsRepository: SettingsRepository
    
    private var previousState: TimerState = TimerState.IDLE
    private var previousTimeRemaining: Long = 0L
    
    companion object {
        const val ACTION_START = "com.pomodoro.timer.START"
        const val ACTION_PAUSE = NotificationHelper.ACTION_PAUSE
        const val ACTION_RESUME = NotificationHelper.ACTION_RESUME
        const val ACTION_RESET = NotificationHelper.ACTION_RESET
        const val ACTION_SKIP = NotificationHelper.ACTION_SKIP
        const val ACTION_STOP = "com.pomodoro.timer.STOP"
    }
    
    override fun onCreate() {
        super.onCreate()
        
        // Initialize timer with service scope
        timerManager.initialize(serviceScope)
        
        // Load and apply settings
        serviceScope.launch {
            val settings = settingsRepository.getSettings().first()
            timerManager.updateSettings(settings)
        }
        
        // Observe timer state and time changes
        observeTimerState()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> handleStart()
            ACTION_PAUSE -> handlePause()
            ACTION_RESUME -> handleResume()
            ACTION_RESET -> handleReset()
            ACTION_SKIP -> handleSkip()
            ACTION_STOP -> handleStop()
        }
        
        return START_STICKY
    }
    
    override fun onBind(intent: Intent): IBinder? = null
    
    /**
     * Observe timer state and handle transitions (matches iOS timer observation)
     */
    private fun observeTimerState() {
        // Observe state changes
        timerManager.timerState.onEach { state ->
            handleStateChange(state)
        }.launchIn(serviceScope)
        
        // Observe time changes for completion detection
        timerManager.timeRemaining.onEach { timeRemaining ->
            // Detect session completion (when timer reaches 0)
            if (previousTimeRemaining > 0 && timeRemaining == 0L && 
                timerManager.timerState.value == TimerState.IDLE) {
                handleTimerCompletion()
            }
            
            // Update notification while running
            if (timerManager.timerState.value != TimerState.IDLE) {
                updateNotification()
            }
            
            previousTimeRemaining = timeRemaining
        }.launchIn(serviceScope)
    }
    
    /**
     * Handle state changes (matches iOS state observation)
     */
    private fun handleStateChange(newState: TimerState) {
        when (newState) {
            TimerState.RUNNING -> {
                // Start foreground service with notification
                startForeground(
                    NotificationHelper.NOTIFICATION_ID_TIMER,
                    createNotification()
                )
            }
            TimerState.PAUSED -> {
                // Update notification to show resume button
                updateNotification()
            }
            TimerState.IDLE -> {
                // If not completing a session, stop foreground
                if (previousState != TimerState.RUNNING || 
                    timerManager.timeRemaining.value > 0) {
                    stopForegroundService()
                }
            }
        }
        
        previousState = newState
    }
    
    /**
     * Handle timer completion (matches iOS completeSession())
     */
    private fun handleTimerCompletion() {
        val sessionType = timerManager.currentSessionType.value
        val settings = timerManager.settings.value
        
        // Save completed session (matches iOS session saving)
        serviceScope.launch {
            val duration = settings.getDuration(sessionType)
            saveSessionUseCase(
                type = sessionType,
                duration = duration,
                wasCompleted = true
            )
            
            // Show completion notification if enabled
            if (settings.notificationsEnabled) {
                notificationHelper.showCompletionNotification(sessionType)
            }
            
            // Switch to next session (matches iOS switchToNextSession())
            timerManager.switchToNextSession()
            
            // Auto-start if enabled (matches iOS shouldAutoStart())
            if (timerManager.shouldAutoStart()) {
                // Small delay before auto-starting (matches iOS 1 second delay)
                kotlinx.coroutines.delay(1000L)
                timerManager.startTimer()
                updateNotification()
            } else {
                // Stop foreground service if not auto-starting
                stopForegroundService()
            }
        }
    }
    
    /**
     * Handle start action
     */
    private fun handleStart() {
        // If already running, just update notification
        if (timerManager.timerState.value == TimerState.RUNNING) {
            updateNotification()
            return
        }
        
        // Start timer
        timerManager.startTimer()
        
        // Start as foreground service
        startForeground(
            NotificationHelper.NOTIFICATION_ID_TIMER,
            createNotification()
        )
    }
    
    /**
     * Handle pause action (matches iOS pauseTimer())
     */
    private fun handlePause() {
        timerManager.pauseTimer()
        updateNotification()
    }
    
    /**
     * Handle resume action
     */
    private fun handleResume() {
        if (timerManager.timerState.value == TimerState.PAUSED) {
            timerManager.startTimer()
            updateNotification()
        }
    }
    
    /**
     * Handle reset action (matches iOS resetTimer())
     */
    private fun handleReset() {
        // Save as skipped session if timer was running
        if (timerManager.timerState.value != TimerState.IDLE) {
            val sessionType = timerManager.currentSessionType.value
            val settings = timerManager.settings.value
            val totalDuration = settings.getDuration(sessionType)
            val elapsedDuration = totalDuration - timerManager.timeRemaining.value
            
            serviceScope.launch {
                saveSessionUseCase(
                    type = sessionType,
                    duration = elapsedDuration,
                    wasCompleted = false
                )
            }
        }
        
        timerManager.resetTimer()
        stopForegroundService()
    }
    
    /**
     * Handle skip action (matches iOS skipSession())
     */
    private fun handleSkip() {
        val sessionType = timerManager.currentSessionType.value
        val elapsedTime = timerManager.skipSession()
        
        // Save skipped session (matches iOS session saving in skipSession)
        serviceScope.launch {
            saveSessionUseCase(
                type = sessionType,
                duration = elapsedTime,
                wasCompleted = false
            )
            
            // Check if we should auto-start next session
            val settings = settingsRepository.getSettings().first()
            val shouldAutoStart = when (sessionType) {
                SessionType.FOCUS -> settings.autoStartBreaks
                SessionType.SHORT_BREAK, SessionType.LONG_BREAK -> settings.autoStartFocus
            }
            
            if (shouldAutoStart) {
                // Auto-start the next session
                timerManager.startTimer()
                updateNotification()
            } else {
                // Stop foreground service
                stopForegroundService()
            }
        }
    }
    
    /**
     * Handle stop action
     */
    private fun handleStop() {
        stopForegroundService()
    }
    
    /**
     * Create notification for current timer state
     */
    private fun createNotification() = notificationHelper.createTimerNotification(
        sessionType = timerManager.currentSessionType.value,
        remainingTime = timerManager.getFormattedRemainingTime(),
        isRunning = timerManager.isRunning()
    )
    
    /**
     * Update notification
     */
    private fun updateNotification() {
        notificationHelper.updateTimerNotification(
            sessionType = timerManager.currentSessionType.value,
            remainingTime = timerManager.getFormattedRemainingTime(),
            isRunning = timerManager.isRunning()
        )
    }
    
    /**
     * Stop foreground service and cleanup
     */
    private fun stopForegroundService() {
        notificationHelper.cancelTimerNotification()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        serviceScope.cancel()
        notificationHelper.cancelTimerNotification()
    }
}
