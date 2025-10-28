package com.pomodoro.timer.ui.screens.settings

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilledIconButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import com.pomodoro.timer.domain.model.AppTheme
import com.pomodoro.timer.presentation.viewmodel.SettingsViewModel
import com.pomodoro.timer.ui.theme.PomodoroTheme

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
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        MaterialTheme.colorScheme.primary.copy(alpha = 0.05f),
                        MaterialTheme.colorScheme.background
                    )
                )
            )
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp, vertical = 24.dp)
        ) {
            // Creative Header with gradient
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 32.dp)
            ) {
                Column {
                    Text(
                        text = "⚙️ Settings",
                        style = MaterialTheme.typography.headlineLarge,
                        fontWeight = FontWeight.Bold,
                        color = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.semantics { heading() }
                    )
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = "Customize your focus experience",
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        
        // Timer Durations Section with icon
        SettingsSection(
            title = "Timer Durations",
            icon = Icons.Default.Timer,
            description = "Set your ideal work and break intervals"
        ) {
            DurationSetting(
                label = "Focus Duration",
                value = (settings.focusDuration.toInt() / 60),
                onValueChange = { viewModel.updateFocusDuration((it * 60).toInt()) },
                unit = "min",
                range = 1f..60f
            )
            
            HorizontalDivider(
                modifier = Modifier.padding(vertical = 8.dp),
                color = MaterialTheme.colorScheme.outlineVariant
            )
            
            DurationSetting(
                label = "Short Break",
                value = (settings.shortBreakDuration.toInt() / 60),
                onValueChange = { viewModel.updateShortBreakDuration((it * 60).toInt()) },
                unit = "min",
                range = 1f..30f
            )
            
            HorizontalDivider(
                modifier = Modifier.padding(vertical = 8.dp),
                color = MaterialTheme.colorScheme.outlineVariant
            )
            
            DurationSetting(
                label = "Long Break",
                value = (settings.longBreakDuration.toInt() / 60),
                onValueChange = { viewModel.updateLongBreakDuration((it * 60).toInt()) },
                unit = "min",
                range = 5f..60f
            )
            
            HorizontalDivider(
                modifier = Modifier.padding(vertical = 8.dp),
                color = MaterialTheme.colorScheme.outlineVariant
            )
            
            DurationSetting(
                label = "Sessions Until Long Break",
                value = settings.sessionsUntilLongBreak,
                onValueChange = { viewModel.updateSessionsUntilLongBreak(it.toInt()) },
                unit = "sessions",
                range = 2f..10f
            )
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Theme Selection Section with icon
        SettingsSection(
            title = "Appearance",
            icon = Icons.Default.Palette,
            description = "Choose your favorite color theme"
        ) {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onThemeClick() },
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.3f)
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(
                        modifier = Modifier.weight(1f),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        // Large color preview
                        Box(
                            modifier = Modifier
                                .size(48.dp)
                                .clip(CircleShape)
                                .background(AppTheme.getById(settings.selectedCustomTheme).primaryColor)
                        )
                        
                        Spacer(modifier = Modifier.width(16.dp))
                        
                        Column {
                            Text(
                                text = "Color Theme",
                                style = MaterialTheme.typography.bodyLarge,
                                fontWeight = FontWeight.SemiBold,
                                color = MaterialTheme.colorScheme.onSurface
                            )
                            
                            Spacer(modifier = Modifier.height(2.dp))
                            
                            Text(
                                text = AppTheme.getById(settings.selectedCustomTheme).name,
                                style = MaterialTheme.typography.bodyMedium,
                                fontWeight = FontWeight.Medium,
                                color = MaterialTheme.colorScheme.primary
                            )
                        }
                    }
                    
                    Icon(
                        imageVector = Icons.Default.ChevronRight,
                        contentDescription = "Change theme",
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Preferences Section with icon
        SettingsSection(
            title = "Preferences",
            icon = Icons.Default.Speed,
            description = "Fine-tune your workflow"
        ) {
            ToggleSetting(
                label = "Auto-start Breaks",
                description = "Automatically start break sessions",
                checked = settings.autoStartBreaks,
                onCheckedChange = { viewModel.toggleAutoStartBreaks() },
                icon = Icons.Default.Timer
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            ToggleSetting(
                label = "Auto-start Focus",
                description = "Automatically start focus sessions after break",
                checked = settings.autoStartFocus,
                onCheckedChange = { viewModel.toggleAutoStartFocus() },
                icon = Icons.Default.Timer
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            ToggleSetting(
                label = "Sound Effects",
                description = "Play sounds when session completes",
                checked = settings.soundEnabled,
                onCheckedChange = { viewModel.toggleSound() },
                icon = Icons.Default.VolumeUp
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            ToggleSetting(
                label = "Haptic Feedback",
                description = "Vibrate on button presses",
                checked = settings.hapticEnabled,
                onCheckedChange = { viewModel.toggleHaptic() },
                icon = Icons.Default.Vibration
            )
            
            Spacer(modifier = Modifier.height(8.dp))
            
            ToggleSetting(
                label = "Notifications",
                description = "Show completion notifications",
                checked = settings.notificationsEnabled,
                onCheckedChange = { viewModel.toggleNotifications() },
                icon = Icons.Default.Notifications
            )
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // About Section with icon
        SettingsSection(
            title = "About",
            icon = Icons.Default.Info,
            description = "Learn more about Pomodoro"
        ) {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onBenefitsClick() },
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surface
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "About Pomodoro Technique",
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Medium
                    )
                    Icon(
                        imageVector = Icons.Default.ChevronRight,
                        contentDescription = "Learn more",
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
            
            Spacer(modifier = Modifier.height(8.dp))
            
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { onPrivacyPolicyClick() },
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.surface
                ),
                shape = RoundedCornerShape(16.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Privacy Policy",
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Medium
                    )
                    Icon(
                        imageVector = Icons.Default.ChevronRight,
                        contentDescription = "View policy",
                        tint = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
        
        // Developer Tools Section removed for cleaner UI
        // Can be accessed through a hidden gesture or settings menu if needed
        
        Spacer(modifier = Modifier.height(32.dp))
        
        // Reset Button with proper styling
        TextButton(
            onClick = { viewModel.resetToDefaults() },
            modifier = Modifier
                .fillMaxWidth()
                .semantics {
                    contentDescription = "Reset all settings to default values"
                }
        ) {
            Text(
                text = "Reset to Defaults",
                style = MaterialTheme.typography.labelLarge,
                color = MaterialTheme.colorScheme.error
            )
        }
        
        Spacer(modifier = Modifier.height(64.dp))
        }
    }
}

@Composable
private fun SettingsSection(
    title: String,
    icon: ImageVector,
    description: String,
    content: @Composable () -> Unit
) {
    Column {
        // Creative section header with icon and description
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Icon with gradient background
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .clip(CircleShape)
                    .background(
                        brush = Brush.linearGradient(
                            colors = listOf(
                                MaterialTheme.colorScheme.primary.copy(alpha = 0.2f),
                                MaterialTheme.colorScheme.primary.copy(alpha = 0.1f)
                            )
                        )
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary,
                    modifier = Modifier.size(22.dp)
                )
            }
            
            Spacer(modifier = Modifier.width(12.dp))
            
            Column {
                Text(
                    text = title,
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onBackground,
                    modifier = Modifier.semantics { heading() }
                )
                Text(
                    text = description,
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
        }
        
        // Enhanced card with better styling
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surface
            ),
            shape = RoundedCornerShape(20.dp),
            elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
        ) {
            Column(
                modifier = Modifier.padding(20.dp)
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
    val scale by animateFloatAsState(
        targetValue = if (value > range.start.toInt()) 1.05f else 1f,
        animationSpec = tween(200),
        label = "valueScale"
    )
    
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .semantics(mergeDescendants = true) {
                contentDescription = "$label is set to $value $unit"
            },
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodyLarge,
            fontWeight = FontWeight.Medium,
            color = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.weight(1f)
        )
        
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Minus button
            FilledIconButton(
                onClick = {
                    val newValue = (value - 1).coerceAtLeast(range.start.toInt())
                    onValueChange(newValue.toFloat())
                },
                enabled = value > range.start.toInt(),
                modifier = Modifier.size(40.dp),
                colors = IconButtonDefaults.filledIconButtonColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
                    disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                    disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f)
                )
            ) {
                Icon(
                    imageVector = Icons.Default.Remove,
                    contentDescription = "Decrease $label",
                    modifier = Modifier.size(20.dp)
                )
            }
            
            // Value display with animation
            Box(
                modifier = Modifier
                    .clip(RoundedCornerShape(12.dp))
                    .background(MaterialTheme.colorScheme.primaryContainer)
                    .padding(horizontal = 20.dp, vertical = 10.dp)
                    .scale(scale),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "$value $unit",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }
            
            // Plus button
            FilledIconButton(
                onClick = {
                    val newValue = (value + 1).coerceAtMost(range.endInclusive.toInt())
                    onValueChange(newValue.toFloat())
                },
                enabled = value < range.endInclusive.toInt(),
                modifier = Modifier.size(40.dp),
                colors = IconButtonDefaults.filledIconButtonColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
                    disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                    disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f)
                )
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = "Increase $label",
                    modifier = Modifier.size(20.dp)
                )
            }
        }
    }
}

@Composable
private fun ToggleSetting(
    label: String,
    description: String,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit,
    icon: ImageVector? = null
) {
    val backgroundColor by animateColorAsState(
        targetValue = if (checked) {
            MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.3f)
        } else {
            MaterialTheme.colorScheme.surface
        },
        animationSpec = tween(300),
        label = "backgroundColor"
    )
    
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(
                role = androidx.compose.ui.semantics.Role.Switch,
                onClickLabel = if (checked) "Disable $label" else "Enable $label"
            ) {
                onCheckedChange(!checked)
            }
            .semantics(mergeDescendants = true) {
                contentDescription = "$label, $description, ${if (checked) "enabled" else "disabled"}"
            },
        colors = CardDefaults.cardColors(
            containerColor = backgroundColor
        ),
        shape = RoundedCornerShape(16.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(
                modifier = Modifier.weight(1f),
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Icon if provided
                icon?.let {
                    Icon(
                        imageVector = it,
                        contentDescription = null,
                        tint = if (checked) {
                            MaterialTheme.colorScheme.primary
                        } else {
                            MaterialTheme.colorScheme.onSurfaceVariant
                        },
                        modifier = Modifier.size(24.dp)
                    )
                    Spacer(modifier = Modifier.width(12.dp))
                }
                
                Column {
                    Text(
                        text = label,
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.SemiBold,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                    
                    Spacer(modifier = Modifier.height(2.dp))
                    
                    Text(
                        text = description,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
            
            Spacer(modifier = Modifier.width(16.dp))
            
            // Enhanced switch with custom colors
            Switch(
                checked = checked,
                onCheckedChange = null,
                modifier = Modifier.height(48.dp),
                colors = SwitchDefaults.colors(
                    checkedThumbColor = MaterialTheme.colorScheme.primary,
                    checkedTrackColor = MaterialTheme.colorScheme.primaryContainer,
                    uncheckedThumbColor = MaterialTheme.colorScheme.outline,
                    uncheckedTrackColor = MaterialTheme.colorScheme.surfaceVariant
                )
            )
        }
    }
}


@Preview(showBackground = true)
@Composable
private fun SettingsSectionPreview() {
    PomodoroTheme {
        SettingsSection(
            title = "Timer Durations",
            icon = Icons.Default.Timer,
            description = "Set your ideal work and break intervals"
        ) {
            Text("Setting content goes here")
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun DurationSettingPreview() {
    PomodoroTheme {
        DurationSetting(
            label = "Focus Duration",
            value = 25,
            onValueChange = {},
            unit = "min",
            range = 1f..60f
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun ToggleSettingPreview() {
    PomodoroTheme {
        ToggleSetting(
            label = "Auto-start Breaks",
            description = "Automatically start break sessions",
            checked = true,
            onCheckedChange = {},
            icon = Icons.Default.Timer
        )
    }
}
