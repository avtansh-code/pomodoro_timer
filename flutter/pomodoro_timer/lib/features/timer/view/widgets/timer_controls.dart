import 'package:flutter/material.dart';
import '../../bloc/timer_bloc.dart';
import '../../bloc/timer_event.dart' as event;
import '../../bloc/timer_state.dart' as state;

/// Widget that provides control buttons for the timer.
/// 
/// Shows different buttons based on the current timer state:
/// - Start button when timer is initial
/// - Pause/Resume buttons when timer is running/paused
/// - Reset and Skip buttons as secondary actions
class TimerControls extends StatelessWidget {
  /// Current timer state
  final state.TimerState timerState;
  
  /// Callback to add events to the TimerBloc
  final void Function(event.TimerEvent) onEventAdded;

  const TimerControls({
    super.key,
    required this.timerState,
    required this.onEventAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary action button (Start/Pause/Resume)
        _buildPrimaryButton(context),
        
        const SizedBox(height: 16),
        
        // Secondary action buttons (Reset/Skip)
        if (timerState is! state.TimerInitial)
          _buildSecondaryButtons(context),
      ],
    );
  }

  /// Builds the main action button based on current state
  Widget _buildPrimaryButton(BuildContext context) {
    if (timerState is state.TimerInitial || timerState is state.TimerCompleted) {
      // Show Start button
      return ElevatedButton.icon(
        onPressed: () => onEventAdded(
          event.TimerStarted(timerState.duration),
        ),
        icon: const Icon(Icons.play_arrow, size: 32),
        label: const Text('Start'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    } else if (timerState is state.TimerRunning) {
      // Show Pause button
      return ElevatedButton.icon(
        onPressed: () => onEventAdded(const event.TimerPaused()),
        icon: const Icon(Icons.pause, size: 32),
        label: const Text('Pause'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    } else if (timerState is state.TimerPaused) {
      // Show Resume button
      return ElevatedButton.icon(
        onPressed: () => onEventAdded(const event.TimerResumed()),
        icon: const Icon(Icons.play_arrow, size: 32),
        label: const Text('Resume'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  /// Builds secondary action buttons
  Widget _buildSecondaryButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        OutlinedButton.icon(
          onPressed: () => onEventAdded(const event.TimerReset()),
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Skip button
        OutlinedButton.icon(
          onPressed: () => onEventAdded(const event.TimerSkipped()),
          icon: const Icon(Icons.skip_next),
          label: const Text('Skip'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
