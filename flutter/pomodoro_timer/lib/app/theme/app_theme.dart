import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State for theme management
class ThemeState {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode ?? this.themeMode);
  }
}

/// Cubit for managing application theme.
///
/// Handles loading, switching, and persisting the current theme mode.
/// Supports light, dark, and system theme modes.
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;

  static const String _themeKey = 'theme_mode';

  ThemeCubit(this._prefs) : super(const ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  /// Loads the saved theme from persistent storage.
  void _loadTheme() {
    try {
      final themeIndex = _prefs.getInt(_themeKey);

      if (themeIndex != null) {
        emit(ThemeState(ThemeMode.values[themeIndex]));
      }
    } catch (e) {
      // If loading fails, keep default (system) theme
    }
  }

  /// Changes the theme mode and saves it to persistent storage.
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      await _prefs.setInt(_themeKey, mode.index);
      emit(ThemeState(mode));
    } catch (e) {
      // If saving fails, still update UI but theme won't persist
      emit(ThemeState(mode));
    }
  }

  /// Sets the theme to light mode.
  Future<void> setLightTheme() => setThemeMode(ThemeMode.light);

  /// Sets the theme to dark mode.
  Future<void> setDarkTheme() => setThemeMode(ThemeMode.dark);

  /// Sets the theme to follow system preferences.
  Future<void> setSystemTheme() => setThemeMode(ThemeMode.system);

  /// Toggles between light and dark themes.
  /// If currently on system theme, switches to light.
  Future<void> toggleTheme() async {
    switch (state.themeMode) {
      case ThemeMode.light:
        await setDarkTheme();
        break;
      case ThemeMode.dark:
        await setLightTheme();
        break;
      case ThemeMode.system:
        await setLightTheme();
        break;
    }
  }
}
