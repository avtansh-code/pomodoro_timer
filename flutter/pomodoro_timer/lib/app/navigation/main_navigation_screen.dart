import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/service_locator.dart';
import '../theme/pomodoro_theme_cubit.dart';
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
      extendBody: true, // Allow body to extend behind the navigation bar
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _buildModernNavigationBar(context),
    );
  }

  Widget _buildModernNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = context.watch<PomodoroThemeCubit>().state.currentTheme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        Platform.isIOS ? 24 : 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.black.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  // iOS: timer, Flutter equivalent: timer/timer_outlined
                  icon: CupertinoIcons.timer,
                  selectedIcon: CupertinoIcons.timer_fill,
                  label: 'Timer',
                  primaryColor: primaryColor,
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  // iOS: chart.line.uptrend.xyaxis, Flutter equivalent: graph_increase/trending_up
                  icon: CupertinoIcons.graph_square,
                  selectedIcon: CupertinoIcons.graph_square_fill,
                  label: 'Stats',
                  primaryColor: primaryColor,
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  // iOS: slider.horizontal.3, Flutter equivalent: slider icons
                  icon: CupertinoIcons.slider_horizontal_3,
                  selectedIcon: CupertinoIcons.slider_horizontal_3,
                  label: 'Settings',
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required Color primaryColor,
  }) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.2),
                    primaryColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected 
                    ? primaryColor 
                    : (isDark ? Colors.white70 : Colors.black54),
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? primaryColor 
                    : (isDark ? Colors.white70 : Colors.black54),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
