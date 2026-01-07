import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/features/timer/bloc/timer_event.dart';

void main() {
  group('TimerEvent', () {
    group('TimerStarted', () {
      test('creates instance with duration', () {
        const event = TimerStarted(1500);
        expect(event.duration, 1500);
      });

      test('equality works correctly', () {
        const event1 = TimerStarted(1500);
        const event2 = TimerStarted(1500);
        const event3 = TimerStarted(300);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props contain duration', () {
        const event = TimerStarted(1500);
        expect(event.props, [1500]);
      });
    });

    group('TimerPaused', () {
      test('creates instance', () {
        const event = TimerPaused();
        expect(event, isNotNull);
      });

      test('equality works correctly', () {
        const event1 = TimerPaused();
        const event2 = TimerPaused();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        const event = TimerPaused();
        expect(event.props, isEmpty);
      });
    });

    group('TimerResumed', () {
      test('creates instance', () {
        const event = TimerResumed();
        expect(event, isNotNull);
      });

      test('equality works correctly', () {
        const event1 = TimerResumed();
        const event2 = TimerResumed();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        const event = TimerResumed();
        expect(event.props, isEmpty);
      });
    });

    group('TimerReset', () {
      test('creates instance', () {
        const event = TimerReset();
        expect(event, isNotNull);
      });

      test('equality works correctly', () {
        const event1 = TimerReset();
        const event2 = TimerReset();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        const event = TimerReset();
        expect(event.props, isEmpty);
      });
    });

    group('TimerTicked', () {
      test('creates instance with duration', () {
        const event = TimerTicked(100);
        expect(event.duration, 100);
      });

      test('equality works correctly', () {
        const event1 = TimerTicked(100);
        const event2 = TimerTicked(100);
        const event3 = TimerTicked(50);

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props contain duration', () {
        const event = TimerTicked(100);
        expect(event.props, [100]);
      });
    });

    group('TimerSkipped', () {
      test('creates instance', () {
        const event = TimerSkipped();
        expect(event, isNotNull);
      });

      test('equality works correctly', () {
        const event1 = TimerSkipped();
        const event2 = TimerSkipped();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        const event = TimerSkipped();
        expect(event.props, isEmpty);
      });
    });

    group('TimerCompleted', () {
      test('creates instance', () {
        const event = TimerCompleted();
        expect(event, isNotNull);
      });

      test('equality works correctly', () {
        const event1 = TimerCompleted();
        const event2 = TimerCompleted();

        expect(event1, equals(event2));
      });

      test('props are empty', () {
        const event = TimerCompleted();
        expect(event.props, isEmpty);
      });
    });

    group('TimerSettingsUpdated', () {
      test('creates instance with all parameters', () {
        const event = TimerSettingsUpdated(
          workDuration: 30,
          shortBreakDuration: 10,
          longBreakDuration: 20,
          sessionsBeforeLongBreak: 3,
          autoStartBreaks: true,
          autoStartFocus: false,
        );

        expect(event.workDuration, 30);
        expect(event.shortBreakDuration, 10);
        expect(event.longBreakDuration, 20);
        expect(event.sessionsBeforeLongBreak, 3);
        expect(event.autoStartBreaks, true);
        expect(event.autoStartFocus, false);
      });

      test('equality works correctly', () {
        const event1 = TimerSettingsUpdated(
          workDuration: 30,
          shortBreakDuration: 10,
          longBreakDuration: 20,
          sessionsBeforeLongBreak: 3,
          autoStartBreaks: true,
          autoStartFocus: false,
        );
        const event2 = TimerSettingsUpdated(
          workDuration: 30,
          shortBreakDuration: 10,
          longBreakDuration: 20,
          sessionsBeforeLongBreak: 3,
          autoStartBreaks: true,
          autoStartFocus: false,
        );
        const event3 = TimerSettingsUpdated(
          workDuration: 25,
          shortBreakDuration: 10,
          longBreakDuration: 20,
          sessionsBeforeLongBreak: 3,
          autoStartBreaks: true,
          autoStartFocus: false,
        );

        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('props contain all values', () {
        const event = TimerSettingsUpdated(
          workDuration: 30,
          shortBreakDuration: 10,
          longBreakDuration: 20,
          sessionsBeforeLongBreak: 3,
          autoStartBreaks: true,
          autoStartFocus: false,
        );

        expect(event.props, [30, 10, 20, 3, true, false]);
      });
    });
  });
}
