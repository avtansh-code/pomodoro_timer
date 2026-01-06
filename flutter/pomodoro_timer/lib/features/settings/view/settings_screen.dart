import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/models/timer_settings.dart';
import '../../../core/services/persistence_service.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';

/// Settings screen for configuring timer durations and preferences.
/// 
/// Allows users to customize:
/// - Work session duration
/// - Short break duration
/// - Long break duration
/// - Number of sessions before long break
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(getIt<PersistenceService>()),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          // Show error message if present
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<SettingsCubit>().clearError();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.settings == const TimerSettings()) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Timer Durations Section
              _buildSectionHeader(context, 'Timer Durations'),
              const SizedBox(height: 16),
              
              _buildDurationTile(
                context: context,
                title: 'Work Duration',
                subtitle: 'Focus session length',
                value: state.settings.workDuration,
                min: 1,
                max: 60,
                onChanged: (value) {
                  context.read<SettingsCubit>().updateWorkDuration(value.round());
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildDurationTile(
                context: context,
                title: 'Short Break',
                subtitle: 'Brief rest between sessions',
                value: state.settings.shortBreakDuration,
                min: 1,
                max: 30,
                onChanged: (value) {
                  context.read<SettingsCubit>().updateShortBreakDuration(value.round());
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildDurationTile(
                context: context,
                title: 'Long Break',
                subtitle: 'Extended rest period',
                value: state.settings.longBreakDuration,
                min: 1,
                max: 60,
                onChanged: (value) {
                  context.read<SettingsCubit>().updateLongBreakDuration(value.round());
                },
              ),
              
              const SizedBox(height: 24),
              
              // Session Settings Section
              _buildSectionHeader(context, 'Session Settings'),
              const SizedBox(height: 16),
              
              _buildSessionsTile(
                context: context,
                title: 'Sessions Before Long Break',
                subtitle: 'Number of work sessions',
                value: state.settings.sessionsBeforeLongBreak,
                min: 1,
                max: 10,
                onChanged: (value) {
                  context.read<SettingsCubit>().updateSessionsBeforeLongBreak(value.round());
                },
              ),
              
              const SizedBox(height: 24),
              
              // Reset Button
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _showResetDialog(context),
                  icon: const Icon(Icons.restore),
                  label: const Text('Reset to Defaults'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Info card
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'About Pomodoro Technique',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The Pomodoro Technique uses a timer to break work into intervals, '
                        'traditionally 25 minutes, separated by short breaks. After several '
                        'sessions, take a longer break to recharge.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildDurationTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int value,
    required int min,
    required int max,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                Text(
                  '$value min',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              label: '$value minutes',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionsTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int value,
    required int min,
    required int max,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                Text(
                  '$value',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              label: '$value sessions',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset to Defaults?'),
        content: const Text(
          'This will reset all timer settings to their default values:\n\n'
          '• Work: 25 minutes\n'
          '• Short Break: 5 minutes\n'
          '• Long Break: 15 minutes\n'
          '• Sessions: 4',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<SettingsCubit>().resetToDefaults();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
