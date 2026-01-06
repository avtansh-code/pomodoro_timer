import 'package:audioplayers/audioplayers.dart';

/// Service for managing audio playback.
/// 
/// Handles playing notification sounds when timer sessions complete.
/// Uses the audioplayers package for cross-platform audio support.
class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isSoundEnabled = true;

  /// Sets whether sounds should be played.
  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
  }

  /// Gets the current sound enabled state.
  bool get isSoundEnabled => _isSoundEnabled;

  /// Plays a completion sound.
  /// 
  /// This will play a simple notification sound when a timer completes.
  /// In production, you would load actual audio files from assets.
  Future<void> playCompletionSound() async {
    if (!_isSoundEnabled) return;

    try {
      // For now, we'll use a system sound
      // In production, you would load from assets like:
      // await _audioPlayer.play(AssetSource('sounds/completion.mp3'));
      
      // Using a simple beep/notification sound
      // This is a placeholder - actual implementation would use asset files
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      // Silently fail if sound cannot be played
      // In production, log this error
    }
  }

  /// Plays a break completion sound.
  Future<void> playBreakSound() async {
    if (!_isSoundEnabled) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/break_complete.mp3'));
    } catch (e) {
      // Silently fail if sound cannot be played
    }
  }

  /// Plays a subtle tick sound (optional feature for timer running).
  Future<void> playTickSound() async {
    if (!_isSoundEnabled) return;

    try {
      await _audioPlayer.play(
        AssetSource('sounds/tick.mp3'),
        volume: 0.3, // Lower volume for tick sounds
      );
    } catch (e) {
      // Silently fail if sound cannot be played
    }
  }

  /// Stops any currently playing audio.
  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  /// Disposes of the audio player resources.
  /// 
  /// Should be called when the service is no longer needed.
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
