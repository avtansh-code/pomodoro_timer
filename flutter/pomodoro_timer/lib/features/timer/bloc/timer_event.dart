import 'package:equatable/equatable.dart';

/// Base class for all timer events.
///
/// Timer events represent user actions or system events that
/// trigger state changes in the TimerBloc.
sealed class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start the timer.
///
/// Initiates a new timer session with the specified duration.
class TimerStarted extends TimerEvent {
  /// Duration of the timer in seconds
  final int duration;

  const TimerStarted(this.duration);

  @override
  List<Object?> get props => [duration];
}

/// Event to pause the currently running timer.
class TimerPaused extends TimerEvent {
  const TimerPaused();
}

/// Event to resume a paused timer.
class TimerResumed extends TimerEvent {
  const TimerResumed();
}

/// Event to reset the timer to its initial state.
class TimerReset extends TimerEvent {
  const TimerReset();
}

/// Internal event triggered by the timer tick.
///
/// This event is emitted every second while the timer is running
/// to update the remaining duration.
class TimerTicked extends TimerEvent {
  /// Remaining duration in seconds
  final int duration;

  const TimerTicked(this.duration);

  @override
  List<Object?> get props => [duration];
}

/// Event to skip to the next session (work -> break or break -> work).
class TimerSkipped extends TimerEvent {
  const TimerSkipped();
}

/// Event triggered when a timer session completes.
///
/// This handles the transition between work and break sessions.
class TimerCompleted extends TimerEvent {
  const TimerCompleted();
}

/// Event to update timer settings.
///
/// This allows updating settings (like durations) without losing timer state.
class TimerSettingsUpdated extends TimerEvent {
  final int workDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int sessionsBeforeLongBreak;

  const TimerSettingsUpdated({
    required this.workDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.sessionsBeforeLongBreak,
  });

  @override
  List<Object?> get props => [
    workDuration,
    shortBreakDuration,
    longBreakDuration,
    sessionsBeforeLongBreak,
  ];
}
