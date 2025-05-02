import 'package:flutter/foundation.dart';
import 'package:plantarium/config/env_loader.dart';

/// Environment types for the application
enum Environment { dev, prod }

/// Configuration class for environment-specific settings
class EnvConfig {
  const EnvConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.weatherApiKey,
    required this.enableLogging,
    required this.useMockServices,
    required this.timeoutDuration,
    required this.maxRetryAttempts,
  });

  /// Development environment configuration
  static Future<EnvConfig> development() async {
    return EnvConfig._(
      environment: Environment.dev,
      apiBaseUrl: EnvLoader.getString(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3002',
      ),
      weatherApiKey: EnvLoader.getString(
        'WEATHER_API_KEY',
        defaultValue: 'dev_key',
      ),
      enableLogging: EnvLoader.getBool('ENABLE_LOGGING', defaultValue: true),
      useMockServices: EnvLoader.getBool(
        'USE_MOCK_SERVICES',
        defaultValue: true,
      ),
      timeoutDuration: EnvLoader.getDuration(
        'TIMEOUT_DURATION',
        defaultSeconds: 30,
      ),
      maxRetryAttempts: EnvLoader.getInt('MAX_RETRY_ATTEMPTS', defaultValue: 3),
    );
  }

  /// Production environment configuration
  static Future<EnvConfig> production() async {
    return EnvConfig._(
      environment: Environment.prod,
      apiBaseUrl: EnvLoader.getString(
        'API_BASE_URL',
        defaultValue: 'https://api.plantarium.app',
      ),
      weatherApiKey: EnvLoader.getString('WEATHER_API_KEY', defaultValue: ''),
      enableLogging: EnvLoader.getBool('ENABLE_LOGGING', defaultValue: false),
      useMockServices: EnvLoader.getBool(
        'USE_MOCK_SERVICES',
        defaultValue: false,
      ),
      timeoutDuration: EnvLoader.getDuration(
        'TIMEOUT_DURATION',
        defaultSeconds: 30,
      ),
      maxRetryAttempts: EnvLoader.getInt('MAX_RETRY_ATTEMPTS', defaultValue: 3),
    );
  }

  final Environment environment;
  final String apiBaseUrl;
  final String weatherApiKey;
  final bool enableLogging;
  final bool useMockServices;
  final Duration timeoutDuration;
  final int maxRetryAttempts;

  /// Get configuration based on the current environment
  static Future<EnvConfig> getConfig(final Environment env) async {
    switch (env) {
      case Environment.dev:
        return await development();
      case Environment.prod:
        return await production();
    }
  }

  /// Check if the current environment is development
  bool get isDev => environment == Environment.dev;

  /// Check if the current environment is production
  bool get isProd => environment == Environment.prod;

  @override
  String toString() => '''
    Environment: ${environment.name}
    API Base URL: $apiBaseUrl
    Logging Enabled: $enableLogging
    Mock Services: $useMockServices
    Timeout Duration: $timeoutDuration
    Max Retry Attempts: $maxRetryAttempts
    ''';
}
