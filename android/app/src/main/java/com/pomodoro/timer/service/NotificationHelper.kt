package com.pomodoro.timer.service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import com.pomodoro.timer.MainActivity
import com.pomodoro.timer.R
import com.pomodoro.timer.domain.model.SessionType
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Helper class for creating and managing timer notifications.
 * Provides notification channels and notification builders.
 */
@Singleton
class NotificationHelper @Inject constructor(
    @ApplicationContext private val context: Context
) {
    
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    
    companion object {
        const val CHANNEL_ID_TIMER = "pomodoro_timer_channel"
        const val NOTIFICATION_ID_TIMER = 1001
        
        const val ACTION_PAUSE = "com.pomodoro.timer.PAUSE"
        const val ACTION_RESUME = "com.pomodoro.timer.RESUME"
        const val ACTION_RESET = "com.pomodoro.timer.RESET"
        const val ACTION_SKIP = "com.pomodoro.timer.SKIP"
    }
    
    init {
        createNotificationChannels()
    }
    
    /**
     * Create notification channels (required for Android O+)
     */
    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val timerChannel = NotificationChannel(
                CHANNEL_ID_TIMER,
                context.getString(R.string.notification_channel_timer),
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = context.getString(R.string.notification_channel_timer_desc)
                setShowBadge(false)
                enableVibration(false)
                enableLights(false)
            }
            
            notificationManager.createNotificationChannel(timerChannel)
        }
    }
    
    /**
     * Create foreground service notification for running timer
     */
    fun createTimerNotification(
        sessionType: SessionType,
        remainingTime: String,
        isRunning: Boolean
    ): Notification {
        val contentIntent = PendingIntent.getActivity(
            context,
            0,
            Intent(context, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        
        val title = when (sessionType) {
            SessionType.FOCUS -> context.getString(R.string.session_focus)
            SessionType.SHORT_BREAK -> context.getString(R.string.session_short_break)
            SessionType.LONG_BREAK -> context.getString(R.string.session_long_break)
        }
        
        val builder = NotificationCompat.Builder(context, CHANNEL_ID_TIMER)
            .setContentTitle(title)
            .setContentText(remainingTime)
            .setSmallIcon(R.drawable.ic_launcher_foreground)
            .setContentIntent(contentIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_PROGRESS)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
        
        // Add pause/resume action
        if (isRunning) {
            val pauseIntent = createActionIntent(ACTION_PAUSE)
            builder.addAction(
                0,
                context.getString(R.string.action_pause),
                pauseIntent
            )
        } else {
            val resumeIntent = createActionIntent(ACTION_RESUME)
            builder.addAction(
                0,
                context.getString(R.string.action_resume),
                resumeIntent
            )
        }
        
        // Add reset action
        val resetIntent = createActionIntent(ACTION_RESET)
        builder.addAction(
            0,
            context.getString(R.string.action_reset),
            resetIntent
        )
        
        return builder.build()
    }
    
    /**
     * Create completion notification
     */
    fun showCompletionNotification(sessionType: SessionType) {
        val title = context.getString(R.string.notification_session_complete)
        val message = when (sessionType) {
            SessionType.FOCUS -> "Focus session completed! Time for a break."
            SessionType.SHORT_BREAK -> "Short break completed! Ready to focus?"
            SessionType.LONG_BREAK -> "Long break completed! Ready to focus?"
        }
        
        val contentIntent = PendingIntent.getActivity(
            context,
            0,
            Intent(context, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        
        val notification = NotificationCompat.Builder(context, CHANNEL_ID_TIMER)
            .setContentTitle(title)
            .setContentText(message)
            .setSmallIcon(R.drawable.ic_launcher_foreground)
            .setContentIntent(contentIntent)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .build()
        
        notificationManager.notify(NOTIFICATION_ID_TIMER + 1, notification)
    }
    
    /**
     * Update timer notification
     */
    fun updateTimerNotification(
        sessionType: SessionType,
        remainingTime: String,
        isRunning: Boolean
    ) {
        val notification = createTimerNotification(sessionType, remainingTime, isRunning)
        notificationManager.notify(NOTIFICATION_ID_TIMER, notification)
    }
    
    /**
     * Cancel timer notification
     */
    fun cancelTimerNotification() {
        notificationManager.cancel(NOTIFICATION_ID_TIMER)
    }
    
    /**
     * Cancel all notifications
     */
    fun cancelAllNotifications() {
        notificationManager.cancelAll()
    }
    
    /**
     * Create pending intent for notification actions
     */
    private fun createActionIntent(action: String): PendingIntent {
        val intent = Intent(context, TimerService::class.java).apply {
            this.action = action
        }
        return PendingIntent.getService(
            context,
            action.hashCode(),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    }
    
    /**
     * Check if notifications are enabled
     */
    fun areNotificationsEnabled(): Boolean {
        return notificationManager.areNotificationsEnabled()
    }
}
