package com.pomodoro.timer.manager

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Manager for Android Do Not Disturb (DND) functionality
 * 
 * Maps to iOS FocusModeManager.swift
 * 
 * Provides:
 * - DND mode activation/deactivation
 * - Permission checking and requesting
 * - DND status monitoring
 * - Integration with TimerService for auto-DND during focus sessions
 */
@Singleton
class DoNotDisturbManager @Inject constructor(
    @ApplicationContext private val context: Context
) {
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    
    // State management
    private val _isAuthorized = MutableStateFlow(false)
    val isAuthorized: StateFlow<Boolean> = _isAuthorized.asStateFlow()
    
    private val _isDndActive = MutableStateFlow(false)
    val isDndActive: StateFlow<Boolean> = _isDndActive.asStateFlow()
    
    init {
        checkAuthorization()
        updateDndStatus()
    }
    
    /**
     * Check if app has DND permission
     */
    fun checkAuthorization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            _isAuthorized.value = notificationManager.isNotificationPolicyAccessGranted
        } else {
            // DND API not available on pre-M devices
            _isAuthorized.value = false
        }
    }
    
    /**
     * Request DND permission from user
     * Opens system settings for DND access
     */
    @RequiresApi(Build.VERSION_CODES.M)
    fun requestAuthorization() {
        if (!notificationManager.isNotificationPolicyAccessGranted) {
            val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
        }
    }
    
    /**
     * Update current DND status
     */
    fun updateDndStatus() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val currentFilter = notificationManager.currentInterruptionFilter
            _isDndActive.value = when (currentFilter) {
                NotificationManager.INTERRUPTION_FILTER_NONE,
                NotificationManager.INTERRUPTION_FILTER_PRIORITY,
                NotificationManager.INTERRUPTION_FILTER_ALARMS -> true
                else -> false
            }
        } else {
            _isDndActive.value = false
        }
    }
    
    /**
     * Enable Do Not Disturb mode
     * Requires INTERRUPTION_FILTER permission
     * 
     * @return true if successfully enabled, false otherwise
     */
    @RequiresApi(Build.VERSION_CODES.M)
    fun enableDnd(): Boolean {
        if (!notificationManager.isNotificationPolicyAccessGranted) {
            return false
        }
        
        return try {
            // Set DND to Priority mode (allows alarms and specific notifications)
            notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY)
            updateDndStatus()
            true
        } catch (e: SecurityException) {
            e.printStackTrace()
            false
        }
    }
    
    /**
     * Disable Do Not Disturb mode
     * Restores normal notification behavior
     * 
     * @return true if successfully disabled, false otherwise
     */
    @RequiresApi(Build.VERSION_CODES.M)
    fun disableDnd(): Boolean {
        if (!notificationManager.isNotificationPolicyAccessGranted) {
            return false
        }
        
        return try {
            // Restore to normal (all) interruptions
            notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
            updateDndStatus()
            true
        } catch (e: SecurityException) {
            e.printStackTrace()
            false
        }
    }
    
    /**
     * Toggle DND mode
     * 
     * @return true if operation succeeded, false otherwise
     */
    @RequiresApi(Build.VERSION_CODES.M)
    fun toggleDnd(): Boolean {
        return if (_isDndActive.value) {
            disableDnd()
        } else {
            enableDnd()
        }
    }
    
    /**
     * Enable DND for focus session
     * Called when focus session starts
     * 
     * @param enabled Whether to enable or disable DND
     */
    fun setDndForFocusSession(enabled: Boolean) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return
        }
        
        if (!_isAuthorized.value) {
            return
        }
        
        if (enabled) {
            enableDnd()
        } else {
            disableDnd()
        }
    }
    
    /**
     * Check if device supports DND
     */
    fun isDndSupported(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
    }
    
    /**
     * Get intent to open DND settings
     */
    fun getDndSettingsIntent(): Intent {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
        } else {
            Intent(Settings.ACTION_SETTINGS).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
        }
    }
    
    /**
     * Get user-friendly status message
     */
    fun getStatusMessage(): String {
        return when {
            !isDndSupported() -> "DND not supported on this device"
            !_isAuthorized.value -> "DND permission not granted"
            _isDndActive.value -> "DND is active"
            else -> "DND is inactive"
        }
    }
    
    companion object {
        private const val TAG = "DoNotDisturbManager"
    }
}
