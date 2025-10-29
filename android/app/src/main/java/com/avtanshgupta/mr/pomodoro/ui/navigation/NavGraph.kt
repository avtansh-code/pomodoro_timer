package com.avtanshgupta.mr.pomodoro.ui.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import com.avtanshgupta.mr.pomodoro.ui.screens.benefits.PomodoroBenefitsScreen
import com.avtanshgupta.mr.pomodoro.ui.screens.privacy.PrivacyPolicyScreen
import com.avtanshgupta.mr.pomodoro.ui.screens.screenshot.ScreenshotPreparationScreen
import com.avtanshgupta.mr.pomodoro.ui.screens.settings.SettingsScreen
import com.avtanshgupta.mr.pomodoro.ui.screens.statistics.StatisticsScreen
import com.avtanshgupta.mr.pomodoro.ui.screens.theme.ThemeSelectionScreen
import com.avtanshgupta.mr.pomodoro.ui.screens.timer.TimerScreen

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
            SettingsScreen(
                onPrivacyPolicyClick = {
                    navController.navigate(Screen.PrivacyPolicy.route)
                },
                onBenefitsClick = {
                    navController.navigate(Screen.Benefits.route)
                },
                onThemeClick = {
                    navController.navigate(Screen.ThemeSelection.route)
                },
                onScreenshotToolsClick = {
                    navController.navigate(Screen.ScreenshotPreparation.route)
                }
            )
        }
        
        composable(Screen.ThemeSelection.route) {
            ThemeSelectionScreen(
                onBackClick = {
                    navController.popBackStack()
                }
            )
        }
        
        composable(Screen.ScreenshotPreparation.route) {
            ScreenshotPreparationScreen(
                onBackClick = {
                    navController.popBackStack()
                }
            )
        }
        
        composable(Screen.PrivacyPolicy.route) {
            PrivacyPolicyScreen(
                onBackClick = {
                    navController.popBackStack()
                }
            )
        }
        
        composable(Screen.Benefits.route) {
            PomodoroBenefitsScreen(
                onBackClick = {
                    navController.popBackStack()
                },
                onGetStartedClick = {
                    // Navigate to timer and pop back stack
                    navController.navigate(Screen.Timer.route) {
                        popUpTo(Screen.Timer.route) { inclusive = true }
                    }
                }
            )
        }
    }
}
