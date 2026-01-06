import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/models/timer_session.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/notification_service.dart';
import '../../settings/bloc/settings_cubit.dart';
import '../../settings/bloc/settings_state.dart';
import '../../settings/view/settings_screen.dart';
import '../bloc/timer_bloc.dart';
import '../bloc/timer_state.dart' as state;
import 'widgets/timer_controls.dart';
import 'widgets/timer_display.dart';

/// Main screen for the Pomodoro timer.
/// 
/// This screen displays the timer and provides controls to start,
/// pause, resume, and reset the timer. It uses BlocProvider to
/// manage the TimerBloc lifecycle and loads settings from SettingsCubit.
class MainTimerScreen extends StatelessWidget {
  const MainTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return BlocProvider(
          create: (context) => TimerBloc(
            settings: settingsState.settings,
            notificationService: getIt<NotificationService>(),
            audioService: getIt<AudioService>(),
          ),
          child: const _MainTimerView(),
        );
      },
    );
  }
}

class _MainTimerView extends StatelessWidget {
  const _MainTimerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        centerTitle: true,
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          
          // Statistics button
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              // TODO: Navigate to statistics
            },
          ),
        ],
      ),
      body: BlocBuilder<TimerBloc, state.TimerState>(
        builder: (context, timerState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Session counter
                  _buildSessionCounter(context, timerState),
                  
                  const SizedBox(height: 32),
                  
                  // Timer display
                  Expanded(
                    child: Center(
                      child: TimerDisplay(
                        duration: timerState.duration,
                        sessionType: timerState.sessionType,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Timer controls
                  TimerControls(
                    timerState: timerState,
                    onEventAdded: (event) {
                      context.read<TimerBloc>().add(event);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Completion message
                  if (timerState is state.TimerCompleted)
                    _buildCompletionMessage(context, timerState),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the session counter display
  Widget _buildSessionCounter(BuildContext context, state.TimerState timerState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 20),
          const SizedBox(width: 8),
          Text(
            'Sessions: ${timerState.completedSessions}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
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
