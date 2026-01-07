import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/pomodoro_theme_cubit.dart';
import '../../../../core/models/timer_session.dart';
import '../../bloc/timer_state.dart' as state;
import 'circular_timer_progress.dart';
import 'state_indicator_chip.dart';

/// Widget that displays the timer countdown in a large, readable format.
///
/// Shows minutes and seconds in MM:SS format with appropriate styling
/// based on the current session type. Now uses circular progress indicator.
class TimerDisplay extends StatelessWidget {
  /// Duration to display in seconds
  final int duration;

  /// Total duration for the current session (to calculate progress)
  final int totalDuration;

  /// Current session type (affects color and style)
  final SessionType sessionType;

  /// Current timer state
  final state.TimerState timerState;

  const TimerDisplay({
    super.key,
    required this.duration,
    required this.totalDuration,
    required this.sessionType,
    required this.timerState,
  });

  /// Formats seconds into MM:SS format
  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Gets the color based on session type from the current theme
  Color _getSessionColor(BuildContext context) {
    final appTheme = context.read<PomodoroThemeCubit>().state.currentTheme;
    return appTheme.getColorForSession(sessionType);
  }

  /// Calculates progress (0.0 to 1.0)
  double _getProgress() {
    if (totalDuration == 0) return 0.0;
    return 1.0 - (duration / totalDuration);
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSessionColor(context);

    return CircularTimerProgress(
      progress: _getProgress(),
      timeText: _formatDuration(duration),
      color: color,
      size: 300.0,
      strokeWidth: 16.0,
      stateIndicator: StateIndicatorChip(timerState: timerState, color: color),
    );
  }
}
