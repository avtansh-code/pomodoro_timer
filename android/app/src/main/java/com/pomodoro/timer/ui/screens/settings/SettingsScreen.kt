package com.pomodoro.timer.ui.screens.settings

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Divider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Slider
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.pomodoro.timer.domain.model.AppTheme
import com.pomodoro.timer.presentation.viewmodel.SettingsViewModel

/**
 * Settings Screen matching iOS SettingsView functionality.
 */
@Composable
fun SettingsScreen(
    viewModel: SettingsViewModel = hiltViewModel(),
    onPrivacyPolicyClick: () -> Unit = {},
    onBenefitsClick: () -> Unit = {},
    onThemeClick: () -> Unit = {},
    onScreenshotToolsClick: () -> Unit = {}
) {
    val settings by viewModel.settings.collectAsState()
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(16.dp)
    ) {
        Text(
            text = "Settings",
            style = MaterialTheme.typography.headlineLarge,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(vertical = 16.dp)
        )
        
        // Timer Durations Section
        SettingsSection(title = "Timer Durations") {
            DurationSetting(
                label = "Focus Duration",
                value = (settings.focusDuration.toInt() / 60),
                onValueChange = { viewModel.updateFocusDuration((it * 60).toInt()) },
                unit = "min",
                range = 1f..60f
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            DurationSetting(
                label = "Short Break",
                value = (settings.shortBreakDuration.toInt() / 60),
                onValueChange = { viewModel.updateShortBreakDuration((it * 60).toInt()) },
                unit = "min",
                range = 1f..30f
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            DurationSetting(
                label = "Long Break",
                value = (settings.longBreakDuration.toInt() / 60),
                onValueChange = { viewModel.updateLongBreakDuration((it * 60).toInt()) },
                unit = "min",
                range = 5f..60f
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            DurationSetting(
                label = "Sessions Until Long Break",
                value = settings.sessionsUntilLongBreak,
                onValueChange = { viewModel.updateSessionsUntilLongBreak(it.toInt()) },
                unit = "sessions",
                range = 2f..10f
            )
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Theme Selection Section
        SettingsSection(title = "Appearance") {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onThemeClick() }
                    .padding(vertical = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = "App Theme",
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Medium
                    )
                    
                    Spacer(modifier = Modifier.height(4.dp))
                    
                    Text(
                        text = AppTheme.getById(settings.selectedCustomTheme).name,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.primary
                    )
                }
                
                Spacer(modifier = Modifier.width(16.dp))
                
                // Color preview circle
                Card(
                    modifier = Modifier.size(32.dp),
                    colors = CardDefaults.cardColors(
                        containerColor = AppTheme.getById(settings.selectedCustomTheme).primaryColor
                    ),
                    shape = RoundedCornerShape(16.dp)
                ) {}
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Preferences Section
        SettingsSection(title = "Preferences") {
            ToggleSetting(
                label = "Auto-start Breaks",
                description = "Automatically start break sessions",
                checked = settings.autoStartBreaks,
                onCheckedChange = { viewModel.toggleAutoStartBreaks() }
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            ToggleSetting(
                label = "Auto-start Focus",
                description = "Automatically start focus sessions after break",
                checked = settings.autoStartFocus,
                onCheckedChange = { viewModel.toggleAutoStartFocus() }
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            ToggleSetting(
                label = "Sound Effects",
                description = "Play sounds when session completes",
                checked = settings.soundEnabled,
                onCheckedChange = { viewModel.toggleSound() }
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            ToggleSetting(
                label = "Haptic Feedback",
                description = "Vibrate on button presses",
                checked = settings.hapticEnabled,
                onCheckedChange = { viewModel.toggleHaptic() }
            )
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            ToggleSetting(
                label = "Notifications",
                description = "Show completion notifications",
                checked = settings.notificationsEnabled,
                onCheckedChange = { viewModel.toggleNotifications() }
            )
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // About Section
        SettingsSection(title = "About") {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onBenefitsClick() }
                    .padding(vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "About Pomodoro Technique",
                    style = MaterialTheme.typography.bodyLarge
                )
            }
            
            Divider(modifier = Modifier.padding(vertical = 8.dp))
            
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onPrivacyPolicyClick() }
                    .padding(vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Privacy Policy",
                    style = MaterialTheme.typography.bodyLarge
                )
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Developer Tools Section (for screenshots)
        SettingsSection(title = "Developer Tools") {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onScreenshotToolsClick() }
                    .padding(vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = "Screenshot Preparation",
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Medium
                    )
                    
                    Spacer(modifier = Modifier.height(4.dp))
                    
                    Text(
                        text = "Generate test data for Play Store screenshots",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Reset Button
        TextButton(
            onClick = { viewModel.resetToDefaults() },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                text = "Reset to Defaults",
                color = MaterialTheme.colorScheme.error
            )
        }
        
        Spacer(modifier = Modifier.height(32.dp))
    }
}

@Composable
private fun SettingsSection(
    title: String,
    content: @Composable () -> Unit
) {
    Column {
        Text(
            text = title,
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.SemiBold,
            modifier = Modifier.padding(bottom = 12.dp)
        )
        
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
            ),
            shape = RoundedCornerShape(16.dp)
        ) {
            Column(
                modifier = Modifier.padding(16.dp)
            ) {
                content()
            }
        }
    }
}

@Composable
private fun DurationSetting(
    label: String,
    value: Int,
    onValueChange: (Float) -> Unit,
    unit: String,
    range: ClosedFloatingPointRange<Float>
) {
    Column {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = label,
                style = MaterialTheme.typography.bodyLarge
            )
            
            Text(
                text = "$value $unit",
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.primary
            )
        }
        
        Slider(
            value = value.toFloat(),
            onValueChange = onValueChange,
            valueRange = range,
            steps = (range.endInclusive - range.start).toInt() - 1,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

@Composable
private fun ToggleSetting(
    label: String,
    description: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onCheckedChange(!checked) }
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = label,
                style = MaterialTheme.typography.bodyLarge,
                fontWeight = FontWeight.Medium
            )
            
            Spacer(modifier = Modifier.height(4.dp))
            
            Text(
                text = description,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        
        Spacer(modifier = Modifier.width(16.dp))
        
        Switch(
            checked = checked,
            onCheckedChange = onCheckedChange
        )
    }
}

@Composable
private fun ThemeSelector(
    currentTheme: AppTheme,
    onThemeSelected: (AppTheme) -> Unit
) {
    Column {
        AppTheme.allThemes.forEach { theme ->
            ThemeOption(
                theme = theme,
                isSelected = theme.id == currentTheme.id,
                onSelected = { onThemeSelected(theme) }
            )
            
            if (theme != AppTheme.allThemes.last()) {
                Divider(modifier = Modifier.padding(vertical = 8.dp))
            }
        }
    }
}

@Composable
private fun ThemeOption(
    theme: AppTheme,
    isSelected: Boolean,
    onSelected: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onSelected() }
            .padding(vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Color preview circle
        Card(
            modifier = Modifier.size(40.dp),
            colors = CardDefaults.cardColors(
                containerColor = androidx.compose.ui.graphics.Color(
                    android.graphics.Color.parseColor(theme.primaryColorHex)
                )
            ),
            shape = RoundedCornerShape(20.dp)
        ) {}
        
        Spacer(modifier = Modifier.width(16.dp))
        
        Text(
            text = theme.displayName,
            style = MaterialTheme.typography.bodyLarge,
            fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Normal,
            color = if (isSelected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurface
        )
    }
}
