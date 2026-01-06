import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/service_locator.dart';
import '../core/services/persistence_service.dart';
import '../features/settings/bloc/settings_cubit.dart';
import 'app_router.dart';
import 'theme/app_theme.dart';
import 'theme/themes.dart';

/// Root application widget.
///
/// Provides global BLoCs/Cubits and configures MaterialApp with
/// theme management and go_router navigation.
class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global Settings Provider
        BlocProvider(
          create: (context) => SettingsCubit(getIt<PersistenceService>()),
        ),
        // Global Theme Provider
        BlocProvider(create: (context) => ThemeCubit(getIt())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Pomodoro Timer',
            debugShowCheckedModeBanner: false,

            // Theme Configuration
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeState.themeMode,

            // Router Configuration
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
