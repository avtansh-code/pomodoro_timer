package com.avtanshgupta.mr.pomodoro

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.compose.rememberNavController
import com.avtanshgupta.mr.pomodoro.domain.model.AppTheme
import com.avtanshgupta.mr.pomodoro.presentation.viewmodel.SettingsViewModel
import com.avtanshgupta.mr.pomodoro.ui.navigation.BottomNavBar
import com.avtanshgupta.mr.pomodoro.ui.navigation.PomodoroNavGraph
import com.avtanshgupta.mr.pomodoro.ui.navigation.Screen
import com.avtanshgupta.mr.pomodoro.ui.theme.PomodoroTheme
import dagger.hilt.android.AndroidEntryPoint

/**
 * Main activity for Pomodoro Timer app.
 * Entry point for the Compose UI with navigation.
 */
@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    
    private val settingsViewModel: SettingsViewModel by viewModels()
    
    override fun onCreate(savedInstanceState: Bundle?) {
        // Install splash screen before calling super.onCreate()
        installSplashScreen()
        
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        setContent {
            val settings by settingsViewModel.settings.collectAsStateWithLifecycle()
            val selectedTheme = AppTheme.allThemes.find { it.id == settings.selectedCustomTheme }
                ?: AppTheme.ClassicRed
            
            PomodoroTheme(theme = selectedTheme) {
                val navController = rememberNavController()
                
                // Handle deep links from app shortcuts
                LaunchedEffect(Unit) {
                    handleDeepLink(intent, navController::navigate)
                }
                
                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    bottomBar = {
                        BottomNavBar(navController = navController)
                    }
                ) { innerPadding ->
                    PomodoroNavGraph(
                        navController = navController,
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        // Deep link will be handled in the LaunchedEffect
    }
    
    private fun handleDeepLink(intent: Intent?, navigate: (String) -> Unit) {
        intent?.data?.let { uri ->
            when {
                uri.toString().contains("start/focus") -> {
                    // Navigate to timer screen (already default)
                    navigate(Screen.Timer.route)
                    // TODO: Optionally trigger timer start automatically
                }
                uri.toString().contains("start/short_break") -> {
                    navigate(Screen.Timer.route)
                    // TODO: Optionally start short break timer
                }
                uri.toString().contains("view/statistics") -> {
                    navigate(Screen.Statistics.route)
                }
            }
        }
    }
}
