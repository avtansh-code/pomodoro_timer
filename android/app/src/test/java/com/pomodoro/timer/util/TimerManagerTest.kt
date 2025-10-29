package com.pomodoro.timer.util

import com.pomodoro.timer.domain.model.SessionType
import com.pomodoro.timer.domain.model.TimerState
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.runTest
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

/**
 * Unit tests for TimerManager.
 * Demonstrates testing coroutine-based timer logic.
 */
@OptIn(ExperimentalCoroutinesApi::class)
class TimerManagerTest {
    
    private lateinit var timerManager: TimerManager
    private lateinit var testScope: TestScope
    
    @Before
    fun setup() {
        val testDispatcher = StandardTestDispatcher()
        testScope = TestScope(testDispatcher)
        timerManager = TimerManager()
        timerManager.initialize(testScope)
    }
    
    @Test
    fun `initial state should be idle`() {
        assertEquals(TimerState.IDLE, timerManager.timerState.value)
        assertEquals(25 * 60L, timerManager.timeRemaining.value) // Default focus duration
        assertEquals(0, timerManager.completedFocusSessions.value)
    }
    
    @Test
    fun `start should set timer to running state`() = testScope.runTest {
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        
        assertEquals(TimerState.RUNNING, timerManager.timerState.value)
        assertEquals(SessionType.FOCUS, timerManager.currentSessionType.value)
    }
    
    @Test
    fun `timer should count down correctly`() = testScope.runTest {
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        
        val initialTime = timerManager.timeRemaining.value
        
        // Advance time by 3 seconds
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        
        // Should have 3 seconds less remaining
        assertEquals(initialTime - 3L, timerManager.timeRemaining.value)
        assertEquals(TimerState.RUNNING, timerManager.timerState.value)
    }
    
    @Test
    fun `pause should stop timer countdown`() = testScope.runTest {
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        val timeAfterRunning = timerManager.timeRemaining.value
        
        timerManager.pauseTimer()
        assertEquals(TimerState.PAUSED, timerManager.timerState.value)
        
        // Advance time while paused
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        
        // Time should not have changed
        assertEquals(timeAfterRunning, timerManager.timeRemaining.value)
    }
    
    @Test
    fun `resume should continue timer from paused state`() = testScope.runTest {
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        
        val timeBeforePause = timerManager.timeRemaining.value
        timerManager.pauseTimer()
        
        timerManager.startTimer() // Resume by calling startTimer again
        assertEquals(TimerState.RUNNING, timerManager.timerState.value)
        
        testScheduler.apply { advanceTimeBy(2000L); runCurrent() }
        assertEquals(timeBeforePause - 2L, timerManager.timeRemaining.value)
    }
    
    @Test
    fun `reset should return timer to idle state`() = testScope.runTest {
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        advanceTimeBy(10000L)
        
        timerManager.resetTimer()
        
        assertEquals(TimerState.IDLE, timerManager.timerState.value)
        assertTrue(timerManager.timeRemaining.value > 0L) // Reset restores duration
    }
    
    @Test
    fun `timer completion should increment session count for focus`() = testScope.runTest {
        assertEquals(0, timerManager.completedFocusSessions.value)
        
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        
        // Fast-forward to completion
        val duration = timerManager.timeRemaining.value
        advanceTimeBy((duration + 1) * 1000L)
        
        timerManager.switchToNextSession()
        assertEquals(1, timerManager.completedFocusSessions.value)
    }
    
    @Test
    fun `timer completion should not increment for breaks`() = testScope.runTest {
        val initialCount = timerManager.completedFocusSessions.value
        
        timerManager.prepareSession(SessionType.SHORT_BREAK)
        timerManager.startTimer()
        
        val duration = timerManager.timeRemaining.value
        advanceTimeBy((duration + 1) * 1000L)
        
        timerManager.switchToNextSession()
        assertEquals(initialCount, timerManager.completedFocusSessions.value)
    }
    
    @Test
    fun `getProgress should return correct percentage`() = testScope.runTest {
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        
        val totalDuration = timerManager.settings.value.focusDuration
        assertEquals(0.0f, timerManager.getProgress(), 0.01f)
        
        testScheduler.apply { advanceTimeBy((totalDuration * 250).toLong()); runCurrent() } // 25% time
        assertTrue(timerManager.getProgress() > 0.20f && timerManager.getProgress() < 0.30f)
    }
    
    @Test
    fun `formatTime should format seconds correctly`() {
        assertEquals("00:00", timerManager.formatTime(0))
        assertEquals("00:30", timerManager.formatTime(30))
        assertEquals("01:00", timerManager.formatTime(60))
        assertEquals("25:00", timerManager.formatTime(1500))
        assertEquals("99:59", timerManager.formatTime(5999))
    }
    
    @Test
    fun `isRunning should return correct state`() = testScope.runTest {
        assertFalse(timerManager.isRunning())
        
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        assertTrue(timerManager.isRunning())
        
        timerManager.pauseTimer()
        assertFalse(timerManager.isRunning())
        
        timerManager.startTimer()
        assertTrue(timerManager.isRunning())
    }
    
    @Test
    fun `isPaused should return correct state`() = testScope.runTest {
        assertFalse(timerManager.isPaused())
        
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        assertFalse(timerManager.isPaused())
        
        timerManager.pauseTimer()
        assertTrue(timerManager.isPaused())
        
        timerManager.startTimer()
        assertFalse(timerManager.isPaused())
    }
    
    @Test
    fun `skip should stop timer and switch session`() = testScope.runTest {
        timerManager.prepareSession(SessionType.FOCUS)
        timerManager.startTimer()
        advanceTimeBy(10000L)
        
        val completedBefore = timerManager.completedFocusSessions.value
        timerManager.skipSession()
        
        assertEquals(TimerState.IDLE, timerManager.timerState.value)
        // Skip switches to next session, so completed sessions increases for focus
        assertEquals(completedBefore + 1, timerManager.completedFocusSessions.value)
    }
}
