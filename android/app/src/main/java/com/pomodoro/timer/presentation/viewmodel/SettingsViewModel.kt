package com.pomodoro.timer.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.pomodoro.timer.domain.model.AppTheme
import com.pomodoro.timer.domain.model.AppThemeType
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerSettings
import com.pomodoro.timer.domain.repository.SettingsRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * ViewModel for the settings screen.
 * Manages app settings, theme selection, and preferences.
 * 
 * Maps to iOS SettingsView functionality.
 */
@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val settingsRepository: SettingsRepository
) : ViewModel() {
    
    // Settings state
    private val _settings = MutableStateFlow(TimerSettings.DEFAULT)
    val settings: StateFlow<TimerSettings> = _settings.asStateFlow()
    
    // UI state
    private val _isSaving = MutableStateFlow(false)
    val isSaving: StateFlow<Boolean> = _isSaving.asStateFlow()
    
    init {
        loadSettings()
    }
    
    /**
     * Load current settings
     */
    private fun loadSettings() {
        viewModelScope.launch {
            settingsRepository.getSettings().collect { newSettings ->
                _settings.value = newSettings
            }
        }
    }
    
    /**
     * Update focus duration (in minutes)
     */
    fun updateFocusDuration(minutes: Int) {
        if (TimerSettings.isValidDuration(minutes)) {
            viewModelScope.launch {
                _isSaving.value = true
                settingsRepository.updateFocusDuration(minutes)
                _isSaving.value = false
            }
        }
    }
    
    /**
     * Update short break duration (in minutes)
     */
    fun updateShortBreakDuration(minutes: Int) {
        if (TimerSettings.isValidDuration(minutes)) {
            viewModelScope.launch {
                _isSaving.value = true
                settingsRepository.updateShortBreakDuration(minutes)
                _isSaving.value = false
            }
        }
    }
    
    /**
     * Update long break duration (in minutes)
     */
    fun updateLongBreakDuration(minutes: Int) {
        if (TimerSettings.isValidDuration(minutes)) {
            viewModelScope.launch {
                _isSaving.value = true
                settingsRepository.updateLongBreakDuration(minutes)
                _isSaving.value = false
            }
        }
    }
    
    /**
     * Update sessions until long break
     */
    fun updateSessionsUntilLongBreak(count: Int) {
        if (TimerSettings.isValidSessionsCount(count)) {
            viewModelScope.launch {
                _isSaving.value = true
                settingsRepository.updateSessionsUntilLongBreak(count)
                _isSaving.value = false
            }
        }
    }
    
    /**
     * Toggle auto start breaks
     */
    fun toggleAutoStartBreaks() {
        viewModelScope.launch {
            val newValue = !_settings.value.autoStartBreaks
            settingsRepository.updateAutoStartBreaks(newValue)
        }
    }
    
    /**
     * Toggle auto start focus
     */
    fun toggleAutoStartFocus() {
        viewModelScope.launch {
            val newValue = !_settings.value.autoStartFocus
            settingsRepository.updateAutoStartFocus(newValue)
        }
    }
    
    /**
     * Toggle sound
     */
    fun toggleSound() {
        viewModelScope.launch {
            val newValue = !_settings.value.soundEnabled
            settingsRepository.updateSoundEnabled(newValue)
        }
    }
    
    /**
     * Toggle haptic feedback
     */
    fun toggleHaptic() {
        viewModelScope.launch {
            val newValue = !_settings.value.hapticEnabled
            settingsRepository.updateHapticEnabled(newValue)
        }
    }
    
    /**
     * Toggle notifications
     */
    fun toggleNotifications() {
        viewModelScope.launch {
            val newValue = !_settings.value.notificationsEnabled
            settingsRepository.updateNotificationsEnabled(newValue)
        }
    }
    
    /**
     * Toggle focus mode
     */
    fun toggleFocusMode() {
        viewModelScope.launch {
            val newValue = !_settings.value.focusModeEnabled
            settingsRepository.updateFocusModeEnabled(newValue)
        }
    }
    
    /**
     * Toggle sync with focus mode
     */
    fun toggleSyncWithFocusMode() {
        viewModelScope.launch {
            val newValue = !_settings.value.syncWithFocusMode
            settingsRepository.updateSyncWithFocusMode(newValue)
        }
    }
    
    /**
     * Update selected theme type
     */
    fun updateThemeType(themeType: AppThemeType) {
        viewModelScope.launch {
            val updatedSettings = _settings.value.copy(selectedTheme = themeType)
            settingsRepository.saveSettings(updatedSettings)
        }
    }
    
    /**
     * Update selected custom theme
     */
    fun updateCustomTheme(themeId: String) {
        viewModelScope.launch {
            settingsRepository.updateSelectedTheme(themeId)
        }
    }
    
    /**
     * Get all available themes
     */
    fun getAvailableThemes(): List<AppTheme> {
        return AppTheme.allThemes
    }
    
    /**
     * Get current theme
     */
    fun getCurrentTheme(): AppTheme {
        val themeId = _settings.value.selectedCustomTheme
        return AppTheme.getById(themeId)
    }
    
    /**
     * Reset all settings to defaults
     */
    fun resetToDefaults() {
        viewModelScope.launch {
            _isSaving.value = true
            settingsRepository.resetToDefaults()
            _isSaving.value = false
        }
    }
    
    /**
     * Get duration in minutes for a session type
     */
    fun getDurationMinutes(sessionType: SessionType): Int {
        return _settings.value.getDurationInMinutes(sessionType)
    }
    
    /**
     * Validate duration input
     */
    fun isValidDuration(minutes: Int): Boolean {
        return TimerSettings.isValidDuration(minutes)
    }
    
    /**
     * Validate sessions count input
     */
    fun isValidSessionsCount(count: Int): Boolean {
        return TimerSettings.isValidSessionsCount(count)
    }
    
    /**
     * Get duration range
     */
    fun getDurationRange(): IntRange {
        return TimerSettings.MIN_DURATION_MINUTES..TimerSettings.MAX_DURATION_MINUTES
    }
    
    /**
     * Get sessions count range
     */
    fun getSessionsCountRange(): IntRange {
        return TimerSettings.MIN_SESSIONS..TimerSettings.MAX_SESSIONS
    }
}
