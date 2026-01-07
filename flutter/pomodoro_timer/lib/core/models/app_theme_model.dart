import 'package:flutter/material.dart';
import '../models/timer_session.dart';

/// Represents a color theme for the Pomodoro app.
///
/// Based on iOS legacy app's 5 pre-defined themes:
/// 1. Classic Red
/// 2. Ocean Blue
/// 3. Forest Green
/// 4. Midnight Dark
/// 5. Sunset Orange
class AppThemeModel {
  /// Unique identifier for the theme
  final String id;

  /// Display name for the theme
  final String name;

  /// Primary color for the theme
  final Color primaryColor;

  /// Secondary color for the theme (lighter shade)
  final Color secondaryColor;

  /// Accent color for highlights
  final Color accentColor;

  /// Gradient for focus/work sessions
  final Gradient focusGradient;

  /// Gradient for short break sessions
  final Gradient shortBreakGradient;

  /// Gradient for long break sessions
  final Gradient longBreakGradient;

  const AppThemeModel({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.focusGradient,
    required this.shortBreakGradient,
    required this.longBreakGradient,
  });

  /// Gets the gradient for a specific session type
  Gradient getGradientForSession(SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return focusGradient;
      case SessionType.shortBreak:
        return shortBreakGradient;
      case SessionType.longBreak:
        return longBreakGradient;
    }
  }

  /// Gets the primary color for a specific session type
  Color getColorForSession(SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return primaryColor;
      case SessionType.shortBreak:
        return const Color(0xFF34C759); // Green
      case SessionType.longBreak:
        return const Color(0xFF007AFF); // Blue
    }
  }

  /// Creates a copy of this theme with updated values
  AppThemeModel copyWith({
    String? id,
    String? name,
    Color? primaryColor,
    Color? secondaryColor,
    Color? accentColor,
    Gradient? focusGradient,
    Gradient? shortBreakGradient,
    Gradient? longBreakGradient,
  }) {
    return AppThemeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
      focusGradient: focusGradient ?? this.focusGradient,
      shortBreakGradient: shortBreakGradient ?? this.shortBreakGradient,
      longBreakGradient: longBreakGradient ?? this.longBreakGradient,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Pre-defined themes matching iOS legacy app
class PomodoroThemes {
  PomodoroThemes._();

  /// Classic Red theme (Default - matches current deep orange)
  static const AppThemeModel classicRed = AppThemeModel(
    id: 'classic_red',
    name: 'Classic Red',
    primaryColor: Color(0xFFED4242),
    secondaryColor: Color(0xFFFA7343),
    accentColor: Color(0xFFFF6B6B),
    focusGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFED4242), Color(0xFFFA7343)],
    ),
    shortBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFA7343), Color(0xFFFFB366)],
    ),
    longBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFED4242), Color(0xFFFA7343)],
    ),
  );

  /// Ocean Blue theme
  static const AppThemeModel oceanBlue = AppThemeModel(
    id: 'ocean_blue',
    name: 'Ocean Blue',
    primaryColor: Color(0xFF3399DB),
    secondaryColor: Color(0xFF33CCED),
    accentColor: Color(0xFF66D9EF),
    focusGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3399DB), Color(0xFF33CCED)],
    ),
    shortBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF33CCED), Color(0xFF66E0F0)],
    ),
    longBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3399DB), Color(0xFF5EAEE0)],
    ),
  );

  /// Forest Green theme
  static const AppThemeModel forestGreen = AppThemeModel(
    id: 'forest_green',
    name: 'Forest Green',
    primaryColor: Color(0xFF339966),
    secondaryColor: Color(0xFF4DC785),
    accentColor: Color(0xFF66D99E),
    focusGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF339966), Color(0xFF4DC785)],
    ),
    shortBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4DC785), Color(0xFF7DE0A8)],
    ),
    longBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF339966), Color(0xFF5DD094)],
    ),
  );

  /// Midnight Dark theme (Purple)
  static const AppThemeModel midnightDark = AppThemeModel(
    id: 'midnight_dark',
    name: 'Midnight Dark',
    primaryColor: Color(0xFF736BC2),
    secondaryColor: Color(0xFF998CD9),
    accentColor: Color(0xFFA99FDE),
    focusGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF736BC2), Color(0xFF998CD9)],
    ),
    shortBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF998CD9), Color(0xFFB5A9E3)],
    ),
    longBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF736BC2), Color(0xFF8D84D0)],
    ),
  );

  /// Sunset Orange theme
  static const AppThemeModel sunsetOrange = AppThemeModel(
    id: 'sunset_orange',
    name: 'Sunset Orange',
    primaryColor: Color(0xFFFA8033),
    secondaryColor: Color(0xFFFFA64D),
    accentColor: Color(0xFFFFB870),
    focusGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFA8033), Color(0xFFFFA64D)],
    ),
    shortBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFA64D), Color(0xFFFFCC80)],
    ),
    longBreakGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFA8033), Color(0xFFFFB366)],
    ),
  );

  /// List of all available themes
  static const List<AppThemeModel> allThemes = [
    classicRed,
    oceanBlue,
    forestGreen,
    midnightDark,
    sunsetOrange,
  ];

  /// Get theme by ID
  static AppThemeModel getThemeById(String id) {
    return allThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => classicRed,
    );
  }

  /// Default theme
  static AppThemeModel get defaultTheme => classicRed;
}