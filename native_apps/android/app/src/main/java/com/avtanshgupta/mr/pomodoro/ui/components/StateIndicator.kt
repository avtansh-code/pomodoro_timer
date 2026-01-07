package com.avtanshgupta.mr.pomodoro.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.avtanshgupta.mr.pomodoro.domain.model.TimerState
import com.avtanshgupta.mr.pomodoro.ui.theme.PomodoroTheme

/**
 * State indicator chip showing timer status (Active/Paused/Ready).
 * Matches iOS stateIndicator design with colored dot.
 *
 * @param state Current timer state
 * @param modifier Modifier
 */
@Composable
fun StateIndicator(
    state: TimerState,
    modifier: Modifier = Modifier
) {
    val (stateText, stateColor) = when (state) {
        TimerState.RUNNING -> "Active" to Color(0xFF34C759) // Green
        TimerState.PAUSED -> "Paused" to Color(0xFFFF9500) // Orange
        TimerState.IDLE -> "Ready" to Color(0xFF8E8E93) // Gray
    }
    
    Row(
        modifier = modifier
            .background(
                color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.6f),
                shape = RoundedCornerShape(16.dp)
            )
            .padding(horizontal = 16.dp, vertical = 8.dp),
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Status dot
        Box(
            modifier = Modifier
                .size(8.dp)
                .background(color = stateColor, shape = CircleShape)
        )
        
        Spacer(modifier = Modifier.width(6.dp))
        
        // Status text
        Text(
            text = stateText,
            style = MaterialTheme.typography.labelSmall.copy(
                fontSize = 12.sp,
                fontWeight = FontWeight.Medium
            ),
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun StateIndicatorRunningPreview() {
    PomodoroTheme {
        StateIndicator(state = TimerState.RUNNING)
    }
}

@Preview(showBackground = true)
@Composable
private fun StateIndicatorPausedPreview() {
    PomodoroTheme {
        StateIndicator(state = TimerState.PAUSED)
    }
}

@Preview(showBackground = true)
@Composable
private fun StateIndicatorIdlePreview() {
    PomodoroTheme {
        StateIndicator(state = TimerState.IDLE)
    }
}
