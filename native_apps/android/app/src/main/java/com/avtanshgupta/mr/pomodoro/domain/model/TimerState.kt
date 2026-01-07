package avtanshgupta.PomodoroTimer.domain.model

/**
 * Represents the current state of the timer.
 * Maps to TimerState enum in iOS app (TimerManager.swift)
 */
enum class TimerState {
    IDLE,
    RUNNING,
    PAUSED
}
