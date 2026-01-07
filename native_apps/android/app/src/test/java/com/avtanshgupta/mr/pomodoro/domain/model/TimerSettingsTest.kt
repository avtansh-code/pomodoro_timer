package com.avtanshgupta.mr.pomodoro.domain.model

import org.junit.Assert.*
import org.junit.Test

/**
 * Unit tests for TimerSettings domain model.
 * Demonstrates testing approach for domain layer.
 */
class TimerSettingsTest {
    
    @Test
    fun `default settings should have correct values`() {
        val settings = TimerSettings.DEFAULT
        
        assertEquals(25 * 60L, settings.focusDuration)
        assertEquals(5 * 60L, settings.shortBreakDuration)
        assertEquals(15 * 60L, settings.longBreakDuration)
        assertEquals(4, settings.sessionsUntilLongBreak)
        assertFalse(settings.autoStartBreaks)
        assertFalse(settings.autoStartFocus)
        assertTrue(settings.soundEnabled)
        assertTrue(settings.hapticEnabled)
        assertTrue(settings.notificationsEnabled)
        assertEquals(AppThemeType.SYSTEM, settings.selectedTheme)
        assertEquals("classic_red", settings.selectedCustomTheme)
    }
    
    @Test
    fun `getDuration should return correct duration for session type`() {
        val settings = TimerSettings.DEFAULT
        
        assertEquals(25 * 60L, settings.getDuration(SessionType.FOCUS))
        assertEquals(5 * 60L, settings.getDuration(SessionType.SHORT_BREAK))
        assertEquals(15 * 60L, settings.getDuration(SessionType.LONG_BREAK))
    }
    
    @Test
    fun `getDurationInMinutes should return correct minutes`() {
        val settings = TimerSettings.DEFAULT
        
        assertEquals(25, settings.getDurationInMinutes(SessionType.FOCUS))
        assertEquals(5, settings.getDurationInMinutes(SessionType.SHORT_BREAK))
        assertEquals(15, settings.getDurationInMinutes(SessionType.LONG_BREAK))
    }
    
    @Test
    fun `withDuration should update correct duration`() {
        val settings = TimerSettings.DEFAULT
        
        val updatedFocus = settings.withDuration(SessionType.FOCUS, 30)
        assertEquals(30 * 60L, updatedFocus.focusDuration)
        assertEquals(5 * 60L, updatedFocus.shortBreakDuration) // unchanged
        
        val updatedShortBreak = settings.withDuration(SessionType.SHORT_BREAK, 10)
        assertEquals(25 * 60L, updatedShortBreak.focusDuration) // unchanged
        assertEquals(10 * 60L, updatedShortBreak.shortBreakDuration)
        
        val updatedLongBreak = settings.withDuration(SessionType.LONG_BREAK, 20)
        assertEquals(20 * 60L, updatedLongBreak.longBreakDuration)
    }
    
    @Test
    fun `isValidDuration should validate duration range`() {
        assertTrue(TimerSettings.isValidDuration(1))
        assertTrue(TimerSettings.isValidDuration(25))
        assertTrue(TimerSettings.isValidDuration(120))
        
        assertFalse(TimerSettings.isValidDuration(0))
        assertFalse(TimerSettings.isValidDuration(-1))
        assertFalse(TimerSettings.isValidDuration(121))
    }
    
    @Test
    fun `isValidSessionsCount should validate sessions range`() {
        assertTrue(TimerSettings.isValidSessionsCount(2))
        assertTrue(TimerSettings.isValidSessionsCount(4))
        assertTrue(TimerSettings.isValidSessionsCount(10))
        
        assertFalse(TimerSettings.isValidSessionsCount(1))
        assertFalse(TimerSettings.isValidSessionsCount(0))
        assertFalse(TimerSettings.isValidSessionsCount(11))
    }
    
    @Test
    fun `copy should create new instance with updated values`() {
        val original = TimerSettings.DEFAULT
        val modified = original.copy(
            focusDuration = 30 * 60L,
            autoStartBreaks = true
        )
        
        assertEquals(30 * 60L, modified.focusDuration)
        assertTrue(modified.autoStartBreaks)
        
        // Original should be unchanged
        assertEquals(25 * 60L, original.focusDuration)
        assertFalse(original.autoStartBreaks)
    }
}
