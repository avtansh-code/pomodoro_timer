# Audio Assets for Pomodoro Timer

This directory contains audio files for timer completion notifications.

## Required Sound Files

The following sound files should be placed in this directory:

### 1. notification.mp3
**Purpose:** Played when a work session completes  
**Duration:** 1-3 seconds  
**Description:** A pleasant, attention-getting sound to indicate it's time for a break

### 2. break_complete.mp3
**Purpose:** Played when a break (short or long) completes  
**Duration:** 1-3 seconds  
**Description:** A gentle, encouraging sound to indicate it's time to get back to work

### 3. tick.mp3 (Optional)
**Purpose:** Can be played every second while timer is running  
**Duration:** < 0.5 seconds  
**Description:** A subtle tick sound for users who want audible feedback during countdown

## Audio Format Specifications

- **Format:** MP3 or OGG
- **Sample Rate:** 44.1kHz recommended
- **Bit Rate:** 128kbps or higher
- **Channels:** Mono or Stereo

## Sources for Sound Files

You can obtain royalty-free sound files from:
- [Freesound.org](https://freesound.org)
- [Zapsplat](https://www.zapsplat.com)
- [Mixkit](https://mixkit.co/free-sound-effects/)
- [BBC Sound Effects](https://sound-effects.bbcrewind.co.uk/)

## Current Status

⚠️ **Placeholder sounds needed** - The AudioService is implemented but will fail gracefully if these files are missing. Add the sound files before production release.

## Implementation Note

The AudioService (`lib/core/services/audio_service.dart`) uses these files via:
```dart
await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
await _audioPlayer.play(AssetSource('sounds/break_complete.mp3'));
await _audioPlayer.play(AssetSource('sounds/tick.mp3'));
```

If sound files are missing, the app will continue to function but without audio feedback.
