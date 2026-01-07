package avtanshgupta.PomodoroTimer.di

import android.content.Context
import avtanshgupta.PomodoroTimer.domain.repository.SessionRepository
import avtanshgupta.PomodoroTimer.manager.DoNotDisturbManager
import avtanshgupta.PomodoroTimer.manager.ScreenshotHelper
import avtanshgupta.PomodoroTimer.service.NotificationHelper
import avtanshgupta.PomodoroTimer.util.TimerManager
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
