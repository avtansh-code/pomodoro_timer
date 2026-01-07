import 'package:equatable/equatable.dart';
import '../../../core/models/timer_session.dart';

/// Filter for displaying statistics
enum StatisticsFilter { today, week, month, all }

/// State for the statistics feature.
///
/// Contains filtered sessions and aggregate statistics.
class StatisticsState extends Equatable {
  /// List of filtered sessions
  final List<TimerSession> sessions;

  /// Current filter being applied
  final StatisticsFilter filter;

  /// Whether statistics are being loaded
  final bool isLoading;

  /// Error message if something went wrong
  final String? errorMessage;

  const StatisticsState({
    required this.sessions,
    required this.filter,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Creates the initial state
  factory StatisticsState.initial() {
    return const StatisticsState(
      sessions: [],
      filter: StatisticsFilter.all,
      isLoading: true,
    );
  }

  /// Calculates total work sessions
  int get workSessionCount {
    return sessions
        .where((session) => session.sessionType == SessionType.work)
        .length;
  }

  /// Calculates total focus time in minutes
  int get totalFocusTime {
    return sessions
        .where((session) => session.sessionType == SessionType.work)
        .fold<int>(0, (total, session) => total + session.durationInMinutes);
  }

  /// Calculates total break time in minutes
  int get totalBreakTime {
    return sessions
        .where((session) => session.sessionType != SessionType.work)
        .fold<int>(0, (total, session) => total + session.durationInMinutes);
  }

  /// Gets work sessions grouped by date
  Map<DateTime, List<TimerSession>> get sessionsByDate {
    final Map<DateTime, List<TimerSession>> grouped = {};

    for (final session in sessions) {
      final date = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(session);
    }

    return grouped;
  }

  /// Creates a copy with updated values
  StatisticsState copyWith({
    List<TimerSession>? sessions,
    StatisticsFilter? filter,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StatisticsState(
      sessions: sessions ?? this.sessions,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [sessions, filter, isLoading, errorMessage];
}
