import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pomodoro_timer/core/models/timer_settings.dart';
import 'package:pomodoro_timer/core/services/persistence_service.dart';
import 'package:pomodoro_timer/features/settings/bloc/settings_cubit.dart';
import 'package:pomodoro_timer/features/settings/bloc/settings_state.dart';

// Mock class
class MockPersistenceService extends Mock implements PersistenceService {}

void main() {
  late SettingsCubit settingsCubit;
  late MockPersistenceService mockPersistenceService;
  late TimerSettings testSettings;

  setUpAll(() {
    // Register fallback value for TimerSettings
    registerFallbackValue(const TimerSettings());
  });

  setUp(() {
    mockPersistenceService = MockPersistenceService();
    testSettings = const TimerSettings(
      workDuration: 25,
      shortBreakDuration: 5,
      longBreakDuration: 15,
      sessionsBeforeLongBreak: 4,
    );

    // Setup default mock behavior
    when(() => mockPersistenceService.getSettings()).thenReturn(testSettings);
    when(() => mockPersistenceService.saveSettings(any()))
        .thenAnswer((_) async => true);

    settingsCubit = SettingsCubit(mockPersistenceService);
  });

  tearDown(() {
    settingsCubit.close();
  });

  group('SettingsCubit', () {
    test('initial state has default settings and loads immediately', () {
      final cubit = SettingsCubit(mockPersistenceService);
      expect(cubit.state.settings, testSettings);
      expect(cubit.state.isLoading, false);
      cubit.close();
    });

    blocTest<SettingsCubit, SettingsState>(
      'loadSettings emits loading then loaded state',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.loadSettings(),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings, 'settings', testSettings),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateWorkDuration updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateWorkDuration(30),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.workDuration, 'workDuration', 30),
      ],
      verify: (_) {
        verify(() => mockPersistenceService.saveSettings(any())).called(1);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateWorkDuration rejects invalid values',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateWorkDuration(0),
      expect: () => [
        isA<SettingsState>()
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              contains('must be between 1 and 60'),
            ),
      ],
      verify: (_) {
        verifyNever(() => mockPersistenceService.saveSettings(any()));
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateShortBreakDuration updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateShortBreakDuration(10),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.shortBreakDuration, 'shortBreakDuration', 10),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateShortBreakDuration rejects invalid values',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateShortBreakDuration(31),
      expect: () => [
        isA<SettingsState>()
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              contains('must be between 1 and 30'),
            ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateLongBreakDuration updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateLongBreakDuration(20),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.longBreakDuration, 'longBreakDuration', 20),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateLongBreakDuration rejects invalid values',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateLongBreakDuration(61),
      expect: () => [
        isA<SettingsState>()
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              contains('must be between 1 and 60'),
            ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateSessionsBeforeLongBreak updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateSessionsBeforeLongBreak(3),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.sessionsBeforeLongBreak, 'sessionsBeforeLongBreak', 3),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateSessionsBeforeLongBreak rejects invalid values',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateSessionsBeforeLongBreak(11),
      expect: () => [
        isA<SettingsState>()
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              contains('must be between 1 and 10'),
            ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateAutoStartBreaks updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateAutoStartBreaks(true),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.autoStartBreaks, 'autoStartBreaks', true),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateAutoStartFocus updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateAutoStartFocus(true),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.autoStartFocus, 'autoStartFocus', true),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateNotificationsEnabled updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateNotificationsEnabled(false),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.notificationsEnabled, 'notificationsEnabled', false),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateSoundEnabled updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateSoundEnabled(false),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.soundEnabled, 'soundEnabled', false),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'updateHapticEnabled updates and saves settings',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.updateHapticEnabled(false),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings.hapticEnabled, 'hapticEnabled', false),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'resetToDefaults resets settings to defaults',
      build: () => SettingsCubit(mockPersistenceService),
      act: (cubit) => cubit.resetToDefaults(),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.settings, 'settings', const TimerSettings()),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'handles error when save fails',
      build: () {
        when(() => mockPersistenceService.saveSettings(any()))
            .thenAnswer((_) async => false);
        return SettingsCubit(mockPersistenceService);
      },
      act: (cubit) => cubit.updateWorkDuration(30),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', true),
        isA<SettingsState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having(
              (s) => s.errorMessage,
              'errorMessage',
              'Failed to save settings',
            ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'clearError removes error message',
      build: () => settingsCubit,
      seed: () => SettingsState(
        settings: testSettings,
        errorMessage: 'Some error',
      ),
      act: (cubit) => cubit.clearError(),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.errorMessage, 'errorMessage', null),
      ],
    );
  });

  group('SettingsState', () {
    test('copyWith updates values correctly', () {
      final state = SettingsState(settings: testSettings);

      final newSettings = testSettings.copyWith(workDuration: 30);
      final updated = state.copyWith(
        settings: newSettings,
        isLoading: true,
      );

      expect(updated.settings.workDuration, 30);
      expect(updated.isLoading, true);
    });

    test('copyWith with clearError removes error', () {
      final state = SettingsState(
        settings: testSettings,
        errorMessage: 'Error',
      );

      final updated = state.copyWith(clearError: true);

      expect(updated.errorMessage, null);
    });
  });
}
