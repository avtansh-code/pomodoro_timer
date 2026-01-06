import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';
import 'core/models/timer_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(TimerSessionAdapter());
  Hive.registerAdapter(SessionTypeAdapter());
  
  // Initialize services
  await setupServiceLocator();
  
  runApp(const PomodoroApp());
}
