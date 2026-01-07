import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/core/services/notification_service.dart';

void main() {
  group('NotificationService', () {
    late NotificationService notificationService;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      notificationService = NotificationService();
    });

    test('creates instance successfully', () {
      expect(notificationService, isNotNull);
    });

    test('showWorkSessionComplete does not throw before initialization', () async {
      // Should not throw even when not initialized (gracefully handles)
      await expectLater(
        notificationService.showWorkSessionComplete(),
        completes,
      );
    });

    test('showShortBreakComplete does not throw before initialization', () async {
      // Should not throw even when not initialized (gracefully handles)
      await expectLater(
        notificationService.showShortBreakComplete(),
        completes,
      );
    });

    test('showLongBreakComplete does not throw before initialization', () async {
      // Should not throw even when not initialized (gracefully handles)
      await expectLater(
        notificationService.showLongBreakComplete(),
        completes,
      );
    });

    // Note: cancelAll requires platform initialization which cannot be done in unit tests.
    // These methods are tested through integration tests or manual testing.
  });
}