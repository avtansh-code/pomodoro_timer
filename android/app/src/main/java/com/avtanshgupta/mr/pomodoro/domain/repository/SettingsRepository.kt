package com.avtanshgupta.mr.pomodoro.domain.repository

import com.avtanshgupta.mr.pomodoro.domain.model.TimerSettings
import kotlinx.coroutines.flow.Flow

/**
 * Repository interface for managing user settings.
 * Maps to settings-related functionality in iOS PersistenceManager.swift
 */
interface SettingsRepository {
    
    /**
     * Get settings as a Flow (reactive updates)
     */
    fun getSettings(): Flow<TimerSettings>
    
    /**
     * Get current settings (one-time read)
     */
    suspend fun getCurrentSettings(): TimerSettings
    
    /**
     * Save settings
     */
    suspend fun saveSettings(settings: TimerSettings)
    
    /**
     * Update specific setting without loading all settings
     */
    suspend fun updateFocusDuration(minutes: Int)
    suspend fun updateShortBreakDuration(minutes: Int)
    suspend fun updateLongBreakDuration(minutes: Int)
    suspend fun updateSessionsUntilLongBreak(count: Int)
    suspend fun updateAutoStartBreaks(enabled: Boolean)
    suspend fun updateAutoStartFocus(enabled: Boolean)
    suspend fun updateSoundEnabled(enabled: Boolean)
    suspend fun updateHapticEnabled(enabled: Boolean)
    suspend fun updateNotificationsEnabled(enabled: Boolean)
    suspend fun updateSelectedTheme(themeId: String)
    suspend fun updateFocusModeEnabled(enabled: Boolean)
    suspend fun updateSyncWithFocusMode(enabled: Boolean)
    
    /**
     * Reset settings to defaults
     */
    suspend fun resetToDefaults()
    
    /**
     * Clear all settings data
     */
    suspend fun clearAllSettings()
}
