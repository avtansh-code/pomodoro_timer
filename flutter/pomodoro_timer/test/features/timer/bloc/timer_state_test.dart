import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/models/timer_session.dart';
import 'package:pomodoro_timer/features/timer/bloc/timer_state.dart';

void main() {
  group('TimerState', () {
    group('TimerInitial', () {
      test('creates instance with required fields', () {
        const state = TimerInitial(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 0,
        );

        expect(state.duration, 1500);
        expect(state.sessionType, SessionType.work);
        expect(state.completedSessions, 0);
      });

      test('completedSessions defaults to 0', () {
        const state = TimerInitial(
          duration: 1500,
          sessionType: SessionType.work,
        );

        expect(state.completedSessions, 0);
      });

      test('equality works correctly', () {
        const state1 = TimerInitial(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 0,
        );
        const state2 = TimerInitial(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 0,
        );
        const state3 = TimerInitial(
          duration: 300,
          sessionType: SessionType.shortBreak,
          completedSessions: 1,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('props contain duration, sessionType, and completedSessions', () {
        const state = TimerInitial(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 2,
        );

        expect(state.props, [1500, SessionType.work, 2]);
      });
    });

    group('TimerRunning', () {
      test('creates instance with required fields', () {
        final startTime = DateTime.now();
        final state = TimerRunning(
          duration: 1500,
          sessionType: SessionType.work,
          startTime: startTime,
          completedSessions: 0,
        );

        expect(state.duration, 1500);
        expect(state.sessionType, SessionType.work);
        expect(state.startTime, startTime);
        expect(state.completedSessions, 0);
      });

      test('equality includes startTime', () {
        final startTime1 = DateTime(2024, 1, 15, 10, 0, 0);
        final startTime2 = DateTime(2024, 1, 15, 10, 0, 0);
        final startTime3 = DateTime(2024, 1, 15, 11, 0, 0);

        final state1 = TimerRunning(
          duration: 1500,
          sessionType: SessionType.work,
          startTime: startTime1,
          completedSessions: 0,
        );
        final state2 = TimerRunning(
          duration: 1500,
          sessionType: SessionType.work,
          startTime: startTime2,
          completedSessions: 0,
        );
        final state3 = TimerRunning(
          duration: 1500,
          sessionType: SessionType.work,
          startTime: startTime3,
          completedSessions: 0,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test(
        'props contain duration, sessionType, completedSessions, and startTime',
        () {
          final startTime = DateTime(2024, 1, 15, 10, 0, 0);
          final state = TimerRunning(
            duration: 1500,
            sessionType: SessionType.work,
            startTime: startTime,
            completedSessions: 2,
          );

          expect(state.props, [1500, SessionType.work, 2, startTime]);
        },
      );
    });

    group('TimerPaused', () {
      test('creates instance with required fields', () {
        const state = TimerPaused(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 0,
        );

        expect(state.duration, 1500);
        expect(state.sessionType, SessionType.work);
        expect(state.completedSessions, 0);
      });

      test('equality works correctly', () {
        const state1 = TimerPaused(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 0,
        );
        const state2 = TimerPaused(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 0,
        );
        const state3 = TimerPaused(
          duration: 300,
          sessionType: SessionType.shortBreak,
          completedSessions: 1,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('props contain duration, sessionType, and completedSessions', () {
        const state = TimerPaused(
          duration: 1500,
          sessionType: SessionType.work,
          completedSessions: 2,
        );

        expect(state.props, [1500, SessionType.work, 2]);
      });
    });

    group('TimerCompleted', () {
      test('creates instance with required fields', () {
        const state = TimerCompleted(
          duration: 300,
          sessionType: SessionType.shortBreak,
          completedSessionType: SessionType.work,
          completedSessions: 1,
        );

        expect(state.duration, 300);
        expect(state.sessionType, SessionType.shortBreak);
        expect(state.completedSessionType, SessionType.work);
        expect(state.completedSessions, 1);
      });

      test('equality includes completedSessionType', () {
        const state1 = TimerCompleted(
          duration: 300,
          sessionType: SessionType.shortBreak,
          completedSessionType: SessionType.work,
          completedSessions: 1,
        );
        const state2 = TimerCompleted(
          duration: 300,
          sessionType: SessionType.shortBreak,
          completedSessionType: SessionType.work,
          completedSessions: 1,
        );
        const state3 = TimerCompleted(
          duration: 300,
          sessionType: SessionType.work,
          completedSessionType: SessionType.shortBreak,
          completedSessions: 1,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test(
        'props contain duration, sessionType, completedSessions, and completedSessionType',
        () {
          const state = TimerCompleted(
            duration: 300,
            sessionType: SessionType.shortBreak,
            completedSessionType: SessionType.work,
            completedSessions: 1,
          );

          expect(state.props, [
            300,
            SessionType.shortBreak,
            1,
            SessionType.work,
          ]);
        },
      );
    });

    group('TimerError', () {
      test('creates instance with required fields', () {
        const state = TimerError(
          duration: 1500,
          sessionType: SessionType.work,
          message: 'An error occurred',
          completedSessions: 0,
        );

        expect(state.duration, 1500);
        expect(state.sessionType, SessionType.work);
        expect(state.message, 'An error occurred');
        expect(state.completedSessions, 0);
      });

      test('equality includes message', () {
        const state1 = TimerError(
          duration: 1500,
          sessionType: SessionType.work,
          message: 'Error 1',
          completedSessions: 0,
        );
        const state2 = TimerError(
          duration: 1500,
          sessionType: SessionType.work,
          message: 'Error 1',
          completedSessions: 0,
        );
        const state3 = TimerError(
          duration: 1500,
          sessionType: SessionType.work,
          message: 'Error 2',
          completedSessions: 0,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test(
        'props contain duration, sessionType, completedSessions, and message',
        () {
          const state = TimerError(
            duration: 1500,
            sessionType: SessionType.work,
            message: 'An error occurred',
            completedSessions: 2,
          );

          expect(state.props, [1500, SessionType.work, 2, 'An error occurred']);
        },
      );
    });

    group('SessionType in states', () {
      test('all session types work with TimerInitial', () {
        for (final sessionType in SessionType.values) {
          final state = TimerInitial(duration: 1500, sessionType: sessionType);
          expect(state.sessionType, sessionType);
        }
      });

      test('all session types work with TimerPaused', () {
        for (final sessionType in SessionType.values) {
          final state = TimerPaused(duration: 1500, sessionType: sessionType);
          expect(state.sessionType, sessionType);
        }
      });
    });
  });
}
