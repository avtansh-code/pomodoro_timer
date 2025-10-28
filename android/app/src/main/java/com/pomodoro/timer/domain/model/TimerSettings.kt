package com.pomodoro.timer.domain.model

import kotlinx.serialization.Serializable

/**
 * Represents user settings for the Pomodoro Timer.
 * Maps to TimerSettings class in iOS app (TimerSettings.swift)
 *
 * All duration values are in seconds to match iOS implementation.
 */
@Serializable
data class TimerSettings(
    val focusDuration: Long = 25 * 60, // 25 minutes in seconds
    val shortBreakDuration: Long = 5 * 60, // 5 minutes in seconds
    val longBreakDuration: Long = 15 * 60, // 15 minutes in seconds
    val sessionsUntilLongBreak: Int = 4,
    val autoStartBreaks: Boolean = false,
    val autoStartFocus: Boolean = false,
    val soundEnabled: Boolean = true,
    val hapticEnabled: Boolean = true,
    val notificationsEnabled: Boolean = true,
    val selectedTheme: AppThemeType = AppThemeType.SYSTEM,
    val selectedCustomTheme: String = "classic_red", // ID of the custom color theme
    val focusModeEnabled: Boolean = false,
    val syncWithFocusMode: Boolean = false
) {
    /**
     * Returns the duration for a specific session type
     */
    fun getDuration(sessionType: SessionType): Long {
        return when (sessionType) {
            SessionType.FOCUS -> focusDuration
            SessionType.SHORT_BREAK -> shortBreakDuration
            SessionType.LONG_BREAK -> longBreakDuration
        }
    }

    /**
     * Returns duration in minutes for display
     */
    fun getDurationInMinutes(sessionType: SessionType): Int {
        return (getDuration(sessionType) / 60).toInt()
    }

    /**
     * Creates a copy with updated duration (in minutes)
     */
    fun withDuration(sessionType: SessionType, minutes: Int): TimerSettings {
        val seconds = minutes * 60L
        return when (sessionType) {
            SessionType.FOCUS -> copy(focusDuration = seconds)
            SessionType.SHORT_BREAK -> copy(shortBreakDuration = seconds)
            SessionType.LONG_BREAK -> copy(longBreakDuration = seconds)
        }
    }

    companion object {
        /**
         * Default settings matching iOS app defaults
         */
        val DEFAULT = TimerSettings()

        /**
         * Validates duration is within acceptable range (1-120 minutes)
         */
        fun isValidDuration(minutes: Int): Boolean {
            return minutes in 1..120
        }

        /**
         * Validates sessions until long break is within acceptable range (2-10)
         */
        fun isValidSessionsCount(count: Int): Boolean {
            return count in 2..10
        }
    }
}

/**
 * App theme selection (System, Light, Dark).
 * Maps to AppTheme enum in iOS TimerSettings.swift
 */
@Serializable
enum class AppThemeType {
    SYSTEM,
    LIGHT,
    DARK;

    val displayName: String
        get() = when (this) {
            SYSTEM -> "System"
            LIGHT -> "Light"
            DARK -> "Dark"
        }

    companion object {
        fun fromString(value: String): AppThemeType {
            return entries.find { it.name == value } ?: SYSTEM
        }
    }
}
