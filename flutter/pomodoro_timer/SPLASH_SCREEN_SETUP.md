# Splash Screen Setup Guide

## Overview
The Flutter app splash screen has been configured to match the iOS LaunchScreen design for a consistent cross-platform experience.

## iOS Design Analysis

The iOS splash screen (`LaunchScreen.storyboard`) features:
- **Background**: Light gray (#F9F9F9 / RGB 249, 249, 249)
- **Logo**: Tomato icon centered, 200x200 points
- **Tagline**: "Focus with ease. Flow with purpose."
- **Accent Line**: 100pt wide, 2pt height, orange with 30% opacity
- **Version**: "v1.1.0" at bottom
- **Layout**: Centered logo, tagline 20pt below logo, accent line 15pt below tagline

## Flutter Configuration

### Current Setup (`flutter_native_splash.yaml`)

```yaml
flutter_native_splash:
  # Matches iOS light background
  color: "#F9F9F9"
  color_dark: "#1C1C1E"  # iOS dark mode
  
  # Main logo (centered)
  image: assets/splash/splash_logo.png
  image_dark: assets/splash/splash_logo_dark.png
  
  # Branding/tagline at bottom
  branding: assets/splash/branding.png
  branding_dark: assets/splash/branding_dark.png
  branding_mode: bottom
```

## Required Assets

You need to create these images in `flutter/pomodoro_timer/assets/splash/`:

### 1. Main Logo (`splash_logo.png`)
- **Size**: 512x512 px (will be scaled appropriately)
- **Content**: Tomato logo from `iOS/PomodoroTimer/Assets.xcassets/LaunchLogo.imageset/`
- **Format**: PNG with transparency
- **Background**: Transparent

### 2. Branding Image (`branding.png`)
- **Size**: 1200x300 px (wide enough for text)
- **Content**: 
  - Text: "Focus with ease. Flow with purpose."
  - Font: System, Semibold, 18pt equivalent
  - Color: Dark gray (#333333)
  - Include decorative orange line below text
- **Format**: PNG with transparency
- **Layout**: Centered text with accent line

### 3. Dark Mode Variants
- `splash_logo_dark.png` - Same logo for dark mode
- `branding_dark.png` - Light text on dark background

### 4. Android 12+ Icons
- `splash_logo_android12.png` - 512x512 px
- `splash_logo_android12_dark.png` - 512x512 px

## Creating the Assets

### Option 1: Export from iOS Assets
1. Navigate to `iOS/PomodoroTimer/Assets.xcassets/LaunchLogo.imageset/`
2. Copy the tomato icon to `flutter/pomodoro_timer/assets/splash/splash_logo.png`
3. Ensure it's 512x512 px

### Option 2: Create Branding Image

Using any image editor (Photoshop, Figma, Canva, etc.):

**Light Mode (`branding.png`):**
```
Canvas: 1200 x 300 px, transparent background

Text Layer:
- Content: "Focus with ease. Flow with purpose."
- Font: San Francisco / System, Semibold, 54px
- Color: #333333 (dark gray)
- Alignment: Center
- Position: Center vertically

Accent Line:
- Width: 300px
- Height: 6px
- Color: #FA7343 with 30% opacity
- Position: 45px below text
- Alignment: Center horizontally
```

**Dark Mode (`branding_dark.png`):**
```
Same as light but:
- Text Color: #EEEEEE (light gray)
- Accent Line: #FA7343 with 40% opacity
```

### Quick Creation with Text Editor

If you don't have image editors, you can create a simple text-based version using Flutter:

Create `lib/features/splash/splash_screen.dart`:

```dart
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF9F9F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/icon/app_icon.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            
            // Tagline
            Text(
              'Focus with ease. Flow with purpose.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFEEEEEE) : const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 15),
            
            // Accent line
            Container(
              width: 100,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFFA7343).withValues(alpha: isDark ? 0.4 : 0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            
            const SizedBox(height: 150),
            
            // Version
            Text(
              'v1.1.0',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: isDark ? const Color(0xFF999999) : const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Generating Splash Screens

After creating the assets:

```bash
cd flutter/pomodoro_timer

# Install dependencies
flutter pub get

# Generate splash screens
flutter pub run flutter_native_splash:create
```

This will:
1. Generate native splash screens for Android
2. Generate native splash screens for iOS
3. Configure both light and dark mode variants
4. Set up Android 12+ adaptive icons

## Verification

### Android
1. Run: `flutter run` on Android emulator/device
2. Close and reopen the app
3. Verify splash screen shows:
   - Light background (#F9F9F9)
   - Centered tomato logo
   - Branding at bottom

### iOS
1. Run: `flutter run` on iOS simulator/device
2. Close and reopen the app
3. Should match the existing iOS LaunchScreen

### Dark Mode
1. Enable dark mode on device
2. Relaunch app
3. Verify dark background (#1C1C1E) and light branding

## Comparison: iOS vs Flutter

| Element | iOS | Flutter (After) |
|---------|-----|-----------------|
| Background (Light) | #F9F9F9 | #F9F9F9 ✅ |
| Background (Dark) | System | #1C1C1E ✅ |
| Logo Size | 200pt | 200pt scaled ✅ |
| Logo Position | Centered, -90 from center | Centered ✅ |
| Tagline | "Focus with ease..." | "Focus with ease..." ✅ |
| Accent Line | 100x2pt, orange 30% | 100x2pt, orange 30% ✅ |
| Version Label | Bottom, v1.1.0 | Bottom, v1.1.0 ✅ |

## Troubleshooting

### Assets not found
- Ensure files are in `assets/splash/` directory
- Check `pubspec.yaml` has assets folder declared
- Run `flutter pub get` again

### Splash not updating
- Clean build: `flutter clean`
- Regenerate: `flutter pub run flutter_native_splash:create`
- Rebuild: `flutter run`

### iOS splash not showing
- Check `ios/Runner/Info.plist` is configured
- Verify `LaunchScreen.storyboard` hasn't been modified
- Clean iOS build folder in Xcode

### Android 12+ issues
- Ensure Android 12+ assets are provided
- Check `android_12` configuration in yaml
- Verify icon background colors match

## Next Steps

1. ✅ Configuration updated to match iOS design
2. ⚠️ Create splash assets (`splash_logo.png`, `branding.png`)
3. ⚠️ Run splash screen generator
4. ⚠️ Test on both platforms
5. ⚠️ Verify dark mode variants

## Resources

- iOS Launch Screen: `iOS/PomodoroTimer/LaunchScreen.storyboard`
- iOS Logo Assets: `iOS/PomodoroTimer/Assets.xcassets/LaunchLogo.imageset/`
- Flutter Config: `flutter_native_splash.yaml`
- Package Docs: https://pub.dev/packages/flutter_native_splash
