package com.pomodoro.timer.di

import android.content.Context
import com.pomodoro.timer.service.NotificationHelper
import com.pomodoro.timer.util.TimerManager
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Hilt module for service layer dependencies.
 * Provides TimerManager and NotificationHelper.
 */
@Module
@InstallIn(SingletonComponent::class)
object ServiceModule {
    
    /**
     * Provides TimerManager singleton
     */
    @Provides
    @Singleton
    fun provideTimerManager(): TimerManager {
        return TimerManager()
    }
    
    /**
     * Provides NotificationHelper singleton
     */
    @Provides
    @Singleton
    fun provideNotificationHelper(
        @ApplicationContext context: Context
    ): NotificationHelper {
        return NotificationHelper(context)
    }
}
