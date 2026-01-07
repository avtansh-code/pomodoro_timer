import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodoro_timer/core/services/persistence_service.dart';
import 'package:pomodoro_timer/core/models/timer_settings.dart';

void main() {
  group('PersistenceService', () {
    late SharedPreferences prefs;
    late PersistenceService persistenceService;

    setUp(() async {
      // Set up SharedPreferences with mock data
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      persistenceService = PersistenceService(prefs);
    });

    tearDown(() async {
      await prefs.clear();
    });

    test('initial state has no settings', () {
      expect(persistenceService.hasSettings(), false);
    });

    test('getSettings returns default settings when none saved', () {
      final settings = persistenceService.getSettings();

      expect(settings, equals(const TimerSettings()));
      expect(settings.workDuration, equals(25));
      expect(settings.shortBreakDuration, equals(5));
      expect(settings.longBreakDuration, equals(15));
      expect(settings.sessionsBeforeLongBreak, equals(4));
      expect(settings.soundEnabled, equals(true));
    });

    test('saveSettings persists settings successfully', () async {
      const settings = TimerSettings(
        workDuration: 30,
        shortBreakDuration: 10,
        longBreakDuration: 20,
        sessionsBeforeLongBreak: 3,
        soundEnabled: false,
      );

      final result = await persistenceService.saveSettings(settings);

      expect(result, true);
      expect(persistenceService.hasSettings(), true);
    });

    test('getSettings retrieves saved settings correctly', () async {
      const settings = TimerSettings(
        workDuration: 30,
        shortBreakDuration: 10,
        longBreakDuration: 20,
        sessionsBeforeLongBreak: 3,
        soundEnabled: false,
      );

      await persistenceService.saveSettings(settings);
      final retrievedSettings = persistenceService.getSettings();

      expect(retrievedSettings, equals(settings));
      expect(retrievedSettings.workDuration, equals(30));
      expect(retrievedSettings.shortBreakDuration, equals(10));
      expect(retrievedSettings.longBreakDuration, equals(20));
      expect(retrievedSettings.sessionsBeforeLongBreak, equals(3));
      expect(retrievedSettings.soundEnabled, equals(false));
    });

    test('saveSettings overwrites previous settings', () async {
      const firstSettings = TimerSettings(workDuration: 25);
      const secondSettings = TimerSettings(workDuration: 50);

      await persistenceService.saveSettings(firstSettings);
      await persistenceService.saveSettings(secondSettings);

      final retrieved = persistenceService.getSettings();
      expect(retrieved.workDuration, equals(50));
    });

    test('clearSettings removes saved settings', () async {
      const settings = TimerSettings(workDuration: 30);
      await persistenceService.saveSettings(settings);

      expect(persistenceService.hasSettings(), true);

      final result = await persistenceService.clearSettings();

      expect(result, true);
      expect(persistenceService.hasSettings(), false);
    });

    test('getSettings returns defaults after clearing', () async {
      const settings = TimerSettings(workDuration: 30);
      await persistenceService.saveSettings(settings);
      await persistenceService.clearSettings();

      final retrieved = persistenceService.getSettings();
      expect(retrieved, equals(const TimerSettings()));
    });

    test('hasSettings returns true after saving', () async {
      expect(persistenceService.hasSettings(), false);

      await persistenceService.saveSettings(const TimerSettings());

      expect(persistenceService.hasSettings(), true);
    });

    test('getSettings handles corrupted data gracefully', () async {
      // Manually set invalid JSON data
      await prefs.setString('timer_settings', 'invalid json');

      final settings = persistenceService.getSettings();

      // Should return default settings instead of crashing
      expect(settings, equals(const TimerSettings()));
    });

    test('multiple save and load operations work correctly', () async {
      const settings1 = TimerSettings(workDuration: 20);
      const settings2 = TimerSettings(workDuration: 30);
      const settings3 = TimerSettings(workDuration: 40);

      await persistenceService.saveSettings(settings1);
      expect(persistenceService.getSettings().workDuration, equals(20));

      await persistenceService.saveSettings(settings2);
      expect(persistenceService.getSettings().workDuration, equals(30));

      await persistenceService.saveSettings(settings3);
      expect(persistenceService.getSettings().workDuration, equals(40));
    });
  });
}
