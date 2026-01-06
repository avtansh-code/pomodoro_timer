import 'package:flutter/material.dart';
import '../../bloc/timer_state.dart' as state;

/// A chip that displays the current timer state (Ready, Running, Paused).
/// 
/// Matches the state indicator design from iOS/Android legacy apps.
class StateIndicatorChip extends StatelessWidget {
  final state.TimerState timerState;
  final Color color;

  const StateIndicatorChip({
    super.key,
    required this.timerState,
    required this.color,
  });

  /// Gets the state text based on timer state
  String get _stateText {
    if (timerState is state.TimerRunning) {
      return 'Running';
    } else if (timerState is state.TimerPaused) {
      return 'Paused';
    } else if (timerState is state.TimerCompleted) {
      return 'Complete';
    } else {
      return 'Ready';
    }
  }

  /// Gets the indicator dot color
  Color get _dotColor {
    if (timerState is state.TimerRunning) {
      return Colors.green;
    } else if (timerState is state.TimerPaused) {
      return const Color(0xFFFF9500); // Orange
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0.7,
        end: timerState is state.TimerRunning ? 1.0 : 0.85,
      ),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated dot indicator
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: 1.0,
                end: timerState is state.TimerRunning ? 1.0 : 0.6,
              ),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _dotColor,
                      shape: BoxShape.circle,
                      boxShadow: timerState is state.TimerRunning
                          ? [
                              BoxShadow(
                                color: _dotColor.withValues(alpha: 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              _stateText,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
