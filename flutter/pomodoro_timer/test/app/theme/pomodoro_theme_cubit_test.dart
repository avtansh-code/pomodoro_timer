import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pomodoro_timer/app/theme/pomodoro_theme_cubit.dart';
import 'package:pomodoro_timer/core/models/app_theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock class for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
  });

  group('PomodoroThemeState', () {
    test('creates instance with currentTheme', () {
      const state = PomodoroThemeState(PomodoroThemes.classicRed);
      expect(state.currentTheme, PomodoroThemes.classicRed);
    });

    test('copyWith updates currentTheme', () {
      const state = PomodoroThemeState(PomodoroThemes.classicRed);
      final updated = state.copyWith(currentTheme: PomodoroThemes.oceanBlue);
      expect(updated.currentTheme, PomodoroThemes.oceanBlue);
    });

    test('copyWith without parameters keeps current theme', () {
      const state = PomodoroThemeState(PomodoroThemes.forestGreen);
      final updated = state.copyWith();
      expect(updated.currentTheme, PomodoroThemes.forestGreen);
    });
  });

  group('PomodoroThemeCubit', () {
    test('initial state is default theme when no saved theme', () {
      when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);

      final cubit = PomodoroThemeCubit(mockPrefs);

      expect(cubit.state.currentTheme, PomodoroThemes.defaultTheme);

      cubit.close();
    });

    test('loads saved theme from preferences', () {
      when(
        () => mockPrefs.getString('pomodoro_theme_id'),
      ).thenReturn('ocean_blue');

      final cubit = PomodoroThemeCubit(mockPrefs);

      expect(cubit.state.currentTheme, PomodoroThemes.oceanBlue);

      cubit.close();
    });

    test('handles invalid theme id gracefully', () {
      when(
        () => mockPrefs.getString('pomodoro_theme_id'),
      ).thenReturn('invalid_theme');

      final cubit = PomodoroThemeCubit(mockPrefs);

      // Should fall back to classicRed (default when theme not found)
      expect(cubit.state.currentTheme, PomodoroThemes.classicRed);

      cubit.close();
    });

    test('handles exception during load gracefully', () {
      when(
        () => mockPrefs.getString('pomodoro_theme_id'),
      ).thenThrow(Exception('Storage error'));

      // Should not throw and should use default theme
      final cubit = PomodoroThemeCubit(mockPrefs);

      expect(cubit.state.currentTheme, PomodoroThemes.defaultTheme);

      cubit.close();
    });

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setTheme updates current theme and saves to preferences',
      setUp: () {
        when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setTheme(PomodoroThemes.midnightDark),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.midnightDark,
        ),
      ],
      verify: (_) {
        verify(
          () => mockPrefs.setString('pomodoro_theme_id', 'midnight_dark'),
        ).called(1);
      },
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setTheme still updates UI even when save fails',
      setUp: () {
        when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenThrow(Exception('Save failed'));
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setTheme(PomodoroThemes.sunsetOrange),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.sunsetOrange,
        ),
      ],
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setThemeById sets correct theme',
      setUp: () {
        when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setThemeById('forest_green'),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.forestGreen,
        ),
      ],
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setClassicRed sets classic red theme',
      setUp: () {
        when(
          () => mockPrefs.getString('pomodoro_theme_id'),
        ).thenReturn('ocean_blue');
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setClassicRed(),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.classicRed,
        ),
      ],
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setOceanBlue sets ocean blue theme',
      setUp: () {
        when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setOceanBlue(),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.oceanBlue,
        ),
      ],
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setForestGreen sets forest green theme',
      setUp: () {
        when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setForestGreen(),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.forestGreen,
        ),
      ],
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setMidnightDark sets midnight dark theme',
      setUp: () {
        when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setMidnightDark(),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.midnightDark,
        ),
      ],
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'setSunsetOrange sets sunset orange theme',
      setUp: () {
        when(() => mockPrefs.getString('pomodoro_theme_id')).thenReturn(null);
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.setSunsetOrange(),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.sunsetOrange,
        ),
      ],
    );

    blocTest<PomodoroThemeCubit, PomodoroThemeState>(
      'resetToDefault sets default theme',
      setUp: () {
        when(
          () => mockPrefs.getString('pomodoro_theme_id'),
        ).thenReturn('classic_red');
        when(
          () => mockPrefs.setString('pomodoro_theme_id', any()),
        ).thenAnswer((_) async => true);
      },
      build: () => PomodoroThemeCubit(mockPrefs),
      act: (cubit) => cubit.resetToDefault(),
      expect: () => [
        isA<PomodoroThemeState>().having(
          (s) => s.currentTheme,
          'currentTheme',
          PomodoroThemes.defaultTheme,
        ),
      ],
    );
  });
}
