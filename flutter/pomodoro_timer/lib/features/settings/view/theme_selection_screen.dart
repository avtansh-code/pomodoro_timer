import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/theme/pomodoro_theme_cubit.dart';
import '../../../core/models/app_theme_model.dart';

/// Theme selection screen for changing app theme and color scheme.
///
/// Allows users to:
/// - Switch between light/dark/system theme modes
/// - Select different color schemes (Classic Red, Ocean Blue, etc.)
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
        title: const Text('Appearance'),
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
            // Color Scheme Section
            _buildColorSchemeSection(context),

            const SizedBox(height: 24),

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

  Widget _buildColorSchemeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Icon(
                Icons.palette,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'COLOR SCHEME',
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
          child: BlocBuilder<PomodoroThemeCubit, PomodoroThemeState>(
            builder: (context, state) {
              return Column(
                children: PomodoroThemes.allThemes.map((appTheme) {
                  final isLast =
                      appTheme == PomodoroThemes.allThemes.last;
                  return Column(
                    children: [
                      _buildColorSchemeOption(
                        context: context,
                        appTheme: appTheme,
                        currentTheme: state.currentTheme,
                      ),
                      if (!isLast) const Divider(height: 1),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            'Choose your preferred color scheme. All colors work with both light and dark modes.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorSchemeOption({
    required BuildContext context,
    required AppThemeModel appTheme,
    required AppThemeModel currentTheme,
  }) {
    final isSelected = appTheme.id == currentTheme.id;

    return ListTile(
      leading: _buildThemePreview(appTheme),
      title: Text(
        appTheme.name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: appTheme.primaryColor,
            )
          : null,
      onTap: () {
        context.read<PomodoroThemeCubit>().setTheme(appTheme);
      },
    );
  }

  /// Builds a theme preview with 3 colored circles matching iOS design
  Widget _buildThemePreview(AppThemeModel appTheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPreviewCircle(appTheme.primaryColor, 12),
        const SizedBox(width: 4),
        _buildPreviewCircle(appTheme.secondaryColor, 12),
        const SizedBox(width: 4),
        _buildPreviewCircle(appTheme.accentColor, 12),
      ],
    );
  }

  Widget _buildPreviewCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
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
                'BRIGHTNESS',
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
          const Icon(
            Icons.info_outline,
            color: Colors.blue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Changes apply immediately. The color scheme works with all brightness modes.',
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