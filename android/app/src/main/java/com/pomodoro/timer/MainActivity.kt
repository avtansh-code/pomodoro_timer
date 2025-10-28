package com.pomodoro.timer

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.pomodoro.timer.ui.theme.PomodoroTheme
import dagger.hilt.android.AndroidEntryPoint

/**
 * Main activity for Pomodoro Timer app.
 * Entry point for the Compose UI.
 */
@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        setContent {
            PomodoroTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    // TODO: Replace with actual navigation and screens in Milestone 6
                    PlaceholderScreen()
                }
            }
        }
    }
}

@Composable
fun PlaceholderScreen() {
    Text(
        text = "Pomodoro Timer\n\nData layer implemented!\n\nNext: Timer Service & UI"
    )
}

@Preview(showBackground = true)
@Composable
fun PlaceholderScreenPreview() {
    PomodoroTheme {
        PlaceholderScreen()
    }
}
