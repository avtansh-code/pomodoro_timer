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
    });

    test('creates instance with custom values', () {
      const settings = TimerSettings(
        workDuration: 30,
        shortBreakDuration: 10,
        longBreakDuration: 20,
        sessionsBeforeLongBreak: 3,
      );

      expect(settings.workDuration, 30);
      expect(settings.shortBreakDuration, 10);
      expect(settings.longBreakDuration, 20);
      expect(settings.sessionsBeforeLongBreak, 3);
    });

    test('copyWith creates new instance with updated values', () {
      const settings = TimerSettings();
      final updated = settings.copyWith(workDuration: 30);

      expect(updated.workDuration, 30);
      expect(updated.shortBreakDuration, 5);
      expect(updated.longBreakDuration, 15);
      expect(updated.sessionsBeforeLongBreak, 4);
    });

    test('toJson converts to map correctly', () {
      const settings = TimerSettings(
        workDuration: 30,
        shortBreakDuration: 10,
        longBreakDuration: 20,
        sessionsBeforeLongBreak: 3,
      );

      final json = settings.toJson();

      expect(json['workDuration'], 30);
      expect(json['shortBreakDuration'], 10);
      expect(json['longBreakDuration'], 20);
      expect(json['sessionsBeforeLongBreak'], 3);
    });

    test('fromJson creates instance from map', () {
      final json = {
        'workDuration': 30,
        'shortBreakDuration': 10,
        'longBreakDuration': 20,
        'sessionsBeforeLongBreak': 3,
      };

      final settings = TimerSettings.fromJson(json);

      expect(settings.workDuration, 30);
      expect(settings.shortBreakDuration, 10);
      expect(settings.longBreakDuration, 20);
      expect(settings.sessionsBeforeLongBreak, 3);
    });

    test('equality works correctly', () {
      const settings1 = TimerSettings(workDuration: 25);
      const settings2 = TimerSettings(workDuration: 25);
      const settings3 = TimerSettings(workDuration: 30);

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });

    test('hashCode is consistent', () {
      const settings1 = TimerSettings(workDuration: 25);
      const settings2 = TimerSettings(workDuration: 25);

      expect(settings1.hashCode, equals(settings2.hashCode));
    });
  });
}
