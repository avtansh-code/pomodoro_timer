package avtanshgupta.PomodoroTimer.ui.components

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.spring
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FastForward
import androidx.compose.material.icons.filled.Help
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import avtanshgupta.PomodoroTimer.ui.theme.PomodoroTheme

/**
 * Reusable action button component matching iOS ActionButton design.
 * 
 * Features:
 * - Press scale animation
 * - Haptic feedback
 * - Icon + text layout
 * - Shadow effect
 * - Accessibility support
 *
 * @param title Button text
 * @param icon Icon resource name (from system icons)
 * @param backgroundColor Button background color
 * @param foregroundColor Text and icon color
 * @param modifier Modifier for the button
 * @param contentDescription Accessibility description
 * @param onClick Click handler
 */
@Composable
fun ActionButton(
    title: String,
    icon: String,
    backgroundColor: Color,
    foregroundColor: Color,
    modifier: Modifier = Modifier,
    contentDescription: String = title,
    onClick: () -> Unit
) {
    val haptic = LocalHapticFeedback.current
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    
    // Animate scale on press (similar to iOS ScaleButtonStyle)
    val scale by animateFloatAsState(
        targetValue = if (isPressed) 0.95f else 1.0f,
        animationSpec = spring(
            dampingRatio = 0.7f,
            stiffness = 300f
        ),
        label = "buttonScale"
    )
    
    Button(
        onClick = {
            haptic.performHapticFeedback(HapticFeedbackType.LongPress)
            onClick()
        },
        modifier = modifier
            .fillMaxWidth()
            .height(56.dp)
            .graphicsLayer {
                scaleX = scale
                scaleY = scale
            }
            .semantics {
                this.contentDescription = contentDescription
            },
        colors = ButtonDefaults.buttonColors(
            containerColor = backgroundColor,
            contentColor = foregroundColor
        ),
        shape = RoundedCornerShape(16.dp),
        elevation = ButtonDefaults.buttonElevation(
            defaultElevation = 4.dp,
            pressedElevation = 2.dp
        ),
        interactionSource = interactionSource
    ) {
        Row(
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Icon - use system icons or material icons
            Icon(
                imageVector = getIconVector(icon),
                contentDescription = null,
                modifier = Modifier.size(18.dp)
            )
            
            Spacer(modifier = Modifier.width(8.dp))
            
            // Text
            Text(
                text = title,
                fontSize = 17.sp,
                fontWeight = FontWeight.SemiBold
            )
        }
    }
}

/**
 * Maps iOS SF Symbols icon names to Material Icons.
 * 
 * iOS → Material mapping:
 * - play.fill → PlayArrow
 * - pause.fill → Pause
 * - arrow.counterclockwise → Refresh
 * - forward.fill → FastForward
 */
private fun getIconVector(iconName: String): ImageVector {
    return when (iconName) {
        "play.fill" -> Icons.Filled.PlayArrow
        "pause.fill" -> Icons.Filled.Pause
        "arrow.counterclockwise" -> Icons.Filled.Refresh
        "forward.fill" -> Icons.Filled.FastForward
        else -> Icons.Filled.Help
    }
}

@Preview(showBackground = true)
@Composable
private fun ActionButtonPreview() {
    PomodoroTheme {
        ActionButton(
            title = "Start",
            icon = "play.fill",
            backgroundColor = Color(0xFF007AFF),
            foregroundColor = Color.White,
            contentDescription = "Start timer"
        ) {}
    }
}

@Preview(showBackground = true)
@Composable
private fun ActionButtonPausedPreview() {
    PomodoroTheme {
        ActionButton(
            title = "Pause",
            icon = "pause.fill",
            backgroundColor = Color(0xFFFF9500),
            foregroundColor = Color.White,
            contentDescription = "Pause timer"
        ) {}
    }
}

@Preview(showBackground = true)
@Composable
private fun ActionButtonResetPreview() {
    PomodoroTheme {
        ActionButton(
            title = "Reset",
            icon = "arrow.counterclockwise",
            backgroundColor = Color(0xFF007AFF).copy(alpha = 0.15f),
            foregroundColor = Color(0xFF007AFF),
            contentDescription = "Reset timer"
        ) {}
    }
}
