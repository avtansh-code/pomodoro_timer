package com.pomodoro.timer.ui.screens.timer

import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.scaleIn
import androidx.compose.animation.scaleOut
import androidx.compose.foundation.background
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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FastForward
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerState
import com.pomodoro.timer.presentation.viewmodel.TimerViewModel
import com.pomodoro.timer.ui.components.CircularTimerProgress
import com.pomodoro.timer.ui.theme.LongBreakColor
import com.pomodoro.timer.ui.theme.PomodoroTheme
import com.pomodoro.timer.ui.theme.ShortBreakColor
import java.util.Locale

/**
 * Clean and Creative Timer Screen with Material Design 3.
 * 
 * Features:
 * - Subtle gradient background
 * - Large, clear timer display
 * - Session info card
 * - Prominent action buttons
 * - Clean visual hierarchy
 */
@Composable
fun TimerScreen(
    viewModel: TimerViewModel = hiltViewModel()
) {
    val timerState by viewModel.timerState.collectAsState()
    val sessionType by viewModel.currentSessionType.collectAsState()
    val timeRemaining by viewModel.timeRemaining.collectAsState()
    val progress by viewModel.progress.collectAsState()
    val completedSessions by viewModel.completedFocusSessions.collectAsState()
    
    Log.d("TimerScreen", "=== TimerScreen Recomposition ===")
    Log.d("TimerScreen", "timerState: $timerState")
    Log.d("TimerScreen", "sessionType: $sessionType")
    Log.d("TimerScreen", "timeRemaining: $timeRemaining")
    Log.d("TimerScreen", "progress: $progress")
    Log.d("TimerScreen", "completedSessions: $completedSessions")
    
    val sessionColor = getColorForSession(sessionType)
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        sessionColor.copy(alpha = 0.08f),
                        MaterialTheme.colorScheme.background,
                        MaterialTheme.colorScheme.background
                    ),
                    startY = 0f,
                    endY = 800f
                )
            )
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp)
                .semantics { heading() },
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(32.dp))
            
            // Session Info Card - Clean and prominent
            SessionInfoCard(
                sessionType = sessionType,
                sessionNumber = completedSessions + 1,
                color = sessionColor
            )
            
            Spacer(modifier = Modifier.weight(0.5f))
            
            // Large Circular Timer - Main focus
            Box(
                contentAlignment = Alignment.Center
            ) {
                CircularTimerProgress(
                    progress = progress,
                    timeText = formatTime(timeRemaining),
                    color = sessionColor,
                    size = 300.dp,
                    strokeWidth = 16.dp,
                    stateIndicator = {
                        StateIndicatorChip(state = timerState, color = sessionColor)
                    }
                )
            }
            
            Spacer(modifier = Modifier.weight(0.5f))
            
            // Control Buttons - Clear and accessible
            ControlButtonsRow(
                timerState = timerState,
                sessionColor = sessionColor,
                onStart = { 
                    Log.d("TimerScreen", ">>> UI: Start button pressed")
                    viewModel.startTimer()
                },
                onPause = { 
                    Log.d("TimerScreen", ">>> UI: Pause button pressed")
                    viewModel.pauseTimer()
                },
                onResume = { 
                    Log.d("TimerScreen", ">>> UI: Resume button pressed")
                    viewModel.resumeTimer()
                },
                onReset = { 
                    Log.d("TimerScreen", ">>> UI: Reset button pressed")
                    viewModel.resetTimer()
                }
            )
            
            Spacer(modifier = Modifier.height(24.dp))
            
            // Skip Button - Subtle but accessible
            SkipButton(
                nextSessionName = getNextSessionName(sessionType, completedSessions, viewModel),
                onSkip = { 
                    Log.d("TimerScreen", ">>> UI: Skip button pressed")
                    viewModel.skipSession()
                },
                color = sessionColor
            )
            
            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
private fun SessionInfoCard(
    sessionType: SessionType,
    sessionNumber: Int,
    color: Color
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = color.copy(alpha = 0.15f)
        ),
        shape = RoundedCornerShape(20.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 0.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(20.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(
                    text = when (sessionType) {
                        SessionType.FOCUS -> "🎯 Focus Session"
                        SessionType.SHORT_BREAK -> "☕ Short Break"
                        SessionType.LONG_BREAK -> "🌴 Long Break"
                    },
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = color
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = if (sessionType == SessionType.FOCUS) {
                        "Session #$sessionNumber"
                    } else {
                        "Relax and recharge"
                    },
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }
            
            // Session number badge
            if (sessionType == SessionType.FOCUS) {
                Box(
                    modifier = Modifier
                        .size(48.dp)
                        .clip(CircleShape)
                        .background(color),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "$sessionNumber",
                        style = MaterialTheme.typography.titleLarge,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                }
            }
        }
    }
}

@Composable
private fun StateIndicatorChip(
    state: TimerState,
    color: Color
) {
    val alpha by animateFloatAsState(
        targetValue = if (state == TimerState.RUNNING) 1f else 0.7f,
        animationSpec = tween(300),
        label = "stateAlpha"
    )
    
    Card(
        modifier = Modifier.alpha(alpha),
        colors = CardDefaults.cardColors(
            containerColor = when (state) {
                TimerState.IDLE -> MaterialTheme.colorScheme.surfaceVariant
                TimerState.RUNNING -> color
                TimerState.PAUSED -> Color(0xFFFF9500)
            }
        ),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text(
            text = when (state) {
                TimerState.IDLE -> "Ready"
                TimerState.RUNNING -> "Running"
                TimerState.PAUSED -> "Paused"
            },
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
            style = MaterialTheme.typography.labelMedium,
            fontWeight = FontWeight.Bold,
            color = if (state == TimerState.IDLE) {
                MaterialTheme.colorScheme.onSurfaceVariant
            } else {
                Color.White
            }
        )
    }
}

@Composable
private fun ControlButtonsRow(
    timerState: TimerState,
    sessionColor: Color,
    onStart: () -> Unit,
    onPause: () -> Unit,
    onResume: () -> Unit,
    onReset: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Main Action Button (Start/Pause/Resume)
        AnimatedVisibility(
            visible = true,
            modifier = Modifier.weight(1f)
        ) {
            when (timerState) {
                TimerState.IDLE -> {
                    PrimaryActionButton(
                        text = "Start",
                        icon = Icons.Default.PlayArrow,
                        color = sessionColor,
                        onClick = onStart
                    )
                }
                TimerState.RUNNING -> {
                    PrimaryActionButton(
                        text = "Pause",
                        icon = Icons.Default.Pause,
                        color = Color(0xFFFF9500),
                        onClick = onPause
                    )
                }
                TimerState.PAUSED -> {
                    PrimaryActionButton(
                        text = "Resume",
                        icon = Icons.Default.PlayArrow,
                        color = sessionColor,
                        onClick = onResume
                    )
                }
            }
        }
        
        // Reset Button - Secondary action
        SecondaryActionButton(
            icon = Icons.Default.Refresh,
            color = sessionColor,
            onClick = onReset,
            contentDescription = "Reset timer"
        )
    }
}

@Composable
private fun PrimaryActionButton(
    text: String,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    color: Color,
    onClick: () -> Unit
) {
    val scale by animateFloatAsState(
        targetValue = 1f,
        animationSpec = tween(200),
        label = "buttonScale"
    )
    
    FilledTonalButton(
        onClick = onClick,
        modifier = Modifier
            .fillMaxWidth()
            .height(64.dp)
            .scale(scale)
            .semantics {
                contentDescription = "$text timer"
            },
        colors = androidx.compose.material3.ButtonDefaults.filledTonalButtonColors(
            containerColor = color,
            contentColor = Color.White
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Icon(
            imageVector = icon,
            contentDescription = null,
            modifier = Modifier.size(28.dp)
        )
        Spacer(modifier = Modifier.width(12.dp))
        Text(
            text = text,
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.Bold,
            fontSize = 20.sp
        )
    }
}

@Composable
private fun SecondaryActionButton(
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    color: Color,
    onClick: () -> Unit,
    contentDescription: String
) {
    Card(
        modifier = Modifier.size(64.dp),
        onClick = onClick,
        colors = CardDefaults.cardColors(
            containerColor = color.copy(alpha = 0.15f)
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = contentDescription,
                tint = color,
                modifier = Modifier.size(28.dp)
            )
        }
    }
}

@Composable
private fun SkipButton(
    nextSessionName: String,
    onSkip: () -> Unit,
    color: Color
) {
    FilledTonalButton(
        onClick = onSkip,
        modifier = Modifier
            .semantics {
                contentDescription = "Skip to $nextSessionName"
            },
        colors = androidx.compose.material3.ButtonDefaults.filledTonalButtonColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.6f),
            contentColor = color
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Icon(
            imageVector = Icons.Default.FastForward,
            contentDescription = null,
            modifier = Modifier.size(18.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
        Text(
            text = "Skip to $nextSessionName",
            style = MaterialTheme.typography.labelLarge,
            fontWeight = FontWeight.SemiBold
        )
    }
}

@Composable
private fun getColorForSession(sessionType: SessionType): Color {
    return when (sessionType) {
        SessionType.FOCUS -> MaterialTheme.colorScheme.primary
        SessionType.SHORT_BREAK -> ShortBreakColor
        SessionType.LONG_BREAK -> LongBreakColor
    }
}

private fun getNextSessionName(
    sessionType: SessionType,
    completedSessions: Int,
    viewModel: TimerViewModel
): String {
    return when (sessionType) {
        SessionType.FOCUS -> {
            val settings = viewModel.settings.value
            if ((completedSessions + 1) % settings.sessionsUntilLongBreak == 0) {
                "Long Break"
            } else {
                "Short Break"
            }
        }
        SessionType.SHORT_BREAK, SessionType.LONG_BREAK -> "Focus"
    }
}

private fun formatTime(seconds: Long): String {
    val minutes = seconds / 60
    val secs = seconds % 60
    return String.format(Locale.US, "%02d:%02d", minutes, secs)
}

@Preview(showBackground = true)
@Composable
private fun SessionInfoCardPreview() {
    PomodoroTheme {
        SessionInfoCard(
            sessionType = SessionType.FOCUS,
            sessionNumber = 3,
            color = Color(0xFFED4242)
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun SkipButtonPreview() {
    PomodoroTheme {
        SkipButton(
            nextSessionName = "Short Break",
            onSkip = {},
            color = Color(0xFFED4242)
        )
    }
}
