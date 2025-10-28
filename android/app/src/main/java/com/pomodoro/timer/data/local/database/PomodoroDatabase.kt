package com.pomodoro.timer.data.local.database

import androidx.room.Database
import androidx.room.RoomDatabase
import com.pomodoro.timer.data.local.database.entity.SessionEntity

/**
 * Room database for Pomodoro Timer app.
 * Stores timer sessions in a local SQLite database.
 *
 * Version 1: Initial schema with sessions table
 */
@Database(
    entities = [SessionEntity::class],
    version = 1,
    exportSchema = true
)
abstract class PomodoroDatabase : RoomDatabase() {
    
    /**
     * Provides access to session data
     */
    abstract fun sessionDao(): SessionDao
    
    companion object {
        const val DATABASE_NAME = "pomodoro_database"
    }
}
