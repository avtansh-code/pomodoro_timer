import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await setupServiceLocator();
  
  runApp(const PomodoroApp());
}
