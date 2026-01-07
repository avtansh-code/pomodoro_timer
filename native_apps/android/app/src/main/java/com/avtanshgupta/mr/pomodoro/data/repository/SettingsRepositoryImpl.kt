package avtanshgupta.PomodoroTimer.data.repository

import avtanshgupta.PomodoroTimer.data.local.datastore.SettingsDataStore
import avtanshgupta.PomodoroTimer.domain.model.TimerSettings
import avtanshgupta.PomodoroTimer.domain.repository.SettingsRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Implementation of SettingsRepository using DataStore.
 * Maps to iOS PersistenceManager settings functionality.
 */
@Singleton
class SettingsRepositoryImpl @Inject constructor(
    private val settingsDataStore: SettingsDataStore
) : SettingsRepository {
    
    override fun getSettings(): Flow<TimerSettings> {
        return settingsDataStore.settingsFlow
    }
    
    override suspend fun getCurrentSettings(): TimerSettings {
        return settingsDataStore.settingsFlow.first()
    }
    
    override suspend fun saveSettings(settings: TimerSettings) {
        settingsDataStore.saveSettings(settings)
    }
    
    override suspend fun updateFocusDuration(minutes: Int) {
        if (TimerSettings.isValidDuration(minutes)) {
            settingsDataStore.updateFocusDuration(minutes * 60L)
        }
    }
    
    override suspend fun updateShortBreakDuration(minutes: Int) {
        if (TimerSettings.isValidDuration(minutes)) {
            settingsDataStore.updateShortBreakDuration(minutes * 60L)
        }
    }
    
    override suspend fun updateLongBreakDuration(minutes: Int) {
        if (TimerSettings.isValidDuration(minutes)) {
            settingsDataStore.updateLongBreakDuration(minutes * 60L)
        }
    }
    
    override suspend fun updateSessionsUntilLongBreak(count: Int) {
        if (TimerSettings.isValidSessionsCount(count)) {
            settingsDataStore.updateSessionsUntilLongBreak(count)
        }
    }
    
    override suspend fun updateAutoStartBreaks(enabled: Boolean) {
        settingsDataStore.updateAutoStartBreaks(enabled)
    }
    
    override suspend fun updateAutoStartFocus(enabled: Boolean) {
        settingsDataStore.updateAutoStartFocus(enabled)
    }
    
    override suspend fun updateSoundEnabled(enabled: Boolean) {
        settingsDataStore.updateSoundEnabled(enabled)
    }
    
    override suspend fun updateHapticEnabled(enabled: Boolean) {
        settingsDataStore.updateHapticEnabled(enabled)
    }
    
    override suspend fun updateNotificationsEnabled(enabled: Boolean) {
        settingsDataStore.updateNotificationsEnabled(enabled)
    }
    
    override suspend fun updateSelectedTheme(themeId: String) {
        settingsDataStore.updateSelectedCustomTheme(themeId)
    }
    
    override suspend fun updateFocusModeEnabled(enabled: Boolean) {
        settingsDataStore.updateFocusModeEnabled(enabled)
    }
    
    override suspend fun updateSyncWithFocusMode(enabled: Boolean) {
        settingsDataStore.updateSyncWithFocusMode(enabled)
    }
    
    override suspend fun resetToDefaults() {
        settingsDataStore.saveSettings(TimerSettings.DEFAULT)
    }
    
    override suspend fun clearAllSettings() {
        settingsDataStore.clearAllSettings()
    }
}
