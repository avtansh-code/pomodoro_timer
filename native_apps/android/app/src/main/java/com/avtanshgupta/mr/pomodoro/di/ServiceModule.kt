package com.avtanshgupta.mr.pomodoro.di

import android.content.Context
import com.avtanshgupta.mr.pomodoro.domain.repository.SessionRepository
import com.avtanshgupta.mr.pomodoro.manager.DoNotDisturbManager
import com.avtanshgupta.mr.pomodoro.manager.ScreenshotHelper
import com.avtanshgupta.mr.pomodoro.service.NotificationHelper
import com.avtanshgupta.mr.pomodoro.util.TimerManager
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
