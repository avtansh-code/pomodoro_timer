import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_timer/core/models/timer_session.dart';
import 'package:pomodoro_timer/features/statistics/data/statistics_repository.dart';

void main() {
  group('StatisticsRepository', () {
    late StatisticsRepository repository;

    setUpAll(() async {
      // Initialize Hive for testing with a temporary directory
      TestWidgetsFlutterBinding.ensureInitialized();
      Hive.init('./test_hive');
      Hive.registerAdapter(TimerSessionAdapter());
      Hive.registerAdapter(SessionTypeAdapter());
    });

    setUp(() async {
      repository = StatisticsRepository();
      await repository.initialize();
    });

    tearDown(() async {
      await repository.close();
      await Hive.deleteBoxFromDisk('timer_sessions');
    });

    test('initial repository has no sessions', () {
      expect(repository.getSessionCount(), 0);
      expect(repository.getAllSessions(), isEmpty);
    });

    test('addSession adds a session successfully', () async {
      final now = DateTime.now();
      final session = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );

      final key = await repository.addSession(session);

      expect(key, isA<int>());
      expect(repository.getSessionCount(), 1);
    });

    test('getAllSessions returns all added sessions', () async {
      final now = DateTime.now();
      final session1 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );
      final startTime2 = now.add(const Duration(minutes: 30));
      final session2 = TimerSession.create(
        sessionType: SessionType.shortBreak,
        durationInMinutes: 5,
        startTime: startTime2,
        endTime: startTime2.add(const Duration(minutes: 5)),
      );

      await repository.addSession(session1);
      await repository.addSession(session2);

      final sessions = repository.getAllSessions();
      expect(sessions.length, 2);
      expect(sessions[0].sessionType, SessionType.work);
      expect(sessions[1].sessionType, SessionType.shortBreak);
    });

    test('getAllSessions returns sessions in chronological order', () async {
      final now = DateTime.now();
      final startTime1 = now.subtract(const Duration(hours: 2));
      final session1 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: startTime1,
        endTime: startTime1.add(const Duration(minutes: 25)),
      );
      final startTime2 = now.subtract(const Duration(hours: 1));
      final session2 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: startTime2,
        endTime: startTime2.add(const Duration(minutes: 25)),
      );
      final session3 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );

      await repository.addSession(session3);
      await repository.addSession(session1);
      await repository.addSession(session2);

      final sessions = repository.getAllSessions();
      expect(sessions.length, 3);
      expect(sessions[0].startTime.isBefore(sessions[1].startTime), true);
      expect(sessions[1].startTime.isBefore(sessions[2].startTime), true);
    });

    test('getTodaySessions returns only today\'s sessions', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      final todaySession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );
      final yesterdaySession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: yesterday,
        endTime: yesterday.add(const Duration(minutes: 25)),
      );

      await repository.addSession(todaySession);
      await repository.addSession(yesterdaySession);

      final todaySessions = repository.getTodaySessions();
      expect(todaySessions.length, 1);
      expect(todaySessions[0].sessionType, SessionType.work);
    });

    test('getWeekSessions returns sessions from current week', () async {
      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 8));

      final thisWeekSession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );
      final lastWeekSession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: lastWeek,
        endTime: lastWeek.add(const Duration(minutes: 25)),
      );

      await repository.addSession(thisWeekSession);
      await repository.addSession(lastWeekSession);

      final weekSessions = repository.getWeekSessions();
      expect(weekSessions.length, 1);
    });

    test('getMonthSessions returns sessions from current month', () async {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1, now.day);

      final thisMonthSession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );
      final lastMonthSession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: lastMonth,
        endTime: lastMonth.add(const Duration(minutes: 25)),
      );

      await repository.addSession(thisMonthSession);
      await repository.addSession(lastMonthSession);

      final monthSessions = repository.getMonthSessions();
      expect(monthSessions.length, 1);
    });

    test('getSessionsByDateRange returns sessions in range', () async {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 7));
      final endDate = now;

      final inRangeStart = now.subtract(const Duration(days: 3));
      final inRangeSession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: inRangeStart,
        endTime: inRangeStart.add(const Duration(minutes: 25)),
      );
      final outOfRangeStart = now.subtract(const Duration(days: 10));
      final outOfRangeSession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: outOfRangeStart,
        endTime: outOfRangeStart.add(const Duration(minutes: 25)),
      );

      await repository.addSession(inRangeSession);
      await repository.addSession(outOfRangeSession);

      final sessions = repository.getSessionsByDateRange(startDate, endDate);
      expect(sessions.length, 1);
    });

    test('getWorkSessionCount returns only work sessions', () async {
      final now = DateTime.now();
      final workSession = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );
      final breakStart = now.add(const Duration(minutes: 30));
      final breakSession = TimerSession.create(
        sessionType: SessionType.shortBreak,
        durationInMinutes: 5,
        startTime: breakStart,
        endTime: breakStart.add(const Duration(minutes: 5)),
      );

      await repository.addSession(workSession);
      await repository.addSession(breakSession);

      expect(repository.getWorkSessionCount(), 1);
      expect(repository.getSessionCount(), 2);
    });

    test('getTotalFocusTime calculates correctly', () async {
      final now = DateTime.now();
      final session1 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );
      final start2 = now.add(const Duration(minutes: 30));
      final session2 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 30,
        startTime: start2,
        endTime: start2.add(const Duration(minutes: 30)),
      );
      final breakStart = now.add(const Duration(minutes: 65));
      final breakSession = TimerSession.create(
        sessionType: SessionType.shortBreak,
        durationInMinutes: 5,
        startTime: breakStart,
        endTime: breakStart.add(const Duration(minutes: 5)),
      );

      await repository.addSession(session1);
      await repository.addSession(session2);
      await repository.addSession(breakSession);

      expect(repository.getTotalFocusTime(), 55); // 25 + 30, break excluded
    });

    test('deleteSession removes a session', () async {
      final now = DateTime.now();
      final session = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );

      final key = await repository.addSession(session);
      expect(repository.getSessionCount(), 1);

      await repository.deleteSession(key);
      expect(repository.getSessionCount(), 0);
    });

    test('clearAllSessions removes all sessions', () async {
      final now = DateTime.now();
      final session1 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );
      final start2 = now.add(const Duration(minutes: 30));
      final session2 = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: start2,
        endTime: start2.add(const Duration(minutes: 25)),
      );

      await repository.addSession(session1);
      await repository.addSession(session2);
      expect(repository.getSessionCount(), 2);

      await repository.clearAllSessions();
      expect(repository.getSessionCount(), 0);
      expect(repository.getAllSessions(), isEmpty);
    });

    test('throws StateError when not initialized', () {
      final uninitializedRepo = StatisticsRepository();

      expect(() => uninitializedRepo.getAllSessions(), throwsStateError);
      expect(() => uninitializedRepo.getSessionCount(), throwsStateError);
      expect(() => uninitializedRepo.getWorkSessionCount(), throwsStateError);
      expect(() => uninitializedRepo.getTotalFocusTime(), throwsStateError);
    });

    test('repository can be reinitialized after closing', () async {
      await repository.close();
      await repository.initialize();

      final now = DateTime.now();
      final session = TimerSession.create(
        sessionType: SessionType.work,
        durationInMinutes: 25,
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
      );

      await repository.addSession(session);
      expect(repository.getSessionCount(), 1);
    });
  });
}