import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pomodoro_timer/core/models/timer_session.dart';
import 'package:pomodoro_timer/core/models/timer_settings.dart';
import 'package:pomodoro_timer/core/services/audio_service.dart';
import 'package:pomodoro_timer/core/services/notification_service.dart';
import 'package:pomodoro_timer/features/statistics/data/statistics_repository.dart';
import 'package:pomodoro_timer/features/timer/bloc/timer_bloc.dart';
import 'package:pomodoro_timer/features/timer/bloc/timer_event.dart' as event;
import 'package:pomodoro_timer/features/timer/bloc/timer_state.dart' as state;

// Mock classes
class MockNotificationService extends Mock implements NotificationService {}

class MockAudioService extends Mock implements AudioService {}

class MockStatisticsRepository extends Mock implements StatisticsRepository {}

void main() {
  late TimerBloc timerBloc;
  late MockNotificationService mockNotificationService;
  late MockAudioService mockAudioService;
  late MockStatisticsRepository mockStatisticsRepository;
  late TimerSettings testSettings;

  setUp(() {
    mockNotificationService = MockNotificationService();
    mockAudioService = MockAudioService();
    mockStatisticsRepository = MockStatisticsRepository();
    testSettings = const TimerSettings(
      workDuration: 25,
      shortBreakDuration: 5,
      longBreakDuration: 15,
      sessionsBeforeLongBreak: 4,
    );

    // Register fallback values for any calls
    registerFallbackValue(
      TimerSession.create(
        sessionType: SessionType.work,
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        durationInMinutes: 25,
      ),
    );

    // Setup default mock behaviors
    when(
      () => mockNotificationService.showWorkSessionComplete(),
    ).thenAnswer((_) async {});
    when(
      () => mockNotificationService.showShortBreakComplete(),
    ).thenAnswer((_) async {});
    when(
      () => mockNotificationService.showLongBreakComplete(),
    ).thenAnswer((_) async {});
    when(() => mockAudioService.playCompletionSound()).thenAnswer((_) async {});
    when(() => mockAudioService.playBreakSound()).thenAnswer((_) async {});
    when(
      () => mockStatisticsRepository.addSession(any()),
    ).thenAnswer((_) async => 0);

    timerBloc = TimerBloc(
      settings: testSettings,
      notificationService: mockNotificationService,
      audioService: mockAudioService,
      statisticsRepository: mockStatisticsRepository,
    );
  });

  tearDown(() {
    timerBloc.close();
  });

  group('TimerBloc', () {
    test('initial state is TimerInitial with work session', () {
      expect(
        timerBloc.state,
        const state.TimerInitial(
          duration: 25 * 60, // 25 minutes in seconds
          sessionType: SessionType.work,
          completedSessions: 0,
        ),
      );
    });

    group('TimerStarted', () {
      blocTest<TimerBloc, state.TimerState>(
        'emits TimerRunning when timer is started',
        build: () => timerBloc,
        act: (bloc) => bloc.add(const event.TimerStarted(25 * 60)),
        expect: () => [
          isA<state.TimerRunning>()
              .having((s) => s.duration, 'duration', 25 * 60)
              .having((s) => s.sessionType, 'sessionType', SessionType.work)
              .having((s) => s.completedSessions, 'completedSessions', 0),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'starts ticking after timer is started',
        build: () => timerBloc,
        act: (bloc) => bloc.add(const event.TimerStarted(3)),
        wait: const Duration(seconds: 6),
        expect: () => [
          isA<state.TimerRunning>().having((s) => s.duration, 'duration', 3),
          isA<state.TimerRunning>().having((s) => s.duration, 'duration', 2),
          isA<state.TimerRunning>().having((s) => s.duration, 'duration', 1),
          isA<state.TimerCompleted>().having(
            (s) => s.sessionType,
            'sessionType',
            SessionType.shortBreak,
          ),
          isA<state.TimerInitial>().having(
            (s) => s.sessionType,
            'sessionType',
            SessionType.shortBreak,
          ),
        ],
      );
    });

    group('TimerPaused', () {
      blocTest<TimerBloc, state.TimerState>(
        'emits TimerPaused when running timer is paused',
        build: () => timerBloc,
        seed: () => state.TimerRunning(
          duration: 25 * 60,
          sessionType: SessionType.work,
          startTime: DateTime.now(),
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(const event.TimerPaused()),
        expect: () => [
          isA<state.TimerPaused>()
              .having((s) => s.duration, 'duration', 25 * 60)
              .having((s) => s.sessionType, 'sessionType', SessionType.work),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'does not emit when pausing from initial state',
        build: () => timerBloc,
        act: (bloc) => bloc.add(const event.TimerPaused()),
        expect: () => [],
      );
    });

    group('TimerResumed', () {
      blocTest<TimerBloc, state.TimerState>(
        'emits TimerRunning when paused timer is resumed',
        build: () => timerBloc,
        seed: () => const state.TimerPaused(
          duration: 25 * 60,
          sessionType: SessionType.work,
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(const event.TimerResumed()),
        expect: () => [
          isA<state.TimerRunning>()
              .having((s) => s.duration, 'duration', 25 * 60)
              .having((s) => s.sessionType, 'sessionType', SessionType.work),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'does not emit when resuming from initial state',
        build: () => timerBloc,
        act: (bloc) => bloc.add(const event.TimerResumed()),
        expect: () => [],
      );
    });

    group('TimerReset', () {
      blocTest<TimerBloc, state.TimerState>(
        'emits TimerInitial when timer is reset',
        build: () => timerBloc,
        seed: () => state.TimerRunning(
          duration: 20 * 60,
          sessionType: SessionType.work,
          startTime: DateTime.now(),
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(const event.TimerReset()),
        expect: () => [
          const state.TimerInitial(
            duration: 25 * 60,
            sessionType: SessionType.work,
            completedSessions: 0,
          ),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'resets to correct duration for short break',
        build: () => timerBloc,
        seed: () => const state.TimerPaused(
          duration: 2 * 60,
          sessionType: SessionType.shortBreak,
          completedSessions: 1,
        ),
        act: (bloc) => bloc.add(const event.TimerReset()),
        expect: () => [
          const state.TimerInitial(
            duration: 5 * 60,
            sessionType: SessionType.shortBreak,
            completedSessions: 1,
          ),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'resets to correct duration for long break',
        build: () => timerBloc,
        seed: () => const state.TimerPaused(
          duration: 10 * 60,
          sessionType: SessionType.longBreak,
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(const event.TimerReset()),
        expect: () => [
          const state.TimerInitial(
            duration: 15 * 60,
            sessionType: SessionType.longBreak,
            completedSessions: 0,
          ),
        ],
      );
    });

    group('TimerCompleted', () {
      blocTest<TimerBloc, state.TimerState>(
        'transitions from work to short break after completion',
        build: () => timerBloc,
        act: (bloc) => bloc.add(const event.TimerStarted(1)),
        wait: const Duration(seconds: 4),
        verify: (_) {
          verify(
            () => mockNotificationService.showWorkSessionComplete(),
          ).called(1);
          verify(() => mockAudioService.playCompletionSound()).called(1);
          verify(() => mockStatisticsRepository.addSession(any())).called(1);
        },
      );

      blocTest<TimerBloc, state.TimerState>(
        'transitions to long break after 4 work sessions',
        build: () => timerBloc,
        seed: () => const state.TimerInitial(
          duration: 25 * 60,
          sessionType: SessionType.work,
          completedSessions: 3,
        ),
        act: (bloc) => bloc.add(const event.TimerStarted(1)),
        wait: const Duration(seconds: 4),
        expect: () => [
          isA<state.TimerRunning>()
              .having((s) => s.sessionType, 'sessionType', SessionType.work)
              .having((s) => s.completedSessions, 'completedSessions', 3),
          isA<state.TimerCompleted>()
              .having(
                (s) => s.sessionType,
                'sessionType',
                SessionType.longBreak,
              )
              .having((s) => s.completedSessions, 'completedSessions', 0),
          isA<state.TimerInitial>()
              .having(
                (s) => s.sessionType,
                'sessionType',
                SessionType.longBreak,
              )
              .having((s) => s.duration, 'duration', 15 * 60)
              .having((s) => s.completedSessions, 'completedSessions', 0),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'transitions from short break back to work',
        build: () => TimerBloc(
          settings: testSettings,
          notificationService: mockNotificationService,
          audioService: mockAudioService,
          statisticsRepository: mockStatisticsRepository,
        ),
        seed: () => const state.TimerInitial(
          duration: 5 * 60,
          sessionType: SessionType.shortBreak,
          completedSessions: 1,
        ),
        act: (bloc) => bloc.add(const event.TimerStarted(1)),
        wait: const Duration(seconds: 4),
        verify: (_) {
          verify(
            () => mockNotificationService.showShortBreakComplete(),
          ).called(1);
          verify(() => mockAudioService.playBreakSound()).called(1);
        },
      );

      blocTest<TimerBloc, state.TimerState>(
        'transitions from long break back to work',
        build: () => TimerBloc(
          settings: testSettings,
          notificationService: mockNotificationService,
          audioService: mockAudioService,
          statisticsRepository: mockStatisticsRepository,
        ),
        seed: () => const state.TimerInitial(
          duration: 15 * 60,
          sessionType: SessionType.longBreak,
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(const event.TimerStarted(1)),
        wait: const Duration(seconds: 4),
        verify: (_) {
          verify(
            () => mockNotificationService.showLongBreakComplete(),
          ).called(1);
          verify(() => mockAudioService.playBreakSound()).called(1);
        },
      );
    });

    group('TimerSettingsUpdated', () {
      blocTest<TimerBloc, state.TimerState>(
        'updates duration in initial state',
        build: () => timerBloc,
        act: (bloc) => bloc.add(
          const event.TimerSettingsUpdated(
            workDuration: 30,
            shortBreakDuration: 10,
            longBreakDuration: 20,
            sessionsBeforeLongBreak: 3,
            autoStartBreaks: false,
            autoStartFocus: false,
          ),
        ),
        expect: () => [
          const state.TimerInitial(
            duration: 30 * 60,
            sessionType: SessionType.work,
            completedSessions: 0,
          ),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'adjusts running timer duration proportionally',
        build: () => timerBloc,
        seed: () => state.TimerRunning(
          duration: 20 * 60, // 20 minutes remaining out of 25
          sessionType: SessionType.work,
          startTime: DateTime.now().subtract(const Duration(minutes: 5)),
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(
          const event.TimerSettingsUpdated(
            workDuration: 30, // Increase from 25 to 30
            shortBreakDuration: 5,
            longBreakDuration: 15,
            sessionsBeforeLongBreak: 4,
            autoStartBreaks: false,
            autoStartFocus: false,
          ),
        ),
        expect: () => [
          isA<state.TimerRunning>()
              .having((s) => s.duration, 'duration', 25 * 60) // 30 - 5 elapsed
              .having((s) => s.sessionType, 'sessionType', SessionType.work),
        ],
      );

      blocTest<TimerBloc, state.TimerState>(
        'completes timer immediately if new duration is less than elapsed time',
        build: () => timerBloc,
        seed: () => state.TimerRunning(
          duration: 5 * 60, // 5 minutes remaining
          sessionType: SessionType.work,
          startTime: DateTime.now().subtract(const Duration(minutes: 20)),
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(
          const event.TimerSettingsUpdated(
            workDuration: 15, // Less than 20 elapsed
            shortBreakDuration: 5,
            longBreakDuration: 15,
            sessionsBeforeLongBreak: 4,
            autoStartBreaks: false,
            autoStartFocus: false,
          ),
        ),
        wait: const Duration(seconds: 3),
        expect: () => [isA<state.TimerCompleted>(), isA<state.TimerInitial>()],
      );

      blocTest<TimerBloc, state.TimerState>(
        'updates paused timer duration',
        build: () => timerBloc,
        seed: () => const state.TimerPaused(
          duration: 20 * 60,
          sessionType: SessionType.work,
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(
          const event.TimerSettingsUpdated(
            workDuration: 30,
            shortBreakDuration: 5,
            longBreakDuration: 15,
            sessionsBeforeLongBreak: 4,
            autoStartBreaks: false,
            autoStartFocus: false,
          ),
        ),
        expect: () => [
          isA<state.TimerPaused>()
              .having((s) => s.duration, 'duration', 25 * 60)
              .having((s) => s.sessionType, 'sessionType', SessionType.work),
        ],
      );
    });

    group('TimerSkipped', () {
      blocTest<TimerBloc, state.TimerState>(
        'skips to next session',
        build: () => timerBloc,
        seed: () => state.TimerRunning(
          duration: 20 * 60,
          sessionType: SessionType.work,
          startTime: DateTime.now(),
          completedSessions: 0,
        ),
        act: (bloc) => bloc.add(const event.TimerSkipped()),
        wait: const Duration(seconds: 3),
        expect: () => [isA<state.TimerCompleted>(), isA<state.TimerInitial>()],
      );
    });

    group('Session tracking', () {
      test('increments completed sessions after work session', () async {
        final bloc = TimerBloc(
          settings: testSettings,
          notificationService: mockNotificationService,
          audioService: mockAudioService,
          statisticsRepository: mockStatisticsRepository,
        );

        bloc.add(const event.TimerStarted(1));
        await Future.delayed(const Duration(seconds: 4));

        expect(
          bloc.state,
          isA<state.TimerInitial>().having(
            (s) => s.completedSessions,
            'completedSessions',
            1,
          ),
        );

        bloc.close();
      });

      test('resets completed sessions after long break', () async {
        final bloc = TimerBloc(
          settings: testSettings,
          notificationService: mockNotificationService,
          audioService: mockAudioService,
          statisticsRepository: mockStatisticsRepository,
        );

        // Start with 3 completed sessions (4th will trigger long break)
        bloc.emit(
          const state.TimerInitial(
            duration: 25 * 60,
            sessionType: SessionType.work,
            completedSessions: 3,
          ),
        );

        bloc.add(const event.TimerStarted(1));
        await Future.delayed(const Duration(seconds: 4));

        expect(
          bloc.state,
          isA<state.TimerInitial>()
              .having(
                (s) => s.sessionType,
                'sessionType',
                SessionType.longBreak,
              )
              .having((s) => s.completedSessions, 'completedSessions', 0),
        );

        bloc.close();
      });
    });
  });
}
