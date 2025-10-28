package com.pomodoro.timer.ui.screens.theme

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.pomodoro.timer.domain.model.AppTheme
import com.pomodoro.timer.presentation.viewmodel.SettingsViewModel
import com.pomodoro.timer.ui.theme.PomodoroTheme

/**
 * Theme Selection Screen - Visual theme picker
 * 
 * Maps to iOS ThemeSelectionView.swift
 * Allows users to select and preview app themes with:
 * - Visual theme cards with color previews
 * - Animated theme switching
 * - Haptic feedback on selection
 * - Checkmark indicator for current theme
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ThemeSelectionScreen(
    onBackClick: () -> Unit,
    viewModel: SettingsViewModel = hiltViewModel()
) {
    val settings by viewModel.settings.collectAsStateWithLifecycle()
    val haptic = LocalHapticFeedback.current
    val availableThemes = remember { AppTheme.allThemes }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        text = "App Theme",
                        style = MaterialTheme.typography.titleLarge
                    )
                },
                navigationIcon = {
                    IconButton(
                        onClick = onBackClick,
                        modifier = Modifier.semantics {
                            contentDescription = "Navigate back"
                        }
                    ) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = null
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface,
                    titleContentColor = MaterialTheme.colorScheme.onSurface,
                    navigationIconContentColor = MaterialTheme.colorScheme.onSurface
                )
            )
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
            contentPadding = PaddingValues(vertical = 16.dp)
        ) {
            item {
                Text(
                    text = "Choose your theme",
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    color = MaterialTheme.colorScheme.onBackground,
                    modifier = Modifier
                        .padding(bottom = 8.dp)
                        .semantics { heading() }
                )
            }
            
            items(availableThemes) { theme ->
                ThemeCard(
                    theme = theme,
                    isSelected = settings.selectedCustomTheme == theme.id,
                    onClick = {
                        // Trigger haptic feedback
                        haptic.performHapticFeedback(HapticFeedbackType.LongPress)
                        // Update theme
                        viewModel.updateCustomTheme(theme.id)
                    }
                )
            }
        }
    }
}

/**
 * Theme Card Component
 * Displays a theme with color preview circles
 */
@Composable
private fun ThemeCard(
    theme: AppTheme,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    val cardColor by animateColorAsState(
        targetValue = if (isSelected) {
            MaterialTheme.colorScheme.primaryContainer
        } else {
            MaterialTheme.colorScheme.surface
        },
        animationSpec = tween(durationMillis = 300),
        label = "cardColor"
    )
    
    val borderColor by animateColorAsState(
        targetValue = if (isSelected) {
            MaterialTheme.colorScheme.primary
        } else {
            MaterialTheme.colorScheme.outline.copy(alpha = 0.3f)
        },
        animationSpec = tween(durationMillis = 300),
        label = "borderColor"
    )
    
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(
                onClickLabel = if (isSelected) "Currently selected" else "Select ${theme.name} theme"
            ) {
                onClick()
            }
            .semantics(mergeDescendants = true) {
                contentDescription = "${theme.name} theme${if (isSelected) ", currently selected" else ""}"
            },
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = cardColor
        ),
        elevation = CardDefaults.cardElevation(
            defaultElevation = if (isSelected) 3.dp else 1.dp
        )
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Theme name and colors
            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = theme.name,
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.SemiBold,
                    color = if (isSelected) {
                        MaterialTheme.colorScheme.onPrimaryContainer
                    } else {
                        MaterialTheme.colorScheme.onSurface
                    }
                )
                
                Spacer(modifier = Modifier.height(16.dp))
                
                // Color preview circles
                Row(
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    ColorCircle(
                        color = theme.primaryColor,
                        label = "Primary"
                    )
                    ColorCircle(
                        color = theme.secondaryColor,
                        label = "Secondary"
                    )
                    ColorCircle(
                        color = theme.accentColor,
                        label = "Accent"
                    )
                }
            }
            
            // Checkmark for selected theme
            if (isSelected) {
                Box(
                    modifier = Modifier
                        .size(32.dp)
                        .clip(CircleShape)
                        .background(MaterialTheme.colorScheme.primary),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(
                        imageVector = Icons.Default.Check,
                        contentDescription = "Selected",
                        tint = MaterialTheme.colorScheme.onPrimary,
                        modifier = Modifier.size(20.dp)
                    )
                }
            }
        }
    }
}

/**
 * Color Circle Preview Component
 */
@Composable
private fun ColorCircle(
    color: Color,
    label: String
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(6.dp)
    ) {
        Box(
            modifier = Modifier
                .size(44.dp)
                .clip(CircleShape)
                .background(color)
                .semantics {
                    contentDescription = "$label color"
                }
        )
        Text(
            text = label,
            style = MaterialTheme.typography.labelSmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun ThemeCardPreview() {
    PomodoroTheme {
        ThemeCard(
            theme = AppTheme.allThemes.first(),
            isSelected = true,
            onClick = {}
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun ThemeCardUnselectedPreview() {
    PomodoroTheme {
        ThemeCard(
            theme = AppTheme.allThemes[1],
            isSelected = false,
            onClick = {}
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun ColorCirclePreview() {
    PomodoroTheme {
        ColorCircle(
            color = Color(0xFF007AFF),
            label = "Primary"
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun ThemeCardListPreview() {
    PomodoroTheme {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            AppTheme.allThemes.take(3).forEachIndexed { index, theme ->
                ThemeCard(
                    theme = theme,
                    isSelected = index == 0,
                    onClick = {}
                )
            }
        }
    }
}
