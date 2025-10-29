package com.avtanshgupta.mr.pomodoro.ui.components

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.avtanshgupta.mr.pomodoro.ui.theme.PomodoroTheme

/**
 * Circular progress indicator with timer display (iOS style).
 *
 * @param progress Progress from 0.0 to 1.0
 * @param timeText Time remaining (MM:SS format)
 * @param color Progress arc color
 * @param size Circle diameter
 * @param strokeWidth Arc thickness
 * @param modifier Modifier
 * @param stateIndicator Optional state chip
 */
@Composable
fun CircularTimerProgress(
    progress: Float,
    timeText: String,
    color: Color,
    size: Dp = 280.dp,
    strokeWidth: Dp = 20.dp,
    modifier: Modifier = Modifier,
    stateIndicator: @Composable (() -> Unit)? = null
) {
    val animatedProgress by animateFloatAsState(
        targetValue = progress,
        animationSpec = tween(durationMillis = 1000),
        label = "circularProgress"
    )
    
    Box(
        modifier = modifier.size(size),
        contentAlignment = Alignment.Center
    ) {
        // Background circle
        Canvas(modifier = Modifier.size(size)) {
            drawArc(
                color = color.copy(alpha = 0.2f),
                startAngle = -90f,
                sweepAngle = 360f,
                useCenter = false,
                style = Stroke(width = strokeWidth.toPx(), cap = StrokeCap.Round)
            )
        }
        
        // Progress arc
        Canvas(modifier = Modifier.size(size)) {
            drawArc(
                color = color,
                startAngle = -90f,
                sweepAngle = 360f * animatedProgress,
                useCenter = false,
                style = Stroke(width = strokeWidth.toPx(), cap = StrokeCap.Round)
            )
        }
        
        // Center content
        Column(
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = timeText,
                style = MaterialTheme.typography.displayLarge.copy(
                    fontSize = (size.value * 0.20).sp
                ),
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onBackground,
                textAlign = TextAlign.Center
            )
            
            if (stateIndicator != null) {
                Spacer(modifier = Modifier.height((size.value * 0.04).dp))
                stateIndicator()
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun CircularTimerProgressPreview() {
    PomodoroTheme {
        CircularTimerProgress(
            progress = 0.75f,
            timeText = "18:30",
            color = Color(0xFF007AFF),
            size = 280.dp,
            strokeWidth = 20.dp
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun CircularTimerProgressWithIndicatorPreview() {
    PomodoroTheme {
        CircularTimerProgress(
            progress = 0.5f,
            timeText = "12:30",
            color = Color(0xFF34C759),
            size = 280.dp,
            strokeWidth = 20.dp,
            stateIndicator = {
                Text(
                    text = "Running",
                    style = MaterialTheme.typography.bodySmall,
                    color = Color.Gray
                )
            }
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun CircularTimerProgressFullPreview() {
    PomodoroTheme {
        CircularTimerProgress(
            progress = 1.0f,
            timeText = "25:00",
            color = Color(0xFFFF9500),
            size = 280.dp,
            strokeWidth = 20.dp
        )
    }
}
