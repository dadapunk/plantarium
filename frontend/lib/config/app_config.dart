import 'package:plantarium/config/env_config.dart';
import 'package:plantarium/config/env_loader.dart';

/// Global application configuration
class AppConfig {
  static late EnvConfig _config;

  /// Initialize the application configuration
  static Future<void> initialize(final Environment env) async {
    // Load environment variables first
    await EnvLoader.load(env.name);

    // Then initialize the config
    _config = await EnvConfig.getConfig(env);
  }

  /// Get the current environment configuration
  static EnvConfig get config => _config;

  /// Check if the app is running in development mode
  static bool get isDevelopment => _config.isDev;

  /// Check if the app is running in production mode
  static bool get isProduction => _config.isProd;
}
