import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme/pomodoro_theme_cubit.dart';
import '../../../core/models/timer_session.dart';
import '../bloc/statistics_cubit.dart';
import '../bloc/statistics_state.dart';
import 'dart:math' as math;

/// Statistics screen matching iOS design with charts and analytics.
///
/// Displays comprehensive session statistics including:
/// - Current streak
/// - Bar chart for sessions per day
/// - Line chart for focus time trend
/// - Pie chart for session distribution
/// - Detailed statistics sections
///
/// NOTE: This screen expects a StatisticsCubit to be provided by an ancestor.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatisticsView();
  }
}

class _StatisticsView extends StatefulWidget {
  const _StatisticsView();

  @override
  State<_StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<_StatisticsView> {
  StatisticsFilter _selectedTimeRange = StatisticsFilter.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocBuilder<PomodoroThemeCubit, PomodoroThemeState>(
        builder: (context, pomodoroThemeState) {
          final theme = Theme.of(context);
          final appTheme = pomodoroThemeState.currentTheme;
          final primaryColor = appTheme.primaryColor;

          return BlocBuilder<StatisticsCubit, StatisticsState>(
            builder: (context, state) {
              if (state.isLoading && state.sessions.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentSessions = _getCurrentSessions(state);
              final todaySessions = _getTodaySessions(state);
              final streak = _calculateStreak(state);

              return Container(
                color: Color.lerp(
                  theme.scaffoldBackgroundColor,
                  primaryColor,
                  0.12,
                ),
                child: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Time Range Picker
                      _buildTimeRangePicker(context),

                      const SizedBox(height: 24),

                      // Streak Card
                      _buildStreakCard(context, streak),

                      const SizedBox(height: 24),

                      // Weekly Sessions Chart
                      _buildWeeklySessionsChart(
                        context,
                        currentSessions,
                        primaryColor,
                      ),

                      const SizedBox(height: 24),

                      // Focus Time Trend Chart
                      _buildFocusTimeTrendChart(
                        context,
                        currentSessions,
                        primaryColor,
                      ),

                      const SizedBox(height: 24),

                      // Session Type Distribution
                      _buildSessionTypeDistribution(
                        context,
                        currentSessions,
                        appTheme,
                      ),

                      const SizedBox(height: 24),

                      // Today's Stats
                      _buildStatsSection(
                        context,
                        'Today',
                        todaySessions,
                        Icons.calendar_today,
                        primaryColor,
                      ),

                      const SizedBox(height: 24),

                      // Selected Range Stats
                      _buildStatsSection(
                        context,
                        _selectedTimeRange == StatisticsFilter.week
                            ? 'Week'
                            : 'Month',
                        currentSessions,
                        Icons.calendar_month,
                        primaryColor,
                      ),

                      const SizedBox(height: 24),

                      // Motivational Quote
                      _buildMotivationalQuote(context),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<TimerSession> _getCurrentSessions(StatisticsState state) {
    return _selectedTimeRange == StatisticsFilter.week
        ? _getWeekSessions(state)
        : _getMonthSessions(state);
  }

  List<TimerSession> _getTodaySessions(StatisticsState state) {
    final now = DateTime.now();
    return state.sessions.where((session) {
      return session.startTime.year == now.year &&
          session.startTime.month == now.month &&
          session.startTime.day == now.day;
    }).toList();
  }

  List<TimerSession> _getWeekSessions(StatisticsState state) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return state.sessions.where((session) {
      return session.startTime.isAfter(weekAgo);
    }).toList();
  }

  List<TimerSession> _getMonthSessions(StatisticsState state) {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));
    return state.sessions.where((session) {
      return session.startTime.isAfter(monthAgo);
    }).toList();
  }

  int _calculateStreak(StatisticsState state) {
    if (state.sessions.isEmpty) return 0;

    int streak = 0;
    final now = DateTime.now();
    var checkDate = DateTime(now.year, now.month, now.day);

    while (true) {
      final hasSessions = state.sessions.any((session) {
        final sessionDate = DateTime(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );
        return sessionDate == checkDate;
      });

      if (!hasSessions) break;

      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Widget _buildTimeRangePicker(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              context,
              'Week',
              StatisticsFilter.week,
              primaryColor,
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              context,
              'Month',
              StatisticsFilter.month,
              primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
    BuildContext context,
    String label,
    StatisticsFilter filter,
    Color primaryColor,
  ) {
    final isSelected = _selectedTimeRange == filter;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeRange = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.15),
            Colors.orange.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.local_fire_department,
              size: 50,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$streak',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            streak == 1 ? 'Day Streak' : 'Days Streak',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySessionsChart(
    BuildContext context,
    List<TimerSession> sessions,
    Color primaryColor,
  ) {
    final theme = Theme.of(context);
    final dailyData = _getDailySessionData(sessions);

    if (dailyData.every((data) => data.count == 0)) {
      return _buildEmptyChart(
        context,
        'Sessions per Day',
        Icons.bar_chart,
        'No sessions yet',
      );
    }

    final maxCount = dailyData.map((e) => e.count).reduce(math.max).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.cardColor, primaryColor.withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Sessions per Day',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (maxCount + 2).ceilToDouble(),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < dailyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              dailyData[value.toInt()].day,
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: theme.dividerColor, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  dailyData.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: dailyData[index].count.toDouble(),
                        color: primaryColor,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusTimeTrendChart(
    BuildContext context,
    List<TimerSession> sessions,
    Color primaryColor,
  ) {
    final theme = Theme.of(context);
    final trendData = _getFocusTimeTrendData(sessions);

    if (trendData.every((data) => data.minutes == 0)) {
      return _buildEmptyChart(
        context,
        'Focus Time Trend',
        Icons.show_chart,
        'No focus sessions yet',
      );
    }

    final maxMinutes = trendData.map((e) => e.minutes).reduce(math.max);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.cardColor, primaryColor.withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Focus Time Trend',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: theme.dividerColor, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < trendData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              trendData[value.toInt()].day,
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}m',
                          style: theme.textTheme.bodySmall,
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (trendData.length - 1).toDouble(),
                minY: 0,
                maxY: (maxMinutes + 10).ceilToDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      trendData.length,
                      (index) =>
                          FlSpot(index.toDouble(), trendData[index].minutes),
                    ),
                    isCurved: true,
                    color: primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionTypeDistribution(
    BuildContext context,
    List<TimerSession> sessions,
    appTheme,
  ) {
    final theme = Theme.of(context);
    final distributionData = _getSessionDistribution(sessions, appTheme);

    if (distributionData.isEmpty) {
      return _buildEmptyChart(
        context,
        'Session Distribution',
        Icons.pie_chart,
        'No sessions yet',
      );
    }

    final primaryColor = appTheme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.cardColor, primaryColor.withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: theme.colorScheme.secondary),
              const SizedBox(width: 8),
              Text(
                'Session Distribution',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: PieChart(
                  PieChartData(
                    sections: distributionData.map((data) {
                      return PieChartSectionData(
                        value: data.count.toDouble(),
                        title: '',
                        color: data.color,
                        radius: 50,
                      );
                    }).toList(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: distributionData.map((data) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: data.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              data.type,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          Text(
                            '${data.count}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    String title,
    List<TimerSession> sessions,
    IconData icon,
    Color primaryColor,
  ) {
    final theme = Theme.of(context);

    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'No sessions yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final focusCount = sessions
        .where((s) => s.sessionType == SessionType.work)
        .length;
    final totalFocusTime = sessions
        .where((s) => s.sessionType == SessionType.work)
        .fold<int>(0, (sum, s) => sum + s.durationInMinutes);
    final totalBreakTime = sessions
        .where((s) => s.sessionType != SessionType.work)
        .fold<int>(0, (sum, s) => sum + s.durationInMinutes);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.secondary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            context,
            'Total Sessions',
            '${sessions.length}',
            Icons.check_circle,
            const Color(0xFF34C759),
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            context,
            'Focus Sessions',
            '$focusCount',
            Icons.psychology,
            primaryColor,
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            context,
            'Total Focus Time',
            _formatTime(totalFocusTime),
            Icons.timer,
            theme.colorScheme.secondary,
          ),
          const SizedBox(height: 12),
          _buildStatRow(
            context,
            'Break Time',
            _formatTime(totalBreakTime),
            Icons.coffee,
            const Color(0xFF34C759),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildMotivationalQuote(BuildContext context) {
    final quotes = [
      "Stay focused and never give up! 🎯",
      "Small progress is still progress. 🌱",
      "You're doing amazing! Keep going! 💪",
      "Consistency is key to success. 🔑",
      "Every session brings you closer to your goals. ⭐",
      "Believe in yourself and all that you are. 🌟",
      "Focus on progress, not perfection. 📈",
      "You've got this! One session at a time. 🚀",
    ];

    final quote = (quotes..shuffle()).first;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow.withValues(alpha: 0.15),
            Colors.yellow.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.yellow.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.yellow, size: 32),
          const SizedBox(height: 12),
          Text(
            quote,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(
    BuildContext context,
    String title,
    IconData icon,
    String message,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<({String day, int count})> _getDailySessionData(
    List<TimerSession> sessions,
  ) {
    final now = DateTime.now();
    final daysToShow = _selectedTimeRange == StatisticsFilter.week ? 7 : 30;
    final data = <({String day, int count})>[];

    for (int i = daysToShow - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _selectedTimeRange == StatisticsFilter.month
          ? '${date.day}'
          : DateFormat('E').format(date);

      final count = sessions.where((session) {
        return session.startTime.year == date.year &&
            session.startTime.month == date.month &&
            session.startTime.day == date.day;
      }).length;

      data.add((day: dayName, count: count));
    }

    return data;
  }

  List<({String day, double minutes})> _getFocusTimeTrendData(
    List<TimerSession> sessions,
  ) {
    final now = DateTime.now();
    final daysToShow = _selectedTimeRange == StatisticsFilter.week ? 7 : 30;
    final data = <({String day, double minutes})>[];

    for (int i = daysToShow - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _selectedTimeRange == StatisticsFilter.month
          ? '${date.day}'
          : DateFormat('E').format(date);

      final focusMinutes = sessions
          .where(
            (session) =>
                session.sessionType == SessionType.work &&
                session.startTime.year == date.year &&
                session.startTime.month == date.month &&
                session.startTime.day == date.day,
          )
          .fold<double>(0, (sum, s) => sum + s.durationInMinutes);

      data.add((day: dayName, minutes: focusMinutes));
    }

    return data;
  }

  List<({String type, int count, Color color})> _getSessionDistribution(
    List<TimerSession> sessions,
    appTheme,
  ) {
    final focusCount = sessions
        .where((s) => s.sessionType == SessionType.work)
        .length;
    final shortBreakCount = sessions
        .where((s) => s.sessionType == SessionType.shortBreak)
        .length;
    final longBreakCount = sessions
        .where((s) => s.sessionType == SessionType.longBreak)
        .length;

    final data = <({String type, int count, Color color})>[];

    if (focusCount > 0) {
      data.add((
        type: 'Focus',
        count: focusCount,
        color: appTheme.primaryColor,
      ));
    }
    if (shortBreakCount > 0) {
      data.add((
        type: 'Short Break',
        count: shortBreakCount,
        color: const Color(0xFF34C759),
      ));
    }
    if (longBreakCount > 0) {
      data.add((
        type: 'Long Break',
        count: longBreakCount,
        color: const Color(0xFF007AFF),
      ));
    }

    return data;
  }

  String _formatTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}
