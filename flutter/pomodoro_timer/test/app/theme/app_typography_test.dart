import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/app/theme/app_typography.dart';

void main() {
  group('AppTypography', () {
    group('Text Styles', () {
      test('largeTitle has correct properties', () {
        final style = AppTypography.largeTitle;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 34);
        expect(style.fontWeight, FontWeight.bold);
        expect(style.letterSpacing, 0.4);
      });

      test('title has correct properties', () {
        final style = AppTypography.title;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 28);
        expect(style.fontWeight, FontWeight.bold);
        expect(style.letterSpacing, 0.36);
      });

      test('title2 has correct properties', () {
        final style = AppTypography.title2;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 22);
        expect(style.fontWeight, FontWeight.bold);
        expect(style.letterSpacing, 0.35);
      });

      test('title3 has correct properties', () {
        final style = AppTypography.title3;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 20);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.letterSpacing, 0.38);
      });

      test('headline has correct properties', () {
        final style = AppTypography.headline;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 17);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.letterSpacing, -0.41);
      });

      test('body has correct properties', () {
        final style = AppTypography.body;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 17);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, -0.41);
      });

      test('callout has correct properties', () {
        final style = AppTypography.callout;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, -0.32);
      });

      test('subheadline has correct properties', () {
        final style = AppTypography.subheadline;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 15);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, -0.24);
      });

      test('footnote has correct properties', () {
        final style = AppTypography.footnote;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 13);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, -0.08);
      });

      test('caption has correct properties', () {
        final style = AppTypography.caption;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 12);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.letterSpacing, 0.0);
      });

      test('timerFont has correct properties', () {
        final style = AppTypography.timerFont;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 64);
        expect(style.fontWeight, FontWeight.w100);
        expect(style.letterSpacing, 2.0);
        expect(
          style.fontFeatures,
          contains(const FontFeature.tabularFigures()),
        );
      });

      test('button has correct properties', () {
        final style = AppTypography.button;
        expect(style.fontFamily, 'Quicksand');
        expect(style.fontSize, 17);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.letterSpacing, -0.41);
      });
    });

    group('createTextTheme', () {
      test('creates TextTheme with correct color', () {
        const testColor = Color(0xFF123456);
        final textTheme = AppTypography.createTextTheme(testColor);

        expect(textTheme.displayLarge?.color, testColor);
        expect(textTheme.displayMedium?.color, testColor);
        expect(textTheme.displaySmall?.color, testColor);
        expect(textTheme.headlineMedium?.color, testColor);
        expect(textTheme.headlineSmall?.color, testColor);
        expect(textTheme.titleLarge?.color, testColor);
        expect(textTheme.titleMedium?.color, testColor);
        expect(textTheme.titleSmall?.color, testColor);
        expect(textTheme.bodyLarge?.color, testColor);
        expect(textTheme.bodyMedium?.color, testColor);
        expect(textTheme.bodySmall?.color, testColor);
        expect(textTheme.labelLarge?.color, testColor);
        expect(textTheme.labelMedium?.color, testColor);
        expect(textTheme.labelSmall?.color, testColor);
      });

      test('displayLarge uses largeTitle style', () {
        const testColor = Colors.black;
        final textTheme = AppTypography.createTextTheme(testColor);

        expect(
          textTheme.displayLarge?.fontSize,
          AppTypography.largeTitle.fontSize,
        );
        expect(
          textTheme.displayLarge?.fontWeight,
          AppTypography.largeTitle.fontWeight,
        );
      });

      test('displayMedium uses title style', () {
        const testColor = Colors.black;
        final textTheme = AppTypography.createTextTheme(testColor);

        expect(textTheme.displayMedium?.fontSize, AppTypography.title.fontSize);
        expect(
          textTheme.displayMedium?.fontWeight,
          AppTypography.title.fontWeight,
        );
      });

      test('bodyLarge uses body style', () {
        const testColor = Colors.black;
        final textTheme = AppTypography.createTextTheme(testColor);

        expect(textTheme.bodyLarge?.fontSize, AppTypography.body.fontSize);
        expect(textTheme.bodyLarge?.fontWeight, AppTypography.body.fontWeight);
      });

      test('labelLarge uses button style', () {
        const testColor = Colors.black;
        final textTheme = AppTypography.createTextTheme(testColor);

        expect(textTheme.labelLarge?.fontSize, AppTypography.button.fontSize);
        expect(
          textTheme.labelLarge?.fontWeight,
          AppTypography.button.fontWeight,
        );
      });
    });

    group('withColor', () {
      test('applies color to style', () {
        const testColor = Color(0xFFABCDEF);
        final style = AppTypography.body;
        final coloredStyle = AppTypography.withColor(style, testColor);

        expect(coloredStyle.color, testColor);
        expect(coloredStyle.fontSize, style.fontSize);
        expect(coloredStyle.fontWeight, style.fontWeight);
        expect(coloredStyle.fontFamily, style.fontFamily);
      });

      test('preserves other style properties', () {
        const testColor = Colors.red;
        final style = AppTypography.timerFont;
        final coloredStyle = AppTypography.withColor(style, testColor);

        expect(coloredStyle.color, testColor);
        expect(coloredStyle.fontSize, 64);
        expect(coloredStyle.fontWeight, FontWeight.w100);
        expect(coloredStyle.letterSpacing, 2.0);
        expect(
          coloredStyle.fontFeatures,
          contains(const FontFeature.tabularFigures()),
        );
      });
    });

    group('Font hierarchy', () {
      test('font sizes follow proper hierarchy', () {
        expect(
          AppTypography.largeTitle.fontSize,
          greaterThan(AppTypography.title.fontSize!),
        );
        expect(
          AppTypography.title.fontSize,
          greaterThan(AppTypography.title2.fontSize!),
        );
        expect(
          AppTypography.title2.fontSize,
          greaterThan(AppTypography.title3.fontSize!),
        );
        expect(
          AppTypography.title3.fontSize,
          greaterThan(AppTypography.headline.fontSize!),
        );
        expect(
          AppTypography.headline.fontSize,
          equals(AppTypography.body.fontSize),
        );
        expect(
          AppTypography.body.fontSize,
          greaterThan(AppTypography.callout.fontSize!),
        );
        expect(
          AppTypography.callout.fontSize,
          greaterThan(AppTypography.subheadline.fontSize!),
        );
        expect(
          AppTypography.subheadline.fontSize,
          greaterThan(AppTypography.footnote.fontSize!),
        );
        expect(
          AppTypography.footnote.fontSize,
          greaterThan(AppTypography.caption.fontSize!),
        );
      });

      test('timerFont is largest', () {
        expect(
          AppTypography.timerFont.fontSize,
          greaterThan(AppTypography.largeTitle.fontSize!),
        );
      });
    });

    group('Font weights', () {
      test('title styles use heavier weights', () {
        expect(AppTypography.largeTitle.fontWeight, FontWeight.bold);
        expect(AppTypography.title.fontWeight, FontWeight.bold);
        expect(AppTypography.title2.fontWeight, FontWeight.bold);
        expect(AppTypography.title3.fontWeight, FontWeight.w600);
        expect(AppTypography.headline.fontWeight, FontWeight.w600);
      });

      test('body styles use regular weight', () {
        expect(AppTypography.body.fontWeight, FontWeight.w400);
        expect(AppTypography.callout.fontWeight, FontWeight.w400);
        expect(AppTypography.subheadline.fontWeight, FontWeight.w400);
        expect(AppTypography.footnote.fontWeight, FontWeight.w400);
        expect(AppTypography.caption.fontWeight, FontWeight.w400);
      });

      test('timerFont uses thin weight', () {
        expect(AppTypography.timerFont.fontWeight, FontWeight.w100);
      });

      test('button uses semibold weight', () {
        expect(AppTypography.button.fontWeight, FontWeight.w600);
      });
    });
  });
}
