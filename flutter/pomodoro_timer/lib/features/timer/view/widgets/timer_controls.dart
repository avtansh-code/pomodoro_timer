import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
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
/// Enhanced with scale animations and improved styling matching legacy apps.
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

  Color _getSessionColor(BuildContext context) {
    switch (timerState.sessionType) {
      case SessionType.work:
        return Theme.of(context).colorScheme.primary;
      case SessionType.shortBreak:
        return const Color(0xFF34C759);
      case SessionType.longBreak:
        return const Color(0xFF007AFF);
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
        Vibration.vibrate(duration: 50);
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
        height: 64,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
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
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
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
    return _ScaleButton(
      onPressed: () {
        Vibration.vibrate(duration: 30);
        onEventAdded(const event.TimerReset());
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: sessionColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.refresh, color: sessionColor, size: 28),
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
