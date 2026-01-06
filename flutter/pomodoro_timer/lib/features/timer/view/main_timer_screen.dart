import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider.value(
      value: _timerBloc,
      child: const _MainTimerView(),
    );
  }
}

class _MainTimerView extends StatelessWidget {
  const _MainTimerView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, settingsState) {
        // When settings change, update the timer bloc
        context.read<TimerBloc>().add(event.TimerSettingsUpdated(
          workDuration: settingsState.settings.workDuration,
          shortBreakDuration: settingsState.settings.shortBreakDuration,
          longBreakDuration: settingsState.settings.longBreakDuration,
          sessionsBeforeLongBreak: settingsState.settings.sessionsBeforeLongBreak,
        ));
      },
      child: BlocBuilder<TimerBloc, state.TimerState>(
        builder: (context, timerState) {
        final sessionColor = _getSessionColor(context, timerState.sessionType);
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Focus Timer'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  sessionColor.withValues(alpha: _getBackgroundOpacity(timerState.sessionType)),
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Session header with emoji and info
                    _buildSessionHeader(context, timerState, sessionColor),
                    
                    const SizedBox(height: 40),
                    
                    // Timer display
                    Expanded(
                      child: Center(
                        child: TimerDisplay(
                          duration: timerState.duration,
                          totalDuration: _getTotalDuration(context, timerState),
                          sessionType: timerState.sessionType,
                          timerState: timerState,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Timer controls
                    TimerControls(
                      timerState: timerState,
                      onEventAdded: (event) {
                        context.read<TimerBloc>().add(event);
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Skip button
                    _buildSkipButton(context, timerState, sessionColor),
                    
                    const SizedBox(height: 24),
                    
                    // Completion message
                    if (timerState is state.TimerCompleted)
                      _buildCompletionMessage(context, timerState),
                    
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      ),
    );
  }

  /// Gets the color for the session type
  Color _getSessionColor(BuildContext context, SessionType sessionType) {
    switch (sessionType) {
      case SessionType.work:
        return Theme.of(context).colorScheme.primary;
      case SessionType.shortBreak:
        return const Color(0xFF34C759); // Green
      case SessionType.longBreak:
        return const Color(0xFF007AFF); // Blue
    }
  }

  /// Gets background opacity based on session type
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

  /// Builds the session header with emoji and session info
  Widget _buildSessionHeader(
    BuildContext context,
    state.TimerState timerState,
    Color color,
  ) {
    String emoji;
    String title;
    String subtitle;

    switch (timerState.sessionType) {
      case SessionType.work:
        emoji = '🎯';
        title = 'Focus Session';
        subtitle = 'Session #${timerState.completedSessions + 1}';
        break;
      case SessionType.shortBreak:
        emoji = '☕';
        title = 'Short Break';
        subtitle = 'Relax and recharge';
        break;
      case SessionType.longBreak:
        emoji = '🌴';
        title = 'Long Break';
        subtitle = 'Well-deserved rest';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Emoji
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
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
                        color: color,
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
                color: color,
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

  /// Builds the skip button
  Widget _buildSkipButton(
    BuildContext context,
    state.TimerState timerState,
    Color sessionColor,
  ) {
    final settings = context.read<SettingsCubit>().state.settings;
    String nextSessionName;
    
    if (timerState.sessionType == SessionType.work) {
      if ((timerState.completedSessions + 1) >= settings.sessionsBeforeLongBreak) {
        nextSessionName = 'Long Break';
      } else {
        nextSessionName = 'Short Break';
      }
    } else {
      nextSessionName = 'Focus';
    }

    return TextButton.icon(
      onPressed: () {
        context.read<TimerBloc>().add(const event.TimerSkipped());
      },
      icon: Icon(
        Icons.fast_forward,
        size: 18,
        color: sessionColor,
      ),
      label: Text(
        'Skip to $nextSessionName',
        style: TextStyle(
          color: sessionColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Builds the completion message
  Widget _buildCompletionMessage(
    BuildContext context,
    state.TimerCompleted completedState,
  ) {
    String message;
    switch (completedState.completedSessionType) {
      case SessionType.work:
        message = '🎉 Great work! Time for a break.';
        break;
      case SessionType.shortBreak:
        message = '💪 Break over! Ready to focus?';
        break;
      case SessionType.longBreak:
        message = '🌟 Long break complete! Let\'s get back to it.';
        break;
    }

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
