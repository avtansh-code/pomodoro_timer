import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/timer_settings.dart';
import '../../../core/services/persistence_service.dart';
import 'settings_state.dart';

/// Cubit for managing settings state.
///
/// Handles loading, updating, and persisting timer settings.
/// Uses PersistenceService for storage.
class SettingsCubit extends Cubit<SettingsState> {
  final PersistenceService _persistenceService;

  SettingsCubit(this._persistenceService) : super(SettingsState.initial()) {
    loadSettings();
  }

  /// Loads settings from storage.
  ///
  /// If no settings exist, uses defaults.
  Future<void> loadSettings() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final settings = _persistenceService.getSettings();

      emit(state.copyWith(settings: settings, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load settings: $e',
        ),
      );
    }
  }

  /// Updates the work duration setting.
  Future<void> updateWorkDuration(int minutes) async {
    if (minutes < 1 || minutes > 60) {
      emit(
        state.copyWith(
          errorMessage: 'Work duration must be between 1 and 60 minutes',
        ),
      );
      return;
    }

    await _updateSettings(state.settings.copyWith(workDuration: minutes));
  }

  /// Updates the short break duration setting.
  Future<void> updateShortBreakDuration(int minutes) async {
    if (minutes < 1 || minutes > 30) {
      emit(
        state.copyWith(
          errorMessage: 'Short break must be between 1 and 30 minutes',
        ),
      );
      return;
    }

    await _updateSettings(state.settings.copyWith(shortBreakDuration: minutes));
  }

  /// Updates the long break duration setting.
  Future<void> updateLongBreakDuration(int minutes) async {
    if (minutes < 1 || minutes > 60) {
      emit(
        state.copyWith(
          errorMessage: 'Long break must be between 1 and 60 minutes',
        ),
      );
      return;
    }

    await _updateSettings(state.settings.copyWith(longBreakDuration: minutes));
  }

  /// Updates the sessions before long break setting.
  Future<void> updateSessionsBeforeLongBreak(int sessions) async {
    if (sessions < 1 || sessions > 10) {
      emit(
        state.copyWith(
          errorMessage: 'Sessions before long break must be between 1 and 10',
        ),
      );
      return;
    }

    await _updateSettings(
      state.settings.copyWith(sessionsBeforeLongBreak: sessions),
    );
  }

  /// Updates the auto-start breaks setting.
  Future<void> updateAutoStartBreaks(bool enabled) async {
    await _updateSettings(state.settings.copyWith(autoStartBreaks: enabled));
  }

  /// Updates the auto-start focus setting.
  Future<void> updateAutoStartFocus(bool enabled) async {
    await _updateSettings(state.settings.copyWith(autoStartFocus: enabled));
  }

  /// Updates the notifications enabled setting.
  Future<void> updateNotificationsEnabled(bool enabled) async {
    await _updateSettings(
      state.settings.copyWith(notificationsEnabled: enabled),
    );
  }

  /// Updates the sound enabled setting.
  Future<void> updateSoundEnabled(bool enabled) async {
    await _updateSettings(state.settings.copyWith(soundEnabled: enabled));
  }

  /// Updates the haptic feedback enabled setting.
  Future<void> updateHapticEnabled(bool enabled) async {
    await _updateSettings(state.settings.copyWith(hapticEnabled: enabled));
  }

  /// Resets settings to defaults.
  Future<void> resetToDefaults() async {
    await _updateSettings(const TimerSettings());
  }

  /// Internal method to update and persist settings.
  Future<void> _updateSettings(TimerSettings newSettings) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final success = await _persistenceService.saveSettings(newSettings);

      if (success) {
        emit(state.copyWith(settings: newSettings, isLoading: false));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to save settings',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error saving settings: $e',
        ),
      );
    }
  }

  /// Clears any error message.
  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
