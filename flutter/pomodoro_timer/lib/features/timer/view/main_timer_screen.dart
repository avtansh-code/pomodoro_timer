import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/pomodoro_theme_cubit.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/models/timer_session.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/notification_service.dart';
import '../../settings/bloc/settings_cubit.dart';
import '../../settings/bloc/settings_state.dart';
import '../../statistics/data/statistics_repository.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_event.dart' as event;
import '../bloc/timer_state.dart' as state;
import 'widgets/timer_controls.dart';
import 'widgets/timer_display.dart';

/// Main screen for the Pomodoro timer.
///
/// This screen displays the timer and provides controls to start,
/// pause, resume, and reset the timer. It uses BlocProvider to
/// manage the TimerBloc lifecycle and loads settings from SettingsCubit.
class MainTimerScreen extends StatefulWidget {
  const MainTimerScreen({super.key});

  @override
  State<MainTimerScreen> createState() => _MainTimerScreenState();
}

class _MainTimerScreenState extends State<MainTimerScreen> {
  late final TimerBloc _timerBloc;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsCubit>().state.settings;
    _timerBloc = TimerBloc(
      settings: settings,
      notificationService: getIt<NotificationService>(),
      audioService: getIt<AudioService>(),
      statisticsRepository: getIt<StatisticsRepository>(),
    );
  }

  @override
  void dispose() {
    _timerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _timerBloc, child: const _MainTimerView());
  }
}

class _MainTimerView extends StatelessWidget {
  const _MainTimerView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, settingsState) {
            // When settings change, update the timer bloc
            context.read<TimerBloc>().add(
              event.TimerSettingsUpdated(
                workDuration: settingsState.settings.workDuration,
                shortBreakDuration: settingsState.settings.shortBreakDuration,
                longBreakDuration: settingsState.settings.longBreakDuration,
                sessionsBeforeLongBreak:
                    settingsState.settings.sessionsBeforeLongBreak,
                autoStartBreaks: settingsState.settings.autoStartBreaks,
                autoStartFocus: settingsState.settings.autoStartFocus,
              ),
            );
          },
        ),
        // Timer completion is handled via notifications, no in-app toast needed
        BlocListener<TimerBloc, state.TimerState>(
          listener: (context, timerState) {
            // No action needed - notifications are handled by TimerBloc
          },
        ),
      ],
      child: BlocBuilder<PomodoroThemeCubit, PomodoroThemeState>(
        builder: (context, pomodoroThemeState) {
          return BlocBuilder<TimerBloc, state.TimerState>(
            builder: (context, timerState) {
              final appTheme = pomodoroThemeState.currentTheme;
              // Always use the theme's primary color for main UI
              final primaryColor = appTheme.primaryColor;
              // Use accent colors for session type differentiation
              final sessionAccentColor = _getSessionAccentColor(
                timerState.sessionType,
                appTheme,
              );

              return Scaffold(
                extendBodyBehindAppBar: true, // Extend gradient behind AppBar
                appBar: AppBar(
                  title: const Text('Focus Timer'),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent, // Remove tint color
                ),
                body: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  color: Color.lerp(
                    Theme.of(context).scaffoldBackgroundColor,
                    primaryColor, // Always use primary color for background
                    _getBackgroundOpacity(timerState.sessionType),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Session header with session info
                          _buildSessionHeader(
                            context,
                            timerState,
                            primaryColor,
                            sessionAccentColor,
                          ),

                          const SizedBox(height: 40),

                          // Timer display
                          Expanded(
                            child: Center(
                              child: TimerDisplay(
                                duration: timerState.duration,
                                totalDuration: _getTotalDuration(
                                  context,
                                  timerState,
                                ),
                                sessionType: timerState.sessionType,
                                timerState: timerState,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Timer controls
                          TimerControls(
                            timerState: timerState,
                            onEventAdded: (timerEvent) {
                              context.read<TimerBloc>().add(timerEvent);
                            },
                          ),

                          const SizedBox(height: 24),

                          // Skip button
                          _buildSkipButton(context, timerState, primaryColor),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Gets background opacity based on session type (matching iOS)
  double _getBackgroundOpacity(SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return 0.15; // Slightly more prominent for focus mode
      case SessionType.shortBreak:
        return 0.10; // Lighter for short break
      case SessionType.longBreak:
        return 0.08; // Even lighter for long break
    }
  }

  /// Gets accent color for session type while keeping main theme intact
  /// All sessions use variations of the primary color to maintain theme consistency
  Color _getSessionAccentColor(SessionType sessionType, dynamic appTheme) {
    final Color primaryColor = appTheme.primaryColor;

    switch (sessionType) {
      case SessionType.work:
        // Full primary color for focus
        return primaryColor;
      case SessionType.shortBreak:
        // Lighter tint of primary for short break
        return Color.lerp(primaryColor, Colors.white, 0.2) ?? primaryColor;
      case SessionType.longBreak:
        // Slightly darker shade of primary for long break
        return Color.lerp(primaryColor, Colors.black, 0.15) ?? primaryColor;
    }
  }

  /// Gets icon for session type
  IconData _getSessionIcon(SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return Icons.psychology;
      case SessionType.shortBreak:
        return Icons.coffee;
      case SessionType.longBreak:
        return Icons.self_improvement;
    }
  }

  /// Builds the session header matching iOS design
  Widget _buildSessionHeader(
    BuildContext context,
    state.TimerState timerState,
    Color primaryColor,
    Color accentColor,
  ) {
    String title;
    String subtitle;

    switch (timerState.sessionType) {
      case SessionType.work:
        title = 'Focus';
        subtitle = 'Session ${timerState.completedSessions + 1}';
        break;
      case SessionType.shortBreak:
        title = 'Short Break';
        subtitle = 'Rest and recharge';
        break;
      case SessionType.longBreak:
        title = 'Long Break';
        subtitle = 'Well-deserved rest';
        break;
    }

    // Use accent color for session-specific elements, primary for base
    final displayColor = accentColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: displayColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Session type icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: displayColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getSessionIcon(timerState.sessionType),
              color: displayColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: displayColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Session badge for work sessions
          if (timerState.sessionType == SessionType.work)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${timerState.completedSessions + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Gets the total duration for the current session type
  int _getTotalDuration(BuildContext context, state.TimerState timerState) {
    final settings = context.read<SettingsCubit>().state.settings;
    switch (timerState.sessionType) {
      case SessionType.work:
        return settings.workDuration * 60;
      case SessionType.shortBreak:
        return settings.shortBreakDuration * 60;
      case SessionType.longBreak:
        return settings.longBreakDuration * 60;
    }
  }

  /// Builds the skip button with capsule shape (matching iOS)
  Widget _buildSkipButton(
    BuildContext context,
    state.TimerState timerState,
    Color sessionColor,
  ) {
    final settings = context.read<SettingsCubit>().state.settings;
    String nextSessionName;

    if (timerState.sessionType == SessionType.work) {
      if ((timerState.completedSessions + 1) >=
          settings.sessionsBeforeLongBreak) {
        nextSessionName = 'Long Break';
      } else {
        nextSessionName = 'Short Break';
      }
    } else {
      nextSessionName = 'Focus';
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: TextButton.icon(
        onPressed: () {
          context.read<TimerBloc>().add(const event.TimerSkipped());
        },
        icon: Icon(
          Icons.skip_next_rounded,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        label: Text(
          'Skip to $nextSessionName',
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: theme.cardColor,
          shape: StadiumBorder(
            side: BorderSide(
              color: isDark
                  ? theme.dividerColor.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
