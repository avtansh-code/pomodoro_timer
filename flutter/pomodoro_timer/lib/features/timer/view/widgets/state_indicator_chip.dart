import 'package:flutter/material.dart';
import '../../bloc/timer_state.dart' as state;

/// A chip that displays the current timer state (Ready, Running, Paused).
///
/// Matches the state indicator design from iOS/Android legacy apps.
/// Supports responsive sizing for different screen sizes.
class StateIndicatorChip extends StatelessWidget {
  final state.TimerState timerState;
  final Color color;

  const StateIndicatorChip({
    super.key,
    required this.timerState,
    required this.color,
  });

  /// Calculates responsive scale factor based on screen size
  static double _getScaleFactor(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < 600) {
      return 1.0; // Phone
    } else if (shortestSide < 900) {
      // Tablet - scale 1.0 to 1.25
      return 1.0 + ((shortestSide - 600) / 300 * 0.25);
    } else {
      // Large screen - scale 1.25 to 1.5
      final scale = ((shortestSide - 900) / 500).clamp(0.0, 1.0);
      return 1.25 + (scale * 0.25);
    }
  }

  /// Gets the state text based on timer state (matching iOS)
  String get _stateText {
    if (timerState is state.TimerRunning) {
      return 'Active';
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
    final scale = _getScaleFactor(context);

    // Scaled dimensions
    final horizontalPadding = 16.0 * scale;
    final verticalPadding = 8.0 * scale;
    final borderRadius = 20.0 * scale;
    final dotSize = 8.0 * scale;
    final spacing = 8.0 * scale;
    final fontSize = 13.0 * scale;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0.7,
        end: timerState is state.TimerRunning ? 1.0 : 0.85,
      ),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(borderRadius), // Capsule shape
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
              builder: (context, animScale, child) {
                return Transform.scale(
                  scale: animScale,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
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
            SizedBox(width: spacing),
            Text(
              _stateText,
              style: TextStyle(
                fontSize: fontSize,
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
