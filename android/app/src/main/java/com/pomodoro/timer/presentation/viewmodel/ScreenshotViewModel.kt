package com.pomodoro.timer.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.pomodoro.timer.manager.ScreenshotHelper
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * UI State for Screenshot Preparation Screen
 */
data class ScreenshotUiState(
    val isLoading: Boolean = false,
    val message: String = "",
    val isSuccess: Boolean = false
)

/**
 * ViewModel for Screenshot Preparation Screen
 * 
 * Maps to iOS ScreenshotPreparationView's @StateObject manager
 * 
 * Provides state management for:
 * - Generating dummy statistics data
 * - Creating specific timer states for screenshots
 * - Cleaning up test data
 */
@HiltViewModel
class ScreenshotViewModel @Inject constructor(
    private val screenshotHelper: ScreenshotHelper
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(ScreenshotUiState())
    val uiState: StateFlow<ScreenshotUiState> = _uiState.asStateFlow()
    
    fun generateFullStatistics() {
        viewModelScope.launch {
            _uiState.value = ScreenshotUiState(isLoading = true)
            try {
                screenshotHelper.generateDummyStatistics()
                _uiState.value = ScreenshotUiState(
                    message = "✓ Generated 60 days of session data",
                    isSuccess = true
                )
            } catch (e: Exception) {
                _uiState.value = ScreenshotUiState(
                    message = "Error: ${e.message}",
                    isSuccess = false
                )
            }
        }
    }
    
    fun generateWeekViewData() {
        viewModelScope.launch {
            _uiState.value = ScreenshotUiState(isLoading = true)
            try {
                screenshotHelper.generateWeekViewData()
                _uiState.value = ScreenshotUiState(
                    message = "✓ Generated week view data",
                    isSuccess = true
                )
            } catch (e: Exception) {
                _uiState.value = ScreenshotUiState(
                    message = "Error: ${e.message}",
                    isSuccess = false
                )
            }
        }
    }
    
    fun generateMonthViewData() {
        viewModelScope.launch {
            _uiState.value = ScreenshotUiState(isLoading = true)
            try {
                screenshotHelper.generateMonthViewData()
                _uiState.value = ScreenshotUiState(
                    message = "✓ Generated month view data",
                    isSuccess = true
                )
            } catch (e: Exception) {
                _uiState.value = ScreenshotUiState(
                    message = "Error: ${e.message}",
                    isSuccess = false
                )
            }
        }
    }
    
    fun generateFocusInProgress() {
        viewModelScope.launch {
            _uiState.value = ScreenshotUiState(isLoading = true)
            try {
                screenshotHelper.generateInProgressSession(0.5f)
                _uiState.value = ScreenshotUiState(
                    message = "✓ Focus session created - navigate to Timer screen",
                    isSuccess = true
                )
            } catch (e: Exception) {
                _uiState.value = ScreenshotUiState(
                    message = "Error: ${e.message}",
                    isSuccess = false
                )
            }
        }
    }
    
    fun generateBreakSession() {
        viewModelScope.launch {
            _uiState.value = ScreenshotUiState(isLoading = true)
            try {
                screenshotHelper.generateBreakSession()
                _uiState.value = ScreenshotUiState(
                    message = "✓ Break session created - navigate to Timer screen",
                    isSuccess = true
                )
            } catch (e: Exception) {
                _uiState.value = ScreenshotUiState(
                    message = "Error: ${e.message}",
                    isSuccess = false
                )
            }
        }
    }
    
    fun clearAllData() {
        viewModelScope.launch {
            _uiState.value = ScreenshotUiState(isLoading = true)
            try {
                screenshotHelper.clearAllSessions()
                _uiState.value = ScreenshotUiState(
                    message = "✓ All test data cleared",
                    isSuccess = true
                )
            } catch (e: Exception) {
                _uiState.value = ScreenshotUiState(
                    message = "Error: ${e.message}",
                    isSuccess = false
                )
            }
        }
    }
}
