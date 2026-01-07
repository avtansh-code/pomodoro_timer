import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/pomodoro_theme_cubit.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/models/app_theme_model.dart';
import '../../../core/models/timer_session.dart';
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

  /// App version from pubspec.yaml (version name only)
  static Future<String> _getAppVersion() async {
    // Get version from pubspec.yaml via platform channel
    // Version is set in pubspec.yaml and read at build time
    const version = String.fromEnvironment(
      'APP_VERSION',
      defaultValue: '2.0.0',
    );
    return version;
  }

  /// Full app version with build number from pubspec.yaml
  static Future<String> _getAppVersionFull() async {
    // Get full version from pubspec.yaml (version+build)
    // Version is set in pubspec.yaml and read at build time
    const version = String.fromEnvironment(
      'APP_VERSION',
      defaultValue: '2.0.0',
    );
    const buildNumber = String.fromEnvironment(
      'APP_BUILD_NUMBER',
      defaultValue: '7',
    );
    return '$version+$buildNumber';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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

          return BlocBuilder<PomodoroThemeCubit, PomodoroThemeState>(
            builder: (context, pomodoroState) {
              final primaryColor = pomodoroState.currentTheme.primaryColor;

              return Container(
                color: Color.lerp(
                  theme.scaffoldBackgroundColor,
                  primaryColor,
                  0.12,
                ),
                child: SafeArea(
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

                      // Developer Tools (Debug mode only)
                      if (const bool.fromEnvironment('dart.vm.product') ==
                          false)
                        _buildDeveloperSection(context),

                      if (const bool.fromEnvironment('dart.vm.product') ==
                          false)
                        const SizedBox(height: 8),

                      // Data Management
                      _buildDataSection(context),

                      const SizedBox(height: 8),

                      // About Section
                      _buildAboutSection(context),

                      const SizedBox(height: 24),
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
        BlocBuilder<PomodoroThemeCubit, PomodoroThemeState>(
          builder: (context, pomodoroThemeState) {
            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                String themeModeName;
                switch (themeState.themeMode) {
                  case ThemeMode.light:
                    themeModeName = 'Light';
                    break;
                  case ThemeMode.dark:
                    themeModeName = 'Dark';
                    break;
                  case ThemeMode.system:
                    themeModeName = 'System';
                    break;
                }

                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: pomodoroThemeState.currentTheme.primaryColor
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.palette,
                      color: pomodoroThemeState.currentTheme.primaryColor,
                      size: 22,
                    ),
                  ),
                  title: const Text('Theme & Colors'),
                  subtitle: Text(
                    '${pomodoroThemeState.currentTheme.name} • $themeModeName',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildThemePreview(pomodoroThemeState.currentTheme),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ThemeSelectionScreen(),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// Builds a theme preview with 3 colored circles matching iOS design
  Widget _buildThemePreview(AppThemeModel appTheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPreviewCircle(appTheme.primaryColor, 12),
        const SizedBox(width: 4),
        _buildPreviewCircle(appTheme.secondaryColor, 12),
        const SizedBox(width: 4),
        _buildPreviewCircle(appTheme.accentColor, 12),
      ],
    );
  }

  Widget _buildPreviewCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
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
          suffix: 'min',
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
          suffix: 'min',
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
          suffix: 'min',
          onChanged: (value) {
            context.read<SettingsCubit>().updateLongBreakDuration(
              value.round(),
            );
          },
        ),
        const Divider(height: 1),
        _buildDurationTile(
          context: context,
          icon: Icons.repeat,
          iconColor: theme.colorScheme.tertiary,
          title: 'Long break after',
          value: state.settings.sessionsBeforeLongBreak,
          min: 2,
          max: 10,
          suffix: '',
          onChanged: (value) {
            context.read<SettingsCubit>().updateSessionsBeforeLongBreak(
              value.round(),
            );
          },
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

  Widget _buildDeveloperSection(BuildContext context) {
    return _buildSection(
      context: context,
      icon: Icons.construction,
      title: 'Developer Tools',
      footer: 'Tools for debugging and testing. Only visible in debug builds.',
      children: [
        ListTile(
          leading: const Icon(Icons.bug_report, color: Colors.purple),
          title: const Text(
            'App Information',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('View technical details and logs'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showAppInfoDialog(context),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.palette, color: Colors.pink),
          title: const Text(
            'Test All Themes',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Quick preview of all color schemes'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeTestDialog(context),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.data_object, color: Colors.teal),
          title: const Text(
            'Generate Sample Data',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Add dummy sessions for testing'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showGenerateDataDialog(context),
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
        FutureBuilder<String>(
          future: _getAppVersion(),
          builder: (context, snapshot) {
            return ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.grey),
              title: const Text('Version'),
              trailing: Text(
                snapshot.data ?? '...',
                style: const TextStyle(color: Colors.grey),
              ),
            );
          },
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
          color: theme.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
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
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Icon
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          // Title
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          // Compact stepper control
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Minus button
                GestureDetector(
                  onTap: value > min
                      ? () => onChanged((value - 1).toDouble())
                      : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.remove,
                      color: value > min
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      size: 18,
                    ),
                  ),
                ),
                // Value display
                Container(
                  constraints: const BoxConstraints(minWidth: 40),
                  alignment: Alignment.center,
                  child: Text(
                    suffix.isEmpty ? '$value' : '$value $suffix',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                // Plus button
                GestureDetector(
                  onTap: value < max
                      ? () => onChanged((value + 1).toDouble())
                      : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      color: value < max
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
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

  void _showAppInfoDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            const Text('App Information'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<String>(
                future: _getAppVersionFull(),
                builder: (context, snapshot) {
                  return _buildInfoRow('Version', snapshot.data ?? '...');
                },
              ),
              _buildInfoRow('Build Mode', 'Debug'),
              _buildInfoRow('Flutter SDK', '3.10.4+'),
              _buildInfoRow('Platform', Theme.of(context).platform.name),
              const Divider(),
              _buildInfoRow('Material', 'Design 3'),
              _buildInfoRow('State Management', 'BLoC'),
              _buildInfoRow('Storage', 'Hive + SharedPreferences'),
              const Divider(),
              const Text(
                'Theme System',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              BlocBuilder<PomodoroThemeCubit, PomodoroThemeState>(
                builder: (context, state) {
                  return _buildInfoRow(
                    'Current Theme',
                    state.currentTheme.name,
                  );
                },
              ),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return _buildInfoRow('Brightness', state.themeMode.name);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeTestDialog(BuildContext context) {
    final allThemes = PomodoroThemes.allThemes;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Theme Preview'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: allThemes.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final theme = allThemes[index];
              return ListTile(
                leading: _buildThemePreview(theme),
                title: Text(theme.name),
                subtitle: Text(
                  '#${(theme.primaryColor.r * 255).round().toRadixString(16).padLeft(2, '0')}${(theme.primaryColor.g * 255).round().toRadixString(16).padLeft(2, '0')}${(theme.primaryColor.b * 255).round().toRadixString(16).padLeft(2, '0')}'
                      .toUpperCase(),
                ),
                onTap: () {
                  context.read<PomodoroThemeCubit>().setTheme(theme);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched to ${theme.name}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showGenerateDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Generate Sample Data'),
        content: const Text(
          'This will add dummy session data for the past 30 days. Useful for testing statistics and charts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              // Generate sample data
              final repository = getIt<StatisticsRepository>();

              // Add sessions for the past 30 days
              final now = DateTime.now();
              for (int i = 0; i < 30; i++) {
                final date = now.subtract(Duration(days: i));

                // Add 2-4 sessions per day
                final sessionsCount = 2 + (i % 3);
                for (int j = 0; j < sessionsCount; j++) {
                  final startTime = date.subtract(Duration(hours: j * 2));
                  final breakStartTime = date.subtract(
                    Duration(hours: j * 2, minutes: 25),
                  );

                  // Add focus session
                  await repository.addSession(
                    TimerSession(
                      id: '${DateTime.now().millisecondsSinceEpoch}_${i}_$j',
                      startTime: startTime,
                      endTime: startTime.add(const Duration(minutes: 25)),
                      sessionType: SessionType.work,
                      durationInMinutes: 25,
                    ),
                  );

                  // Add a short break
                  await repository.addSession(
                    TimerSession(
                      id: '${DateTime.now().millisecondsSinceEpoch}_${i}_${j}_break',
                      startTime: breakStartTime,
                      endTime: breakStartTime.add(const Duration(minutes: 5)),
                      sessionType: SessionType.shortBreak,
                      durationInMinutes: 5,
                    ),
                  );
                }
              }

              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sample data generated successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}
