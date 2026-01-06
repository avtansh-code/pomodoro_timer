import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/models/timer_session.dart';

/// Repository for managing timer session statistics.
///
/// Provides data access layer for storing and retrieving
/// completed Pomodoro sessions using Hive database.
class StatisticsRepository {
  static const String _boxName = 'timer_sessions';
  Box<TimerSession>? _box;

  /// Initializes the Hive box for timer sessions.
  ///
  /// Must be called before any other repository methods.
  Future<void> initialize() async {
    _box = await Hive.openBox<TimerSession>(_boxName);
  }

  /// Adds a completed session to the database.
  ///
  /// Returns the key of the added session.
  Future<int> addSession(TimerSession session) async {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
    return await _box!.add(session);
  }

  /// Retrieves all sessions from the database.
  ///
  /// Returns sessions in chronological order (oldest first).
  List<TimerSession> getAllSessions() {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
    return _box!.values.toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Retrieves sessions within a date range.
  ///
  /// Both [start] and [end] are inclusive.
  List<TimerSession> getSessionsByDateRange(DateTime start, DateTime end) {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }

    return _box!.values.where((session) {
      return session.startTime.isAfter(
            start.subtract(const Duration(seconds: 1)),
          ) &&
          session.startTime.isBefore(end.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Retrieves sessions for today.
  List<TimerSession> getTodaySessions() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getSessionsByDateRange(startOfDay, endOfDay);
  }

  /// Retrieves sessions for the current week.
  ///
  /// Week starts on Monday.
  List<TimerSession> getWeekSessions() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return getSessionsByDateRange(startOfWeekDay, now);
  }

  /// Retrieves sessions for the current month.
  List<TimerSession> getMonthSessions() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    return getSessionsByDateRange(startOfMonth, now);
  }

  /// Gets the total number of sessions.
  int getSessionCount() {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
    return _box!.length;
  }

  /// Gets the count of work sessions only.
  int getWorkSessionCount() {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
    return _box!.values
        .where((session) => session.sessionType == SessionType.work)
        .length;
  }

  /// Calculates total focus time in minutes.
  int getTotalFocusTime() {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }

    return _box!.values
        .where((session) => session.sessionType == SessionType.work)
        .fold<int>(0, (total, session) => total + session.durationInMinutes);
  }

  /// Deletes a session by key.
  Future<void> deleteSession(int key) async {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
    await _box!.delete(key);
  }

  /// Clears all sessions from the database.
  ///
  /// Use with caution - this cannot be undone.
  Future<void> clearAllSessions() async {
    if (_box == null) {
      throw StateError('Repository not initialized. Call initialize() first.');
    }
    await _box!.clear();
  }

  /// Closes the Hive box.
  ///
  /// Should be called when the repository is no longer needed.
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
