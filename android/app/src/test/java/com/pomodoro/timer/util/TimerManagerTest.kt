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
        assertEquals(TimerState.IDLE, timerManager.state.value)
        assertEquals(0L, timerManager.remainingSeconds.value)
        assertEquals(0L, timerManager.totalSeconds.value)
    }
    
    @Test
    fun `start should set timer to running state`() = testScope.runTest {
        timerManager.start(SessionType.FOCUS, 60L)
        
        assertEquals(TimerState.RUNNING, timerManager.state.value)
        assertEquals(SessionType.FOCUS, timerManager.sessionType.value)
        assertEquals(60L, timerManager.remainingSeconds.value)
        assertEquals(60L, timerManager.totalSeconds.value)
    }
    
    @Test
    fun `timer should count down correctly`() = testScope.runTest {
        timerManager.start(SessionType.FOCUS, 5L)
        
        // Advance time by 3 seconds
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        
        // Should have 2 seconds remaining
        assertEquals(2L, timerManager.remainingSeconds.value)
        assertEquals(TimerState.RUNNING, timerManager.state.value)
    }
    
    @Test
    fun `pause should stop timer countdown`() = testScope.runTest {
        timerManager.start(SessionType.FOCUS, 10L)
        
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        assertEquals(7L, timerManager.remainingSeconds.value)
        
        timerManager.pause()
        assertEquals(TimerState.PAUSED, timerManager.state.value)
        
        // Advance time while paused
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        
        // Time should not have changed
        assertEquals(7L, timerManager.remainingSeconds.value)
    }
    
    @Test
    fun `resume should continue timer from paused state`() = testScope.runTest {
        timerManager.start(SessionType.FOCUS, 10L)
        testScheduler.apply { advanceTimeBy(3000L); runCurrent() }
        
        timerManager.pause()
        assertEquals(7L, timerManager.remainingSeconds.value)
        
        timerManager.resume()
        assertEquals(TimerState.RUNNING, timerManager.state.value)
        
        testScheduler.apply { advanceTimeBy(2000L); runCurrent() }
        assertEquals(5L, timerManager.remainingSeconds.value)
    }
    
    @Test
    fun `reset should return timer to idle state`() = testScope.runTest {
        timerManager.start(SessionType.FOCUS, 60L)
        advanceTimeBy(10000L)
        
        timerManager.reset()
        
        assertEquals(TimerState.IDLE, timerManager.state.value)
        assertEquals(0L, timerManager.remainingSeconds.value)
        assertEquals(0L, timerManager.totalSeconds.value)
    }
    
    @Test
    fun `timer completion should increment session count for focus`() = testScope.runTest {
        assertEquals(0, timerManager.completedSessions.value)
        
        timerManager.start(SessionType.FOCUS, 3L)
        
        // Fast-forward to completion
        advanceTimeBy(4000L)
        
        assertEquals(TimerState.IDLE, timerManager.state.value)
        assertEquals(1, timerManager.completedSessions.value)
    }
    
    @Test
    fun `timer completion should not increment for breaks`() = testScope.runTest {
        assertEquals(0, timerManager.completedSessions.value)
        
        timerManager.start(SessionType.SHORT_BREAK, 3L)
        advanceTimeBy(4000L)
        
        assertEquals(0, timerManager.completedSessions.value)
    }
    
    @Test
    fun `getProgress should return correct percentage`() = testScope.runTest {
        timerManager.start(SessionType.FOCUS, 100L)
        
        assertEquals(0.0f, timerManager.getProgress(), 0.01f)
        
        testScheduler.apply { advanceTimeBy(25000L); runCurrent() }
        assertEquals(0.25f, timerManager.getProgress(), 0.01f)
        
        testScheduler.apply { advanceTimeBy(25000L); runCurrent() }
        assertEquals(0.50f, timerManager.getProgress(), 0.01f)
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
        
        timerManager.start(SessionType.FOCUS, 60L)
        assertTrue(timerManager.isRunning())
        
        timerManager.pause()
        assertFalse(timerManager.isRunning())
        
        timerManager.resume()
        assertTrue(timerManager.isRunning())
    }
    
    @Test
    fun `isPaused should return correct state`() = testScope.runTest {
        assertFalse(timerManager.isPaused())
        
        timerManager.start(SessionType.FOCUS, 60L)
        assertFalse(timerManager.isPaused())
        
        timerManager.pause()
        assertTrue(timerManager.isPaused())
        
        timerManager.resume()
        assertFalse(timerManager.isPaused())
    }
    
    @Test
    fun `skip should stop timer without incrementing sessions`() = testScope.runTest {
        timerManager.start(SessionType.FOCUS, 60L)
        advanceTimeBy(10000L)
        
        val completedBefore = timerManager.completedSessions.value
        timerManager.skip()
        
        assertEquals(TimerState.IDLE, timerManager.state.value)
        assertEquals(0L, timerManager.remainingSeconds.value)
        assertEquals(completedBefore, timerManager.completedSessions.value)
    }
}
