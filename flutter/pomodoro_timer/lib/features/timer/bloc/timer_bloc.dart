import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/timer_session.dart';
import '../../../core/models/timer_settings.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/audio_service.dart';
import '../../statistics/data/statistics_repository.dart';
import 'timer_event.dart' as event;
import 'timer_state.dart' as state;

/// BLoC for managing timer state and business logic.
/// 
/// This BLoC handles the core Pomodoro timer functionality including:
/// - Starting, pausing, resuming, and resetting the timer
/// - Automatic transitions between work and break sessions
/// - Countdown logic with accurate time tracking
/// - Integration with notification and audio services
class TimerBloc extends Bloc<event.TimerEvent, state.TimerState> {
  TimerSettings settings;
  final NotificationService notificationService;
  final AudioService audioService;
  final StatisticsRepository statisticsRepository;

  StreamSubscription<int>? _tickerSubscription;
  DateTime? _sessionStartTime;

  TimerBloc({
    required this.settings,
    required this.notificationService,
    required this.audioService,
    required this.statisticsRepository,
  }) : super(
          state.TimerInitial(
            duration: settings.workDuration * 60,
            sessionType: SessionType.work,
            completedSessions: 0,
          ),
        ) {
    on<event.TimerStarted>(_onStarted);
    on<event.TimerPaused>(_onPaused);
    on<event.TimerResumed>(_onResumed);
    on<event.TimerReset>(_onReset);
    on<event.TimerTicked>(_onTicked);
    on<event.TimerCompleted>(_onCompleted);
    on<event.TimerSkipped>(_onSkipped);
    on<event.TimerSettingsUpdated>(_onSettingsUpdated);
  }

  /// Handles the timer start event.
  Future<void> _onStarted(
    event.TimerStarted startEvent,
    Emitter<state.TimerState> emit,
  ) async {
    _sessionStartTime = DateTime.now();
    emit(state.TimerRunning(
      duration: startEvent.duration,
      sessionType: this.state.sessionType,
      startTime: _sessionStartTime!,
      completedSessions: this.state.completedSessions,
    ));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker(startEvent.duration).listen(
      (duration) => add(event.TimerTicked(duration)),
    );
  }

  /// Handles the timer pause event.
  Future<void> _onPaused(
    event.TimerPaused pauseEvent,
    Emitter<state.TimerState> emit,
  ) async {
    if (this.state is state.TimerRunning) {
      _tickerSubscription?.pause();
      emit(state.TimerPaused(
        duration: this.state.duration,
        sessionType: this.state.sessionType,
        completedSessions: this.state.completedSessions,
      ));
    }
  }

  /// Handles the timer resume event.
  Future<void> _onResumed(
    event.TimerResumed resumeEvent,
    Emitter<state.TimerState> emit,
  ) async {
    if (this.state is state.TimerPaused) {
      // Keep the original session start time when resuming
      final startTime = _sessionStartTime ?? DateTime.now();
      emit(state.TimerRunning(
        duration: this.state.duration,
        sessionType: this.state.sessionType,
        startTime: startTime,
        completedSessions: this.state.completedSessions,
      ));
      _tickerSubscription?.resume();
    }
  }

  /// Handles the timer reset event.
  /// 
  /// Resets the current session's timer while preserving the session type
  /// and completed sessions count.
  Future<void> _onReset(
    event.TimerReset resetEvent,
    Emitter<state.TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    _sessionStartTime = null;
    
    // Determine duration based on current session type
    int duration;
    switch (this.state.sessionType) {
      case SessionType.work:
        duration = settings.workDuration * 60;
        break;
      case SessionType.shortBreak:
        duration = settings.shortBreakDuration * 60;
        break;
      case SessionType.longBreak:
        duration = settings.longBreakDuration * 60;
        break;
    }
    
    // Reset to initial state but keep current session type and completed sessions
    emit(state.TimerInitial(
      duration: duration,
      sessionType: this.state.sessionType,
      completedSessions: this.state.completedSessions,
    ));
  }

  /// Handles timer tick events (called every second).
  Future<void> _onTicked(
    event.TimerTicked tickEvent,
    Emitter<state.TimerState> emit,
  ) async {
    if (tickEvent.duration > 0) {
      emit(state.TimerRunning(
        duration: tickEvent.duration,
        sessionType: this.state.sessionType,
        startTime: (this.state as state.TimerRunning).startTime,
        completedSessions: this.state.completedSessions,
      ));
    } else {
      add(const event.TimerCompleted());
    }
  }

  /// Handles timer completion event.
  /// 
  /// Determines the next session type and transitions accordingly.
  Future<void> _onCompleted(
    event.TimerCompleted completedEvent,
    Emitter<state.TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    
    final completedType = this.state.sessionType;
    final sessionEndTime = DateTime.now();
    int newCompletedSessions = this.state.completedSessions;
    SessionType nextSessionType;
    int nextDuration;

    // Save completed session to statistics with actual elapsed time
    if (_sessionStartTime != null) {
      final actualDuration = sessionEndTime.difference(_sessionStartTime!);
      final actualMinutes = (actualDuration.inSeconds / 60).ceil();
      
      final session = TimerSession.create(
        sessionType: completedType,
        startTime: _sessionStartTime!,
        endTime: sessionEndTime,
        durationInMinutes: actualMinutes,
      );
      await statisticsRepository.addSession(session);
    }

    // Determine next session type based on current session
    if (completedType == SessionType.work) {
      newCompletedSessions++;
      
      // Check if it's time for a long break
      if (newCompletedSessions >= settings.sessionsBeforeLongBreak) {
        nextSessionType = SessionType.longBreak;
        nextDuration = settings.longBreakDuration * 60;
        newCompletedSessions = 0; // Reset counter after long break
      } else {
        nextSessionType = SessionType.shortBreak;
        nextDuration = settings.shortBreakDuration * 60;
      }
      
      // Show notification and play sound
      await notificationService.showWorkSessionComplete();
      await audioService.playCompletionSound();
    } else {
      // Break completed, return to work
      nextSessionType = SessionType.work;
      nextDuration = settings.workDuration * 60;
      
      // Show appropriate break completion notification
      if (completedType == SessionType.shortBreak) {
        await notificationService.showShortBreakComplete();
      } else {
        await notificationService.showLongBreakComplete();
      }
      await audioService.playBreakSound();
    }

    // Emit completed state briefly, then transition to next session
    emit(state.TimerCompleted(
      duration: nextDuration,
      sessionType: nextSessionType,
      completedSessionType: completedType,
      completedSessions: newCompletedSessions,
    ));

    // Auto-transition to initial state for next session after a brief delay
    await Future.delayed(const Duration(seconds: 2));
    
    emit(state.TimerInitial(
      duration: nextDuration,
      sessionType: nextSessionType,
      completedSessions: newCompletedSessions,
    ));
  }

  /// Handles skip event to manually move to next session.
  Future<void> _onSkipped(
    event.TimerSkipped skipEvent,
    Emitter<state.TimerState> emit,
  ) async {
    _tickerSubscription?.cancel();
    
    // Treat as if current session completed
    add(const event.TimerCompleted());
  }

  /// Handles settings update event.
  /// 
  /// Updates the timer duration based on current state:
  /// - Initial: Updates duration immediately
  /// - Running/Paused: Adjusts duration proportionally to maintain progress percentage
  Future<void> _onSettingsUpdated(
    event.TimerSettingsUpdated settingsEvent,
    Emitter<state.TimerState> emit,
  ) async {
    // Calculate old total duration for the current session type
    int oldTotalDuration;
    switch (this.state.sessionType) {
      case SessionType.work:
        oldTotalDuration = settings.workDuration * 60;
        break;
      case SessionType.shortBreak:
        oldTotalDuration = settings.shortBreakDuration * 60;
        break;
      case SessionType.longBreak:
        oldTotalDuration = settings.longBreakDuration * 60;
        break;
    }
    
    // Update the internal settings object to be used in future session transitions
    settings = TimerSettings(
      workDuration: settingsEvent.workDuration,
      shortBreakDuration: settingsEvent.shortBreakDuration,
      longBreakDuration: settingsEvent.longBreakDuration,
      sessionsBeforeLongBreak: settingsEvent.sessionsBeforeLongBreak,
    );
    
    // Calculate new total duration for the current session type
    int newTotalDuration;
    switch (this.state.sessionType) {
      case SessionType.work:
        newTotalDuration = settingsEvent.workDuration * 60;
        break;
      case SessionType.shortBreak:
        newTotalDuration = settingsEvent.shortBreakDuration * 60;
        break;
      case SessionType.longBreak:
        newTotalDuration = settingsEvent.longBreakDuration * 60;
        break;
    }
    
    if (this.state is state.TimerInitial) {
      // Timer is idle - update duration immediately
      
      emit(state.TimerInitial(
        duration: newTotalDuration,
        sessionType: this.state.sessionType,
        completedSessions: this.state.completedSessions,
      ));
    } else if (this.state is state.TimerRunning) {
      // Timer is running - use absolute elapsed time
      final currentState = this.state as state.TimerRunning;
      
      // Calculate elapsed time in seconds
      final elapsedSeconds = oldTotalDuration - currentState.duration;
      
      // Calculate new remaining duration
      final newRemainingDuration = newTotalDuration - elapsedSeconds;
      
      
      // If elapsed time >= new duration, complete the session immediately
      if (newRemainingDuration <= 0) {
        _tickerSubscription?.cancel();
        add(const event.TimerCompleted());
        return;
      }
      
      // Cancel current ticker and start new one with adjusted duration
      _tickerSubscription?.cancel();
      
      emit(state.TimerRunning(
        duration: newRemainingDuration,
        sessionType: currentState.sessionType,
        startTime: currentState.startTime,
        completedSessions: currentState.completedSessions,
      ));
      
      // Restart ticker with new duration
      _tickerSubscription = _ticker(newRemainingDuration).listen(
        (duration) => add(event.TimerTicked(duration)),
      );
    } else if (this.state is state.TimerPaused) {
      // Timer is paused - use absolute elapsed time
      final currentState = this.state as state.TimerPaused;
      
      // Calculate elapsed time in seconds
      final elapsedSeconds = oldTotalDuration - currentState.duration;
      
      // Calculate new remaining duration
      final newRemainingDuration = newTotalDuration - elapsedSeconds;
      
      
      // If elapsed time >= new duration, set remaining to 0 (will complete when resumed/started)
      final adjustedDuration = newRemainingDuration <= 0 ? 0 : newRemainingDuration;
      
      emit(state.TimerPaused(
        duration: adjustedDuration,
        sessionType: currentState.sessionType,
        completedSessions: currentState.completedSessions,
      ));
    }
  }

  /// Creates a stream that emits decreasing duration values every second.
  Stream<int> _ticker(int initialDuration) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (computationCount) => initialDuration - computationCount - 1,
    ).takeWhile((duration) => duration >= 0);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }
}
