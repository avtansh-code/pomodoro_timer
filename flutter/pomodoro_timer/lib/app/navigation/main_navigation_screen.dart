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
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
