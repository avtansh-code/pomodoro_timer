import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/statistics_repository.dart';
import 'statistics_state.dart';

/// Cubit for managing statistics state.
///
/// Handles loading and filtering of timer session statistics.
class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsCubit(this._repository) : super(StatisticsState.initial()) {
    loadStatistics();
  }

  /// Loads statistics based on current filter.
  Future<void> loadStatistics() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final sessions = switch (state.filter) {
        StatisticsFilter.today => _repository.getTodaySessions(),
        StatisticsFilter.week => _repository.getWeekSessions(),
        StatisticsFilter.month => _repository.getMonthSessions(),
        StatisticsFilter.all => _repository.getAllSessions(),
      };

      emit(state.copyWith(sessions: sessions, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load statistics: $e',
        ),
      );
    }
  }

  /// Changes the filter and reloads statistics.
  Future<void> changeFilter(StatisticsFilter filter) async {
    emit(state.copyWith(filter: filter));
    await loadStatistics();
  }

  /// Refreshes statistics (re-loads current filter).
  Future<void> refresh() async {
    await loadStatistics();
  }

  /// Clears all statistics (with confirmation recommended in UI).
  Future<void> clearAllStatistics() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      await _repository.clearAllSessions();

      emit(state.copyWith(sessions: [], isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to clear statistics: $e',
        ),
      );
    }
  }

  /// Clears any error message.
  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
