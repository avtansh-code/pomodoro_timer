import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/models/timer_session.dart';
import 'package:pomodoro_timer/features/statistics/bloc/statistics_state.dart';

void main() {
  group('StatisticsFilter', () {
    test('has all expected values', () {
      expect(StatisticsFilter.values, contains(StatisticsFilter.today));
      expect(StatisticsFilter.values, contains(StatisticsFilter.week));
      expect(StatisticsFilter.values, contains(StatisticsFilter.month));
      expect(StatisticsFilter.values, contains(StatisticsFilter.all));
      expect(StatisticsFilter.values.length, 4);
    });
  });

  group('StatisticsState', () {
    late List<TimerSession> testSessions;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      testSessions = [
        TimerSession.create(
          sessionType: SessionType.work,
          startTime: now.subtract(const Duration(hours: 2)),
          endTime: now.subtract(const Duration(hours: 1, minutes: 35)),
          durationInMinutes: 25,
        ),
        TimerSession.create(
          sessionType: SessionType.shortBreak,
          startTime: now.subtract(const Duration(hours: 1, minutes: 35)),
          endTime: now.subtract(const Duration(hours: 1, minutes: 30)),
          durationInMinutes: 5,
        ),
        TimerSession.create(
          sessionType: SessionType.work,
          startTime: now.subtract(const Duration(hours: 1)),
          endTime: now.subtract(const Duration(minutes: 35)),
          durationInMinutes: 25,
        ),
        TimerSession.create(
          sessionType: SessionType.longBreak,
          startTime: now.subtract(const Duration(minutes: 30)),
          endTime: now.subtract(const Duration(minutes: 15)),
          durationInMinutes: 15,
        ),
      ];
    });

    group('constructor', () {
      test('creates instance with required parameters', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );

        expect(state.sessions, testSessions);
        expect(state.filter, StatisticsFilter.today);
        expect(state.isLoading, false);
        expect(state.errorMessage, null);
      });

      test('creates instance with all parameters', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.week,
          isLoading: true,
          errorMessage: 'Test error',
        );

        expect(state.sessions, testSessions);
        expect(state.filter, StatisticsFilter.week);
        expect(state.isLoading, true);
        expect(state.errorMessage, 'Test error');
      });
    });

    group('initial factory', () {
      test('creates state with empty sessions and all filter', () {
        final state = StatisticsState.initial();

        expect(state.sessions, isEmpty);
        expect(state.filter, StatisticsFilter.all);
        expect(state.isLoading, true);
        expect(state.errorMessage, null);
      });
    });

    group('workSessionCount', () {
      test('returns count of work sessions', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );

        expect(state.workSessionCount, 2);
      });

      test('returns 0 for empty sessions', () {
        final state = StatisticsState(
          sessions: const [],
          filter: StatisticsFilter.today,
        );

        expect(state.workSessionCount, 0);
      });

      test('returns 0 when no work sessions', () {
        final breakOnlySessions = [
          TimerSession.create(
            sessionType: SessionType.shortBreak,
            startTime: now.subtract(const Duration(hours: 1)),
            endTime: now.subtract(const Duration(minutes: 55)),
            durationInMinutes: 5,
          ),
          TimerSession.create(
            sessionType: SessionType.longBreak,
            startTime: now.subtract(const Duration(minutes: 30)),
            endTime: now.subtract(const Duration(minutes: 15)),
            durationInMinutes: 15,
          ),
        ];

        final state = StatisticsState(
          sessions: breakOnlySessions,
          filter: StatisticsFilter.today,
        );

        expect(state.workSessionCount, 0);
      });
    });

    group('totalFocusTime', () {
      test('calculates total focus time from work sessions', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );

        expect(state.totalFocusTime, 50); // 25 + 25
      });

      test('returns 0 for empty sessions', () {
        final state = StatisticsState(
          sessions: const [],
          filter: StatisticsFilter.today,
        );

        expect(state.totalFocusTime, 0);
      });

      test('excludes break sessions from focus time', () {
        final breakOnlySessions = [
          TimerSession.create(
            sessionType: SessionType.shortBreak,
            startTime: now.subtract(const Duration(hours: 1)),
            endTime: now.subtract(const Duration(minutes: 55)),
            durationInMinutes: 5,
          ),
        ];

        final state = StatisticsState(
          sessions: breakOnlySessions,
          filter: StatisticsFilter.today,
        );

        expect(state.totalFocusTime, 0);
      });
    });

    group('totalBreakTime', () {
      test('calculates total break time from break sessions', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );

        expect(state.totalBreakTime, 20); // 5 + 15
      });

      test('returns 0 for empty sessions', () {
        final state = StatisticsState(
          sessions: const [],
          filter: StatisticsFilter.today,
        );

        expect(state.totalBreakTime, 0);
      });

      test('includes both short and long breaks', () {
        final breakSessions = [
          TimerSession.create(
            sessionType: SessionType.shortBreak,
            startTime: now.subtract(const Duration(hours: 1)),
            endTime: now.subtract(const Duration(minutes: 55)),
            durationInMinutes: 5,
          ),
          TimerSession.create(
            sessionType: SessionType.longBreak,
            startTime: now.subtract(const Duration(minutes: 30)),
            endTime: now.subtract(const Duration(minutes: 15)),
            durationInMinutes: 15,
          ),
          TimerSession.create(
            sessionType: SessionType.shortBreak,
            startTime: now.subtract(const Duration(minutes: 10)),
            endTime: now.subtract(const Duration(minutes: 5)),
            durationInMinutes: 5,
          ),
        ];

        final state = StatisticsState(
          sessions: breakSessions,
          filter: StatisticsFilter.today,
        );

        expect(state.totalBreakTime, 25); // 5 + 15 + 5
      });

      test('excludes work sessions from break time', () {
        final workOnlySessions = [
          TimerSession.create(
            sessionType: SessionType.work,
            startTime: now.subtract(const Duration(hours: 1)),
            endTime: now.subtract(const Duration(minutes: 35)),
            durationInMinutes: 25,
          ),
        ];

        final state = StatisticsState(
          sessions: workOnlySessions,
          filter: StatisticsFilter.today,
        );

        expect(state.totalBreakTime, 0);
      });
    });

    group('sessionsByDate', () {
      test('groups sessions by date', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );

        final grouped = state.sessionsByDate;
        final today = DateTime(now.year, now.month, now.day);

        expect(grouped.containsKey(today), isTrue);
        expect(grouped[today]?.length, 4);
      });

      test('returns empty map for empty sessions', () {
        final state = StatisticsState(
          sessions: const [],
          filter: StatisticsFilter.today,
        );

        expect(state.sessionsByDate, isEmpty);
      });

      test('groups sessions from different days correctly', () {
        final yesterday = now.subtract(const Duration(days: 1));
        final sessionsAcrossDays = [
          TimerSession.create(
            sessionType: SessionType.work,
            startTime: now.subtract(const Duration(hours: 1)),
            endTime: now.subtract(const Duration(minutes: 35)),
            durationInMinutes: 25,
          ),
          TimerSession.create(
            sessionType: SessionType.work,
            startTime: yesterday,
            endTime: yesterday.add(const Duration(minutes: 25)),
            durationInMinutes: 25,
          ),
        ];

        final state = StatisticsState(
          sessions: sessionsAcrossDays,
          filter: StatisticsFilter.week,
        );

        final grouped = state.sessionsByDate;
        final todayDate = DateTime(now.year, now.month, now.day);
        final yesterdayDate = DateTime(yesterday.year, yesterday.month, yesterday.day);

        expect(grouped.keys.length, 2);
        expect(grouped[todayDate]?.length, 1);
        expect(grouped[yesterdayDate]?.length, 1);
      });
    });

    group('copyWith', () {
      test('updates sessions', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );
        final newSessions = <TimerSession>[];
        final updated = state.copyWith(sessions: newSessions);

        expect(updated.sessions, newSessions);
        expect(updated.filter, state.filter);
      });

      test('updates filter', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );
        final updated = state.copyWith(filter: StatisticsFilter.week);

        expect(updated.filter, StatisticsFilter.week);
        expect(updated.sessions, state.sessions);
      });

      test('updates isLoading', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );
        final updated = state.copyWith(isLoading: true);

        expect(updated.isLoading, true);
      });

      test('updates errorMessage', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );
        final updated = state.copyWith(errorMessage: 'Error');

        expect(updated.errorMessage, 'Error');
      });

      test('clearError removes error message', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
          errorMessage: 'Existing error',
        );
        final updated = state.copyWith(clearError: true);

        expect(updated.errorMessage, null);
      });

      test('clearError takes precedence over errorMessage', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
          errorMessage: 'Existing error',
        );
        final updated = state.copyWith(
          clearError: true,
          errorMessage: 'New error',
        );

        expect(updated.errorMessage, null);
      });

      test('keeps existing values when no parameters provided', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.month,
          isLoading: true,
          errorMessage: 'Error',
        );
        final updated = state.copyWith();

        expect(updated.sessions, testSessions);
        expect(updated.filter, StatisticsFilter.month);
        expect(updated.isLoading, true);
        expect(updated.errorMessage, 'Error');
      });
    });

    group('Equatable', () {
      test('states with same values are equal', () {
        final state1 = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );
        final state2 = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );

        expect(state1, equals(state2));
      });

      test('states with different sessions are not equal', () {
        final state1 = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );
        final state2 = StatisticsState(
          sessions: const [],
          filter: StatisticsFilter.today,
        );

        expect(state1, isNot(equals(state2)));
      });

      test('states with different filters are not equal', () {
        final state1 = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
        );
        final state2 = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.week,
        );

        expect(state1, isNot(equals(state2)));
      });

      test('props contains all properties', () {
        final state = StatisticsState(
          sessions: testSessions,
          filter: StatisticsFilter.today,
          isLoading: true,
          errorMessage: 'Error',
        );

        expect(state.props, [testSessions, StatisticsFilter.today, true, 'Error']);
      });
    });

    group('Edge cases', () {
      test('handles sessions with zero duration', () {
        final zeroSessions = [
          TimerSession.create(
            sessionType: SessionType.work,
            startTime: now,
            endTime: now,
            durationInMinutes: 0,
          ),
        ];

        final state = StatisticsState(
          sessions: zeroSessions,
          filter: StatisticsFilter.today,
        );

        expect(state.totalFocusTime, 0);
        expect(state.workSessionCount, 1);
      });

      test('handles large number of sessions', () {
        final manySessions = List.generate(
          100,
          (index) => TimerSession.create(
            sessionType: SessionType.work,
            startTime: now.subtract(Duration(hours: index)),
            endTime: now.subtract(Duration(hours: index, minutes: -25)),
            durationInMinutes: 25,
          ),
        );

        final state = StatisticsState(
          sessions: manySessions,
          filter: StatisticsFilter.all,
        );

        expect(state.workSessionCount, 100);
        expect(state.totalFocusTime, 2500); // 100 * 25
      });
    });
  });
}