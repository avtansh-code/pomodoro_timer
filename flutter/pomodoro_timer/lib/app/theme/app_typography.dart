import 'package:flutter/material.dart';

/// Custom typography system matching iOS SF Rounded design patterns.
///
/// Provides a consistent rounded font design across the application,
/// similar to iOS's SF Pro Rounded font. Uses bundled Quicksand font
/// which provides a rounded, friendly appearance similar to SF Rounded.
class AppTypography {
  /// Base text style using Quicksand (rounded font similar to SF Rounded)
  /// Font is bundled locally to avoid network issues on iOS
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: 'Quicksand',
  );
  
  /// Large title style (34pt, bold, rounded)
  /// Used for major section headers
  static TextStyle get largeTitle => _baseStyle.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.4,
      );
  
  /// Title style (28pt, bold, rounded)
  /// Used for screen titles and important headers
  static TextStyle get title => _baseStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.36,
      );
  
  /// Title 2 style (22pt, bold, rounded)
  /// Used for section headers
  static TextStyle get title2 => _baseStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.35,
      );
  
  /// Title 3 style (20pt, semibold, rounded)
  /// Used for subsection headers
  static TextStyle get title3 => _baseStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.38,
      );
  
  /// Headline style (17pt, semibold, rounded)
  /// Used for list items and card headers
  static TextStyle get headline => _baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
      );
  
  /// Body style (17pt, regular, rounded)
  /// Used for main content text
  static TextStyle get body => _baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.41,
      );
  
  /// Callout style (16pt, regular, rounded)
  /// Used for secondary text
  static TextStyle get callout => _baseStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.32,
      );
  
  /// Subheadline style (15pt, regular, rounded)
  /// Used for supporting text
  static TextStyle get subheadline => _baseStyle.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.24,
      );
  
  /// Footnote style (13pt, regular, rounded)
  /// Used for captions and small text
  static TextStyle get footnote => _baseStyle.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.08,
      );
  
  /// Caption style (12pt, regular, rounded)
  /// Used for very small text
  static TextStyle get caption => _baseStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
      );
  
  /// Timer font style (64pt, thin, rounded, monospaced)
  /// Special style for the timer display with tabular figures
  static TextStyle get timerFont => _baseStyle.copyWith(
        fontSize: 64,
        fontWeight: FontWeight.w100, // Thin weight to match iOS .thin
        letterSpacing: 2.0,
        fontFeatures: const [
          FontFeature.tabularFigures(), // Ensures consistent digit width
        ],
      );
  
  /// Button text style (17pt, semibold, rounded)
  /// Used for button labels
  static TextStyle get button => _baseStyle.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
      );
  
  /// Creates a complete TextTheme for Material Design integration
  static TextTheme createTextTheme(Color color) {
    return TextTheme(
      displayLarge: largeTitle.copyWith(color: color),
      displayMedium: title.copyWith(color: color),
      displaySmall: title2.copyWith(color: color),
      headlineMedium: title3.copyWith(color: color),
      headlineSmall: headline.copyWith(color: color),
      titleLarge: title2.copyWith(color: color),
      titleMedium: headline.copyWith(color: color),
      titleSmall: callout.copyWith(color: color),
      bodyLarge: body.copyWith(color: color),
      bodyMedium: body.copyWith(color: color),
      bodySmall: callout.copyWith(color: color),
      labelLarge: button.copyWith(color: color),
      labelMedium: callout.copyWith(color: color),
      labelSmall: footnote.copyWith(color: color),
    );
  }
  
  /// Helper to apply color to any text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}
