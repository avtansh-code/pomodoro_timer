import 'package:flutter/material.dart';
import '../../../../core/models/timer_session.dart';

/// Widget that displays the timer countdown in a large, readable format.
/// 
/// Shows minutes and seconds in MM:SS format with appropriate styling
/// based on the current session type.
class TimerDisplay extends StatelessWidget {
  /// Duration to display in seconds
  final int duration;
  
  /// Current session type (affects color and style)
  final SessionType sessionType;

  const TimerDisplay({
    super.key,
    required this.duration,
    required this.sessionType,
  });

  /// Formats seconds into MM:SS format
  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Gets the color based on session type
  Color _getSessionColor(BuildContext context) {
    switch (sessionType) {
      case SessionType.work:
        return Theme.of(context).colorScheme.primary;
      case SessionType.shortBreak:
        return Colors.green;
      case SessionType.longBreak:
        return Colors.blue;
    }
  }

  /// Gets the session label
  String _getSessionLabel() {
    switch (sessionType) {
      case SessionType.work:
        return 'Focus Time';
      case SessionType.shortBreak:
        return 'Short Break';
      case SessionType.longBreak:
        return 'Long Break';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSessionColor(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Session type label
        Text(
          _getSessionLabel(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 24),
        
        // Timer display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Text(
            _formatDuration(duration),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 72,
                  letterSpacing: 4,
                ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Progress indicator
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: _getProgress(),
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  /// Calculates progress based on session type and duration
  double _getProgress() {
    // This would need the total duration to calculate properly
    // For now, return a placeholder
    // In a real implementation, you'd pass the total duration as a parameter
    return 0.5;
  }
}
