package com.pomodoro.timer.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import com.pomodoro.timer.ui.screens.settings.SettingsScreen
import com.pomodoro.timer.ui.screens.statistics.StatisticsScreen
import com.pomodoro.timer.ui.screens.timer.TimerScreen

/**
 * Navigation graph for the app.
 */
@Composable
fun PomodoroNavGraph(
    navController: NavHostController,
    modifier: androidx.compose.ui.Modifier = androidx.compose.ui.Modifier
) {
    NavHost(
        navController = navController,
        startDestination = Screen.Timer.route,
        modifier = modifier
    ) {
        composable(Screen.Timer.route) {
            TimerScreen()
        }
        
        composable(Screen.Statistics.route) {
            StatisticsScreen()
        }
        
        composable(Screen.Settings.route) {
            SettingsScreen()
        }
    }
}
