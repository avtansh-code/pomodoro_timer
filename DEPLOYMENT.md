# 🚀 Deployment Guide

This guide covers deploying the Mr. Pomodoro Flutter app to the Apple App Store and Google Play Store.

---

## 📋 Prerequisites

Before deploying, ensure you have:

### General Requirements
- Flutter SDK 3.8.0+ installed
- All tests passing (`flutter test`)
- App version updated in `pubspec.yaml`

### iOS Requirements
- macOS with Xcode 14.0+
- Apple Developer Account ($99/year)
- App Store Connect access
- Valid iOS Distribution Certificate
- Valid App Store Provisioning Profile

### Android Requirements
- Android Studio
- Google Play Developer Account ($25 one-time)
- Play Console access
- Keystore file for signing

---

## 🍎 iOS Deployment (App Store)

### Step 1: Configure App Settings

1. **Update version** in `flutter/pomodoro_timer/pubspec.yaml`:
   ```yaml
   version: 2.0.0+7  # version+build_number
   ```

2. **Verify iOS settings** in `flutter/pomodoro_timer/ios/Runner/Info.plist`:
   - `CFBundleDisplayName`: Mr. Pomodoro
   - `CFBundleIdentifier`: com.avtanshgupta.mr.pomodoro
   - Permissions configured (notifications, etc.)

### Step 2: Set Up Code Signing

1. Open Xcode:
   ```bash
   cd flutter/pomodoro_timer/ios
   open Runner.xcworkspace
   ```

2. Select the **Runner** project → **Signing & Capabilities**

3. Configure signing:
   - Team: Select your Apple Developer Team
   - Bundle Identifier: `com.avtanshgupta.mr.pomodoro`
   - Signing Certificate: Distribution
   - Provisioning Profile: App Store Distribution

### Step 3: Build for Release

```bash
cd flutter/pomodoro_timer

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Install iOS pods
cd ios && pod install && cd ..

# Build release IPA
flutter build ipa --release
```

The IPA file will be at:
```
build/ios/ipa/pomodoro_timer.ipa
```

### Step 4: Upload to App Store Connect

**Option A: Using Xcode**

1. Open Xcode → **Product** → **Archive**
2. Select the archive → **Distribute App**
3. Choose **App Store Connect** → **Upload**
4. Follow the wizard to upload

**Option B: Using Transporter**

1. Download [Transporter](https://apps.apple.com/app/transporter/id1450874784) from Mac App Store
2. Sign in with your Apple ID
3. Drag the `.ipa` file to Transporter
4. Click **Deliver**

**Option C: Using Command Line**

```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/pomodoro_timer.ipa \
  --username "your@email.com" \
  --password "@keychain:AC_PASSWORD"
```

### Step 5: Submit for Review

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select **Mr. Pomodoro** → **App Store** tab
3. Create a new version or update existing
4. Fill in:
   - **What's New** - Release notes
   - **Screenshots** - Use files from `screenshots/iPhone/` and `screenshots/iPad/`
   - **App Preview** (optional)
   - **Promotional Text**
   - **Keywords**
   - **Support URL** - https://pomodorotimer.in/contact.html
   - **Privacy Policy URL** - https://pomodorotimer.in/privacy.html
5. Select the uploaded build
6. Click **Submit for Review**

### iOS Review Timeline
- First submission: 24-48 hours
- Updates: Usually within 24 hours
- Rejection reasons will be communicated via App Store Connect

---

## 🤖 Android Deployment (Google Play Store)

### Step 1: Configure App Settings

1. **Update version** in `flutter/pomodoro_timer/pubspec.yaml`:
   ```yaml
   version: 2.0.0+7  # versionName+versionCode
   ```

2. **Verify Android settings** in `flutter/pomodoro_timer/android/app/build.gradle.kts`:
   ```kotlin
   android {
       namespace = "com.avtanshgupta.mr.pomodoro"
       defaultConfig {
           applicationId = "com.avtanshgupta.mr.pomodoro"
           minSdk = 33
           targetSdk = 35
           versionCode = 7
           versionName = "2.0.0"
       }
   }
   ```

### Step 2: Set Up Signing

1. **Create/Locate your keystore file**:
   ```bash
   keytool -genkey -v -keystore mr-pomodoro-release.keystore \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias mr-pomodoro
   ```

2. **Create `key.properties`** in `flutter/pomodoro_timer/android/`:
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=mr-pomodoro
   storeFile=/path/to/mr-pomodoro-release.keystore
   ```
   
   ⚠️ **Never commit this file to git!** Add it to `.gitignore`.

3. **Configure signing in `build.gradle.kts`**:
   
   The signing configuration should already be set up. Verify in `android/app/build.gradle.kts`:
   ```kotlin
   signingConfigs {
       create("release") {
           keyAlias = keystoreProperties["keyAlias"] as String
           keyPassword = keystoreProperties["keyPassword"] as String
           storeFile = file(keystoreProperties["storeFile"] as String)
           storePassword = keystoreProperties["storePassword"] as String
       }
   }
   
   buildTypes {
       release {
           signingConfig = signingConfigs.getByName("release")
           isMinifyEnabled = true
           proguardFiles(...)
       }
   }
   ```

### Step 3: Build for Release

```bash
cd flutter/pomodoro_timer

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK (for testing)
flutter build apk --release

# Build App Bundle (for Play Store - RECOMMENDED)
flutter build appbundle --release
```

Output files:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### Step 4: Upload to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select **Mr. Pomodoro** app
3. Navigate to **Production** → **Create new release**
4. Upload the `.aab` file from `build/app/outputs/bundle/release/`
5. Fill in **Release notes**
6. Click **Save** → **Review release** → **Start rollout**

### Step 5: Complete Store Listing

Ensure your store listing is complete:

1. **Main Store Listing**:
   - App name: Mr. Pomodoro
   - Short description
   - Full description
   - Screenshots (use files from `screenshots/android/`)
   - Feature graphic
   - App icon

2. **Content Rating**: Complete the questionnaire

3. **Target Audience**: Select appropriate age group

4. **Privacy Policy**: https://pomodorotimer.in/privacy.html

5. **App Access**: Full access (no special access needed)

6. **Ads Declaration**: No ads

7. **Data Safety**: Complete the data safety form
   - No data collected
   - No data shared with third parties

### Android Review Timeline
- First submission: Usually a few hours to 1-2 days
- Updates: Usually within a few hours
- If issues arise, check the Play Console dashboard

---

## 📊 Version Management

### Semantic Versioning

Use semantic versioning: `MAJOR.MINOR.PATCH+BUILD`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes
- **BUILD**: Increment for each store submission

Example: `2.0.0+7`
- Version displayed to users: 2.0.0
- iOS CFBundleVersion / Android versionCode: 7

### Updating Version

1. Update `pubspec.yaml`:
   ```yaml
   version: 2.1.0+8
   ```

2. The Flutter build system automatically updates:
   - iOS: `Info.plist` (CFBundleShortVersionString, CFBundleVersion)
   - Android: `build.gradle.kts` (versionName, versionCode)

---

## 🔄 Continuous Deployment (Optional)

Consider setting up CI/CD for automated deployments:

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Stores

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
      - run: flutter build appbundle --release
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_SERVICE_ACCOUNT }}
          packageName: com.avtanshgupta.mr.pomodoro
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production

  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
      - run: flutter build ipa --release
      - uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/ipa/pomodoro_timer.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_PRIVATE_KEY }}
```

---

## 🐛 Troubleshooting

### iOS Issues

**Problem**: Archive fails with signing error
- **Solution**: Verify certificates in Keychain Access and provisioning profiles in Xcode

**Problem**: App rejected for missing permissions description
- **Solution**: Add required `NS*UsageDescription` keys in `Info.plist`

**Problem**: Binary rejected for using private APIs
- **Solution**: Review third-party packages for private API usage

### Android Issues

**Problem**: AAB rejected for version code conflict
- **Solution**: Increment `versionCode` in `build.gradle.kts`

**Problem**: App rejected for policy violation
- **Solution**: Review Play Console messages and update app accordingly

**Problem**: Signing error during build
- **Solution**: Verify `key.properties` path and credentials

---

## 📝 Checklist Before Submission

### Both Platforms
- [ ] All tests passing
- [ ] Version number incremented
- [ ] Release notes prepared
- [ ] Screenshots up to date
- [ ] Privacy policy URL working
- [ ] Support URL working

### iOS Specific
- [ ] App Store Connect listing complete
- [ ] Required device capabilities set
- [ ] App uses required reason APIs declared (if any)
- [ ] Export compliance answered

### Android Specific
- [ ] Play Console listing complete
- [ ] Content rating questionnaire completed
- [ ] Data safety form completed
- [ ] Target API level meets Google's requirements

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in
- **Website**: [pomodorotimer.in](https://pomodorotimer.in)