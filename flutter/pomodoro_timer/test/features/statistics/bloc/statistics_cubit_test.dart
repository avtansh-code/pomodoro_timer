import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pomodoro_timer/core/models/timer_session.dart';
import 'package:pomodoro_timer/features/statistics/bloc/statistics_cubit.dart';
import 'package:pomodoro_timer/features/statistics/bloc/statistics_state.dart';
import 'package:pomodoro_timer/features/statistics/data/statistics_repository.dart';

// Mock class
class MockStatisticsRepository extends Mock implements StatisticsRepository {}

void main() {
  late StatisticsCubit statisticsCubit;
  late MockStatisticsRepository mockRepository;
  late List<TimerSession> testSessions;

  setUp(() {
    mockRepository = MockStatisticsRepository();

    // Create test sessions
    final now = DateTime.now();
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
    ];

    // Setup default mock behavior
    when(() => mockRepository.getTodaySessions()).thenReturn(testSessions);
    when(() => mockRepository.getWeekSessions()).thenReturn(testSessions);
    when(() => mockRepository.getMonthSessions()).thenReturn(testSessions);
    when(() => mockRepository.getAllSessions()).thenReturn(testSessions);
    when(() => mockRepository.clearAllSessions()).thenAnswer((_) async {});

    statisticsCubit = StatisticsCubit(mockRepository);
  });

  tearDown(() {
    statisticsCubit.close();
  });

  group('StatisticsCubit', () {
    test('initial state has today filter and loads immediately', () {
      when(() => mockRepository.getTodaySessions()).thenReturn([]);
      final cubit = StatisticsCubit(mockRepository);

      expect(cubit.state.filter, StatisticsFilter.today);
      expect(cubit.state.sessions, isEmpty);

      cubit.close();
    });

    blocTest<StatisticsCubit, StatisticsState>(
      'loadStatistics emits loading then loaded state',
      build: () {
        when(() => mockRepository.getTodaySessions()).thenReturn(testSessions);
        return StatisticsCubit(mockRepository);
      },
      act: (cubit) => cubit.loadStatistics(),
      expect: () => [
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StatisticsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.sessions, 'sessions', testSessions),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'changeFilter to week loads week sessions',
      build: () {
        when(() => mockRepository.getWeekSessions()).thenReturn(testSessions);
        return StatisticsCubit(mockRepository);
      },
      act: (cubit) => cubit.changeFilter(StatisticsFilter.week),
      expect: () => [
        isA<StatisticsState>().having(
          (s) => s.filter,
          'filter',
          StatisticsFilter.week,
        ),
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StatisticsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.sessions, 'sessions', testSessions),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'changeFilter to month loads month sessions',
      build: () {
        when(() => mockRepository.getMonthSessions()).thenReturn(testSessions);
        return StatisticsCubit(mockRepository);
      },
      act: (cubit) => cubit.changeFilter(StatisticsFilter.month),
      expect: () => [
        isA<StatisticsState>().having(
          (s) => s.filter,
          'filter',
          StatisticsFilter.month,
        ),
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StatisticsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.sessions, 'sessions', testSessions),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'changeFilter to all loads all sessions',
      build: () {
        when(() => mockRepository.getAllSessions()).thenReturn(testSessions);
        return StatisticsCubit(mockRepository);
      },
      act: (cubit) => cubit.changeFilter(StatisticsFilter.all),
      expect: () => [
        isA<StatisticsState>().having(
          (s) => s.filter,
          'filter',
          StatisticsFilter.all,
        ),
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StatisticsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.sessions, 'sessions', testSessions),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'refresh reloads current filter',
      build: () => StatisticsCubit(mockRepository),
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'clearAllStatistics clears sessions',
      build: () => StatisticsCubit(mockRepository),
      act: (cubit) => cubit.clearAllStatistics(),
      expect: () => [
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StatisticsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.sessions, 'sessions', isEmpty),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'handles error when loading statistics fails',
      build: () {
        when(
          () => mockRepository.getTodaySessions(),
        ).thenThrow(Exception('Database error'));
        return StatisticsCubit(mockRepository);
      },
      act: (cubit) => cubit.loadStatistics(),
      expect: () => [
        isA<StatisticsState>().having((s) => s.isLoading, 'isLoading', true),
        isA<StatisticsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              contains('Failed to load statistics'),
            ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'clearError removes error message',
      build: () => statisticsCubit,
      seed: () => StatisticsState(
        sessions: const [],
        filter: StatisticsFilter.today,
        errorMessage: 'Some error',
      ),
      act: (cubit) => cubit.clearError(),
      expect: () => [
        isA<StatisticsState>().having(
          (s) => s.errorMessage,
          'errorMessage',
          null,
        ),
      ],
    );
  });

  group('StatisticsState', () {
    test('workSessionCount calculates correctly', () {
      final state = StatisticsState(
        sessions: testSessions,
        filter: StatisticsFilter.today,
      );

      expect(state.workSessionCount, 2);
    });

    test('totalFocusTime calculates correctly', () {
      final state = StatisticsState(
        sessions: testSessions,
        filter: StatisticsFilter.today,
      );

      expect(state.totalFocusTime, 50); // 25 + 25
    });

    test('totalBreakTime calculates correctly', () {
      final state = StatisticsState(
        sessions: testSessions,
        filter: StatisticsFilter.today,
      );

      expect(state.totalBreakTime, 5);
    });

    test('sessionsByDate groups sessions correctly', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final state = StatisticsState(
        sessions: testSessions,
        filter: StatisticsFilter.today,
      );

      final grouped = state.sessionsByDate;
      expect(grouped.containsKey(today), isTrue);
      expect(grouped[today]?.length, 3);
    });

    test('copyWith updates values correctly', () {
      final state = StatisticsState(
        sessions: testSessions,
        filter: StatisticsFilter.today,
      );

      final updated = state.copyWith(
        filter: StatisticsFilter.week,
        isLoading: true,
      );

      expect(updated.filter, StatisticsFilter.week);
      expect(updated.isLoading, true);
      expect(updated.sessions, testSessions);
    });

    test('copyWith with clearError removes error', () {
      final state = StatisticsState(
        sessions: testSessions,
        filter: StatisticsFilter.today,
        errorMessage: 'Error',
      );

      final updated = state.copyWith(clearError: true);

      expect(updated.errorMessage, null);
    });
  });
}
