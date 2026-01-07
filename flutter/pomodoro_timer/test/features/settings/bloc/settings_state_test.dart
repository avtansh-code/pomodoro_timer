import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/models/timer_settings.dart';
import 'package:pomodoro_timer/features/settings/bloc/settings_state.dart';

void main() {
  group('SettingsState', () {
    const defaultSettings = TimerSettings();
    const customSettings = TimerSettings(
      workDuration: 30,
      shortBreakDuration: 10,
      longBreakDuration: 20,
      sessionsBeforeLongBreak: 3,
    );

    group('constructor', () {
      test('creates instance with required settings', () {
        final state = SettingsState(settings: defaultSettings);

        expect(state.settings, defaultSettings);
        expect(state.isLoading, false);
        expect(state.errorMessage, null);
      });

      test('creates instance with all parameters', () {
        final state = SettingsState(
          settings: customSettings,
          isLoading: true,
          errorMessage: 'Test error',
        );

        expect(state.settings, customSettings);
        expect(state.isLoading, true);
        expect(state.errorMessage, 'Test error');
      });
    });

    group('initial factory', () {
      test('creates state with default settings', () {
        final state = SettingsState.initial();

        expect(state.settings, const TimerSettings());
        expect(state.isLoading, true);
        expect(state.errorMessage, null);
      });

      test('initial state settings have default values', () {
        final state = SettingsState.initial();

        expect(state.settings.workDuration, 25);
        expect(state.settings.shortBreakDuration, 5);
        expect(state.settings.longBreakDuration, 15);
        expect(state.settings.sessionsBeforeLongBreak, 4);
        expect(state.settings.autoStartBreaks, false);
        expect(state.settings.autoStartFocus, false);
        expect(state.settings.notificationsEnabled, true);
        expect(state.settings.soundEnabled, true);
        expect(state.settings.hapticEnabled, true);
      });
    });

    group('copyWith', () {
      test('updates settings', () {
        final state = SettingsState(settings: defaultSettings);
        final updated = state.copyWith(settings: customSettings);

        expect(updated.settings, customSettings);
        expect(updated.isLoading, state.isLoading);
        expect(updated.errorMessage, state.errorMessage);
      });

      test('updates isLoading', () {
        final state = SettingsState(settings: defaultSettings);
        final updated = state.copyWith(isLoading: true);

        expect(updated.settings, state.settings);
        expect(updated.isLoading, true);
        expect(updated.errorMessage, state.errorMessage);
      });

      test('updates errorMessage', () {
        final state = SettingsState(settings: defaultSettings);
        final updated = state.copyWith(errorMessage: 'New error');

        expect(updated.settings, state.settings);
        expect(updated.isLoading, state.isLoading);
        expect(updated.errorMessage, 'New error');
      });

      test('clearError removes error message', () {
        final state = SettingsState(
          settings: defaultSettings,
          errorMessage: 'Existing error',
        );
        final updated = state.copyWith(clearError: true);

        expect(updated.errorMessage, null);
      });

      test('clearError takes precedence over errorMessage', () {
        final state = SettingsState(
          settings: defaultSettings,
          errorMessage: 'Existing error',
        );
        final updated = state.copyWith(
          clearError: true,
          errorMessage: 'New error',
        );

        expect(updated.errorMessage, null);
      });

      test('keeps existing values when no parameters provided', () {
        final state = SettingsState(
          settings: customSettings,
          isLoading: true,
          errorMessage: 'Error',
        );
        final updated = state.copyWith();

        expect(updated.settings, customSettings);
        expect(updated.isLoading, true);
        expect(updated.errorMessage, 'Error');
      });

      test('updates multiple values at once', () {
        final state = SettingsState(settings: defaultSettings);
        final updated = state.copyWith(
          settings: customSettings,
          isLoading: true,
          errorMessage: 'Error',
        );

        expect(updated.settings, customSettings);
        expect(updated.isLoading, true);
        expect(updated.errorMessage, 'Error');
      });
    });

    group('Equatable', () {
      test('states with same values are equal', () {
        final state1 = SettingsState(
          settings: defaultSettings,
          isLoading: false,
          errorMessage: null,
        );
        final state2 = SettingsState(
          settings: defaultSettings,
          isLoading: false,
          errorMessage: null,
        );

        expect(state1, equals(state2));
      });

      test('states with different settings are not equal', () {
        final state1 = SettingsState(settings: defaultSettings);
        final state2 = SettingsState(settings: customSettings);

        expect(state1, isNot(equals(state2)));
      });

      test('states with different isLoading are not equal', () {
        final state1 = SettingsState(settings: defaultSettings, isLoading: false);
        final state2 = SettingsState(settings: defaultSettings, isLoading: true);

        expect(state1, isNot(equals(state2)));
      });

      test('states with different errorMessage are not equal', () {
        final state1 = SettingsState(settings: defaultSettings);
        final state2 = SettingsState(
          settings: defaultSettings,
          errorMessage: 'Error',
        );

        expect(state1, isNot(equals(state2)));
      });

      test('props contains all properties', () {
        final state = SettingsState(
          settings: defaultSettings,
          isLoading: true,
          errorMessage: 'Error',
        );

        expect(state.props, [defaultSettings, true, 'Error']);
      });
    });

    group('State transitions', () {
      test('loading state can transition to loaded state', () {
        final loadingState = SettingsState(
          settings: defaultSettings,
          isLoading: true,
        );

        final loadedState = loadingState.copyWith(
          settings: customSettings,
          isLoading: false,
        );

        expect(loadedState.isLoading, false);
        expect(loadedState.settings, customSettings);
      });

      test('can add error to loaded state', () {
        final loadedState = SettingsState(
          settings: customSettings,
          isLoading: false,
        );

        final errorState = loadedState.copyWith(
          errorMessage: 'Save failed',
        );

        expect(errorState.errorMessage, 'Save failed');
        expect(errorState.settings, customSettings);
      });

      test('can clear error and continue with current settings', () {
        final errorState = SettingsState(
          settings: customSettings,
          isLoading: false,
          errorMessage: 'Error occurred',
        );

        final clearedState = errorState.copyWith(clearError: true);

        expect(clearedState.errorMessage, null);
        expect(clearedState.settings, customSettings);
        expect(clearedState.isLoading, false);
      });
    });
  });
}