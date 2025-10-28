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
 * Foreground service for running the Pomodoro timer in the background.
 * Ensures timer continues running even when app is backgrounded.
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
    
    companion object {
        const val EXTRA_SESSION_TYPE = "session_type"
        const val EXTRA_DURATION = "duration"
        
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
        
        // Observe timer state changes
        observeTimerState()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        
        when (intent?.action) {
            ACTION_START -> handleStart(intent)
            ACTION_PAUSE -> handlePause()
            ACTION_RESUME -> handleResume()
            ACTION_RESET -> handleReset()
            ACTION_SKIP -> handleSkip()
            ACTION_STOP -> handleStop()
        }
        
        return START_STICKY
    }
    
    override fun onBind(intent: Intent): IBinder? {
        return null
    }
    
    /**
     * Observe timer state and update notification
     */
    private fun observeTimerState() {
        // Observe state changes
        timerManager.state.onEach { state ->
            handleStateChange(state)
        }.launchIn(serviceScope)
        
        // Observe remaining time for notification updates
        timerManager.remainingSeconds.onEach { remainingSeconds ->
            if (timerManager.state.value != TimerState.IDLE) {
                updateNotification()
            }
        }.launchIn(serviceScope)
    }
    
    /**
     * Handle state changes
     */
    private fun handleStateChange(newState: TimerState) {
        when {
            // Timer just completed
            previousState == TimerState.RUNNING && newState == TimerState.IDLE -> {
                handleTimerCompletion()
            }
            // Timer started or resumed
            newState == TimerState.RUNNING -> {
                startForeground(
                    NotificationHelper.NOTIFICATION_ID_TIMER,
                    createNotification()
                )
            }
            // Timer reset or stopped
            newState == TimerState.IDLE && previousState != TimerState.RUNNING -> {
                stopForegroundService()
            }
        }
        
        previousState = newState
    }
    
    /**
     * Handle timer completion
     */
    private fun handleTimerCompletion() {
        val sessionType = timerManager.sessionType.value
        val duration = timerManager.totalSeconds.value
        
        // Save completed session
        serviceScope.launch {
            saveSessionUseCase(
                type = sessionType,
                duration = duration,
                wasCompleted = true
            )
        }
        
        // Show completion notification
        notificationHelper.showCompletionNotification(sessionType)
        
        // Stop foreground service
        stopForegroundService()
    }
    
    /**
     * Handle start action
     */
    private fun handleStart(intent: Intent) {
        val sessionTypeString = intent.getStringExtra(EXTRA_SESSION_TYPE) ?: SessionType.FOCUS.name
        val duration = intent.getLongExtra(EXTRA_DURATION, 25 * 60L)
        
        val sessionType = try {
            SessionType.valueOf(sessionTypeString)
        } catch (e: IllegalArgumentException) {
            SessionType.FOCUS
        }
        
        timerManager.start(sessionType, duration)
        
        // Start as foreground service
        startForeground(
            NotificationHelper.NOTIFICATION_ID_TIMER,
            createNotification()
        )
    }
    
    /**
     * Handle pause action
     */
    private fun handlePause() {
        timerManager.pause()
        updateNotification()
    }
    
    /**
     * Handle resume action
     */
    private fun handleResume() {
        timerManager.resume()
        updateNotification()
    }
    
    /**
     * Handle reset action
     */
    private fun handleReset() {
        // Save as skipped session if timer was running
        if (timerManager.state.value != TimerState.IDLE) {
            val sessionType = timerManager.sessionType.value
            val totalDuration = timerManager.totalSeconds.value
            val elapsedDuration = totalDuration - timerManager.remainingSeconds.value
            
            serviceScope.launch {
                saveSessionUseCase(
                    type = sessionType,
                    duration = elapsedDuration,
                    wasCompleted = false
                )
            }
        }
        
        timerManager.reset()
        stopForegroundService()
    }
    
    /**
     * Handle skip action
     */
    private fun handleSkip() {
        // Save as skipped session
        val sessionType = timerManager.sessionType.value
        val totalDuration = timerManager.totalSeconds.value
        val elapsedDuration = totalDuration - timerManager.remainingSeconds.value
        
        serviceScope.launch {
            saveSessionUseCase(
                type = sessionType,
                duration = elapsedDuration,
                wasCompleted = false
            )
        }
        
        // Increment completed sessions if it was a focus session
        if (sessionType == SessionType.FOCUS) {
            timerManager.incrementCompletedSessions()
        }
        
        val completedSessions = timerManager.completedSessions.value
        
        // Determine next session type
        serviceScope.launch {
            val settings = settingsRepository.getSettings().first()
            
            val nextSessionType = when (sessionType) {
                SessionType.FOCUS -> {
                    // After focus, go to break
                    if (completedSessions % settings.sessionsUntilLongBreak == 0) {
                        SessionType.LONG_BREAK
                    } else {
                        SessionType.SHORT_BREAK
                    }
                }
                SessionType.SHORT_BREAK, SessionType.LONG_BREAK -> {
                    // After break, go to focus
                    SessionType.FOCUS
                }
            }
            
            timerManager.skip()
            
            val nextDuration = settings.getDuration(nextSessionType)
            timerManager.start(nextSessionType, nextDuration)
            updateNotification()
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
        sessionType = timerManager.sessionType.value,
        remainingTime = timerManager.getFormattedRemainingTime(),
        isRunning = timerManager.isRunning()
    )
    
    /**
     * Update notification
     */
    private fun updateNotification() {
        notificationHelper.updateTimerNotification(
            sessionType = timerManager.sessionType.value,
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
