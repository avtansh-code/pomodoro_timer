package avtanshgupta.PomodoroTimer.data.local.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import avtanshgupta.PomodoroTimer.domain.model.AppThemeType
import avtanshgupta.PomodoroTimer.domain.model.TimerSettings
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject
import javax.inject.Singleton

/**
 * DataStore implementation for persisting timer settings.
 * Maps to iOS PersistenceManager settings functionality.
 */
@Singleton
class SettingsDataStore @Inject constructor(
    private val dataStore: DataStore<Preferences>
) {
    
    private object Keys {
        val FOCUS_DURATION = longPreferencesKey("focus_duration")
        val SHORT_BREAK_DURATION = longPreferencesKey("short_break_duration")
        val LONG_BREAK_DURATION = longPreferencesKey("long_break_duration")
        val SESSIONS_UNTIL_LONG_BREAK = intPreferencesKey("sessions_until_long_break")
        val AUTO_START_BREAKS = booleanPreferencesKey("auto_start_breaks")
        val AUTO_START_FOCUS = booleanPreferencesKey("auto_start_focus")
        val SOUND_ENABLED = booleanPreferencesKey("sound_enabled")
        val HAPTIC_ENABLED = booleanPreferencesKey("haptic_enabled")
        val NOTIFICATIONS_ENABLED = booleanPreferencesKey("notifications_enabled")
        val SELECTED_THEME = stringPreferencesKey("selected_theme")
        val SELECTED_CUSTOM_THEME = stringPreferencesKey("selected_custom_theme")
        val FOCUS_MODE_ENABLED = booleanPreferencesKey("focus_mode_enabled")
        val SYNC_WITH_FOCUS_MODE = booleanPreferencesKey("sync_with_focus_mode")
    }
    
    /**
     * Get settings as a Flow (reactive updates)
     */
    val settingsFlow: Flow<TimerSettings> = dataStore.data.map { preferences ->
        TimerSettings(
            focusDuration = preferences[Keys.FOCUS_DURATION] ?: TimerSettings.DEFAULT.focusDuration,
            shortBreakDuration = preferences[Keys.SHORT_BREAK_DURATION] ?: TimerSettings.DEFAULT.shortBreakDuration,
            longBreakDuration = preferences[Keys.LONG_BREAK_DURATION] ?: TimerSettings.DEFAULT.longBreakDuration,
            sessionsUntilLongBreak = preferences[Keys.SESSIONS_UNTIL_LONG_BREAK] ?: TimerSettings.DEFAULT.sessionsUntilLongBreak,
            autoStartBreaks = preferences[Keys.AUTO_START_BREAKS] ?: TimerSettings.DEFAULT.autoStartBreaks,
            autoStartFocus = preferences[Keys.AUTO_START_FOCUS] ?: TimerSettings.DEFAULT.autoStartFocus,
            soundEnabled = preferences[Keys.SOUND_ENABLED] ?: TimerSettings.DEFAULT.soundEnabled,
            hapticEnabled = preferences[Keys.HAPTIC_ENABLED] ?: TimerSettings.DEFAULT.hapticEnabled,
            notificationsEnabled = preferences[Keys.NOTIFICATIONS_ENABLED] ?: TimerSettings.DEFAULT.notificationsEnabled,
            selectedTheme = preferences[Keys.SELECTED_THEME]?.let { AppThemeType.fromString(it) } ?: TimerSettings.DEFAULT.selectedTheme,
            selectedCustomTheme = preferences[Keys.SELECTED_CUSTOM_THEME] ?: TimerSettings.DEFAULT.selectedCustomTheme,
            focusModeEnabled = preferences[Keys.FOCUS_MODE_ENABLED] ?: TimerSettings.DEFAULT.focusModeEnabled,
            syncWithFocusMode = preferences[Keys.SYNC_WITH_FOCUS_MODE] ?: TimerSettings.DEFAULT.syncWithFocusMode
        )
    }
    
    /**
     * Save complete settings
     */
    suspend fun saveSettings(settings: TimerSettings) {
        dataStore.edit { preferences ->
            preferences[Keys.FOCUS_DURATION] = settings.focusDuration
            preferences[Keys.SHORT_BREAK_DURATION] = settings.shortBreakDuration
            preferences[Keys.LONG_BREAK_DURATION] = settings.longBreakDuration
            preferences[Keys.SESSIONS_UNTIL_LONG_BREAK] = settings.sessionsUntilLongBreak
            preferences[Keys.AUTO_START_BREAKS] = settings.autoStartBreaks
            preferences[Keys.AUTO_START_FOCUS] = settings.autoStartFocus
            preferences[Keys.SOUND_ENABLED] = settings.soundEnabled
            preferences[Keys.HAPTIC_ENABLED] = settings.hapticEnabled
            preferences[Keys.NOTIFICATIONS_ENABLED] = settings.notificationsEnabled
            preferences[Keys.SELECTED_THEME] = settings.selectedTheme.name
            preferences[Keys.SELECTED_CUSTOM_THEME] = settings.selectedCustomTheme
            preferences[Keys.FOCUS_MODE_ENABLED] = settings.focusModeEnabled
            preferences[Keys.SYNC_WITH_FOCUS_MODE] = settings.syncWithFocusMode
        }
    }
    
    /**
     * Update focus duration
     */
    suspend fun updateFocusDuration(duration: Long) {
        dataStore.edit { preferences ->
            preferences[Keys.FOCUS_DURATION] = duration
        }
    }
    
    /**
     * Update short break duration
     */
    suspend fun updateShortBreakDuration(duration: Long) {
        dataStore.edit { preferences ->
            preferences[Keys.SHORT_BREAK_DURATION] = duration
        }
    }
    
    /**
     * Update long break duration
     */
    suspend fun updateLongBreakDuration(duration: Long) {
        dataStore.edit { preferences ->
            preferences[Keys.LONG_BREAK_DURATION] = duration
        }
    }
    
    /**
     * Update sessions until long break
     */
    suspend fun updateSessionsUntilLongBreak(count: Int) {
        dataStore.edit { preferences ->
            preferences[Keys.SESSIONS_UNTIL_LONG_BREAK] = count
        }
    }
    
    /**
     * Update auto start breaks setting
     */
    suspend fun updateAutoStartBreaks(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[Keys.AUTO_START_BREAKS] = enabled
        }
    }
    
    /**
     * Update auto start focus setting
     */
    suspend fun updateAutoStartFocus(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[Keys.AUTO_START_FOCUS] = enabled
        }
    }
    
    /**
     * Update sound enabled setting
     */
    suspend fun updateSoundEnabled(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[Keys.SOUND_ENABLED] = enabled
        }
    }
    
    /**
     * Update haptic enabled setting
     */
    suspend fun updateHapticEnabled(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[Keys.HAPTIC_ENABLED] = enabled
        }
    }
    
    /**
     * Update notifications enabled setting
     */
    suspend fun updateNotificationsEnabled(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[Keys.NOTIFICATIONS_ENABLED] = enabled
        }
    }
    
    /**
     * Update selected theme
     */
    suspend fun updateSelectedTheme(theme: AppThemeType) {
        dataStore.edit { preferences ->
            preferences[Keys.SELECTED_THEME] = theme.name
        }
    }
    
    /**
     * Update selected custom theme
     */
    suspend fun updateSelectedCustomTheme(themeId: String) {
        dataStore.edit { preferences ->
            preferences[Keys.SELECTED_CUSTOM_THEME] = themeId
        }
    }
    
    /**
     * Update focus mode enabled setting
     */
    suspend fun updateFocusModeEnabled(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[Keys.FOCUS_MODE_ENABLED] = enabled
        }
    }
    
    /**
     * Update sync with focus mode setting
     */
    suspend fun updateSyncWithFocusMode(enabled: Boolean) {
        dataStore.edit { preferences ->
            preferences[Keys.SYNC_WITH_FOCUS_MODE] = enabled
        }
    }
    
    /**
     * Clear all settings
     */
    suspend fun clearAllSettings() {
        dataStore.edit { preferences ->
            preferences.clear()
        }
    }
}
