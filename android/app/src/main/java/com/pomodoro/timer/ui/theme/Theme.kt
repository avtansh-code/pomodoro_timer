package com.pomodoro.timer.ui.theme

import android.app.Activity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.ColorScheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat
import com.pomodoro.timer.domain.model.AppTheme

/**
 * Pomodoro Timer Material3 Theme
 * Supports 5 themes from iOS with light/dark variants
 */

// Light color schemes for each theme
private val ClassicRedLightScheme = lightColorScheme(
    primary = ClassicRedPrimary,
    onPrimary = SurfaceLight,
    secondary = ClassicRedSecondary,
    onSecondary = SurfaceLight,
    tertiary = ClassicRedTertiary,
    background = BackgroundLight,
    onBackground = TextPrimaryLight,
    surface = SurfaceLight,
    onSurface = TextPrimaryLight,
    surfaceVariant = CardLight,
    onSurfaceVariant = TextSecondaryLight,
    error = ErrorColor,
    onError = SurfaceLight,
    outline = DividerLight
)

private val OceanBlueLightScheme = lightColorScheme(
    primary = OceanBluePrimary,
    onPrimary = SurfaceLight,
    secondary = OceanBlueSecondary,
    onSecondary = SurfaceLight,
    tertiary = OceanBlueTertiary,
    background = BackgroundLight,
    onBackground = TextPrimaryLight,
    surface = SurfaceLight,
    onSurface = TextPrimaryLight,
    surfaceVariant = CardLight,
    onSurfaceVariant = TextSecondaryLight,
    error = ErrorColor,
    onError = SurfaceLight,
    outline = DividerLight
)

private val ForestGreenLightScheme = lightColorScheme(
    primary = ForestGreenPrimary,
    onPrimary = SurfaceLight,
    secondary = ForestGreenSecondary,
    onSecondary = SurfaceLight,
    tertiary = ForestGreenTertiary,
    background = BackgroundLight,
    onBackground = TextPrimaryLight,
    surface = SurfaceLight,
    onSurface = TextPrimaryLight,
    surfaceVariant = CardLight,
    onSurfaceVariant = TextSecondaryLight,
    error = ErrorColor,
    onError = SurfaceLight,
    outline = DividerLight
)

private val MidnightDarkLightScheme = lightColorScheme(
    primary = MidnightDarkPrimary,
    onPrimary = SurfaceLight,
    secondary = MidnightDarkSecondary,
    onSecondary = SurfaceLight,
    tertiary = MidnightDarkTertiary,
    background = BackgroundLight,
    onBackground = TextPrimaryLight,
    surface = SurfaceLight,
    onSurface = TextPrimaryLight,
    surfaceVariant = CardLight,
    onSurfaceVariant = TextSecondaryLight,
    error = ErrorColor,
    onError = SurfaceLight,
    outline = DividerLight
)

private val SunsetOrangeLightScheme = lightColorScheme(
    primary = SunsetOrangePrimary,
    onPrimary = SurfaceLight,
    secondary = SunsetOrangeSecondary,
    onSecondary = SurfaceLight,
    tertiary = SunsetOrangeTertiary,
    background = BackgroundLight,
    onBackground = TextPrimaryLight,
    surface = SurfaceLight,
    onSurface = TextPrimaryLight,
    surfaceVariant = CardLight,
    onSurfaceVariant = TextSecondaryLight,
    error = ErrorColor,
    onError = SurfaceLight,
    outline = DividerLight
)

// Dark color schemes for each theme
private val ClassicRedDarkScheme = darkColorScheme(
    primary = ClassicRedPrimary,
    onPrimary = BackgroundDark,
    secondary = ClassicRedSecondary,
    onSecondary = BackgroundDark,
    tertiary = ClassicRedTertiary,
    background = BackgroundDark,
    onBackground = TextPrimaryDark,
    surface = SurfaceDark,
    onSurface = TextPrimaryDark,
    surfaceVariant = CardDark,
    onSurfaceVariant = TextSecondaryDark,
    error = ErrorColorDark,
    onError = BackgroundDark,
    outline = DividerDark
)

private val OceanBlueDarkScheme = darkColorScheme(
    primary = OceanBluePrimary,
    onPrimary = BackgroundDark,
    secondary = OceanBlueSecondary,
    onSecondary = BackgroundDark,
    tertiary = OceanBlueTertiary,
    background = BackgroundDark,
    onBackground = TextPrimaryDark,
    surface = SurfaceDark,
    onSurface = TextPrimaryDark,
    surfaceVariant = CardDark,
    onSurfaceVariant = TextSecondaryDark,
    error = ErrorColorDark,
    onError = BackgroundDark,
    outline = DividerDark
)

private val ForestGreenDarkScheme = darkColorScheme(
    primary = ForestGreenPrimary,
    onPrimary = BackgroundDark,
    secondary = ForestGreenSecondary,
    onSecondary = BackgroundDark,
    tertiary = ForestGreenTertiary,
    background = BackgroundDark,
    onBackground = TextPrimaryDark,
    surface = SurfaceDark,
    onSurface = TextPrimaryDark,
    surfaceVariant = CardDark,
    onSurfaceVariant = TextSecondaryDark,
    error = ErrorColorDark,
    onError = BackgroundDark,
    outline = DividerDark
)

private val MidnightDarkDarkScheme = darkColorScheme(
    primary = MidnightDarkPrimary,
    onPrimary = BackgroundDark,
    secondary = MidnightDarkSecondary,
    onSecondary = BackgroundDark,
    tertiary = MidnightDarkTertiary,
    background = BackgroundDark,
    onBackground = TextPrimaryDark,
    surface = SurfaceDark,
    onSurface = TextPrimaryDark,
    surfaceVariant = CardDark,
    onSurfaceVariant = TextSecondaryDark,
    error = ErrorColorDark,
    onError = BackgroundDark,
    outline = DividerDark
)

private val SunsetOrangeDarkScheme = darkColorScheme(
    primary = SunsetOrangePrimary,
    onPrimary = BackgroundDark,
    secondary = SunsetOrangeSecondary,
    onSecondary = BackgroundDark,
    tertiary = SunsetOrangeTertiary,
    background = BackgroundDark,
    onBackground = TextPrimaryDark,
    surface = SurfaceDark,
    onSurface = TextPrimaryDark,
    surfaceVariant = CardDark,
    onSurfaceVariant = TextSecondaryDark,
    error = ErrorColorDark,
    onError = BackgroundDark,
    outline = DividerDark
)

/**
 * Get color scheme for a specific theme
 */
private fun getColorScheme(theme: AppTheme, darkTheme: Boolean): ColorScheme {
    return when (theme.id) {
        "classic_red" -> if (darkTheme) ClassicRedDarkScheme else ClassicRedLightScheme
        "ocean_blue" -> if (darkTheme) OceanBlueDarkScheme else OceanBlueLightScheme
        "forest_green" -> if (darkTheme) ForestGreenDarkScheme else ForestGreenLightScheme
        "midnight_dark" -> if (darkTheme) MidnightDarkDarkScheme else MidnightDarkLightScheme
        "sunset_orange" -> if (darkTheme) SunsetOrangeDarkScheme else SunsetOrangeLightScheme
        else -> if (darkTheme) ClassicRedDarkScheme else ClassicRedLightScheme
    }
}

/**
 * Main Pomodoro Timer theme composable
 * 
 * @param theme The selected app theme (defaults to Classic Red)
 * @param darkTheme Whether to use dark theme (defaults to system setting)
 * @param content The composable content to theme
 */
@Composable
fun PomodoroTheme(
    theme: AppTheme = AppTheme.classicRed,
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = getColorScheme(theme, darkTheme)
    
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.background.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
        }
    }
    
    MaterialTheme(
        colorScheme = colorScheme,
        typography = PomodoroTypography,
        content = content
    )
}

/**
 * Preview helper for testing themes
 */
@Composable
fun PomodoroThemePreview(
    themeId: String = "classic_red",
    darkTheme: Boolean = false,
    content: @Composable () -> Unit
) {
    val theme = AppTheme.allThemes.find { it.id == themeId } ?: AppTheme.classicRed
    PomodoroTheme(theme = theme, darkTheme = darkTheme, content = content)
}
