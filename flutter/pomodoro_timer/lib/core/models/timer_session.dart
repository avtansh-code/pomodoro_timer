import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'timer_session.g.dart';

/// Enum representing the type of timer session
@HiveType(typeId: 1)
enum SessionType {
  @HiveField(0)
  work,
  @HiveField(1)
  shortBreak,
  @HiveField(2)
  longBreak,
}

/// Model representing a completed timer session for statistics tracking.
/// 
/// This class records the details of each completed Pomodoro session,
/// including when it started, ended, and what type of session it was.
/// Uses Hive for local database persistence and Equatable for value equality.
@HiveType(typeId: 0)
class TimerSession extends Equatable {
  /// Unique identifier for the session
  @HiveField(0)
  final String id;
  
  /// Type of session (work, short break, or long break)
  @HiveField(1)
  final SessionType sessionType;
  
  /// When the session started
  @HiveField(2)
  final DateTime startTime;
  
  /// When the session ended
  @HiveField(3)
  final DateTime endTime;
  
  /// Actual duration of the session in minutes
  @HiveField(4)
  final int durationInMinutes;

  /// Creates a [TimerSession] instance with the given parameters.
  const TimerSession({
    required this.id,
    required this.sessionType,
    required this.startTime,
    required this.endTime,
    required this.durationInMinutes,
  });

  /// Factory constructor to create a session with auto-generated ID
  factory TimerSession.create({
    required SessionType sessionType,
    required DateTime startTime,
    required DateTime endTime,
    required int durationInMinutes,
  }) {
    return TimerSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sessionType: sessionType,
      startTime: startTime,
      endTime: endTime,
      durationInMinutes: durationInMinutes,
    );
  }

  /// Calculates the actual duration between start and end time
  Duration get actualDuration => endTime.difference(startTime);

  /// Returns true if this session was completed on the given date
  bool isOnDate(DateTime date) {
    return startTime.year == date.year &&
        startTime.month == date.month &&
        startTime.day == date.day;
  }

  /// Returns a human-readable description of the session type
  String get sessionTypeLabel {
    switch (sessionType) {
      case SessionType.work:
        return 'Work Session';
      case SessionType.shortBreak:
        return 'Short Break';
      case SessionType.longBreak:
        return 'Long Break';
    }
  }

  /// Converts this [TimerSession] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionType': sessionType.index,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationInMinutes': durationInMinutes,
    };
  }

  /// Creates a [TimerSession] instance from a JSON map
  factory TimerSession.fromJson(Map<String, dynamic> json) {
    return TimerSession(
      id: json['id'] as String,
      sessionType: SessionType.values[json['sessionType'] as int],
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationInMinutes: json['durationInMinutes'] as int,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sessionType,
        startTime,
        endTime,
        durationInMinutes,
      ];

  @override
  String toString() {
    return 'TimerSession(id: $id, type: $sessionTypeLabel, '
        'duration: ${durationInMinutes}m, started: $startTime)';
  }
}
