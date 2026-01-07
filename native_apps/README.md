# Native Apps (Legacy/Retired)

> ⚠️ **These native implementations have been retired.** Please use the [Flutter app](../flutter/pomodoro_timer/README.md) instead.

---

## Overview

This folder contains the original native iOS and Android implementations of Mr. Pomodoro that have been retired in favor of the cross-platform Flutter implementation.

**These apps are preserved for historical reference only and are no longer actively maintained.**

---

## Contents

### iOS (SwiftUI)
- **Location:** `iOS/`
- **Built with:** Swift 5.0+, SwiftUI
- **Min iOS:** 17.0
- **Status:** Retired

### Android (Jetpack Compose)
- **Location:** `android/`
- **Built with:** Kotlin 2.0+, Jetpack Compose
- **Min Android:** 13.0 (API 33)
- **Status:** Retired

---

## Why Retired?

The native apps have been retired in favor of the Flutter implementation because:

1. **Single Codebase** - One codebase for both iOS and Android
2. **Consistent UX** - Identical user experience across platforms
3. **Faster Development** - New features ship to both platforms simultaneously
4. **Easier Maintenance** - Bug fixes apply to both platforms at once
5. **Comprehensive Testing** - 200+ tests covering all features

---

## Active Development

All active development happens in the Flutter app:

📖 **[Flutter App README](../flutter/pomodoro_timer/README.md)**

```bash
cd ../flutter/pomodoro_timer
flutter pub get
flutter run
```

---

## Support

For the actively maintained Flutter version:
- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in