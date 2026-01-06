import 'package:flutter/material.dart';

/// Screen explaining the benefits of the Pomodoro Technique.
/// 
/// Provides information about how the technique works and its advantages.
class PomodoroBenefitsScreen extends StatelessWidget {
  const PomodoroBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Pomodoro Technique'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Header
          const Icon(
            Icons.lightbulb,
            size: 80,
            color: Colors.orange,
          ),
          const SizedBox(height: 24),
          Text(
            'The Pomodoro Technique',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // What is it?
          _buildSection(
            context,
            icon: Icons.info_outline,
            title: 'What is it?',
            content:
                'The Pomodoro Technique is a time management method that uses a timer to break work into intervals, traditionally 25 minutes in length, separated by short breaks.',
          ),
          
          const SizedBox(height: 24),
          
          // How it works
          _buildSection(
            context,
            icon: Icons.schedule,
            title: 'How it works',
            content:
                '1. Choose a task\n'
                '2. Set the timer to 25 minutes\n'
                '3. Work until the timer rings\n'
                '4. Take a short break (5 minutes)\n'
                '5. After 4 Pomodoros, take a longer break (15-30 minutes)',
          ),
          
          const SizedBox(height: 24),
          
          // Benefits
          _buildSection(
            context,
            icon: Icons.star,
            title: 'Benefits',
            content:
                '• Improved focus and concentration\n'
                '• Reduced mental fatigue\n'
                '• Better time awareness\n'
                '• Increased productivity\n'
                '• Reduced burnout\n'
                '• Better work-life balance',
          ),
          
          const SizedBox(height: 32),
          
          // Get Started Button
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.check),
            label: const Text('Got it!'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
