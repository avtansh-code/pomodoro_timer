package com.pomodoro.timer.ui.screens.screenshot

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.pomodoro.timer.manager.ScreenshotHelper
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

/**
 * Screenshot Preparation Screen - Developer Tools
 * 
 * Maps to iOS ScreenshotPreparationView.swift
 * 
 * Provides UI for:
 * - Generating dummy statistics data
 * - Creating specific timer states for screenshots
 * - Cleaning up test data
 * - Different scenarios (focus, break, statistics views)
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ScreenshotPreparationScreen(
    onBackClick: () -> Unit,
    viewModel: ScreenshotViewModel = viewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Screenshot Preparation") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface
                )
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Warning card
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.errorContainer
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Column(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = "⚠️ Developer Tool",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.onErrorContainer
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "This screen generates dummy data for Play Store screenshots. " +
                                "Make sure to clean up test data after use.",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onErrorContainer
                    )
                }
            }
            
            // Status indicator
            if (uiState.isLoading) {
                LinearProgressIndicator(
                    modifier = Modifier.fillMaxWidth()
                )
            }
            
            if (uiState.message.isNotEmpty()) {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(
                        containerColor = if (uiState.isSuccess) {
                            MaterialTheme.colorScheme.primaryContainer
                        } else {
                            MaterialTheme.colorScheme.errorContainer
                        }
                    )
                ) {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        if (uiState.isSuccess) {
                            Icon(
                                imageVector = Icons.Default.CheckCircle,
                                contentDescription = null,
                                tint = MaterialTheme.colorScheme.onPrimaryContainer
                            )
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Text(
                            text = uiState.message,
                            style = MaterialTheme.typography.bodyMedium,
                            color = if (uiState.isSuccess) {
                                MaterialTheme.colorScheme.onPrimaryContainer
                            } else {
                                MaterialTheme.colorScheme.onErrorContainer
                            }
                        )
                    }
                }
            }
            
            // Statistics Data Section
            Text(
                text = "Statistics Data",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold
            )
            
            ScenarioButton(
                title = "Generate Full Statistics",
                description = "60 days of session data with 3-8 sessions per day",
                enabled = !uiState.isLoading,
                onClick = { viewModel.generateFullStatistics() }
            )
            
            ScenarioButton(
                title = "Generate Week View Data",
                description = "7 days of concentrated session data",
                enabled = !uiState.isLoading,
                onClick = { viewModel.generateWeekViewData() }
            )
            
            ScenarioButton(
                title = "Generate Month View Data",
                description = "Current month with consistent patterns",
                enabled = !uiState.isLoading,
                onClick = { viewModel.generateMonthViewData() }
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            // Timer States Section
            Text(
                text = "Timer States",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold
            )
            
            ScenarioButton(
                title = "Focus Session (In Progress)",
                description = "Timer at 50% completion",
                enabled = !uiState.isLoading,
                onClick = { viewModel.generateFocusInProgress() }
            )
            
            ScenarioButton(
                title = "Break Session",
                description = "Short break in progress",
                enabled = !uiState.isLoading,
                onClick = { viewModel.generateBreakSession() }
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            // Cleanup Section
            Text(
                text = "Cleanup",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.error
            )
            
            Button(
                onClick = { viewModel.clearAllData() },
                enabled = !uiState.isLoading,
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(
                    containerColor = MaterialTheme.colorScheme.error
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Icon(
                    imageVector = Icons.Default.Delete,
                    contentDescription = null
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text("Clear All Test Data")
            }
            
            // Instructions
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surfaceVariant
                )
            ) {
                Column(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = "📸 Screenshot Tips",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "1. Generate data for desired scenario\n" +
                                "2. Navigate to the screen you want to capture\n" +
                                "3. Take your screenshot\n" +
                                "4. Clear test data when done\n\n" +
                                "Tip: Use 'Focus Session (In Progress)' for timer screenshots",
                        style = MaterialTheme.typography.bodyMedium
                    )
                }
            }
        }
    }
}

@Composable
private fun ScenarioButton(
    title: String,
    description: String,
    enabled: Boolean,
    onClick: () -> Unit
) {
    OutlinedButton(
        onClick = onClick,
        enabled = enabled,
        modifier = Modifier
            .fillMaxWidth()
            .height(80.dp),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.SemiBold,
                textAlign = TextAlign.Start
            )
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = description,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                textAlign = TextAlign.Start
            )
        }
    }
}

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
