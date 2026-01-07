import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/models/app_theme_model.dart';
import 'package:pomodoro_timer/core/models/timer_session.dart';

void main() {
  group('AppThemeModel', () {
    test('creates instance with required fields', () {
      final theme = AppThemeModel(
        id: 'test_theme',
        name: 'Test Theme',
        primaryColor: const Color(0xFFFF0000),
        secondaryColor: const Color(0xFF00FF00),
        accentColor: const Color(0xFF0000FF),
        focusGradient: const LinearGradient(
          colors: [Color(0xFFFF0000), Color(0xFF00FF00)],
        ),
        shortBreakGradient: const LinearGradient(
          colors: [Color(0xFF00FF00), Color(0xFF0000FF)],
        ),
        longBreakGradient: const LinearGradient(
          colors: [Color(0xFF0000FF), Color(0xFFFF0000)],
        ),
      );

      expect(theme.id, 'test_theme');
      expect(theme.name, 'Test Theme');
      expect(theme.primaryColor, const Color(0xFFFF0000));
      expect(theme.secondaryColor, const Color(0xFF00FF00));
      expect(theme.accentColor, const Color(0xFF0000FF));
    });

    test('getGradientForSession returns correct gradient for work', () {
      final gradient = PomodoroThemes.classicRed.getGradientForSession(SessionType.work);
      expect(gradient, PomodoroThemes.classicRed.focusGradient);
    });

    test('getGradientForSession returns correct gradient for short break', () {
      final gradient = PomodoroThemes.classicRed.getGradientForSession(SessionType.shortBreak);
      expect(gradient, PomodoroThemes.classicRed.shortBreakGradient);
    });

    test('getGradientForSession returns correct gradient for long break', () {
      final gradient = PomodoroThemes.classicRed.getGradientForSession(SessionType.longBreak);
      expect(gradient, PomodoroThemes.classicRed.longBreakGradient);
    });

    test('getColorForSession returns primary color for work', () {
      final color = PomodoroThemes.classicRed.getColorForSession(SessionType.work);
      expect(color, PomodoroThemes.classicRed.primaryColor);
    });

    test('getColorForSession returns green for short break', () {
      final color = PomodoroThemes.classicRed.getColorForSession(SessionType.shortBreak);
      expect(color, const Color(0xFF34C759));
    });

    test('getColorForSession returns blue for long break', () {
      final color = PomodoroThemes.classicRed.getColorForSession(SessionType.longBreak);
      expect(color, const Color(0xFF007AFF));
    });

    test('copyWith creates new instance with updated values', () {
      final original = PomodoroThemes.classicRed;
      final updated = original.copyWith(
        name: 'Updated Theme',
        primaryColor: const Color(0xFF123456),
      );

      expect(updated.id, original.id);
      expect(updated.name, 'Updated Theme');
      expect(updated.primaryColor, const Color(0xFF123456));
      expect(updated.secondaryColor, original.secondaryColor);
    });

    test('copyWith without parameters returns equivalent instance', () {
      final original = PomodoroThemes.classicRed;
      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.primaryColor, original.primaryColor);
    });

    test('equality works based on id', () {
      const theme1 = PomodoroThemes.classicRed;
      const theme2 = PomodoroThemes.classicRed;
      const theme3 = PomodoroThemes.oceanBlue;

      expect(theme1, equals(theme2));
      expect(theme1, isNot(equals(theme3)));
    });

    test('hashCode is consistent based on id', () {
      const theme1 = PomodoroThemes.classicRed;
      const theme2 = PomodoroThemes.classicRed;

      expect(theme1.hashCode, equals(theme2.hashCode));
    });
  });

  group('PomodoroThemes', () {
    test('allThemes contains all 5 themes', () {
      expect(PomodoroThemes.allThemes.length, 5);
    });

    test('allThemes contains classicRed', () {
      expect(PomodoroThemes.allThemes, contains(PomodoroThemes.classicRed));
    });

    test('allThemes contains oceanBlue', () {
      expect(PomodoroThemes.allThemes, contains(PomodoroThemes.oceanBlue));
    });

    test('allThemes contains forestGreen', () {
      expect(PomodoroThemes.allThemes, contains(PomodoroThemes.forestGreen));
    });

    test('allThemes contains midnightDark', () {
      expect(PomodoroThemes.allThemes, contains(PomodoroThemes.midnightDark));
    });

    test('allThemes contains sunsetOrange', () {
      expect(PomodoroThemes.allThemes, contains(PomodoroThemes.sunsetOrange));
    });

    test('getThemeById returns correct theme', () {
      final theme = PomodoroThemes.getThemeById('ocean_blue');
      expect(theme, PomodoroThemes.oceanBlue);
    });

    test('getThemeById returns classicRed for unknown id', () {
      final theme = PomodoroThemes.getThemeById('unknown_theme');
      expect(theme, PomodoroThemes.classicRed);
    });

    test('defaultTheme is forestGreen', () {
      expect(PomodoroThemes.defaultTheme, PomodoroThemes.forestGreen);
    });

    test('all themes have unique ids', () {
      final ids = PomodoroThemes.allThemes.map((t) => t.id).toSet();
      expect(ids.length, PomodoroThemes.allThemes.length);
    });

    test('classicRed has correct id and name', () {
      expect(PomodoroThemes.classicRed.id, 'classic_red');
      expect(PomodoroThemes.classicRed.name, 'Classic Red');
    });

    test('oceanBlue has correct id and name', () {
      expect(PomodoroThemes.oceanBlue.id, 'ocean_blue');
      expect(PomodoroThemes.oceanBlue.name, 'Ocean Blue');
    });

    test('forestGreen has correct id and name', () {
      expect(PomodoroThemes.forestGreen.id, 'forest_green');
      expect(PomodoroThemes.forestGreen.name, 'Forest Green');
    });

    test('midnightDark has correct id and name', () {
      expect(PomodoroThemes.midnightDark.id, 'midnight_dark');
      expect(PomodoroThemes.midnightDark.name, 'Midnight Dark');
    });

    test('sunsetOrange has correct id and name', () {
      expect(PomodoroThemes.sunsetOrange.id, 'sunset_orange');
      expect(PomodoroThemes.sunsetOrange.name, 'Sunset Orange');
    });
  });
}