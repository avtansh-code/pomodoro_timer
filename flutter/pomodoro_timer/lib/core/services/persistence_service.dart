import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_settings.dart';

/// Service for persisting and retrieving timer settings.
///
/// Uses SharedPreferences to store user preferences locally.
/// All methods are synchronous for simplicity since SharedPreferences
/// caches values in memory after initialization.
class PersistenceService {
  final SharedPreferences _prefs;

  static const String _settingsKey = 'timer_settings';

  PersistenceService(this._prefs);

  /// Saves timer settings to local storage.
  ///
  /// Returns true if the save was successful, false otherwise.
  Future<bool> saveSettings(TimerSettings settings) async {
    try {
      final jsonString = json.encode(settings.toJson());
      return await _prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      // Log error in production app
      return false;
    }
  }

  /// Retrieves timer settings from local storage.
  ///
  /// Returns the saved settings if available, otherwise returns
  /// default settings.
  TimerSettings getSettings() {
    try {
      final jsonString = _prefs.getString(_settingsKey);
      if (jsonString == null) {
        return const TimerSettings();
      }
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return TimerSettings.fromJson(jsonMap);
    } catch (e) {
      // If there's any error reading settings, return defaults
      return const TimerSettings();
    }
  }

  /// Clears all saved settings (useful for testing or reset functionality).
  Future<bool> clearSettings() async {
    return await _prefs.remove(_settingsKey);
  }

  /// Checks if settings have been saved before.
  bool hasSettings() {
    return _prefs.containsKey(_settingsKey);
  }
}
