package com.pomodoro.timer.ui.screens.timer

import androidx.compose.animation.AnimatedVisibility
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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FastForward
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import java.util.Locale
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerState
import com.pomodoro.timer.presentation.viewmodel.TimerViewModel
import com.pomodoro.timer.ui.components.ActionButton
import com.pomodoro.timer.ui.components.CircularTimerProgress
import com.pomodoro.timer.ui.components.SessionHeader
import com.pomodoro.timer.ui.components.StateIndicator
import com.pomodoro.timer.ui.theme.LongBreakColor
import com.pomodoro.timer.ui.theme.PomodoroTheme
import com.pomodoro.timer.ui.theme.ShortBreakColor

/**
 * Main Timer Screen matching iOS MainTimerView design.
 * 
 * Features:
 * - Animated background gradient
 * - Circular timer with progress
 * - Session header
 * - Control buttons (Start/Pause/Resume/Reset)
 * - Skip button
 * - State indicator
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
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = getGradientForSession(sessionType)
            )
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(40.dp))
            
            // Session Header
            SessionHeader(
                sessionType = sessionType,
                sessionNumber = completedSessions + 1
            )
            
            Spacer(modifier = Modifier.height(60.dp))
            
            // Circular Timer
            CircularTimerProgress(
                progress = progress,
                timeText = formatTime(timeRemaining),
                color = getColorForSession(sessionType),
                size = 280.dp,
                strokeWidth = 20.dp,
                stateIndicator = {
                    StateIndicator(state = timerState)
                }
            )
            
            Spacer(modifier = Modifier.height(60.dp))
            
            // Control Buttons
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                AnimatedVisibility(
                    visible = timerState == TimerState.IDLE,
                    enter = scaleIn() + fadeIn(),
                    exit = scaleOut() + fadeOut(),
                    modifier = Modifier.weight(1f)
                ) {
                    ActionButton(
                        title = "Start",
                        icon = "play.fill",
                        backgroundColor = getColorForSession(sessionType),
                        foregroundColor = Color.White,
                        contentDescription = "Start timer"
                    ) {
                        viewModel.startTimer()
                    }
                }
                
                AnimatedVisibility(
                    visible = timerState == TimerState.RUNNING,
                    enter = scaleIn() + fadeIn(),
                    exit = scaleOut() + fadeOut(),
                    modifier = Modifier.weight(1f)
                ) {
                    ActionButton(
                        title = "Pause",
                        icon = "pause.fill",
                        backgroundColor = Color(0xFFFF9500), // Orange
                        foregroundColor = Color.White,
                        contentDescription = "Pause timer"
                    ) {
                        viewModel.pauseTimer()
                    }
                }
                
                AnimatedVisibility(
                    visible = timerState == TimerState.PAUSED,
                    enter = scaleIn() + fadeIn(),
                    exit = scaleOut() + fadeOut(),
                    modifier = Modifier.weight(1f)
                ) {
                    ActionButton(
                        title = "Resume",
                        icon = "play.fill",
                        backgroundColor = getColorForSession(sessionType),
                        foregroundColor = Color.White,
                        contentDescription = "Resume timer"
                    ) {
                        viewModel.resumeTimer()
                    }
                }
                
                ActionButton(
                    title = "Reset",
                    icon = "arrow.counterclockwise",
                    backgroundColor = getColorForSession(sessionType).copy(alpha = 0.15f),
                    foregroundColor = getColorForSession(sessionType),
                    contentDescription = "Reset timer",
                    modifier = Modifier.weight(1f)
                ) {
                    viewModel.resetTimer()
                }
            }
            
            Spacer(modifier = Modifier.height(24.dp))
            
            // Skip Button
            SkipButton(
                nextSessionName = getNextSessionName(sessionType, completedSessions, viewModel),
                onSkip = { viewModel.skipSession() }
            )
            
            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

@Composable
private fun SkipButton(
    nextSessionName: String,
    onSkip: () -> Unit
) {
    IconButton(
        onClick = onSkip,
        modifier = Modifier
            .semantics {
                contentDescription = "Skip to $nextSessionName"
            }
    ) {
        Row(
            modifier = Modifier
                .background(
                    color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f),
                    shape = RoundedCornerShape(20.dp)
                )
                .padding(horizontal = 20.dp, vertical = 12.dp),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.FastForward,
                contentDescription = null,
                modifier = Modifier.size(14.dp),
                tint = MaterialTheme.colorScheme.onSurfaceVariant
            )
            
            Spacer(modifier = Modifier.size(8.dp))
            
            Text(
                text = "Skip to $nextSessionName",
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Medium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun getGradientForSession(sessionType: SessionType): Brush {
    val color = getColorForSession(sessionType)
    val opacity = when (sessionType) {
        SessionType.FOCUS -> 0.15f
        SessionType.SHORT_BREAK -> 0.10f
        SessionType.LONG_BREAK -> 0.08f
    }
    
    return Brush.verticalGradient(
        colors = listOf(
            color.copy(alpha = opacity),
            Color.Transparent
        )
    )
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
private fun SkipButtonPreview() {
    PomodoroTheme {
        SkipButton(
            nextSessionName = "Short Break",
            onSkip = {}
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun SkipButtonLongBreakPreview() {
    PomodoroTheme {
        SkipButton(
            nextSessionName = "Long Break",
            onSkip = {}
        )
    }
}
