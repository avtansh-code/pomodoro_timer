import 'package:equatable/equatable.dart';
import '../../../core/models/timer_session.dart';

/// Base class for all timer states.
/// 
/// Timer states represent the current condition of the timer
/// and are emitted by the TimerBloc in response to events.
sealed class TimerState extends Equatable {
  /// Current duration in seconds
  final int duration;
  
  /// Current session type
  final SessionType sessionType;
  
  /// Number of completed work sessions in current cycle
  final int completedSessions;

  const TimerState({
    required this.duration,
    required this.sessionType,
    this.completedSessions = 0,
  });

  @override
  List<Object?> get props => [duration, sessionType, completedSessions];
}

/// Initial state when the timer is first created or reset.
/// 
/// The timer is ready to start but not yet running.
class TimerInitial extends TimerState {
  const TimerInitial({
    required super.duration,
    required super.sessionType,
    super.completedSessions,
  });
}

/// State when the timer is actively counting down.
class TimerRunning extends TimerState {
  /// The start time of the current session for accuracy
  final DateTime startTime;

  const TimerRunning({
    required super.duration,
    required super.sessionType,
    required this.startTime,
    super.completedSessions,
  });

  @override
  List<Object?> get props => [duration, sessionType, completedSessions, startTime];
}

/// State when the timer is paused.
/// 
/// The remaining duration is preserved and can be resumed.
class TimerPaused extends TimerState {
  const TimerPaused({
    required super.duration,
    required super.sessionType,
    super.completedSessions,
  });
}

/// State when a timer session has completed.
/// 
/// This state is shown briefly before transitioning to the next session.
class TimerCompleted extends TimerState {
  /// The type of session that just completed
  final SessionType completedSessionType;

  const TimerCompleted({
    required super.duration,
    required super.sessionType,
    required this.completedSessionType,
    super.completedSessions,
  });

  @override
  List<Object?> get props => [
        duration,
        sessionType,
        completedSessions,
        completedSessionType,
      ];
}

/// State when the timer encounters an error.
class TimerError extends TimerState {
  final String message;

  const TimerError({
    required super.duration,
    required super.sessionType,
    required this.message,
    super.completedSessions,
  });

  @override
  List<Object?> get props => [duration, sessionType, completedSessions, message];
}
