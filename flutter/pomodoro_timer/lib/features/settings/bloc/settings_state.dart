import 'package:equatable/equatable.dart';
import '../../../core/models/timer_settings.dart';

/// State for the settings feature.
///
/// Contains the current timer settings and loading/error states.
class SettingsState extends Equatable {
  /// The current timer settings
  final TimerSettings settings;

  /// Whether settings are being loaded or saved
  final bool isLoading;

  /// Error message if something went wrong
  final String? errorMessage;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Creates the initial state with default settings
  factory SettingsState.initial() {
    return const SettingsState(settings: TimerSettings(), isLoading: true);
  }

  /// Creates a copy with updated values
  SettingsState copyWith({
    TimerSettings? settings,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [settings, isLoading, errorMessage];
}
