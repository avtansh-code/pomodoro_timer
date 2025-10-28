package com.pomodoro.timer.ui.navigation

/**
 * Sealed class defining app navigation screens.
 */
sealed class Screen(val route: String) {
    data object Timer : Screen("timer")
    data object Statistics : Screen("statistics")
    data object Settings : Screen("settings")
}
