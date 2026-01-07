import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodoro_timer/app/theme/app_theme.dart';

void main() {
  group('ThemeState', () {
    test('creates state with theme mode', () {
      const state = ThemeState(ThemeMode.dark);
      expect(state.themeMode, ThemeMode.dark);
    });

    test('copyWith creates new state with updated theme mode', () {
      const state = ThemeState(ThemeMode.light);
      final newState = state.copyWith(themeMode: ThemeMode.dark);

      expect(newState.themeMode, ThemeMode.dark);
      expect(state.themeMode, ThemeMode.light); // Original unchanged
    });

    test('copyWith without parameters returns same state', () {
      const state = ThemeState(ThemeMode.system);
      final newState = state.copyWith();

      expect(newState.themeMode, state.themeMode);
    });
  });

  group('ThemeCubit', () {
    late SharedPreferences prefs;
    late ThemeCubit themeCubit;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      themeCubit = ThemeCubit(prefs);
    });

    tearDown(() async {
      await themeCubit.close();
      await prefs.clear();
    });

    test('initial state is system theme', () {
      expect(themeCubit.state.themeMode, ThemeMode.system);
    });

    test('setThemeMode updates theme and saves to storage', () async {
      await themeCubit.setThemeMode(ThemeMode.dark);

      expect(themeCubit.state.themeMode, ThemeMode.dark);
      expect(prefs.getInt('theme_mode'), ThemeMode.dark.index);
    });

    test('setLightTheme sets light mode', () async {
      await themeCubit.setLightTheme();

      expect(themeCubit.state.themeMode, ThemeMode.light);
      expect(prefs.getInt('theme_mode'), ThemeMode.light.index);
    });

    test('setDarkTheme sets dark mode', () async {
      await themeCubit.setDarkTheme();

      expect(themeCubit.state.themeMode, ThemeMode.dark);
      expect(prefs.getInt('theme_mode'), ThemeMode.dark.index);
    });

    test('setSystemTheme sets system mode', () async {
      await themeCubit.setLightTheme();
      await themeCubit.setSystemTheme();

      expect(themeCubit.state.themeMode, ThemeMode.system);
      expect(prefs.getInt('theme_mode'), ThemeMode.system.index);
    });

    test('toggleTheme switches from light to dark', () async {
      await themeCubit.setLightTheme();
      await themeCubit.toggleTheme();

      expect(themeCubit.state.themeMode, ThemeMode.dark);
    });

    test('toggleTheme switches from dark to light', () async {
      await themeCubit.setDarkTheme();
      await themeCubit.toggleTheme();

      expect(themeCubit.state.themeMode, ThemeMode.light);
    });

    test('toggleTheme switches from system to light', () async {
      await themeCubit.setSystemTheme();
      await themeCubit.toggleTheme();

      expect(themeCubit.state.themeMode, ThemeMode.light);
    });

    test('loads saved theme on initialization', () async {
      await prefs.setInt('theme_mode', ThemeMode.dark.index);
      final newCubit = ThemeCubit(prefs);

      // Give it time to load
      await Future.delayed(const Duration(milliseconds: 100));

      expect(newCubit.state.themeMode, ThemeMode.dark);
      await newCubit.close();
    });

    test('handles missing saved theme gracefully', () async {
      // No saved theme in prefs
      final newCubit = ThemeCubit(prefs);

      await Future.delayed(const Duration(milliseconds: 100));

      expect(newCubit.state.themeMode, ThemeMode.system);
      await newCubit.close();
    });

    test('multiple theme changes persist correctly', () async {
      await themeCubit.setLightTheme();
      expect(prefs.getInt('theme_mode'), ThemeMode.light.index);

      await themeCubit.setDarkTheme();
      expect(prefs.getInt('theme_mode'), ThemeMode.dark.index);

      await themeCubit.setSystemTheme();
      expect(prefs.getInt('theme_mode'), ThemeMode.system.index);
    });

    test('theme persists across cubit instances', () async {
      await themeCubit.setDarkTheme();
      await themeCubit.close();

      final newCubit = ThemeCubit(prefs);
      await Future.delayed(const Duration(milliseconds: 100));

      expect(newCubit.state.themeMode, ThemeMode.dark);
      await newCubit.close();
    });

    test('handles corrupted theme data gracefully', () async {
      // Set invalid theme index
      await prefs.setInt('theme_mode', 999);

      // Should not crash and fallback to default
      expect(() => ThemeCubit(prefs), returnsNormally);
    });
  });
}
