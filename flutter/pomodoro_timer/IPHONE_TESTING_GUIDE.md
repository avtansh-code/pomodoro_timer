# iPhone Physical Device Testing Guide

This guide will help you test the Pomodoro Timer app on your physical iPhone.

## Current Status

**Device Detected**: ✅ Avtansh's iPhone  
**Status**: ⚠️ Unpaired - Needs Xcode pairing  
**Action Required**: Pair device in Xcode Devices Window

---

## Step-by-Step Setup

### Step 1: Enable Developer Mode on iPhone

1. **On your iPhone**, go to:
   - Settings → Privacy & Security → Developer Mode
   - Toggle **Developer Mode** ON
   - Restart your iPhone when prompted
   - After restart, confirm enabling Developer Mode

### Step 2: Connect iPhone to Mac

1. Connect your iPhone to your Mac using a USB cable
2. **Unlock your iPhone**
3. If prompted, tap **Trust This Computer** on your iPhone
4. Enter your iPhone passcode

### Step 3: Pair Device in Xcode

**Option A: Using Xcode Devices Window**
1. Open Xcode (Applications → Xcode)
2. Go to **Window → Devices and Simulators** (or press `Cmd+Shift+2`)
3. Select your iPhone from the list on the left
4. If it says "Unpaired", click **Pair** button
5. Respond to any pairing prompts on your iPhone
6. Wait for "Ready to use" status

**Option B: Open Project in Xcode**
1. Navigate to:
   ```bash
   cd flutter/pomodoro_timer
   open ios/Runner.xcworkspace
   ```
2. Xcode will automatically detect and pair your device
3. Respond to trust prompts on your iPhone

### Step 4: Configure Code Signing in Xcode

1. In Xcode, select **Runner** in the project navigator
2. Select **Runner** under TARGETS
3. Go to **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. Select your **Team** (your Apple ID)
   - If you don't have a team, click "Add Account" and sign in with your Apple ID
6. Xcode will automatically provision the app

**Bundle Identifier**: Update if needed (e.g., com.yourname.pomodorotimer)

### Step 5: Trust Developer Certificate on iPhone

After first installation:
1. On your iPhone, go to: Settings → General → VPN & Device Management
2. Find your Apple ID/Developer profile
3. Tap **Trust "[Your Name]"**
4. Tap **Trust** in the confirmation dialog

---

## Running the App

### Method 1: Using Flutter CLI (Recommended)

1. **Check devices again**:
   ```bash
   cd flutter/pomodoro_timer
   flutter devices
   ```
   You should see: `Avtansh's iPhone` with "Ready to use" status

2. **Run the app**:
   ```bash
   flutter run
   ```
   
3. **Or specify device explicitly**:
   ```bash
   flutter run -d <device-id>
   ```
   Replace `<device-id>` with your iPhone's ID from `flutter devices`

### Method 2: Using Xcode

1. Open the project:
   ```bash
   cd flutter/pomodoro_timer
   open ios/Runner.xcworkspace
   ```

2. Select your iPhone from the device dropdown (top toolbar)

3. Click the **Play** button (▶️) or press `Cmd+R`

4. Xcode will build and install the app on your iPhone

---

## Troubleshooting

### Issue 1: "No Provisioning Profile"
**Solution**:
- Xcode → Preferences → Accounts
- Add your Apple ID
- Download manual profiles if needed
- Enable "Automatically manage signing"

### Issue 2: "Developer Mode Required"
**Solution**:
- Settings → Privacy & Security → Developer Mode
- Enable and restart iPhone
- Confirm after restart

### Issue 3: "Untrusted Developer"
**Solution**:
- Settings → General → VPN & Device Management
- Trust your developer profile

### Issue 4: "Device Busy" or "Locked"
**Solution**:
- Unlock your iPhone
- Keep it unlocked during installation
- Try disconnecting and reconnecting USB cable

### Issue 5: Build Fails with Signing Error
**Solution**:
- Open ios/Runner.xcworkspace in Xcode
- Update Bundle Identifier to be unique
- Select your Team in Signing & Capabilities
- Clean build folder: `flutter clean && flutter pub get`

### Issue 6: "The device is not paired"
**Solution**:
```bash
# Try this command to reset pairing
idevicepair unpair
idevicepair pair

# Then try flutter devices again
flutter devices
```

---

## Testing Checklist

Once the app is running on your iPhone:

### Core Features
- [ ] App launches successfully
- [ ] Splash screen appears
- [ ] App icon shows on home screen
- [ ] Main timer displays correctly
- [ ] Timer starts when tapped
- [ ] Timer pauses/resumes correctly
- [ ] Timer resets properly
- [ ] Session transitions work (work → break)

### Settings
- [ ] Open settings screen
- [ ] Adjust work duration (test with 1-2 min for quick testing)
- [ ] Adjust break durations
- [ ] Change sessions before long break
- [ ] Reset to defaults works
- [ ] Settings persist after app restart

### Statistics
- [ ] Complete a full session
- [ ] Check statistics screen
- [ ] Verify session appears in history
- [ ] Test date filtering (Today/Week/Month/All)
- [ ] Pull to refresh works
- [ ] Clear all data works

### Notifications
- [ ] Complete a work session
- [ ] Notification appears
- [ ] Notification sound plays (if enabled)
- [ ] Tap notification opens app

### Haptics
- [ ] Feel vibration on button taps
- [ ] Haptic feedback on timer actions

### Themes
- [ ] Switch between light/dark themes
- [ ] Theme persists after restart
- [ ] UI adapts correctly to theme

### Navigation
- [ ] Navigate between all screens
- [ ] Back navigation works
- [ ] Deep linking (if implemented)

### Performance
- [ ] App is responsive
- [ ] No lag or stuttering
- [ ] Timer accuracy (use stopwatch to verify)
- [ ] Battery usage reasonable
- [ ] Memory usage normal

### Edge Cases
- [ ] Test with phone locked (timer continues)
- [ ] Test with app backgrounded
- [ ] Test with multiple apps running
- [ ] Test after force quit and relaunch
- [ ] Test with low battery mode

---

## Quick Testing Commands

```bash
# Check if device is connected and ready
flutter devices

# Run app on iPhone
flutter run

# Run in release mode (faster, optimized)
flutter run --release

# Hot reload during development
# (Press 'r' in terminal after making code changes)

# Hot restart
# (Press 'R' in terminal)

# View logs
flutter logs

# Build iOS app (creates .app bundle)
flutter build ios

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## Wireless Debugging (Optional)

Once paired, you can enable wireless debugging:

1. **In Xcode Devices Window**:
   - Right-click your iPhone
   - Select "Connect via Network"
   - iPhone icon will show a network symbol when ready

2. **Disconnect USB** (after wireless connection established)

3. **Run normally**:
   ```bash
   flutter run
   ```

---

## Development Tips

### Fast Testing
For quick testing, temporarily reduce timer durations:
- Work: 1 minute (instead of 25)
- Short break: 15 seconds
- Long break: 30 seconds

This allows you to test full cycles quickly!

### Live Debugging
Use Flutter DevTools for debugging:
```bash
flutter run
# Then open the DevTools URL shown in terminal
```

### Performance Profiling
```bash
flutter run --profile
# Use DevTools to analyze performance
```

---

## Common iPhone-Specific Issues

### Issue: Icons Not Showing
- Clean project: `flutter clean`
- Regenerate icons: `dart run flutter_launcher_icons`
- Rebuild: `flutter run`

### Issue: Splash Screen Not Appearing
- Regenerate: `dart run flutter_native_splash:create`
- Clean and rebuild

### Issue: Notifications Not Working
- Check Settings → Notifications → Pomodoro Timer
- Ensure notifications are enabled
- Grant permissions when prompted

### Issue: Haptics Not Working
- Check Settings → Sounds & Haptics
- Ensure System Haptics is enabled
- Test on different actions

---

## Next Steps After Testing

1. **Note any bugs** encountered during testing
2. **Test on different iOS versions** if possible
3. **Capture screenshots** for App Store
4. **Record video** of app usage
5. **Prepare TestFlight** build for beta testing

---

## Ready for App Store

Once testing is complete:
1. ✅ Update version number in pubspec.yaml
2. ✅ Create App Store screenshots
3. ✅ Prepare App Store listing (copy provided in APP_STORE_ASSETS.md)
4. ✅ Build release: `flutter build ipa`
5. ✅ Upload to App Store Connect
6. ✅ Submit for review

---

**Need Help?**
- Check Flutter docs: https://flutter.dev/docs/deployment/ios
- Xcode help: https://developer.apple.com/documentation/xcode
- Flutter iOS setup: https://flutter.dev/docs/get-started/install/macos#ios-setup

**Last Updated**: January 7, 2026  
**Status**: Ready for iPhone Testing 📱
