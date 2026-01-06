# Bundle ID Analysis & Recommendation

## Current Bundle IDs Across Projects

### 📱 iOS (Native)
**Location**: `iOS/PomodoroTimer/PomodoroTimer.entitlements` & Xcode project  
**Bundle ID**: `com.avtanshgupta.mr.pomodoro`  
**Status**: ✅ Production-ready (already published to App Store)

### 🤖 Android (Native)
**Location**: `android/app/build.gradle.kts`  
**Bundle ID**: `com.avtanshgupta.mr.pomodoro`  
**Status**: ✅ Production-ready (already published to Google Play)  
**Version**: 1.1.1 (versionCode: 4)

### 🎯 Flutter Project
**Location**: `flutter/pomodoro_timer/`

#### Android
- **File**: `flutter/pomodoro_timer/android/app/build.gradle.kts`
- **Bundle ID**: `com.example.pomodoro_timer` ⚠️
- **Status**: ❌ **MISMATCH** - Default example ID

#### iOS
- **File**: `flutter/pomodoro_timer/ios/Runner.xcodeproj/project.pbxproj`
- **Bundle ID**: `com.example.pomodoroTimer` ⚠️
- **Status**: ❌ **MISMATCH** - Default example ID

---

## 🚨 Critical Issue

**The Flutter app has DIFFERENT bundle IDs from your existing native apps!**

### Problem:
- **Native Apps**: `com.avtanshgupta.mr.pomodoro` (already on stores)
- **Flutter App**: `com.example.pomodoro_timer` / `com.example.pomodoroTimer`

### Impact:
If published as-is, the Flutter app would:
- ❌ Create a **NEW, SEPARATE app** on both stores
- ❌ NOT update your existing published apps
- ❌ Require users to download a different app
- ❌ Lose all existing user reviews and ratings
- ❌ Lose app store rankings and visibility

---

## ✅ Recommended Solution

**Change Flutter bundle IDs to match existing apps:**

### Target Bundle ID (Both Platforms):
```
com.avtanshgupta.mr.pomodoro
```

This will:
- ✅ Update your existing apps on both stores
- ✅ Maintain continuity for existing users
- ✅ Preserve reviews, ratings, and rankings
- ✅ Keep same app identity across platforms

---

## 📋 Required Changes

### 1. Flutter Android (`flutter/pomodoro_timer/android/app/build.gradle.kts`)

**Change FROM:**
```kotlin
namespace = "com.example.pomodoro_timer"
applicationId = "com.example.pomodoro_timer"
```

**Change TO:**
```kotlin
namespace = "com.avtanshgupta.mr.pomodoro"
applicationId = "com.avtanshgupta.mr.pomodoro"
```

### 2. Flutter iOS (`flutter/pomodoro_timer/ios/Runner.xcodeproj/project.pbxproj`)

**Change FROM:**
```
PRODUCT_BUNDLE_IDENTIFIER = com.example.pomodoroTimer;
```

**Change TO:**
```
PRODUCT_BUNDLE_IDENTIFIER = com.avtanshgupta.mr.pomodoro;
```

**Note**: This appears in multiple build configurations (Debug, Release, Profile)

### 3. iOS Test Target (`flutter/pomodoro_timer/ios/Runner.xcodeproj/project.pbxproj`)

**Change FROM:**
```
PRODUCT_BUNDLE_IDENTIFIER = com.example.pomodoroTimer.RunnerTests;
```

**Change TO:**
```
PRODUCT_BUNDLE_IDENTIFIER = com.avtanshgupta.mr.pomodoro.RunnerTests;
```

---

## 🔧 Implementation Steps

### Option 1: Manual Update (Recommended)

1. **Update Android bundle ID**:
   ```bash
   # Edit: flutter/pomodoro_timer/android/app/build.gradle.kts
   # Change both namespace and applicationId
   ```

2. **Update iOS bundle ID**:
   ```bash
   # Open Xcode
   cd flutter/pomodoro_timer
   open ios/Runner.xcworkspace
   
   # In Xcode:
   # 1. Select Runner project
   # 2. Select Runner target
   # 3. Go to "Signing & Capabilities"
   # 4. Change Bundle Identifier to: com.avtanshgupta.mr.pomodoro
   ```

3. **Verify changes**:
   ```bash
   # Check Android
   grep "applicationId" flutter/pomodoro_timer/android/app/build.gradle.kts
   
   # Check iOS
   cd flutter/pomodoro_timer
   xcodebuild -showBuildSettings -workspace ios/Runner.xcworkspace -scheme Runner | grep PRODUCT_BUNDLE_IDENTIFIER
   ```

### Option 2: Automated Update

I can update these files automatically for you.

---

## 📊 Version Coordination

### Current Versions:

**Native Android**:
- Version: 1.1.1
- Version Code: 4

**Flutter App** (should be updated to):
- Version: 1.2.0 (next version after native)
- Version Code: 5 (must be higher than current)

**Recommendation**: Update `flutter/pomodoro_timer/pubspec.yaml`:
```yaml
version: 1.2.0+5
```

---

## ⚠️ Important Notes

### App Store Submission:
1. **Must use same Team ID** (Apple Developer account)
2. **Must have proper code signing** (already configured: S6ULATL6PT)
3. **Must increment version** from current store version

### Google Play Submission:
1. **Must use same signing key** as native app
2. **Version code must be higher** than current (currently 4)
3. **Same developer account** required

### Data Migration:
- If apps have local data, consider migration strategy
- Users may lose data when switching from native to Flutter
- Consider implementing data export/import

---

## 🎯 Action Required

**DECISION NEEDED**: 

Do you want to:

**Option A**: Update Flutter app to match existing bundle IDs
- ✅ Updates existing apps
- ✅ Maintains user base
- ✅ Preserves ratings
- ⚠️ Requires proper signing keys

**Option B**: Keep separate bundle IDs
- ❌ Creates new apps
- ❌ Starts from zero users
- ❌ Loses existing presence
- ✅ Easier technically (no signing concerns)

**RECOMMENDED: Option A** - Match existing bundle IDs

---

## 📝 Summary

| Aspect | Native Apps | Flutter App | Status |
|--------|-------------|-------------|---------|
| Android Bundle | `com.avtanshgupta.mr.pomodoro` | `com.example.pomodoro_timer` | ❌ Mismatch |
| iOS Bundle | `com.avtanshgupta.mr.pomodoro` | `com.example.pomodoroTimer` | ❌ Mismatch |
| Android Version | 1.1.1 (4) | 1.0.0+1 | ⚠️ Must increment |
| iOS Version | - | 1.0.0+1 | ⚠️ Must increment |
| Recommendation | - | **Update to match** | 🎯 Action needed |

---

**Created**: January 7, 2026  
**Status**: ⚠️ **CRITICAL** - Bundle ID mismatch requires immediate attention before App Store submission
