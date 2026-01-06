import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service for managing local notifications.
///
/// Handles the initialization and display of notifications when
/// timer sessions complete. Uses flutter_local_notifications for
/// cross-platform notification support.
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initializes the notification service.
  ///
  /// Must be called before any notifications can be shown.
  /// Sets up platform-specific notification settings.
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final result = await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = result ?? false;
  }

  /// Callback when a notification is tapped.
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to specific screen
    // This will be implemented when navigation is set up
  }

  /// Shows a notification for work session completion.
  Future<void> showWorkSessionComplete() async {
    if (!_isInitialized) return;

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_timer',
      'Pomodoro Timer',
      channelDescription: 'Notifications for Pomodoro timer completion',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Work Session Complete! 🎉',
      'Time for a well-deserved break.',
      details,
    );
  }

  /// Shows a notification for short break completion.
  Future<void> showShortBreakComplete() async {
    if (!_isInitialized) return;

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_timer',
      'Pomodoro Timer',
      channelDescription: 'Notifications for Pomodoro timer completion',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Break Over! 💪',
      'Ready to focus again?',
      details,
    );
  }

  /// Shows a notification for long break completion.
  Future<void> showLongBreakComplete() async {
    if (!_isInitialized) return;

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_timer',
      'Pomodoro Timer',
      channelDescription: 'Notifications for Pomodoro timer completion',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Long Break Complete! 🌟',
      'Time to get back to work!',
      details,
    );
  }

  /// Cancels all active notifications.
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
