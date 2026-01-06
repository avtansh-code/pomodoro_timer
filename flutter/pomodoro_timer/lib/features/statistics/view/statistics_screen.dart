import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/models/timer_session.dart';
import '../bloc/statistics_cubit.dart';
import '../bloc/statistics_state.dart';
import '../data/statistics_repository.dart';

/// Statistics screen for viewing timer session history and analytics.
/// 
/// Displays session history, aggregate statistics, and filtering options.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit(getIt<StatisticsRepository>()),
      child: const _StatisticsView(),
    );
  }
}

class _StatisticsView extends StatelessWidget {
  const _StatisticsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<StatisticsCubit>().refresh();
            },
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All Data'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<StatisticsCubit, StatisticsState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<StatisticsCubit>().clearError();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.sessions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => context.read<StatisticsCubit>().refresh(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Filter chips
                _buildFilterChips(context, state),
                
                const SizedBox(height: 24),
                
                // Summary statistics cards
                _buildSummaryCards(context, state),
                
                const SizedBox(height: 24),
                
                // Session list or empty state
                if (state.sessions.isEmpty)
                  _buildEmptyState(context, state.filter)
                else
                  _buildSessionList(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, StatisticsState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: StatisticsFilter.values.map((filter) {
          final isSelected = state.filter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(_getFilterLabel(filter)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  context.read<StatisticsCubit>().changeFilter(filter);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getFilterLabel(StatisticsFilter filter) {
    return switch (filter) {
      StatisticsFilter.today => 'Today',
      StatisticsFilter.week => 'This Week',
      StatisticsFilter.month => 'This Month',
      StatisticsFilter.all => 'All Time',
    };
  }

  Widget _buildSummaryCards(BuildContext context, StatisticsState state) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Sessions',
            value: state.workSessionCount.toString(),
            icon: Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Focus Time',
            value: _formatMinutes(state.totalFocusTime),
            icon: Icons.timer,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Break Time',
            value: _formatMinutes(state.totalBreakTime),
            icon: Icons.coffee,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }

  Widget _buildEmptyState(BuildContext context, StatisticsFilter filter) {
    String message;
    switch (filter) {
      case StatisticsFilter.today:
        message = 'No sessions completed today yet.\nStart a Pomodoro to track your progress!';
        break;
      case StatisticsFilter.week:
        message = 'No sessions this week.\nGet started with your first Pomodoro!';
        break;
      case StatisticsFilter.month:
        message = 'No sessions this month.\nTime to begin your focus journey!';
        break;
      case StatisticsFilter.all:
        message = 'No sessions recorded yet.\nComplete your first Pomodoro session!';
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList(BuildContext context, StatisticsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...state.sessionsByDate.entries.map((entry) {
          return _buildDateSection(context, entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildDateSection(
    BuildContext context,
    DateTime date,
    List<TimerSession> sessions,
  ) {
    final isToday = _isToday(date);
    final isYesterday = _isYesterday(date);
    
    String dateLabel;
    if (isToday) {
      dateLabel = 'Today';
    } else if (isYesterday) {
      dateLabel = 'Yesterday';
    } else {
      dateLabel = DateFormat('EEEE, MMM d').format(date);
    }

    final workSessions = sessions.where((s) => s.sessionType == SessionType.work).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(
                dateLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$workSessions ${workSessions == 1 ? 'session' : 'sessions'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        ...sessions.map((session) => _buildSessionTile(context, session)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSessionTile(BuildContext context, TimerSession session) {
    final timeFormat = DateFormat('h:mm a');
    final isWork = session.sessionType == SessionType.work;
    
    Color color;
    IconData icon;
    
    switch (session.sessionType) {
      case SessionType.work:
        color = Theme.of(context).colorScheme.primary;
        icon = Icons.work;
        break;
      case SessionType.shortBreak:
        color = Colors.green;
        icon = Icons.coffee;
        break;
      case SessionType.longBreak:
        color = Colors.blue;
        icon = Icons.beach_access;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          session.sessionTypeLabel,
          style: TextStyle(
            fontWeight: isWork ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          '${timeFormat.format(session.startTime)} - ${timeFormat.format(session.endTime)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          '${session.durationInMinutes} min',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Statistics?'),
        content: const Text(
          'This will permanently delete all your session history and statistics. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<StatisticsCubit>().clearAllStatistics();
              Navigator.of(dialogContext).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
