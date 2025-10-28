package com.pomodoro.timer.ui.components

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.ui.theme.FocusColor
import com.pomodoro.timer.ui.theme.LongBreakColor
import com.pomodoro.timer.ui.theme.ShortBreakColor

/**
 * Session header showing session type and number.
 * Matches iOS sessionHeader design.
 *
 * @param sessionType Current session type
 * @param sessionNumber Session number (1-based)
 * @param modifier Modifier
 */
@Composable
fun SessionHeader(
    sessionType: SessionType,
    sessionNumber: Int,
    modifier: Modifier = Modifier
) {
    val sessionTypeName = when (sessionType) {
        SessionType.FOCUS -> "Focus"
        SessionType.SHORT_BREAK -> "Short Break"
        SessionType.LONG_BREAK -> "Long Break"
    }
    
    val sessionColor = when (sessionType) {
        SessionType.FOCUS -> MaterialTheme.colorScheme.primary
        SessionType.SHORT_BREAK -> ShortBreakColor
        SessionType.LONG_BREAK -> LongBreakColor
    }
    
    // Animate color changes
    val animatedColor by animateColorAsState(
        targetValue = sessionColor,
        animationSpec = tween(durationMillis = 400),
        label = "sessionColor"
    )
    
    Column(
        modifier = modifier.semantics {
            contentDescription = "Current session: $sessionTypeName, Session number $sessionNumber"
        },
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = sessionTypeName,
            style = MaterialTheme.typography.titleLarge,
            fontWeight = FontWeight.Bold,
            color = animatedColor
        )
        
        Spacer(modifier = Modifier.height(8.dp))
        
        Text(
            text = "Session $sessionNumber",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}
