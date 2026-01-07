import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/models/timer_settings.dart';

void main() {
  group('TimerSettings', () {
    test('creates instance with default values', () {
      const settings = TimerSettings();

      expect(settings.workDuration, 25);
      expect(settings.shortBreakDuration, 5);
      expect(settings.longBreakDuration, 15);
      expect(settings.sessionsBeforeLongBreak, 4);
      expect(settings.autoStartBreaks, false);
      expect(settings.autoStartFocus, false);
      expect(settings.notificationsEnabled, true);
      expect(settings.soundEnabled, true);
      expect(settings.hapticEnabled, true);
    });

    test('creates instance with custom values', () {
      const settings = TimerSettings(
        workDuration: 30,
        shortBreakDuration: 10,
        longBreakDuration: 20,
        sessionsBeforeLongBreak: 3,
        autoStartBreaks: true,
        autoStartFocus: true,
        notificationsEnabled: false,
        soundEnabled: false,
        hapticEnabled: false,
      );

      expect(settings.workDuration, 30);
      expect(settings.shortBreakDuration, 10);
      expect(settings.longBreakDuration, 20);
      expect(settings.sessionsBeforeLongBreak, 3);
      expect(settings.autoStartBreaks, true);
      expect(settings.autoStartFocus, true);
      expect(settings.notificationsEnabled, false);
      expect(settings.soundEnabled, false);
      expect(settings.hapticEnabled, false);
    });

    test('copyWith creates new instance with updated values', () {
      const settings = TimerSettings();
      final updated = settings.copyWith(
        workDuration: 30,
        autoStartBreaks: true,
      );

      expect(updated.workDuration, 30);
      expect(updated.shortBreakDuration, 5);
      expect(updated.longBreakDuration, 15);
      expect(updated.sessionsBeforeLongBreak, 4);
      expect(updated.autoStartBreaks, true);
      expect(updated.autoStartFocus, false);
      expect(updated.notificationsEnabled, true);
      expect(updated.soundEnabled, true);
      expect(updated.hapticEnabled, true);
    });

    test('toJson converts to map correctly', () {
      const settings = TimerSettings(
        workDuration: 30,
        shortBreakDuration: 10,
        longBreakDuration: 20,
        sessionsBeforeLongBreak: 3,
        autoStartBreaks: true,
        autoStartFocus: true,
        notificationsEnabled: false,
        soundEnabled: false,
        hapticEnabled: false,
      );

      final json = settings.toJson();

      expect(json['workDuration'], 30);
      expect(json['shortBreakDuration'], 10);
      expect(json['longBreakDuration'], 20);
      expect(json['sessionsBeforeLongBreak'], 3);
      expect(json['autoStartBreaks'], true);
      expect(json['autoStartFocus'], true);
      expect(json['notificationsEnabled'], false);
      expect(json['soundEnabled'], false);
      expect(json['hapticEnabled'], false);
    });

    test('fromJson creates instance from map', () {
      final json = {
        'workDuration': 30,
        'shortBreakDuration': 10,
        'longBreakDuration': 20,
        'sessionsBeforeLongBreak': 3,
        'autoStartBreaks': true,
        'autoStartFocus': true,
        'notificationsEnabled': false,
        'soundEnabled': false,
        'hapticEnabled': false,
      };

      final settings = TimerSettings.fromJson(json);

      expect(settings.workDuration, 30);
      expect(settings.shortBreakDuration, 10);
      expect(settings.longBreakDuration, 20);
      expect(settings.sessionsBeforeLongBreak, 3);
      expect(settings.autoStartBreaks, true);
      expect(settings.autoStartFocus, true);
      expect(settings.notificationsEnabled, false);
      expect(settings.soundEnabled, false);
      expect(settings.hapticEnabled, false);
    });

    test('equality works correctly', () {
      const settings1 = TimerSettings(workDuration: 25);
      const settings2 = TimerSettings(workDuration: 25);
      const settings3 = TimerSettings(workDuration: 30);

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });

    test('fromJson uses default values for missing fields', () {
      final json = {
        'workDuration': 30,
      };

      final settings = TimerSettings.fromJson(json);

      expect(settings.workDuration, 30);
      expect(settings.shortBreakDuration, 5);
      expect(settings.longBreakDuration, 15);
      expect(settings.sessionsBeforeLongBreak, 4);
      expect(settings.autoStartBreaks, false);
      expect(settings.autoStartFocus, false);
      expect(settings.notificationsEnabled, true);
      expect(settings.soundEnabled, true);
      expect(settings.hapticEnabled, true);
    });

    test('hashCode is consistent', () {
      const settings1 = TimerSettings(workDuration: 25);
      const settings2 = TimerSettings(workDuration: 25);

      expect(settings1.hashCode, equals(settings2.hashCode));
    });
  });
}
