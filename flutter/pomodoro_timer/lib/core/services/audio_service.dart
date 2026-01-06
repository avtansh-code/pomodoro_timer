import 'package:flutter/services.dart';

/// Service for managing audio playback.
/// 
/// Handles playing notification sounds when timer sessions complete.
/// Uses system sounds instead of custom audio files for better compatibility.
class AudioService {
  bool _isSoundEnabled = true;

  /// Sets whether sounds should be played.
  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  /// Gets the current sound enabled state.
  bool get isSoundEnabled => _isSoundEnabled;

  /// Plays a completion sound using system audio.
  /// 
  /// This uses the system's notification sound for timer completion.
  Future<void> playCompletionSound() async {
    if (!_isSoundEnabled) return;

    try {
      // Use system feedback for notifications
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      // Silently fail if sound cannot be played
    }
  }

  /// Plays a break completion sound using system audio.
  Future<void> playBreakSound() async {
    if (!_isSoundEnabled) return;

    try {
      // Use system feedback for break completion
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      // Silently fail if sound cannot be played
    }
  }

  /// Plays a subtle tick sound (optional feature for timer running).
  /// 
  /// Note: System sounds don't provide tick sounds, so this is a no-op.
  /// If needed, consider using haptic feedback instead via HapticFeedback.lightImpact().
  Future<void> playTickSound() async {
    if (!_isSoundEnabled) return;
    
    // System sounds don't provide tick sounds
    // Consider using haptic feedback instead if needed
  }

  /// Stops any currently playing audio.
  /// 
  /// Note: System sounds cannot be stopped once started.
  Future<void> stop() async {
    // System sounds cannot be stopped
  }

  /// Disposes of the audio player resources.
  /// 
  /// Note: No resources to dispose when using system sounds.
  Future<void> dispose() async {
    // No resources to dispose
  }
}
