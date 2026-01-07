import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/app_theme_model.dart';

/// State for Pomodoro theme management
class PomodoroThemeState {
  final AppThemeModel currentTheme;

  const PomodoroThemeState(this.currentTheme);

  PomodoroThemeState copyWith({AppThemeModel? currentTheme}) {
    return PomodoroThemeState(currentTheme ?? this.currentTheme);
  }
}

/// Cubit for managing Pomodoro color themes.
///
/// Handles loading, switching, and persisting the current color theme.
/// Works independently from light/dark mode (ThemeCubit).
class PomodoroThemeCubit extends Cubit<PomodoroThemeState> {
  final SharedPreferences _prefs;

  static const String _themeKey = 'pomodoro_theme_id';

  PomodoroThemeCubit(this._prefs)
    : super(PomodoroThemeState(PomodoroThemes.defaultTheme)) {
    _loadTheme();
  }

  /// Loads the saved theme from persistent storage.
  void _loadTheme() {
    try {
      final themeId = _prefs.getString(_themeKey);

      if (themeId != null) {
        final theme = PomodoroThemes.getThemeById(themeId);
        emit(PomodoroThemeState(theme));
      }
    } catch (e) {
      // If loading fails, keep default theme
    }
  }

  /// Changes the current theme and saves it to persistent storage.
  Future<void> setTheme(AppThemeModel theme) async {
    try {
      await _prefs.setString(_themeKey, theme.id);
      emit(PomodoroThemeState(theme));
    } catch (e) {
      // If saving fails, still update UI but theme won't persist
      emit(PomodoroThemeState(theme));
    }
  }

  /// Sets theme by ID
  Future<void> setThemeById(String themeId) async {
    final theme = PomodoroThemes.getThemeById(themeId);
    await setTheme(theme);
  }

  /// Sets Classic Red theme
  Future<void> setClassicRed() => setTheme(PomodoroThemes.classicRed);

  /// Sets Ocean Blue theme
  Future<void> setOceanBlue() => setTheme(PomodoroThemes.oceanBlue);

  /// Sets Forest Green theme
  Future<void> setForestGreen() => setTheme(PomodoroThemes.forestGreen);

  /// Sets Midnight Dark theme
  Future<void> setMidnightDark() => setTheme(PomodoroThemes.midnightDark);

  /// Sets Sunset Orange theme
  Future<void> setSunsetOrange() => setTheme(PomodoroThemes.sunsetOrange);

  /// Resets to default theme
  Future<void> resetToDefault() => setTheme(PomodoroThemes.defaultTheme);
}
