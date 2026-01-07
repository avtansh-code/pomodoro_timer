import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

/// Educational screen explaining the Pomodoro Technique.
///
/// Matches the iOS app's PomodoroBenefitsView with:
/// - Origin story
/// - How it works (5 steps)
/// - Benefits
/// - Considerations
/// - Call-to-action
class PomodoroBenefitsScreen extends StatelessWidget {
  const PomodoroBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('The Pomodoro Way'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        color: Color.lerp(
          theme.scaffoldBackgroundColor,
          theme.colorScheme.primary,
          0.12,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              _buildHeader(theme),
            const SizedBox(height: 32),

            // History Section
            _buildHistorySection(theme),
            const SizedBox(height: 32),

            // How It Works
            _buildHowItWorksSection(theme),
            const SizedBox(height: 32),

            // Benefits
            _buildBenefitsSection(theme),
            const SizedBox(height: 32),

            // Considerations
            _buildConsiderationsSection(theme),
            const SizedBox(height: 32),

              // CTA
              _buildCTA(context, theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.2),
                theme.colorScheme.secondary.withValues(alpha: 0.15),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.timer, size: 44, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'The Power of Pomodoro',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Focus deeper. Work smarter. Rest better.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHistorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.book,
          title: 'The Origin Story',
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Card(
          color: theme.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The Pomodoro Technique was created in the late 1980s by Francesco Cirillo, an Italian university student seeking a better way to study and manage his time.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Named after the tomato-shaped kitchen timer (pomodoro means "tomato" in Italian) he used to track his work intervals, this simple yet powerful method has since helped millions worldwide achieve better focus and productivity.',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Born from necessity, perfected through practice',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.settings,
          title: 'How It Works',
          color: Colors.blue,
        ),
        const SizedBox(height: 8),
        Text(
          'The technique is simple, sustainable, and scientifically backed:',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        _buildStepCard(
          number: 1,
          title: 'Choose Your Task',
          description: 'Select a single task or project you want to focus on.',
          icon: Icons.check_circle,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          number: 2,
          title: 'Set the Timer',
          description: 'Start a 25-minute focus session (one "pomodoro").',
          icon: Icons.timer,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          number: 3,
          title: 'Work Without Distraction',
          description: 'Focus entirely on your task until the timer rings.',
          icon: Icons.psychology,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          number: 4,
          title: 'Take a Short Break',
          description: 'Rest for 5 minutes. Stretch, hydrate, or relax.',
          icon: Icons.coffee,
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildStepCard(
          number: 5,
          title: 'Repeat & Recharge',
          description: 'After 4 pomodoros, take a longer 15-30 minute break.',
          icon: Icons.refresh,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.star,
          title: 'Why It Works',
          color: Colors.orange,
        ),
        const SizedBox(height: 8),
        Text(
          'Research and millions of users have found these key benefits:',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        _buildBenefitCard(
          icon: Icons.visibility,
          title: 'Enhanced Focus',
          description:
              'Short, timed sessions help maintain deep concentration and prevent mental drift.',
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        _buildBenefitCard(
          icon: Icons.battery_full,
          title: 'Reduced Mental Fatigue',
          description:
              'Regular breaks prevent burnout and keep your mind fresh throughout the day.',
          color: Colors.green,
        ),
        const SizedBox(height: 12),
        _buildBenefitCard(
          icon: Icons.schedule,
          title: 'Better Time Awareness',
          description:
              'Learn to accurately estimate how long tasks take and plan more effectively.',
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildBenefitCard(
          icon: Icons.trending_up,
          title: 'Increased Motivation',
          description:
              'Small wins and completed sessions create positive momentum and build confidence.',
          color: Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildBenefitCard(
          icon: Icons.directions_walk,
          title: 'Sustainable Work Rhythm',
          description:
              'Balance focused work with restorative breaks for long-term productivity.',
          color: Colors.cyan,
        ),
        const SizedBox(height: 12),
        _buildBenefitCard(
          icon: Icons.back_hand,
          title: 'Distraction Management',
          description:
              'The commitment to 25 minutes helps you defer interruptions and stay on track.',
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildConsiderationsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.warning_amber,
          title: 'Things to Keep in Mind',
          color: Colors.orange,
        ),
        const SizedBox(height: 16),
        Card(
          color: theme.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildConsiderationRow(
                  icon: Icons.account_tree,
                  text:
                      'May interrupt deep creative flow states that benefit from longer unbroken periods.',
                ),
                const Divider(height: 24),
                _buildConsiderationRow(
                  icon: Icons.calendar_today,
                  text:
                      'The rigid structure might not suit all task types or work environments.',
                ),
                const Divider(height: 24),
                _buildConsiderationRow(
                  icon: Icons.people,
                  text:
                      'Collaborative work may require flexibility with timing to accommodate others.',
                ),
                const Divider(height: 24),
                _buildConsiderationRow(
                  icon: Icons.tune,
                  text:
                      'Feel free to adjust session lengths to find what works best for you!',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'The Pomodoro Technique is a tool, not a rule. Adapt it to your needs and workflow.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCTA(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Text(
          'Ready to experience the benefits?',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {
            Vibration.vibrate(duration: 50);
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Your First Pomodoro'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required int number,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsiderationRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.orange, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
