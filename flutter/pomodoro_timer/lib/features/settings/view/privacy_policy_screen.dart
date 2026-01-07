import 'package:flutter/material.dart';

/// Privacy Policy screen displaying the app's privacy commitments.
///
/// Matches the iOS app's PrivacyPolicyView with comprehensive sections on:
/// - Data collection practices
/// - What we DON'T collect
/// - Data usage and security
/// - User rights
/// - Compliance information
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Text(
            'Privacy Policy',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mr. Pomodoro',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Effective Date: October 25, 2025',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'Last Updated: October 29, 2025',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Introduction
          _buildSection(
            theme: theme,
            title: 'Our Commitment to Privacy',
            content:
                'Mr. Pomodoro is designed with privacy as a core principle. We believe your productivity data should remain yours, stored securely on your device.',
          ),
          const SizedBox(height: 24),

          // What We Collect
          _buildDataCollectionSection(theme),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // What We DON'T Collect
          _buildWhatWeDoNotCollectSection(theme),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // How Data is Used
          _buildSection(
            theme: theme,
            title: 'How Your Data Is Used',
            content:
                'All data collected is used solely to:\n\n'
                '• Display your timer settings and preferences\n'
                '• Show your productivity statistics\n'
                '• Calculate streaks and performance metrics\n'
                '• Enable Siri Shortcuts integration',
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Data Security
          _buildSecuritySection(theme),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Your Rights
          _buildRightsSection(theme),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Compliance
          _buildComplianceSection(theme),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Children's Privacy
          _buildSection(
            theme: theme,
            title: "Children's Privacy",
            content:
                'Pomodoro Timer is not directed at children under 13 years of age. We do not knowingly collect personal information from children.',
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Contact
          _buildContactSection(theme),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Summary
          _buildSummarySection(theme),
          const SizedBox(height: 24),

          // Footer
          Text(
            'This Privacy Policy reflects our commitment to protecting your privacy. If you have questions or need clarification, please don\'t hesitate to contact us.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection({
    required ThemeData theme,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildDataCollectionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Data We Collect',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Locally Stored Data',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'The app stores the following information locally on your device only:',
        ),
        const SizedBox(height: 12),
        _buildBullet(
          'Timer Settings: Your preferences for focus duration, break lengths, sound/haptic settings, and theme',
        ),
        _buildBullet('Session History: Records of completed Pomodoro sessions'),
        _buildBullet(
          'Statistics: Calculated metrics from your session history',
        ),
        _buildBullet(
          'Focus Mode Settings: iOS Focus Mode integration preferences',
        ),
      ],
    );
  }

  Widget _buildWhatWeDoNotCollectSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What We DO NOT Collect',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildPrivacyFeature(Icons.block, 'No Analytics or Tracking'),
        _buildPrivacyFeature(Icons.block, 'No Third-Party Services'),
        _buildPrivacyFeature(Icons.block, 'No Advertising'),
        _buildPrivacyFeature(Icons.block, 'No Account Creation Required'),
        _buildPrivacyFeature(Icons.block, 'No Network Requests'),
        _buildPrivacyFeature(Icons.block, 'No Location Data'),
        _buildPrivacyFeature(Icons.block, 'No Contact Information'),
        _buildPrivacyFeature(Icons.block, 'No Camera or Photos Access'),
      ],
    );
  }

  Widget _buildSecuritySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Storage & Security',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildSecurityFeature(
          Icons.shield,
          'Local Storage',
          'Protected by platform sandboxing and your device\'s security features',
        ),
        const SizedBox(height: 12),
        _buildSecurityFeature(
          Icons.verified_user,
          'No Server Storage',
          'We do not store any data on our servers',
        ),
        const SizedBox(height: 12),
        _buildSecurityFeature(
          Icons.cloud_off,
          'No Cloud Sync',
          'All data stays on your device only',
        ),
      ],
    );
  }

  Widget _buildRightsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Rights & Control',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text('You have complete control over your data:'),
        const SizedBox(height: 12),
        _buildControlFeature(
          Icons.visibility,
          'Access',
          'View all settings and session history',
        ),
        _buildControlFeature(
          Icons.edit,
          'Modify',
          'Edit or update preferences anytime',
        ),
        _buildControlFeature(
          Icons.delete,
          'Delete',
          'Clear session history or reset all data',
        ),
        _buildControlFeature(
          Icons.download,
          'Export',
          'View session data in Statistics screen',
        ),
      ],
    );
  }

  Widget _buildComplianceSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compliance',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildComplianceBadge(
          'GDPR',
          'EU Privacy Rights',
          Icons.verified,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildComplianceBadge(
          'CCPA',
          'California Privacy Rights',
          Icons.verified,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildComplianceBadge(
          'Apple App Store',
          'Privacy Guidelines',
          Icons.verified,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Us',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'If you have questions or concerns about this Privacy Policy:',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.email, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'support@pomodorotimer.in',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Response Time: We aim to respond within 48 hours',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
              'What We Collect',
              'Timer settings and session history stored locally',
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'What We Don\'t Collect',
              'No analytics, no tracking, no personal information',
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'Your Control',
              'Full control to view, modify, and delete all data',
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'Data Storage',
              'All data stored locally on your device only',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildPrivacyFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildSecurityFeature(
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlFeature(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceBadge(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}
