import 'dart:io';
import 'dart:ui';
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

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  double _dragOffset = 0.0;
  bool _isDragging = false;

  late final StatisticsCubit _statisticsCubit;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Create StatisticsCubit
    _statisticsCubit = StatisticsCubit(getIt<StatisticsRepository>());

    // Animation controller for smooth transitions
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _dragOffset = 0;
    });

    // Refresh statistics when navigating to Stats tab
    if (index == 1) {
      _statisticsCubit.refresh();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
    final primaryColor = context
        .watch<PomodoroThemeCubit>()
        .state
        .currentTheme
        .primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.fromLTRB(40, 0, 40, Platform.isIOS ? 28 : 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.65)
                  : Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / 3;

                return GestureDetector(
                  onHorizontalDragStart: (details) {
                    setState(() => _isDragging = true);
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragOffset += details.delta.dx;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    // Calculate which tab to snap to
                    final totalOffset =
                        _selectedIndex * itemWidth + _dragOffset;
                    final newIndex = (totalOffset / itemWidth).round().clamp(
                      0,
                      2,
                    );

                    setState(() {
                      _isDragging = false;
                      _dragOffset = 0;
                      if (_selectedIndex != newIndex) {
                        _selectedIndex = newIndex;
                        if (newIndex == 1) {
                          _statisticsCubit.refresh();
                        }
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      // Simple sliding indicator
                      AnimatedPositioned(
                        duration: _isDragging
                            ? Duration.zero
                            : const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        left:
                            (_selectedIndex * itemWidth) +
                            _dragOffset.clamp(-itemWidth, itemWidth * 2),
                        top: 6,
                        bottom: 6,
                        width: itemWidth,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(
                              alpha: isDark ? 0.25 : 0.15,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      // Navigation items
                      Row(
                        children: [
                          _buildNavItem(
                            context,
                            index: 0,
                            icon: Icons.hourglass_empty_rounded,
                            selectedIcon: Icons.hourglass_full_rounded,
                            label: 'Timer',
                            primaryColor: primaryColor,
                            itemWidth: itemWidth,
                          ),
                          _buildNavItem(
                            context,
                            index: 1,
                            icon: Icons.bar_chart_rounded,
                            selectedIcon: Icons.bar_chart_rounded,
                            label: 'Stats',
                            primaryColor: primaryColor,
                            itemWidth: itemWidth,
                          ),
                          _buildNavItem(
                            context,
                            index: 2,
                            icon: Icons.tune_rounded,
                            selectedIcon: Icons.tune_rounded,
                            label: 'Settings',
                            primaryColor: primaryColor,
                            itemWidth: itemWidth,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
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
    required double itemWidth,
  }) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: itemWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey('$index-$isSelected'),
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white54 : Colors.black45),
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.white54 : Colors.black45),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
