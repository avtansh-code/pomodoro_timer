package com.pomodoro.timer.util

import android.content.Context
import android.content.Intent
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import com.pomodoro.timer.MainActivity
import com.pomodoro.timer.R
import com.pomodoro.timer.domain.model.TimerState

/**
 * DynamicShortcutManager manages dynamic app shortcuts.
 * 
 * Dynamic shortcuts change based on app state:
 * - Show "Resume Timer" when timer is paused
 * - Show "Pause Timer" when timer is running
 * - Show "Start Focus" when timer is idle
 * 
 * Maps to iOS dynamic shortcuts functionality.
 * Max 4 dynamic shortcuts allowed by Android.
 */
class DynamicShortcutManager(private val context: Context) {
    
    companion object {
        private const val SHORTCUT_START_FOCUS = "dynamic_start_focus"
        private const val SHORTCUT_PAUSE_TIMER = "dynamic_pause_timer"
        private const val SHORTCUT_RESUME_TIMER = "dynamic_resume_timer"
        private const val SHORTCUT_RESET_TIMER = "dynamic_reset_timer"
        private const val MAX_SHORTCUTS = 4
    }
    
    /**
     * Update shortcuts based on current timer state
     */
    fun updateShortcuts(timerState: TimerState, isRunning: Boolean) {
        val shortcuts = mutableListOf<ShortcutInfoCompat>()
        
        when {
            // Timer is running - offer Pause and Reset
            isRunning -> {
                shortcuts.add(createPauseShortcut())
                shortcuts.add(createResetShortcut())
                shortcuts.add(createViewStatsShortcut())
            }
            // Timer is paused - offer Resume and Reset
            timerState == TimerState.PAUSED -> {
                shortcuts.add(createResumeShortcut())
                shortcuts.add(createResetShortcut())
                shortcuts.add(createViewStatsShortcut())
            }
            // Timer is idle - offer Start options
            else -> {
                shortcuts.add(createStartFocusShortcut())
                shortcuts.add(createStartShortBreakShortcut())
                shortcuts.add(createStartLongBreakShortcut())
                shortcuts.add(createViewStatsShortcut())
            }
        }
        
        // Update dynamic shortcuts
        ShortcutManagerCompat.setDynamicShortcuts(context, shortcuts.take(MAX_SHORTCUTS))
    }
    
    /**
     * Remove all dynamic shortcuts
     */
    fun removeAllShortcuts() {
        ShortcutManagerCompat.removeAllDynamicShortcuts(context)
    }
    
    /**
     * Push a shortcut (for reporting usage)
     */
    fun reportShortcutUsed(shortcutId: String) {
        ShortcutManagerCompat.reportShortcutUsed(context, shortcutId)
    }
    
    // Shortcut Creators
    
    private fun createStartFocusShortcut(): ShortcutInfoCompat {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("pomodoro://start/focus")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        return ShortcutInfoCompat.Builder(context, SHORTCUT_START_FOCUS)
            .setShortLabel("Start Focus")
            .setLongLabel("Start Focus Session")
            .setIcon(IconCompat.createWithResource(context, R.drawable.ic_launcher_foreground))
            .setIntent(intent)
            .setRank(0)
            .build()
    }
    
    private fun createStartShortBreakShortcut(): ShortcutInfoCompat {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("pomodoro://start/short_break")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        return ShortcutInfoCompat.Builder(context, "dynamic_start_short_break")
            .setShortLabel("Short Break")
            .setLongLabel("Start Short Break")
            .setIcon(IconCompat.createWithResource(context, R.drawable.ic_launcher_foreground))
            .setIntent(intent)
            .setRank(1)
            .build()
    }
    
    private fun createStartLongBreakShortcut(): ShortcutInfoCompat {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("pomodoro://start/long_break")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        return ShortcutInfoCompat.Builder(context, "dynamic_start_long_break")
            .setShortLabel("Long Break")
            .setLongLabel("Start Long Break")
            .setIcon(IconCompat.createWithResource(context, R.drawable.ic_launcher_foreground))
            .setIntent(intent)
            .setRank(2)
            .build()
    }
    
    private fun createPauseShortcut(): ShortcutInfoCompat {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("pomodoro://action/pause")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        return ShortcutInfoCompat.Builder(context, SHORTCUT_PAUSE_TIMER)
            .setShortLabel("Pause Timer")
            .setLongLabel("Pause Current Session")
            .setIcon(IconCompat.createWithResource(context, R.drawable.ic_launcher_foreground))
            .setIntent(intent)
            .setRank(0)
            .build()
    }
    
    private fun createResumeShortcut(): ShortcutInfoCompat {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("pomodoro://action/resume")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        return ShortcutInfoCompat.Builder(context, SHORTCUT_RESUME_TIMER)
            .setShortLabel("Resume Timer")
            .setLongLabel("Resume Current Session")
            .setIcon(IconCompat.createWithResource(context, R.drawable.ic_launcher_foreground))
            .setIntent(intent)
            .setRank(0)
            .build()
    }
    
    private fun createResetShortcut(): ShortcutInfoCompat {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("pomodoro://action/reset")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        return ShortcutInfoCompat.Builder(context, SHORTCUT_RESET_TIMER)
            .setShortLabel("Reset Timer")
            .setLongLabel("Reset Current Session")
            .setIcon(IconCompat.createWithResource(context, R.drawable.ic_launcher_foreground))
            .setIntent(intent)
            .setRank(1)
            .build()
    }
    
    private fun createViewStatsShortcut(): ShortcutInfoCompat {
        val intent = Intent(context, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = android.net.Uri.parse("pomodoro://view/statistics")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        
        return ShortcutInfoCompat.Builder(context, "dynamic_view_stats")
            .setShortLabel("Statistics")
            .setLongLabel("View Statistics")
            .setIcon(IconCompat.createWithResource(context, R.drawable.ic_launcher_foreground))
            .setIntent(intent)
            .setRank(3)
            .build()
    }
}
