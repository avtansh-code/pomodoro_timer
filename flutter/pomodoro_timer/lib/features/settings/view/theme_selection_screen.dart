import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_theme.dart';

/// Theme selection screen for changing app theme and color scheme.
///
/// Allows users to:
/// - Switch between light/dark/system theme modes
/// - Select different color schemes (future enhancement)
class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ThemeSelectionView();
  }
}

class _ThemeSelectionView extends StatelessWidget {
  const _ThemeSelectionView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Theme'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.05),
              theme.colorScheme.secondary.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Theme Mode Section
            _buildThemeModeSection(context),

            const SizedBox(height: 24),

            // Info Card
            _buildInfoCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Icon(
                Icons.brightness_6,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'THEME MODE',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildThemeModeOption(
                    context: context,
                    icon: Icons.light_mode,
                    iconColor: Colors.amber,
                    title: 'Light',
                    subtitle: 'Bright and clear interface',
                    themeMode: ThemeMode.light,
                    currentMode: state.themeMode,
                  ),
                  const Divider(height: 1),
                  _buildThemeModeOption(
                    context: context,
                    icon: Icons.dark_mode,
                    iconColor: Colors.indigo,
                    title: 'Dark',
                    subtitle: 'Easy on the eyes',
                    themeMode: ThemeMode.dark,
                    currentMode: state.themeMode,
                  ),
                  const Divider(height: 1),
                  _buildThemeModeOption(
                    context: context,
                    icon: Icons.brightness_auto,
                    iconColor: Colors.blue,
                    title: 'System',
                    subtitle: 'Follow device settings',
                    themeMode: ThemeMode.system,
                    currentMode: state.themeMode,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThemeModeOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required ThemeMode themeMode,
    required ThemeMode currentMode,
  }) {
    final isSelected = themeMode == currentMode;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        context.read<ThemeCubit>().setThemeMode(themeMode);
      },
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.15),
            Colors.blue.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'The theme will be applied immediately. System mode follows your device\'s appearance settings.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}