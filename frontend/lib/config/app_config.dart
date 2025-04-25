import 'env_config.dart';

/// Global application configuration
class AppConfig {
  static late EnvConfig _config;

  /// Initialize the application configuration
  static void initialize(Environment env) {
    _config = EnvConfig.getConfig(env);
    assert(_config != null, 'Environment configuration must be initialized');
  }

  /// Get the current environment configuration
  static EnvConfig get config => _config;

  /// Check if the app is running in development mode
  static bool get isDevelopment => _config.isDev;

  /// Check if the app is running in production mode
  static bool get isProduction => _config.isProd;
}
