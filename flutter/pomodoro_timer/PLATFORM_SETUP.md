# Platform Configuration Guide

This document outlines the platform-specific configurations for the Flutter Pomodoro Timer application.

## Android Configuration

### Permissions (AndroidManifest.xml)

The following permissions have been configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

**Permission Details:**
- **VIBRATE**: Enables haptic feedback for button interactions
- **RECEIVE_BOOT_COMPLETED**: Allows scheduled notifications to persist after device reboot
- **POST_NOTIFICATIONS**: Required for Android 13+ to show notifications
- **SCHEDULE_EXACT_ALARM**: Allows precise timer notifications
- **USE_EXACT_ALARM**: Additional permission for exact alarms on newer Android versions

### Notification Receivers

Configured receivers for flutter_local_notifications:
- `ScheduledNotificationReceiver`: Handles scheduled notification delivery
- `ScheduledNotificationBootReceiver`: Reschedules notifications after device reboot

### App Name

**Display Name**: "Pomodoro Timer"  
**Package Name**: `com.example.pomodoro_timer` (update in `build.gradle`)

### Minimum SDK Requirements

- **minSdkVersion**: 21 (Android 5.0 Lollipop)
- **targetSdkVersion**: 34 (Android 14)
- **compileSdkVersion**: 34

## iOS Configuration

### Permissions (Info.plist)

The following permissions have been configured in `ios/Runner/Info.plist`:

```xml
<key>NSUserNotificationsUsageDescription</key>
<string>This app needs notification permission to alert you when timer sessions complete.</string>
```

### Background Modes

Enabled background modes for notifications and audio:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>fetch</string>
    <string>processing</string>
</array>
```

### App Display Settings

- **App Name**: "Pomodoro Timer"
- **Bundle Name**: "Pomodoro Timer"
- **UI Style**: Automatic (supports light and dark mode)

### Minimum iOS Requirements

- **iOS Deployment Target**: 12.0+
- **Swift Version**: 5.0+

## Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build for specific architecture
flutter build apk --release --target-platform android-arm64
```

**Note**: Update the following before release:
1. Package name in `android/app/build.gradle`
2. App signing configuration
3. ProGuard rules if needed

### iOS

```bash
# Build for iOS
flutter build ios --release

# Create IPA for App Store
flutter build ipa --release
```

**Note**: Configure the following before release:
1. Bundle Identifier in Xcode
2. Code signing certificates
3. Provisioning profiles
4. App capabilities in Xcode

## App Icons

### Android

Place app icons in the following directories:
```
android/app/src/main/res/
  ├── mipmap-hdpi/ic_launcher.png (72x72)
  ├── mipmap-mdpi/ic_launcher.png (48x48)
  ├── mipmap-xhdpi/ic_launcher.png (96x96)
  ├── mipmap-xxhdpi/ic_launcher.png (144x144)
  └── mipmap-xxxhdpi/ic_launcher.png (192x192)
```

**Recommended Tool**: Use [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) package for automatic icon generation.

### iOS

Configure app icons in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner → Assets.xcassets → AppIcon
3. Add icon images for all required sizes

**Required Sizes**:
- 20x20 (2x, 3x)
- 29x29 (2x, 3x)
- 40x40 (2x, 3x)
- 60x60 (2x, 3x)
- 76x76 (1x, 2x)
- 83.5x83.5 (2x) for iPad Pro
- 1024x1024 (1x) for App Store

## Testing on Devices

### Android

```bash
# List connected devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release
```

### iOS

```bash
# Run on iOS Simulator
flutter run -d "iPhone 14"

# Run on physical device
flutter run -d <device-id>

# Open in Xcode
open ios/Runner.xcworkspace
```

## Platform-Specific Features

### Android

✅ Material 3 design with dynamic colors  
✅ Adaptive icons  
✅ Edge-to-edge display  
✅ Notification channels  
✅ Exact alarm permissions  

### iOS

✅ Cupertino widgets where appropriate  
✅ Native notifications  
✅ Dark mode support  
✅ Safe area handling  
✅ Haptic feedback patterns  

## Troubleshooting

### Android Issues

**Problem**: Notifications not showing  
**Solution**: Request POST_NOTIFICATIONS permission at runtime for Android 13+

**Problem**: Vibration not working  
**Solution**: Ensure VIBRATE permission is in manifest

**Problem**: Timer not accurate  
**Solution**: Use SCHEDULE_EXACT_ALARM permission

### iOS Issues

**Problem**: Notifications not appearing  
**Solution**: Check notification permissions in device Settings

**Problem**: App crashes on launch  
**Solution**: Verify Info.plist is valid XML

**Problem**: Dark mode not working  
**Solution**: Ensure UIUserInterfaceStyle is set to "Automatic"

## Runtime Permission Requests

The app automatically requests the following permissions at runtime:

**Android 13+**:
- Notification permission (POST_NOTIFICATIONS)
- Exact alarm permission (if required)

**iOS**:
- Notification permission (first time app needs to send notification)

Users can manage permissions in:
- **Android**: Settings → Apps → Pomodoro Timer → Permissions
- **iOS**: Settings → Pomodoro Timer → Notifications

## Store Submission Checklist

### Android (Google Play)

- [ ] Update package name
- [ ] Configure app signing
- [ ] Add app icons (all densities)
- [ ] Create feature graphic (1024x500)
- [ ] Add screenshots (phone + tablet)
- [ ] Write store listing
- [ ] Set age rating
- [ ] Review permissions

### iOS (App Store)

- [ ] Update bundle identifier
- [ ] Configure code signing
- [ ] Add app icons (all sizes)
- [ ] Create screenshots (all device sizes)
- [ ] Add App Store description
- [ ] Set age rating
- [ ] Complete App Privacy details

## Additional Resources

- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Flutter Android Deployment](https://docs.flutter.dev/deployment/android)
- [flutter_local_notifications Setup](https://pub.dev/packages/flutter_local_notifications)
- [Android Notification Best Practices](https://developer.android.com/develop/ui/views/notifications)
- [iOS Notification Best Practices](https://developer.apple.com/design/human-interface-guidelines/notifications)

---

**Last Updated**: January 7, 2026  
**Status**: Production Ready ✅
