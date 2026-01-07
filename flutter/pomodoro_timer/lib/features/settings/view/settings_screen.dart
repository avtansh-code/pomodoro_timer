import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/models/timer_settings.dart';
import '../../statistics/data/statistics_repository.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';
import 'pomodoro_benefits_screen.dart';
import 'privacy_policy_screen.dart';
import 'theme_selection_screen.dart';

/// Settings screen matching iOS legacy app structure.
///
/// Includes all sections from iOS:
/// - Learn about Pomodoro
/// - Duration Settings
/// - Auto-start Settings
/// - Notifications & Feedback
/// - Data Management
/// - About
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the existing SettingsCubit from the app root, don't create a new one
    return const _SettingsView();
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
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
                    context.read<SettingsCubit>().clearError();
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.settings == const TimerSettings()) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                  theme.colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                // Learn Section - Featured at top
                _buildLearnSection(context),

                const SizedBox(height: 8),

                // Theme Section
                _buildThemeSection(context),

                const SizedBox(height: 8),

                // Duration Settings
                _buildDurationSection(context, state),

                const SizedBox(height: 8),

                // Auto-start Settings
                _buildAutoStartSection(context, state),

                const SizedBox(height: 8),

                // Notifications & Feedback
                _buildNotificationSection(context, state),

                const SizedBox(height: 8),

                // Data Management
                _buildDataSection(context),

                const SizedBox(height: 8),

                // About Section
                _buildAboutSection(context),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLearnSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.book,
      title: 'Get Started',
      children: [
        ListTile(
          leading: const Icon(Icons.lightbulb, color: Colors.orange),
          title: const Text(
            'Learn about Pomodoro',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Discover the science behind focused work'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PomodoroBenefitsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.palette,
      title: 'Appearance',
      children: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            String themeModeName;
            IconData themeModeIcon;
            Color themeModeColor;

            switch (themeState.themeMode) {
              case ThemeMode.light:
                themeModeName = 'Light';
                themeModeIcon = Icons.light_mode;
                themeModeColor = Colors.amber;
                break;
              case ThemeMode.dark:
                themeModeName = 'Dark';
                themeModeIcon = Icons.dark_mode;
                themeModeColor = Colors.indigo;
                break;
              case ThemeMode.system:
                themeModeName = 'System';
                themeModeIcon = Icons.brightness_auto;
                themeModeColor = Colors.blue;
                break;
            }

            return ListTile(
              leading: Icon(themeModeIcon, color: themeModeColor),
              title: const Text('App Theme'),
              subtitle: Text(themeModeName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThemeSelectionScreen(),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDurationSection(BuildContext context, SettingsState state) {
    final theme = Theme.of(context);

    return _buildSection(
      context: context,
      icon: Icons.schedule,
      title: 'Session Durations',
      children: [
        _buildDurationTile(
          context: context,
          icon: Icons.psychology,
          iconColor: theme.colorScheme.primary,
          title: 'Focus',
          value: state.settings.workDuration,
          min: 1,
          max: 120,
          onChanged: (value) {
            context.read<SettingsCubit>().updateWorkDuration(value.round());
          },
        ),
        const Divider(height: 1),
        _buildDurationTile(
          context: context,
          icon: Icons.coffee,
          iconColor: Colors.green,
          title: 'Short Break',
          value: state.settings.shortBreakDuration,
          min: 1,
          max: 30,
          onChanged: (value) {
            context.read<SettingsCubit>().updateShortBreakDuration(
              value.round(),
            );
          },
        ),
        const Divider(height: 1),
        _buildDurationTile(
          context: context,
          icon: Icons.hotel,
          iconColor: Colors.blue,
          title: 'Long Break',
          value: state.settings.longBreakDuration,
          min: 1,
          max: 60,
          onChanged: (value) {
            context.read<SettingsCubit>().updateLongBreakDuration(
              value.round(),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: Icon(Icons.repeat, color: theme.colorScheme.tertiary),
          title: const Text('Sessions until long break'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${state.settings.sessionsBeforeLongBreak}',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: state.settings.sessionsBeforeLongBreak > 2
                    ? () {
                        context
                            .read<SettingsCubit>()
                            .updateSessionsBeforeLongBreak(
                              state.settings.sessionsBeforeLongBreak - 1,
                            );
                      }
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: state.settings.sessionsBeforeLongBreak < 10
                    ? () {
                        context
                            .read<SettingsCubit>()
                            .updateSessionsBeforeLongBreak(
                              state.settings.sessionsBeforeLongBreak + 1,
                            );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutoStartSection(BuildContext context, SettingsState state) {
    return _buildSection(
      context: context,
      icon: Icons.play_circle,
      title: 'Auto-Start',
      footer:
          'Automatically begin the next session when the current one completes.',
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.play_circle, color: Colors.green),
          title: const Text('Auto-start breaks'),
          value: state.settings.autoStartBreaks,
          onChanged: (value) {
            context.read<SettingsCubit>().updateAutoStartBreaks(value);
          },
        ),
        const Divider(height: 1),
        SwitchListTile(
          secondary: Icon(
            Icons.play_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Auto-start focus'),
          value: state.settings.autoStartFocus,
          onChanged: (value) {
            context.read<SettingsCubit>().updateAutoStartFocus(value);
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection(BuildContext context, SettingsState state) {
    return _buildSection(
      context: context,
      icon: Icons.notifications,
      title: 'Notifications & Feedback',
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.notifications, color: Colors.blue),
          title: const Text('Notifications'),
          value: state.settings.notificationsEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().updateNotificationsEnabled(value);
          },
        ),
        const Divider(height: 1),
        SwitchListTile(
          secondary: const Icon(Icons.volume_up, color: Colors.purple),
          title: const Text('Sound'),
          value: state.settings.soundEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().updateSoundEnabled(value);
          },
        ),
        const Divider(height: 1),
        SwitchListTile(
          secondary: const Icon(Icons.vibration, color: Colors.orange),
          title: const Text('Haptic Feedback'),
          value: state.settings.hapticEnabled,
          onChanged: (value) {
            context.read<SettingsCubit>().updateHapticEnabled(value);
          },
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.storage,
      title: 'Data Management',
      footer:
          'Use these options to manage your app data. All destructive actions require confirmation.',
      children: [
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.red),
          title: const Text(
            'Clear All Statistics',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => _showClearStatsDialog(context),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.refresh, color: Colors.red),
          title: const Text(
            'Reset App Completely',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => _showResetAppDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.info,
      title: 'About',
      children: [
        ListTile(
          leading: const Icon(Icons.privacy_tip, color: Colors.blue),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PrivacyPolicyScreen(),
              ),
            );
          },
        ),
        const Divider(height: 1),
        const ListTile(
          leading: Icon(Icons.info_outline, color: Colors.grey),
          title: Text('Version'),
          trailing: Text('2.0.0', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
    String? footer,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              footer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDurationTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required int value,
    required int min,
    required int max,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value min',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: value > min
                ? () => onChanged((value - 1).toDouble())
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: value < max
                ? () => onChanged((value + 1).toDouble())
                : null,
          ),
        ],
      ),
    );
  }

  void _showClearStatsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Statistics'),
        content: const Text(
          'This will permanently delete all your session history and statistics. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final repository = getIt<StatisticsRepository>();
              await repository.clearAllSessions();
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Statistics cleared')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear Statistics'),
          ),
        ],
      ),
    );
  }

  void _showResetAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset App Completely'),
        content: const Text(
          'This will reset all settings to defaults and delete all statistics. The app will return to its initial state. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              // Reset settings
              context.read<SettingsCubit>().resetToDefaults();

              // Clear statistics
              final repository = getIt<StatisticsRepository>();
              await repository.clearAllSessions();

              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('App reset complete')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }
}
