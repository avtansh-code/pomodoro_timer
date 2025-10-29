package com.avtanshgupta.mr.pomodoro.domain.model

import kotlinx.serialization.Serializable
import java.time.Instant
import java.util.UUID

/**
 * Represents a completed Pomodoro session.
 * Maps to TimerSession struct in iOS app (TimerSession.swift)
 *
 * @property id Unique identifier for the session
 * @property type Type of session (Focus, Short Break, Long Break)
 * @property duration Duration of the session in seconds
 * @property completedAt Timestamp when the session was completed
 * @property wasCompleted Whether the session was completed (true) or skipped (false)
 */
@Serializable
data class TimerSession(
    val id: String = UUID.randomUUID().toString(),
    val type: SessionType,
    val duration: Long, // Duration in seconds
    val completedAt: Long = Instant.now().epochSecond,
    val wasCompleted: Boolean = true
) {
    /**
     * Returns the duration in minutes (rounded)
     */
    val durationInMinutes: Int
        get() = (duration / 60).toInt()

    /**
     * Returns a human-readable description of the session
     */
    val description: String
        get() = "${type.displayName} - ${durationInMinutes}m ${if (wasCompleted) "completed" else "skipped"}"
}
