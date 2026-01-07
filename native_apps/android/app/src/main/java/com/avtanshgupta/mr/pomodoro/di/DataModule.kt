package avtanshgupta.PomodoroTimer.di

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore
import androidx.room.Room
import avtanshgupta.PomodoroTimer.data.local.database.PomodoroDatabase
import avtanshgupta.PomodoroTimer.data.local.database.SessionDao
import avtanshgupta.PomodoroTimer.data.local.datastore.SettingsDataStore
import avtanshgupta.PomodoroTimer.data.repository.SessionRepositoryImpl
import avtanshgupta.PomodoroTimer.data.repository.SettingsRepositoryImpl
import avtanshgupta.PomodoroTimer.domain.repository.SessionRepository
import avtanshgupta.PomodoroTimer.domain.repository.SettingsRepository
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Hilt module for data layer dependencies.
 * Provides database, DataStore, and repository implementations.
 */
@Module
@InstallIn(SingletonComponent::class)
object DataModule {
    
    // DataStore extension property
    private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(
        name = "pomodoro_settings"
    )
    
    /**
     * Provides Room database instance
     */
    @Provides
    @Singleton
    fun providePomodoroDatabase(
        @ApplicationContext context: Context
    ): PomodoroDatabase {
        return Room.databaseBuilder(
            context,
            PomodoroDatabase::class.java,
            PomodoroDatabase.DATABASE_NAME
        )
            .fallbackToDestructiveMigration() // For development, remove in production
            .build()
    }
    
    /**
     * Provides SessionDao from database
     */
    @Provides
    @Singleton
    fun provideSessionDao(database: PomodoroDatabase): SessionDao {
        return database.sessionDao()
    }
    
    /**
     * Provides DataStore for settings
     */
    @Provides
    @Singleton
    fun provideDataStore(
        @ApplicationContext context: Context
    ): DataStore<Preferences> {
        return context.dataStore
    }
    
    /**
     * Provides SettingsDataStore
     */
    @Provides
    @Singleton
    fun provideSettingsDataStore(
        dataStore: DataStore<Preferences>
    ): SettingsDataStore {
        return SettingsDataStore(dataStore)
    }
    
    /**
     * Provides SessionRepository implementation
     */
    @Provides
    @Singleton
    fun provideSessionRepository(
        sessionDao: SessionDao
    ): SessionRepository {
        return SessionRepositoryImpl(sessionDao)
    }
    
    /**
     * Provides SettingsRepository implementation
     */
    @Provides
    @Singleton
    fun provideSettingsRepository(
        settingsDataStore: SettingsDataStore
    ): SettingsRepository {
        return SettingsRepositoryImpl(settingsDataStore)
    }
}
