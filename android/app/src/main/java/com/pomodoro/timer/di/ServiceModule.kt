package com.pomodoro.timer.di

import android.content.Context
import com.pomodoro.timer.domain.repository.SessionRepository
import com.pomodoro.timer.manager.DoNotDisturbManager
import com.pomodoro.timer.manager.ScreenshotHelper
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
 * Provides TimerManager, NotificationHelper, DoNotDisturbManager, and ScreenshotHelper.
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
    
    /**
     * Provides DoNotDisturbManager singleton
     */
    @Provides
    @Singleton
    fun provideDoNotDisturbManager(
        @ApplicationContext context: Context
    ): DoNotDisturbManager {
        return DoNotDisturbManager(context)
    }
    
    /**
     * Provides ScreenshotHelper singleton
     */
    @Provides
    @Singleton
    fun provideScreenshotHelper(
        sessionRepository: SessionRepository
    ): ScreenshotHelper {
        return ScreenshotHelper(sessionRepository)
    }
}
