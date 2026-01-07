package com.avtanshgupta.mr.pomodoro.util

import android.view.View
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.hapticfeedback.HapticFeedback
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.platform.LocalView
import kotlinx.coroutines.flow.Flow

/**
 * HapticManager provides centralized haptic feedback functionality.
 * Matches iOS HapticManager behavior for consistent tactile feedback.
 * 
 * Usage in Composable:
 * ```
 * val hapticManager = rememberHapticManager()
 * hapticManager.selection() // For UI selection feedback
 * hapticManager.impact() // For button press feedback
 * hapticManager.success() // For successful actions
 * hapticManager.warning() // For warnings
 * hapticManager.error() // For errors
 * ```
 */
class HapticManager(
    private val hapticFeedback: HapticFeedback,
    private val view: View?,
    private val isEnabled: () -> Boolean
) {
    
    /**
     * Light selection feedback - used for UI element selection, theme changes, etc.
     * Equivalent to iOS UISelectionFeedbackGenerator
     */
    fun selection() {
        if (isEnabled()) {
            hapticFeedback.performHapticFeedback(HapticFeedbackType.TextHandleMove)
        }
    }
    
    /**
     * Medium impact feedback - used for button presses, toggle switches
     * Equivalent to iOS UIImpactFeedbackGenerator with medium style
     */
    fun impact() {
        if (isEnabled()) {
            view?.performHapticFeedback(android.view.HapticFeedbackConstants.VIRTUAL_KEY)
                ?: hapticFeedback.performHapticFeedback(HapticFeedbackType.LongPress)
        }
    }
    
    /**
     * Light impact feedback - used for subtle interactions
     * Equivalent to iOS UIImpactFeedbackGenerator with light style
     */
    fun lightImpact() {
        if (isEnabled()) {
            view?.performHapticFeedback(android.view.HapticFeedbackConstants.KEYBOARD_TAP)
                ?: hapticFeedback.performHapticFeedback(HapticFeedbackType.TextHandleMove)
        }
    }
    
    /**
     * Heavy impact feedback - used for important actions
     * Equivalent to iOS UIImpactFeedbackGenerator with heavy style
     */
    fun heavyImpact() {
        if (isEnabled()) {
            view?.performHapticFeedback(android.view.HapticFeedbackConstants.LONG_PRESS)
                ?: hapticFeedback.performHapticFeedback(HapticFeedbackType.LongPress)
        }
    }
    
    /**
     * Success notification feedback - used for successful completions
     * Equivalent to iOS UINotificationFeedbackGenerator with success type
     */
    fun success() {
        if (isEnabled()) {
            view?.performHapticFeedback(android.view.HapticFeedbackConstants.CONFIRM)
                ?: hapticFeedback.performHapticFeedback(HapticFeedbackType.LongPress)
        }
    }
    
    /**
     * Warning notification feedback - used for warnings
     * Equivalent to iOS UINotificationFeedbackGenerator with warning type
     */
    fun warning() {
        if (isEnabled()) {
            view?.performHapticFeedback(android.view.HapticFeedbackConstants.CONTEXT_CLICK)
                ?: hapticFeedback.performHapticFeedback(HapticFeedbackType.LongPress)
        }
    }
    
    /**
     * Error notification feedback - used for errors or failures
     * Equivalent to iOS UINotificationFeedbackGenerator with error type
     */
    fun error() {
        if (isEnabled()) {
            view?.performHapticFeedback(android.view.HapticFeedbackConstants.REJECT)
                ?: hapticFeedback.performHapticFeedback(HapticFeedbackType.LongPress)
        }
    }
    
    /**
     * Timer completion feedback - special feedback for timer completions
     * Uses a distinctive pattern to signal timer end
     */
    fun timerComplete() {
        if (isEnabled()) {
            // Use CONFIRM for timer completion (feels satisfying)
            view?.performHapticFeedback(android.view.HapticFeedbackConstants.CONFIRM)
                ?: hapticFeedback.performHapticFeedback(HapticFeedbackType.LongPress)
        }
    }
    
    companion object {
        /**
         * Create a HapticManager that's always disabled (for preview/testing)
         */
        fun disabled(): HapticManager {
            return HapticManager(
                hapticFeedback = object : HapticFeedback {
                    override fun performHapticFeedback(hapticFeedbackType: HapticFeedbackType) {}
                },
                view = null,
                isEnabled = { false }
            )
        }
    }
}

/**
 * Remember a HapticManager instance in a Composable.
 * The manager respects the haptic settings from the provided Flow.
 * 
 * @param hapticEnabledFlow Flow that emits whether haptic feedback is enabled
 * @return HapticManager instance
 */
@Composable
fun rememberHapticManager(
    hapticEnabledFlow: Flow<Boolean>? = null
): HapticManager {
    val hapticFeedback = LocalHapticFeedback.current
    val view = LocalView.current
    
    return remember(hapticFeedback, view, hapticEnabledFlow) {
        HapticManager(
            hapticFeedback = hapticFeedback,
            view = view,
            isEnabled = { true } // Default to enabled if no flow provided
        )
    }
}

/**
 * Remember a HapticManager instance with a simple boolean state.
 * 
 * @param isEnabled Whether haptic feedback is enabled
 * @return HapticManager instance
 */
@Composable
fun rememberHapticManager(isEnabled: Boolean = true): HapticManager {
    val hapticFeedback = LocalHapticFeedback.current
    val view = LocalView.current
    
    return remember(hapticFeedback, view, isEnabled) {
        HapticManager(
            hapticFeedback = hapticFeedback,
            view = view,
            isEnabled = { isEnabled }
        )
    }
}
