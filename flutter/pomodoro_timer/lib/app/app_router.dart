import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'navigation/main_navigation_screen.dart';
import '../features/onboarding/view/pomodoro_benefits_screen.dart';
import '../features/privacy/view/privacy_policy_screen.dart';

/// Application router configuration using go_router.
/// 
/// Defines all routes and navigation structure for the app.
/// Uses bottom tab navigation for main screens (Timer, Stats, Settings).
class AppRouter {
  static const String home = '/';
  static const String benefits = '/benefits';
  static const String privacy = '/privacy';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainNavigationScreen(),
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
