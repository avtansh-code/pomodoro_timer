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
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.pomodoro.timer.domain.model.AppTheme
import com.pomodoro.timer.presentation.viewmodel.SettingsViewModel
import com.pomodoro.timer.ui.theme.PomodoroTheme

/**
 * Settings Screen with organized sections.
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
            // Header - Creative Design
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 32.dp)
            ) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Box(
                        modifier = Modifier
                            .size(56.dp)
                            .clip(CircleShape)
                            .background(
                                brush = Brush.linearGradient(
                                    colors = listOf(
                                        MaterialTheme.colorScheme.primary,
                                        MaterialTheme.colorScheme.tertiary
                                    )
                                )
                            ),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Settings,
                            contentDescription = null,
                            tint = Color.White,
                            modifier = Modifier.size(32.dp)
                        )
                    }
                    Spacer(modifier = Modifier.width(16.dp))
                    Column {
                        Text(
                            text = "Settings",
                            style = MaterialTheme.typography.headlineLarge,
                            fontWeight = FontWeight.ExtraBold,
                            color = MaterialTheme.colorScheme.onBackground,
                            modifier = Modifier.semantics { heading() }
                        )
                        Text(
                            text = "Personalize your experience",
                            style = MaterialTheme.typography.bodyLarge,
                            color = MaterialTheme.colorScheme.primary,
                            fontWeight = FontWeight.Medium
                        )
                    }
                }
            }
        
            // 1. Getting Started
            Text(
                text = "Getting Started",
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                letterSpacing = 0.5.sp,
                modifier = Modifier
                    .padding(bottom = 8.dp)
                    .semantics { heading() }
            )
            SimpleMenuItem(
                label = "Learn about Pomodoro",
                icon = Icons.Default.School,
                onClick = onBenefitsClick
            )
            
            Spacer(modifier = Modifier.height(20.dp))
            
            // 2. Appearance
            Text(
                text = "Appearance",
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                letterSpacing = 0.5.sp,
                modifier = Modifier
                    .padding(bottom = 8.dp)
                    .semantics { heading() }
            )
            ThemeMenuItem(
                selectedTheme = settings.selectedCustomTheme,
                onClick = onThemeClick
            )
            
            Spacer(modifier = Modifier.height(20.dp))
            
            // 3. Session Durations
            SettingsSection(
                title = "Session Durations",
                icon = Icons.Default.Timer,
                description = "Set your ideal work and break intervals"
            ) {
                DurationSettingGrid(
                    focusDuration = settings.focusDuration.toInt() / 60,
                    shortBreakDuration = settings.shortBreakDuration.toInt() / 60,
                    longBreakDuration = settings.longBreakDuration.toInt() / 60,
                    sessionsUntilLongBreak = settings.sessionsUntilLongBreak,
                    onFocusChange = { viewModel.updateFocusDuration((it * 60).toInt()) },
                    onShortBreakChange = { viewModel.updateShortBreakDuration((it * 60).toInt()) },
                    onLongBreakChange = { viewModel.updateLongBreakDuration((it * 60).toInt()) },
                    onSessionsChange = { viewModel.updateSessionsUntilLongBreak(it.toInt()) }
                )
            }
            
            Spacer(modifier = Modifier.height(20.dp))
            
            // 4. Auto Start
            SettingsSection(
                title = "Auto Start",
                icon = Icons.Default.PlayArrow,
                description = "Automatically start sessions"
            ) {
                ToggleSetting(
                    label = "Auto-start Breaks",
                    description = "Start break sessions automatically",
                    checked = settings.autoStartBreaks,
                    onCheckedChange = { viewModel.toggleAutoStartBreaks() },
                    icon = Icons.Default.Coffee
                )
                
                HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f))
                
                ToggleSetting(
                    label = "Auto-start Focus",
                    description = "Start focus sessions after breaks",
                    checked = settings.autoStartFocus,
                    onCheckedChange = { viewModel.toggleAutoStartFocus() },
                    icon = Icons.Default.FitnessCenter
                )
            }
            
            Spacer(modifier = Modifier.height(20.dp))
            
            // 5. Notifications and Feedback
            SettingsSection(
                title = "Notifications & Feedback",
                icon = Icons.Default.Notifications,
                description = "Manage alerts and sensory feedback"
            ) {
                ToggleSetting(
                    label = "Notifications",
                    description = "Show completion notifications",
                    checked = settings.notificationsEnabled,
                    onCheckedChange = { viewModel.toggleNotifications() },
                    icon = Icons.Default.NotificationsActive
                )
                
                HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f))
                
                ToggleSetting(
                    label = "Sound Effects",
                    description = "Play sounds when session completes",
                    checked = settings.soundEnabled,
                    onCheckedChange = { viewModel.toggleSound() },
                    icon = Icons.Default.VolumeUp
                )
                
                HorizontalDivider(color = MaterialTheme.colorScheme.outlineVariant.copy(alpha = 0.5f))
                
                ToggleSetting(
                    label = "Haptic Feedback",
                    description = "Vibrate on button presses",
                    checked = settings.hapticEnabled,
                    onCheckedChange = { viewModel.toggleHaptic() },
                    icon = Icons.Default.Vibration
                )
            }
            
            Spacer(modifier = Modifier.height(20.dp))
            
            // 6. Data Management
            Text(
                text = "Data Management",
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                letterSpacing = 0.5.sp,
                modifier = Modifier
                    .padding(bottom = 8.dp)
                    .semantics { heading() }
            )
            SimpleMenuItem(
                label = "Reset App Completely",
                description = "Restore all default settings",
                icon = Icons.Default.RestartAlt,
                onClick = { viewModel.resetToDefaults() },
                textColor = MaterialTheme.colorScheme.error
            )
            
            Spacer(modifier = Modifier.height(20.dp))
            
            // 7. About
            Text(
                text = "About",
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.SemiBold,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                letterSpacing = 0.5.sp,
                modifier = Modifier
                    .padding(bottom = 8.dp)
                    .semantics { heading() }
            )
            SimpleMenuItem(
                label = "Privacy Policy",
                icon = Icons.Default.PrivacyTip,
                onClick = onPrivacyPolicyClick
            )
            
            Spacer(modifier = Modifier.height(32.dp))
            
            // Version at bottom with creative styling
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 32.dp),
                horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(6.dp)
                        .clip(CircleShape)
                        .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.3f))
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = "Version 1.0.0",
                    style = MaterialTheme.typography.labelMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f),
                    fontWeight = FontWeight.Medium,
                    letterSpacing = 1.sp
                )
                Spacer(modifier = Modifier.width(8.dp))
                Box(
                    modifier = Modifier
                        .size(6.dp)
                        .clip(CircleShape)
                        .background(MaterialTheme.colorScheme.primary.copy(alpha = 0.3f))
                )
            }
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
        // Simple Section Header
        Text(
            text = title,
            style = MaterialTheme.typography.labelLarge,
            fontWeight = FontWeight.SemiBold,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            letterSpacing = 0.5.sp,
            modifier = Modifier
                .padding(bottom = 8.dp)
                .semantics { heading() }
        )
        
        // Content Card with shadow
        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surface
            ),
            shape = RoundedCornerShape(24.dp),
            elevation = CardDefaults.cardElevation(
                defaultElevation = 3.dp,
                pressedElevation = 1.dp
            )
        ) {
            content()
        }
    }
}

@Composable
private fun DurationSettingGrid(
    focusDuration: Int,
    shortBreakDuration: Int,
    longBreakDuration: Int,
    sessionsUntilLongBreak: Int,
    onFocusChange: (Float) -> Unit,
    onShortBreakChange: (Float) -> Unit,
    onLongBreakChange: (Float) -> Unit,
    onSessionsChange: (Float) -> Unit
) {
    Column(
        modifier = Modifier.padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        DurationControl(
            label = "Focus Duration",
            value = focusDuration,
            unit = "min",
            range = 1f..60f,
            onValueChange = onFocusChange
        )
        
        DurationControl(
            label = "Short Break",
            value = shortBreakDuration,
            unit = "min",
            range = 1f..30f,
            onValueChange = onShortBreakChange
        )
        
        DurationControl(
            label = "Long Break",
            value = longBreakDuration,
            unit = "min",
            range = 5f..60f,
            onValueChange = onLongBreakChange
        )
        
        DurationControl(
            label = "Sessions Until Long Break",
            value = sessionsUntilLongBreak,
            unit = "sessions",
            range = 2f..10f,
            onValueChange = onSessionsChange
        )
    }
}

@Composable
private fun DurationControl(
    label: String,
    value: Int,
    unit: String,
    range: ClosedFloatingPointRange<Float>,
    onValueChange: (Float) -> Unit
) {
    val scale by animateFloatAsState(
        targetValue = if (value > range.start.toInt()) 1.02f else 1f,
        animationSpec = tween(150),
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
            style = MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.Medium,
            color = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.weight(1f)
        )
        
        Row(
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            FilledIconButton(
                onClick = {
                    val newValue = (value - 1).coerceAtLeast(range.start.toInt())
                    onValueChange(newValue.toFloat())
                },
                enabled = value > range.start.toInt(),
                modifier = Modifier.size(36.dp),
                colors = IconButtonDefaults.filledIconButtonColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
                    disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                    disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f)
                )
            ) {
                Icon(
                    imageVector = Icons.Default.Remove,
                    contentDescription = "Decrease",
                    modifier = Modifier.size(18.dp)
                )
            }
            
            Box(
                modifier = Modifier
                    .width(80.dp)
                    .clip(RoundedCornerShape(10.dp))
                    .background(MaterialTheme.colorScheme.primaryContainer)
                    .padding(horizontal = 12.dp, vertical = 8.dp)
                    .scale(scale),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = if (unit == "sessions") "$value" else "$value $unit",
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Bold,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }
            
            FilledIconButton(
                onClick = {
                    val newValue = (value + 1).coerceAtMost(range.endInclusive.toInt())
                    onValueChange(newValue.toFloat())
                },
                enabled = value < range.endInclusive.toInt(),
                modifier = Modifier.size(36.dp),
                colors = IconButtonDefaults.filledIconButtonColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer,
                    contentColor = MaterialTheme.colorScheme.onPrimaryContainer,
                    disabledContainerColor = MaterialTheme.colorScheme.surfaceVariant,
                    disabledContentColor = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.38f)
                )
            ) {
                Icon(
                    imageVector = Icons.Default.Add,
                    contentDescription = "Increase",
                    modifier = Modifier.size(18.dp)
                )
            }
        }
    }
}

@Composable
private fun ThemeMenuItem(
    selectedTheme: String,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        shape = RoundedCornerShape(24.dp),
        elevation = CardDefaults.cardElevation(
            defaultElevation = 3.dp,
            pressedElevation = 1.dp
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clickable { onClick() }
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(
                modifier = Modifier.weight(1f),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(44.dp)
                        .clip(CircleShape)
                        .background(AppTheme.getById(selectedTheme).primaryColor)
                )
                
                Spacer(modifier = Modifier.width(16.dp))
                
                Column {
                    Text(
                        text = "Color Theme",
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Medium,
                        color = MaterialTheme.colorScheme.onSurface
                    )
                    Spacer(modifier = Modifier.height(2.dp))
                    Text(
                        text = AppTheme.getById(selectedTheme).name,
                        style = MaterialTheme.typography.bodySmall,
                        fontWeight = FontWeight.Normal,
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

@Composable
private fun SimpleMenuItem(
    label: String,
    icon: ImageVector,
    onClick: () -> Unit,
    description: String? = null,
    textColor: androidx.compose.ui.graphics.Color = MaterialTheme.colorScheme.onSurface
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        shape = RoundedCornerShape(24.dp),
        elevation = CardDefaults.cardElevation(
            defaultElevation = 3.dp,
            pressedElevation = 1.dp
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clickable { onClick() }
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(
                modifier = Modifier.weight(1f),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = textColor,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(12.dp))
                Column {
                    Text(
                        text = label,
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Medium,
                        color = textColor
                    )
                    description?.let {
                        Spacer(modifier = Modifier.height(2.dp))
                        Text(
                            text = it,
                            style = MaterialTheme.typography.labelMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }
            Icon(
                imageVector = Icons.Default.ChevronRight,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant
            )
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
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(
                role = androidx.compose.ui.semantics.Role.Switch,
                onClickLabel = if (checked) "Disable $label" else "Enable $label"
            ) {
                onCheckedChange(!checked)
            }
            .padding(16.dp)
            .semantics(mergeDescendants = true) {
                contentDescription = "$label, $description, ${if (checked) "enabled" else "disabled"}"
            },
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(
            modifier = Modifier.weight(1f),
            verticalAlignment = Alignment.CenterVertically
        ) {
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
                    style = MaterialTheme.typography.bodyMedium,
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

@Preview(showBackground = true)
@Composable
private fun SettingsSectionPreview() {
    PomodoroTheme {
        SettingsSection(
            title = "Session Durations",
            icon = Icons.Default.Timer,
            description = "Set your ideal work and break intervals"
        ) {
            Text("Setting content goes here")
        }
    }
}
