package com.avtanshgupta.mr.pomodoro

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

/**
 * Application class for Pomodoro Timer.
 * Annotated with @HiltAndroidApp to enable Hilt dependency injection.
 */
@HiltAndroidApp
class PomodoroApplication : Application() {
    
    override fun onCreate() {
        super.onCreate()
        // Application-level initialization can go here
    }
}
