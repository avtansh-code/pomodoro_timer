import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/service_locator.dart';
import '../../features/settings/bloc/settings_cubit.dart';
import '../../features/statistics/bloc/statistics_cubit.dart';
import '../../features/statistics/data/statistics_repository.dart';
import '../../features/timer/view/main_timer_screen.dart';
import '../../features/settings/view/settings_screen.dart';
import '../../features/statistics/view/statistics_screen.dart';

/// Main navigation screen with bottom tab bar.
///
/// Provides a tab-based navigation structure matching iOS/Android legacy apps
/// with three main tabs: Timer, Stats, and Settings.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final StatisticsCubit _statisticsCubit;

  @override
  void initState() {
    super.initState();

    // Create StatisticsCubit
    _statisticsCubit = StatisticsCubit(getIt<StatisticsRepository>());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Refresh statistics when navigating to Stats tab
    if (index == 1) {
      _statisticsCubit.refresh();
    }
  }

  @override
  void dispose() {
    _statisticsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch settings to rebuild when they change
    context.watch<SettingsCubit>();

    // Build pages dynamically
    final pages = [
      // Timer Tab - MainTimerScreen rebuilds via BlocBuilder inside it
      const MainTimerScreen(),

      // Statistics Tab - provide the StatisticsCubit
      BlocProvider.value(
        value: _statisticsCubit,
        child: const StatisticsScreen(),
      ),

      // Settings Tab - SettingsScreen is provided by parent
      const SettingsScreen(),
    ];

    // Use platform-specific navigation
    if (Platform.isIOS) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.timer),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chart_bar),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (context, index) => pages[index],
      );
    } else {
      // Android/Web - Use Material 3 Navigation Bar with subtle styling
      return Scaffold(
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.98),
          indicatorColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.timer_outlined, size: 24),
              selectedIcon: Icon(Icons.timer, size: 24),
              label: 'Timer',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined, size: 24),
              selectedIcon: Icon(Icons.bar_chart, size: 24),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: 24),
              selectedIcon: Icon(Icons.settings, size: 24),
              label: 'Settings',
            ),
          ],
        ),
      );
    }
  }
}
