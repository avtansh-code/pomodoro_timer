import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/models/timer_session.dart';

void main() {
  group('SessionType', () {
    test('has correct enum values', () {
      expect(SessionType.values.length, 3);
      expect(SessionType.values, contains(SessionType.work));
      expect(SessionType.values, contains(SessionType.shortBreak));
      expect(SessionType.values, contains(SessionType.longBreak));
    });
  });

  group('TimerSession', () {
    late DateTime startTime;
    late DateTime endTime;

    setUp(() {
      startTime = DateTime(2024, 1, 15, 10, 0, 0);
      endTime = DateTime(2024, 1, 15, 10, 25, 0);
    });

    test('creates instance with all required fields', () {
      final session = TimerSession(
        id: '123',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      expect(session.id, '123');
      expect(session.sessionType, SessionType.work);
      expect(session.startTime, startTime);
      expect(session.endTime, endTime);
      expect(session.durationInMinutes, 25);
    });

    test('creates instance using factory constructor with auto-generated ID', () {
      final session = TimerSession.create(
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      expect(session.id, isNotEmpty);
      expect(session.sessionType, SessionType.work);
      expect(session.startTime, startTime);
      expect(session.endTime, endTime);
      expect(session.durationInMinutes, 25);
    });

    test('actualDuration calculates correct duration', () {
      final session = TimerSession.create(
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      expect(session.actualDuration, const Duration(minutes: 25));
    });

    test('isOnDate returns true for same date', () {
      final session = TimerSession.create(
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      expect(session.isOnDate(DateTime(2024, 1, 15)), isTrue);
      expect(session.isOnDate(DateTime(2024, 1, 15, 23, 59)), isTrue);
    });

    test('isOnDate returns false for different date', () {
      final session = TimerSession.create(
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      expect(session.isOnDate(DateTime(2024, 1, 14)), isFalse);
      expect(session.isOnDate(DateTime(2024, 1, 16)), isFalse);
      expect(session.isOnDate(DateTime(2024, 2, 15)), isFalse);
    });

    test('sessionTypeLabel returns correct labels', () {
      final workSession = TimerSession.create(
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      final shortBreakSession = TimerSession.create(
        sessionType: SessionType.shortBreak,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 5,
      );

      final longBreakSession = TimerSession.create(
        sessionType: SessionType.longBreak,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 15,
      );

      expect(workSession.sessionTypeLabel, 'Work Session');
      expect(shortBreakSession.sessionTypeLabel, 'Short Break');
      expect(longBreakSession.sessionTypeLabel, 'Long Break');
    });

    test('toJson converts to map correctly', () {
      final session = TimerSession(
        id: '123',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      final json = session.toJson();

      expect(json['id'], '123');
      expect(json['sessionType'], SessionType.work.index);
      expect(json['startTime'], startTime.toIso8601String());
      expect(json['endTime'], endTime.toIso8601String());
      expect(json['durationInMinutes'], 25);
    });

    test('fromJson creates instance from map', () {
      final json = {
        'id': '123',
        'sessionType': SessionType.work.index,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'durationInMinutes': 25,
      };

      final session = TimerSession.fromJson(json);

      expect(session.id, '123');
      expect(session.sessionType, SessionType.work);
      expect(session.startTime, startTime);
      expect(session.endTime, endTime);
      expect(session.durationInMinutes, 25);
    });

    test('fromJson handles all session types correctly', () {
      for (final sessionType in SessionType.values) {
        final json = {
          'id': '123',
          'sessionType': sessionType.index,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'durationInMinutes': 25,
        };

        final session = TimerSession.fromJson(json);
        expect(session.sessionType, sessionType);
      }
    });

    test('equality works correctly', () {
      final session1 = TimerSession(
        id: '123',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      final session2 = TimerSession(
        id: '123',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      final session3 = TimerSession(
        id: '456',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      expect(session1, equals(session2));
      expect(session1, isNot(equals(session3)));
    });

    test('hashCode is consistent', () {
      final session1 = TimerSession(
        id: '123',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      final session2 = TimerSession(
        id: '123',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      expect(session1.hashCode, equals(session2.hashCode));
    });

    test('toString returns formatted string', () {
      final session = TimerSession(
        id: '123',
        sessionType: SessionType.work,
        startTime: startTime,
        endTime: endTime,
        durationInMinutes: 25,
      );

      final string = session.toString();

      expect(string, contains('123'));
      expect(string, contains('Work Session'));
      expect(string, contains('25m'));
    });
  });
}

