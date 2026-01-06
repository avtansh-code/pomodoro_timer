import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/service_locator.dart';
import '../core/services/persistence_service.dart';
import '../features/settings/bloc/settings_cubit.dart';
import '../features/timer/view/main_timer_screen.dart';

/// Root application widget.
/// 
/// Provides global BLoCs/Cubits and sets up theme.
class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(getIt<PersistenceService>()),
      child: MaterialApp(
        title: 'Pomodoro Timer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const MainTimerScreen(),
      ),
    );
  }
}
