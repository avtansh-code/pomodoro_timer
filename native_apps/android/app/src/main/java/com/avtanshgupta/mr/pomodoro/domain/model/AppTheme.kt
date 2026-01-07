package avtanshgupta.PomodoroTimer.domain.model

import androidx.compose.ui.graphics.Color

/**
 * Represents a complete visual theme for the app.
 * Maps to AppTheme struct in iOS app (AppTheme.swift)
 *
 * This is the domain model for themes. The actual Compose theme implementation
 * is in presentation/theme/AppThemes.kt
 */
data class AppTheme(
    val id: String,
    val name: String,
    val primaryColor: Color,
    val secondaryColor: Color,
    val accentColor: Color,
    val focusGradientStart: Color,
    val focusGradientEnd: Color,
    val shortBreakGradientStart: Color,
    val shortBreakGradientEnd: Color,
    val longBreakGradientStart: Color,
    val longBreakGradientEnd: Color
) {
    /**
     * Display name (alias for name)
     */
    val displayName: String get() = name
    
    /**
     * Primary color as hex string
     */
    val primaryColorHex: String
        get() = String.format(
            "#%02X%02X%02X",
            (primaryColor.red * 255).toInt(),
            (primaryColor.green * 255).toInt(),
            (primaryColor.blue * 255).toInt()
        )
    
    /**
     * Returns the appropriate gradient colors for a session type
     */
    fun getGradientColors(sessionType: SessionType): Pair<Color, Color> {
        return when (sessionType) {
            SessionType.FOCUS -> Pair(focusGradientStart, focusGradientEnd)
            SessionType.SHORT_BREAK -> Pair(shortBreakGradientStart, shortBreakGradientEnd)
            SessionType.LONG_BREAK -> Pair(longBreakGradientStart, longBreakGradientEnd)
        }
    }

    /**
     * Returns the primary color for a session type
     */
    fun getColorForSessionType(sessionType: SessionType): Color {
        return when (sessionType) {
            SessionType.FOCUS -> primaryColor
            SessionType.SHORT_BREAK -> shortBreakGradientStart
            SessionType.LONG_BREAK -> longBreakGradientStart
        }
    }

    companion object {
        // Extracted from iOS AppTheme.swift

        val ClassicRed = AppTheme(
            id = "classic_red",
            name = "Classic Red",
            primaryColor = Color(0xFFED4242),
            secondaryColor = Color(0xFFFA7343),
            accentColor = Color(0xFFED4242),
            focusGradientStart = Color(0xFFED4242),
            focusGradientEnd = Color(0xFFFA7343),
            shortBreakGradientStart = Color(0xFF33C759),
            shortBreakGradientEnd = Color(0xFF29A699),
            longBreakGradientStart = Color(0xFF5957D6),
            longBreakGradientEnd = Color(0xFF35ACDB)
        )

        val OceanBlue = AppTheme(
            id = "ocean_blue",
            name = "Ocean Blue",
            primaryColor = Color(0xFF3399DB),
            secondaryColor = Color(0xFF33CCED),
            accentColor = Color(0xFF3399DB),
            focusGradientStart = Color(0xFF3399DB),
            focusGradientEnd = Color(0xFF33CCED),
            shortBreakGradientStart = Color(0xFF66D9EB),
            shortBreakGradientEnd = Color(0xFF99EDD9),
            longBreakGradientStart = Color(0xFF2673B3),
            longBreakGradientEnd = Color(0xFF4DA6D9)
        )

        val ForestGreen = AppTheme(
            id = "forest_green",
            name = "Forest Green",
            primaryColor = Color(0xFF339966),
            secondaryColor = Color(0xFF4DC785),
            accentColor = Color(0xFF339966),
            focusGradientStart = Color(0xFF339966),
            focusGradientEnd = Color(0xFF4DC785),
            shortBreakGradientStart = Color(0xFF80D1A6),
            shortBreakGradientEnd = Color(0xFFA6E6B3),
            longBreakGradientStart = Color(0xFF26734D),
            longBreakGradientEnd = Color(0xFF409973)
        )

        val MidnightDark = AppTheme(
            id = "midnight_dark",
            name = "Midnight Dark",
            primaryColor = Color(0xFF736BC2),
            secondaryColor = Color(0xFF998CD9),
            accentColor = Color(0xFF736BC2),
            focusGradientStart = Color(0xFF736BC2),
            focusGradientEnd = Color(0xFF998CD9),
            shortBreakGradientStart = Color(0xFF59B3BF),
            shortBreakGradientEnd = Color(0xFF80CCD1),
            longBreakGradientStart = Color(0xFF4D478C),
            longBreakGradientEnd = Color(0xFF736BB3)
        )

        val SunsetOrange = AppTheme(
            id = "sunset_orange",
            name = "Sunset Orange",
            primaryColor = Color(0xFFFA8033),
            secondaryColor = Color(0xFFFFA64D),
            accentColor = Color(0xFFFA8033),
            focusGradientStart = Color(0xFFFA8033),
            focusGradientEnd = Color(0xFFFFA64D),
            shortBreakGradientStart = Color(0xFFFFBF66),
            shortBreakGradientEnd = Color(0xFFFFD999),
            longBreakGradientStart = Color(0xFFD96626),
            longBreakGradientEnd = Color(0xFFF28C40)
        )

        /**
         * All available themes
         */
        val allThemes = listOf(
            ClassicRed,
            OceanBlue,
            ForestGreen,
            MidnightDark,
            SunsetOrange
        )

        /**
         * Get theme by ID
         */
        fun getById(id: String): AppTheme {
            return allThemes.find { it.id == id } ?: ClassicRed
        }
    }
}
