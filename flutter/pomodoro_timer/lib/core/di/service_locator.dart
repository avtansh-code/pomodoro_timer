import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/persistence_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';

/// Global service locator instance.
/// 
/// This provides access to registered services throughout the application.
/// Using GetIt allows for easy dependency injection and testing.
final getIt = GetIt.instance;

/// Initializes all services and registers them with the service locator.
/// 
/// This function should be called once at app startup before runApp().
/// It sets up all dependencies in the correct order, ensuring that
/// services that depend on other services are initialized properly.
Future<void> setupServiceLocator() async {
  // Register SharedPreferences as a singleton
  // This needs to be initialized asynchronously
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register PersistenceService
  // Depends on SharedPreferences for storing settings
  getIt.registerLazySingleton<PersistenceService>(
    () => PersistenceService(getIt<SharedPreferences>()),
  );

  // Register NotificationService
  // Handles local notifications for timer completion
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );

  // Register AudioService
  // Handles sound playback for timer events
  getIt.registerLazySingleton<AudioService>(
    () => AudioService(),
  );

  // Initialize services that require async setup
  await getIt<NotificationService>().initialize();
}

/// Resets the service locator (useful for testing).
/// 
/// This removes all registered instances and allows for
/// fresh registration in test scenarios.
Future<void> resetServiceLocator() async {
  await getIt.reset();
}
