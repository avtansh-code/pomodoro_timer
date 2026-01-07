import 'package:flutter/material.dart';

/// Screen displaying the app's privacy policy.
///
/// Explains how user data is handled and stored.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Icon(Icons.privacy_tip_outlined, size: 64, color: Colors.blue),
          const SizedBox(height: 24),
          Text(
            'Your Privacy Matters',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: January 8, 2026',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          _buildSection(
            context,
            title: 'Data Collection',
            content:
                'This app stores all data locally on your device. We do not collect, transmit, or store any of your personal information on external servers.',
          ),

          const SizedBox(height: 20),

          _buildSection(
            context,
            title: 'What We Store Locally',
            content:
                '• Timer settings (work duration, break duration, etc.)\n'
                '• Session history and statistics (stored in Hive database)\n'
                '• App preferences (theme, notifications, via SharedPreferences)\n\n'
                'All this data remains on your device and is never shared.',
          ),

          const SizedBox(height: 20),

          _buildSection(
            context,
            title: 'Permissions',
            content:
                'The app may request the following permissions:\n\n'
                '• Notifications: To alert you when timer sessions complete\n'
                '• Vibration: For haptic feedback on interactions\n\n'
                'These permissions are only used for app functionality and never for tracking.',
          ),

          const SizedBox(height: 20),

          _buildSection(
            context,
            title: 'Third-Party Services',
            content:
                'This app does not use any third-party analytics, advertising, or tracking services. Your usage data stays private.',
          ),

          const SizedBox(height: 20),

          _buildSection(
            context,
            title: 'Data Deletion',
            content:
                'You can delete all app data at any time by:\n'
                '• Clearing statistics in the Statistics screen\n'
                '• Resetting settings to defaults in the Settings screen\n'
                '• Uninstalling the app',
          ),

          const SizedBox(height: 20),

          _buildSection(
            context,
            title: 'Children\'s Privacy',
            content:
                'This app does not knowingly collect data from anyone, including children under 13. All data stays on the device.',
          ),

          const SizedBox(height: 20),

          _buildSection(
            context,
            title: 'Changes to This Policy',
            content:
                'We may update this privacy policy from time to time. Any changes will be reflected in the app with an updated date.',
          ),

          const SizedBox(height: 32),

          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your data never leaves your device',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
