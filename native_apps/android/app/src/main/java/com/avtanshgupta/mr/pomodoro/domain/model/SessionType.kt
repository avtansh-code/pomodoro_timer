package com.avtanshgupta.mr.pomodoro.domain.model

/**
 * Represents the type of Pomodoro session.
 * Maps to SessionType enum in iOS app (TimerSession.swift)
 */
enum class SessionType(val displayName: String) {
    FOCUS("Focus"),
    SHORT_BREAK("Short Break"),
    LONG_BREAK("Long Break");

    companion object {
        fun fromString(value: String): SessionType {
            return entries.find { it.name == value } ?: FOCUS
        }
    }
}
