import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/pomodoro_theme_cubit.dart';
import '../../../../core/models/timer_session.dart';
import '../../bloc/timer_event.dart' as event;
import '../../bloc/timer_state.dart' as state;

/// Widget that provides control buttons for the timer.
///
/// Shows different buttons based on the current timer state:
/// - Start button when timer is initial
/// - Pause/Resume buttons when timer is running/paused
/// - Reset and Skip buttons as secondary actions
///
/// Enhanced with scale animations, improved styling matching legacy apps,
/// and responsive sizing for different screen sizes.
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

  /// Calculates responsive scale factor based on screen size
  /// Returns a multiplier (1.0 for phones, up to 1.5 for large screens)
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

  /// Gets color based on session type using theme's primary color with variations
  Color _getSessionColor(BuildContext context) {
    final appTheme = context.read<PomodoroThemeCubit>().state.currentTheme;
    final primaryColor = appTheme.primaryColor;

    switch (timerState.sessionType) {
      case SessionType.work:
        // Full primary color for focus
        return primaryColor;
      case SessionType.shortBreak:
        // Lighter tint of primary for short break
        return Color.lerp(primaryColor, Colors.white, 0.2) ?? primaryColor;
      case SessionType.longBreak:
        // Slightly darker shade of primary for long break
        return Color.lerp(primaryColor, Colors.black, 0.15) ?? primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionColor = _getSessionColor(context);

    return Row(
      children: [
        // Primary action button (Start/Pause/Resume)
        Expanded(child: _buildPrimaryButton(context, sessionColor)),

        const SizedBox(width: 16),

        // Reset button (always visible)
        _buildResetButton(context, sessionColor),
      ],
    );
  }

  /// Builds the main action button based on current state
  Widget _buildPrimaryButton(BuildContext context, Color sessionColor) {
    final scale = _getScaleFactor(context);
    final buttonHeight = 64.0 * scale;
    final iconSize = 28.0 * scale;
    final fontSize = 20.0 * scale;
    final borderRadius = 16.0 * scale;

    String label;
    IconData icon;
    Color backgroundColor;

    if (timerState is state.TimerInitial ||
        timerState is state.TimerCompleted) {
      label = 'Start';
      icon = Icons.play_arrow;
      backgroundColor = sessionColor;
    } else if (timerState is state.TimerRunning) {
      label = 'Pause';
      icon = Icons.pause;
      backgroundColor = const Color(0xFFFF9500); // Orange
    } else {
      label = 'Resume';
      icon = Icons.play_arrow;
      backgroundColor = sessionColor;
    }

    return _ScaleButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        if (timerState is state.TimerInitial ||
            timerState is state.TimerCompleted) {
          onEventAdded(event.TimerStarted(timerState.duration));
        } else if (timerState is state.TimerRunning) {
          onEventAdded(const event.TimerPaused());
        } else {
          onEventAdded(const event.TimerResumed());
        }
      },
      child: Container(
        height: buttonHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: iconSize),
            SizedBox(width: 12 * scale),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the reset button
  Widget _buildResetButton(BuildContext context, Color sessionColor) {
    final scale = _getScaleFactor(context);
    final buttonSize = 64.0 * scale;
    final iconSize = 28.0 * scale;
    final borderRadius = 16.0 * scale;

    return _ScaleButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onEventAdded(const event.TimerReset());
      },
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: sessionColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(Icons.refresh, color: sessionColor, size: iconSize),
      ),
    );
  }
}

/// Custom button widget with scale animation on press
class _ScaleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _ScaleButton({required this.onPressed, required this.child});

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
