import 'package:equatable/equatable.dart';

/// Model representing user-configurable timer settings.
///
/// This class stores the durations for work sessions, breaks, and the
/// number of work sessions before a long break. Uses [Equatable] for
/// value-based equality comparison.
class TimerSettings extends Equatable {
  /// Duration of a work/focus session in minutes
  final int workDuration;

  /// Duration of a short break in minutes
  final int shortBreakDuration;

  /// Duration of a long break in minutes
  final int longBreakDuration;

  /// Number of work sessions before a long break
  final int sessionsBeforeLongBreak;

  /// Whether to automatically start breaks after work sessions
  final bool autoStartBreaks;

  /// Whether to automatically start focus sessions after breaks
  final bool autoStartFocus;

  /// Whether notifications are enabled
  final bool notificationsEnabled;

  /// Whether sound is enabled
  final bool soundEnabled;

  /// Whether haptic feedback is enabled
  final bool hapticEnabled;

  /// Creates a [TimerSettings] instance with the given parameters.
  ///
  /// Defaults follow the traditional Pomodoro Technique:
  /// - 25 minutes of focused work
  /// - 5 minutes short break
  /// - 15 minutes long break
  /// - Long break after every 4 work sessions
  const TimerSettings({
    this.workDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.sessionsBeforeLongBreak = 4,
    this.autoStartBreaks = false,
    this.autoStartFocus = false,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.hapticEnabled = true,
  });

  /// Creates a copy of this [TimerSettings] with optionally updated values.
  TimerSettings copyWith({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
    bool? autoStartBreaks,
    bool? autoStartFocus,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? hapticEnabled,
  }) {
    return TimerSettings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak:
          sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }

  /// Converts this [TimerSettings] to a JSON map for persistence.
  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      'autoStartBreaks': autoStartBreaks,
      'autoStartFocus': autoStartFocus,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'hapticEnabled': hapticEnabled,
    };
  }

  /// Creates a [TimerSettings] instance from a JSON map.
  factory TimerSettings.fromJson(Map<String, dynamic> json) {
    return TimerSettings(
      workDuration: json['workDuration'] as int? ?? 25,
      shortBreakDuration: json['shortBreakDuration'] as int? ?? 5,
      longBreakDuration: json['longBreakDuration'] as int? ?? 15,
      sessionsBeforeLongBreak: json['sessionsBeforeLongBreak'] as int? ?? 4,
      autoStartBreaks: json['autoStartBreaks'] as bool? ?? false,
      autoStartFocus: json['autoStartFocus'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hapticEnabled: json['hapticEnabled'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [
    workDuration,
    shortBreakDuration,
    longBreakDuration,
    sessionsBeforeLongBreak,
    autoStartBreaks,
    autoStartFocus,
    notificationsEnabled,
    soundEnabled,
    hapticEnabled,
  ];

  @override
  String toString() {
    return 'TimerSettings(work: ${workDuration}m, shortBreak: ${shortBreakDuration}m, '
        'longBreak: ${longBreakDuration}m, sessionsBeforeLongBreak: $sessionsBeforeLongBreak, '
        'autoStartBreaks: $autoStartBreaks, autoStartFocus: $autoStartFocus, '
        'notifications: $notificationsEnabled, sound: $soundEnabled, haptic: $hapticEnabled)';
  }
}
