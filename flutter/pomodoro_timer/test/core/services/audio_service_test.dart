import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/services/audio_service.dart';

void main() {
  group('AudioService', () {
    late AudioService audioService;

    setUp(() {
      audioService = AudioService();
    });

    test('initial sound enabled state is true', () {
      expect(audioService.isSoundEnabled, true);
    });

    test('setSoundEnabled updates sound state', () {
      audioService.setSoundEnabled(false);
      expect(audioService.isSoundEnabled, false);

      audioService.setSoundEnabled(true);
      expect(audioService.isSoundEnabled, true);
    });

    test('playCompletionSound does not throw when sound is enabled', () {
      audioService.setSoundEnabled(true);
      expect(() => audioService.playCompletionSound(), returnsNormally);
    });

    test('playCompletionSound does not throw when sound is disabled', () {
      audioService.setSoundEnabled(false);
      expect(() => audioService.playCompletionSound(), returnsNormally);
    });

    test('playBreakSound does not throw when sound is enabled', () {
      audioService.setSoundEnabled(true);
      expect(() => audioService.playBreakSound(), returnsNormally);
    });

    test('playBreakSound does not throw when sound is disabled', () {
      audioService.setSoundEnabled(false);
      expect(() => audioService.playBreakSound(), returnsNormally);
    });

    test('playTickSound does not throw', () {
      expect(() => audioService.playTickSound(), returnsNormally);
    });

    test('stop does not throw', () {
      expect(() => audioService.stop(), returnsNormally);
    });

    test('dispose does not throw', () {
      expect(() => audioService.dispose(), returnsNormally);
    });

    test('multiple sound state changes work correctly', () {
      audioService.setSoundEnabled(false);
      expect(audioService.isSoundEnabled, false);

      audioService.setSoundEnabled(true);
      expect(audioService.isSoundEnabled, true);

      audioService.setSoundEnabled(false);
      expect(audioService.isSoundEnabled, false);
    });

    test('all sound methods can be called in sequence', () async {
      audioService.setSoundEnabled(true);
      
      await audioService.playCompletionSound();
      await audioService.playBreakSound();
      await audioService.playTickSound();
      await audioService.stop();
      await audioService.dispose();

      // Should not throw any errors
      expect(true, true);
    });
  });
}