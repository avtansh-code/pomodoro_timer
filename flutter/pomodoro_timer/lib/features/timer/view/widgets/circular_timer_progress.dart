import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A circular progress indicator with timer display, matching iOS/Android legacy apps.
///
/// Features:
/// - Animated circular progress arc
/// - Timer text centered inside
/// - Optional state indicator chip
/// - Customizable colors and sizes
class CircularTimerProgress extends StatelessWidget {
  /// Progress from 0.0 to 1.0
  final double progress;

  /// Time remaining in MM:SS format
  final String timeText;

  /// Color of the progress arc
  final Color color;

  /// Diameter of the circle
  final double size;

  /// Width of the progress arc stroke
  final double strokeWidth;

  /// Optional state indicator widget shown below timer
  final Widget? stateIndicator;

  const CircularTimerProgress({
    super.key,
    required this.progress,
    required this.timeText,
    required this.color,
    this.size = 300.0,
    this.strokeWidth = 16.0,
    this.stateIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shadow/Glow effect layer (iOS-style) - transparent container for glow only
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent, // Transparent background
              boxShadow: [
                // Subtle colored glow effect
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Circular progress indicator
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 0, end: progress),
            builder: (context, value, _) {
              return CustomPaint(
                size: Size(size, size),
                painter: _CircularProgressPainter(
                  progress: value,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15), // Lighter track
                  strokeWidth: strokeWidth,
                ),
              );
            },
          ),

          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer text
              Text(
                timeText,
                style: TextStyle(
                  fontSize: size * 0.20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFeatures: const [
                    FontFeature.tabularFigures(), // Monospaced digits
                  ],
                  letterSpacing: 2,
                ),
              ),

              // State indicator
              if (stateIndicator != null) ...[
                SizedBox(height: size * 0.04),
                stateIndicator!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the circular progress arc
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Start from top (-90 degrees = -π/2 radians)
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
