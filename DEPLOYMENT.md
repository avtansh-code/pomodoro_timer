# 🚀 Deployment Guide

This comprehensive guide covers deploying the Mr. Pomodoro Flutter app to all supported platforms: Apple App Store, Google Play Store, macOS, Windows, and the marketing website.

---

## 📋 Table of Contents

- [Prerequisites](#-prerequisites)
- [Quick Start with Build Script](#-quick-start-with-build-script)
- [iOS Deployment (App Store)](#-ios-deployment-app-store)
- [Android Deployment (Google Play Store)](#-android-deployment-google-play-store)
- [macOS Deployment](#-macos-deployment)
- [Windows Deployment](#-windows-deployment)
- [Website Deployment](#-website-deployment)
- [Version Management](#-version-management)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Troubleshooting](#-troubleshooting)
- [Checklist Before Submission](#-checklist-before-submission)

---

## 📋 Prerequisites

Before deploying, ensure you have:

### General Requirements
- Flutter SDK 3.8.0+ installed (CI uses Flutter 3.32.0)
- Dart SDK 3.8.0+
- All tests passing (`flutter test`)
- App version updated in `pubspec.yaml`

### iOS/iPadOS/macOS Requirements
- macOS with Xcode 14.0+
- Apple Developer Account ($99/year)
- App Store Connect access
- Valid iOS Distribution Certificate
- Valid App Store Provisioning Profile
- CocoaPods installed (`gem install cocoapods`)

### Android Requirements
- Android Studio
- Google Play Developer Account ($25 one-time)
- Play Console access
- Keystore file for signing
- Android SDK 33+

### Windows Requirements
- Windows 10/11
- Visual Studio 2022 with "Desktop development with C++" workload
- Flutter Windows support enabled

---

## 🛠️ Quick Start with Build Script

The project includes a comprehensive build script (`build.sh`) that automates the entire build process for all platforms.

### Interactive Mode

```bash
# Run the build script
./build.sh

# Follow the interactive prompts to select:
# 1. Build mode (Debug/Release)
# 2. Platform (Android/iOS/iPadOS/macOS/Windows)
# 3. Install on device (optional)
```

### Command Line Mode

```bash
# Android release build
./build.sh -m release -p android

# iOS release build
./build.sh -m release -p ios

# macOS release build
./build.sh -m release -p macos

# Windows release build
./build.sh -m release -p windows

# Debug build with device install
./build.sh -m debug -p android -i

# Skip formatting and analysis
./build.sh -m release -p ios --skip-format --skip-analyze

# Non-interactive mode (CI/CD)
./build.sh -m release -p android --non-interactive
```

### Build Script Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-m, --mode` | Build mode: `debug` or `release` |
| `-p, --platform` | Platform: `android`, `ios`, `ipados`, `macos`, `windows` |
| `-i, --install` | Install on connected device |
| `--skip-format` | Skip code formatting |
| `--skip-analyze` | Skip code analysis |
| `--non-interactive` | Run without prompts |

### What the Build Script Does

1. **Checks Prerequisites** - Verifies Flutter, Dart, and platform-specific tools
2. **Gets Dependencies** - Runs `flutter pub get`
3. **Formats Code** - Runs `dart format` and verifies formatting
4. **Analyzes Code** - Runs `flutter analyze`
5. **Builds for Platform** - Executes platform-specific build commands
6. **Installs (Optional)** - Installs on connected device

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

**Using Build Script (Recommended):**
```bash
./build.sh -m release -p ios
```

**Manual Build:**
```bash
cd flutter/pomodoro_timer

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Install iOS pods
cd ios && pod install --repo-update && cd ..

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
           targetSdk = flutter.targetSdkVersion
           versionCode = flutter.versionCode
           versionName = flutter.versionName
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
   
   ⚠️ **Never commit this file to git!** It's already in `.gitignore`.

3. **Configure signing in `build.gradle.kts`**:
   
   Add the following signing configuration:
   ```kotlin
   val keystorePropertiesFile = rootProject.file("key.properties")
   val keystoreProperties = Properties()
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(FileInputStream(keystorePropertiesFile))
   }

   android {
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
   }
   ```

### Step 3: Build for Release

**Using Build Script (Recommended):**
```bash
./build.sh -m release -p android
```

**Manual Build:**
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

## 🖥️ macOS Deployment

### Building for macOS

**Using Build Script (Recommended):**
```bash
./build.sh -m release -p macos
```

**Manual Build:**
```bash
cd flutter/pomodoro_timer

# Install CocoaPods dependencies
cd macos && pod install --repo-update && cd ..

# Build release
flutter build macos --release
```

Output location:
- Release: `build/macos/Build/Products/Release/`
- Debug: `build/macos/Build/Products/Debug/`

### macOS App Store Distribution

1. Open `macos/Runner.xcworkspace` in Xcode
2. Configure signing with your Apple Developer account
3. Archive and distribute through App Store Connect

### Direct Distribution

For distributing outside the App Store:
1. Build the release version
2. Sign with Developer ID certificate
3. Notarize with Apple
4. Create DMG installer

---

## 🪟 Windows Deployment

### Prerequisites

- Windows 10/11
- Visual Studio 2022 with "Desktop development with C++" workload
- Flutter Windows support: `flutter config --enable-windows-desktop`

### Building for Windows

**Using Build Script (Recommended):**
```bash
./build.sh -m release -p windows
```

**Manual Build:**
```bash
cd flutter/pomodoro_timer

# Build release
flutter build windows --release
```

Output location:
- Release: `build/windows/x64/runner/Release/`
- Debug: `build/windows/x64/runner/Debug/`

### Creating Windows Installer

Use tools like:
- **MSIX Packaging Tool** - For Microsoft Store
- **Inno Setup** - For traditional installers
- **NSIS** - For custom installers

---

## 🌐 Website Deployment

The marketing website is located in the `website/` directory.

### Structure
```
website/
├── www/                    # Static files
│   ├── index.html          # Landing page
│   ├── contact.html        # Contact/support page
│   ├── privacy.html        # Privacy policy
│   └── css/styles.css      # Stylesheet
├── app.yaml                # Google Cloud config
└── README.md
```

### Deployment Options

#### Option 1: GitHub Pages (Free)
```bash
# Enable GitHub Pages in repository settings
# Select source: main branch, /website/www folder
```
Site URL: `https://yourusername.github.io/repository-name`

#### Option 2: Netlify (Free)
1. Connect GitHub repository at [netlify.com](https://netlify.com)
2. Set build directory to `website/www`
3. Deploy automatically on push

#### Option 3: Vercel (Free)
```bash
npm install -g vercel
cd website/www
vercel
```

#### Option 4: Google Cloud Platform
```bash
cd website
gcloud app deploy
gcloud app browse
```

### Live Site
- **URL**: [pomodorotimer.in](https://pomodorotimer.in)

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

## 🔄 CI/CD Pipeline

### GitHub Actions - Automated Testing

The project includes automated testing via GitHub Actions (`.github/workflows/flutter-tests.yml`):

```yaml
name: Flutter Tests

on:
  pull_request:
    branches: [main, master]
    paths: ['flutter/**', '.github/workflows/flutter-tests.yml']
  push:
    branches: [main, master]
    paths: ['flutter/**', '.github/workflows/flutter-tests.yml']

jobs:
  test:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: flutter/pomodoro_timer
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
          channel: 'stable'
          cache: true
      - run: flutter pub get
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter analyze --no-fatal-infos
      - run: flutter test --coverage
```

### Test Coverage

The project has **200+ comprehensive tests**:
- Core Models: 21+ tests
- Core Services: 21+ tests
- Data Layer: 17+ tests
- BLoC/Cubit: 57+ tests
- Widget Tests: 13+ tests

### Optional: Automated Deployment

Create `.github/workflows/deploy.yml` for automated store deployment:

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
        working-directory: flutter/pomodoro_timer
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_SERVICE_ACCOUNT }}
          packageName: com.avtanshgupta.mr.pomodoro
          releaseFiles: flutter/pomodoro_timer/build/app/outputs/bundle/release/app-release.aab
          track: production

  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
      - run: flutter build ipa --release
        working-directory: flutter/pomodoro_timer
      - uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: flutter/pomodoro_timer/build/ios/ipa/pomodoro_timer.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_PRIVATE_KEY }}
```

---

## 🐛 Troubleshooting

### General Issues

**Problem**: Build fails with dependency errors
- **Solution**: Run `flutter clean && flutter pub get`

**Problem**: Code formatting check fails in CI
- **Solution**: Run `dart format .` before committing

**Problem**: Tests fail in CI but pass locally
- **Solution**: Ensure you're using Flutter 3.32.0 (same as CI)

### iOS Issues

**Problem**: Archive fails with signing error
- **Solution**: Verify certificates in Keychain Access and provisioning profiles in Xcode

**Problem**: App rejected for missing permissions description
- **Solution**: Add required `NS*UsageDescription` keys in `Info.plist`

**Problem**: Binary rejected for using private APIs
- **Solution**: Review third-party packages for private API usage

**Problem**: CocoaPods errors
- **Solution**: Run `cd ios && pod install --repo-update && cd ..`

### Android Issues

**Problem**: AAB rejected for version code conflict
- **Solution**: Increment `versionCode` in `build.gradle.kts`

**Problem**: App rejected for policy violation
- **Solution**: Review Play Console messages and update app accordingly

**Problem**: Signing error during build
- **Solution**: Verify `key.properties` path and credentials

### macOS Issues

**Problem**: Build fails with sandbox errors
- **Solution**: Check entitlements in `macos/Runner/*.entitlements`

**Problem**: CocoaPods errors
- **Solution**: Run `cd macos && pod install --repo-update && cd ..`

### Windows Issues

**Problem**: Build fails with Visual Studio errors
- **Solution**: Ensure Visual Studio 2022 with C++ workload is installed

**Problem**: Missing DLLs when running
- **Solution**: Build in Release mode or include required Visual C++ redistributables

---

## 📝 Checklist Before Submission

### Both Platforms
- [ ] All tests passing (`flutter test`)
- [ ] Code formatted (`dart format .`)
- [ ] Code analyzed (`flutter analyze`)
- [ ] Version number incremented in `pubspec.yaml`
- [ ] Release notes prepared
- [ ] Screenshots up to date (in `screenshots/` folder)
- [ ] Privacy policy URL working (https://pomodorotimer.in/privacy.html)
- [ ] Support URL working (https://pomodorotimer.in/contact.html)

### iOS Specific
- [ ] App Store Connect listing complete
- [ ] Required device capabilities set
- [ ] App uses required reason APIs declared (if any)
- [ ] Export compliance answered
- [ ] CocoaPods updated (`pod install --repo-update`)

### Android Specific
- [ ] Play Console listing complete
- [ ] Content rating questionnaire completed
- [ ] Data safety form completed
- [ ] Target API level meets Google's requirements (currently API 33+)
- [ ] Keystore and signing properly configured

### macOS Specific
- [ ] Entitlements configured correctly
- [ ] Sandbox settings appropriate
- [ ] CocoaPods updated

### Windows Specific
- [ ] Visual C++ redistributables considered
- [ ] 64-bit build verified

### Website
- [ ] All pages render correctly
- [ ] Store links are correct and working
- [ ] Privacy policy is up to date
- [ ] Contact information is accurate

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in
- **Website**: [pomodorotimer.in](https://pomodorotimer.in)

---

## 📁 Project Structure Reference

```
Mr. Pomodoro/
├── flutter/pomodoro_timer/     # Flutter App (Primary)
│   ├── lib/                    # Source code
│   ├── test/                   # Tests (200+)
│   ├── ios/                    # iOS configuration
│   ├── android/                # Android configuration
│   ├── macos/                  # macOS configuration
│   └── windows/                # Windows configuration
├── website/                    # Marketing website
├── screenshots/                # App screenshots
├── native_apps/                # Legacy apps (Retired)
├── build.sh                    # Build automation script
├── .github/workflows/          # CI/CD pipelines
└── DEPLOYMENT.md               # This guide
```

> **Note**: The native iOS (SwiftUI) and Android (Jetpack Compose) apps in `native_apps/` have been retired in favor of the cross-platform Flutter implementation. See [native_apps/README.md](native_apps/README.md) for details.