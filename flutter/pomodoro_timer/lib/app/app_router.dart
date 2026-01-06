import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/timer/view/main_timer_screen.dart';
import '../features/settings/view/settings_screen.dart';
import '../features/statistics/view/statistics_screen.dart';
import '../features/onboarding/view/pomodoro_benefits_screen.dart';
import '../features/privacy/view/privacy_policy_screen.dart';

/// Application router configuration using go_router.
/// 
/// Defines all routes and navigation structure for the app.
class AppRouter {
  static const String home = '/';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
  static const String benefits = '/benefits';
  static const String privacy = '/privacy';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainTimerScreen(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: statistics,
        name: 'statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: benefits,
        name: 'benefits',
        builder: (context, state) => const PomodoroBenefitsScreen(),
      ),
      GoRoute(
        path: privacy,
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
