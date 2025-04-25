import 'package:flutter/foundation.dart';

/// Environment types for the application
enum Environment {
  dev,
  prod,
}

/// Configuration class for environment-specific settings
class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String weatherApiKey;
  final bool enableLogging;
  final bool useMockServices;
  final Duration timeoutDuration;
  final int maxRetryAttempts;

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
  factory EnvConfig.development() => const EnvConfig._(
        environment: Environment.dev,
        apiBaseUrl: 'http://localhost:3000',
        weatherApiKey:
            String.fromEnvironment('WEATHER_API_KEY', defaultValue: 'dev_key'),
        enableLogging: true,
        useMockServices: true,
        timeoutDuration: Duration(seconds: 30),
        maxRetryAttempts: 3,
      );

  /// Production environment configuration
  factory EnvConfig.production() => const EnvConfig._(
        environment: Environment.prod,
        apiBaseUrl: 'https://api.plantarium.app',
        weatherApiKey: String.fromEnvironment('WEATHER_API_KEY'),
        enableLogging: false,
        useMockServices: false,
        timeoutDuration: Duration(seconds: 30),
        maxRetryAttempts: 3,
      );

  /// Get configuration based on the current environment
  static EnvConfig getConfig(Environment env) {
    switch (env) {
      case Environment.dev:
        return EnvConfig.development();
      case Environment.prod:
        return EnvConfig.production();
    }
  }

  /// Check if the current environment is development
  bool get isDev => environment == Environment.dev;

  /// Check if the current environment is production
  bool get isProd => environment == Environment.prod;

  @override
  String toString() {
    return '''
    Environment: ${environment.name}
    API Base URL: $apiBaseUrl
    Logging Enabled: $enableLogging
    Mock Services: $useMockServices
    Timeout Duration: $timeoutDuration
    Max Retry Attempts: $maxRetryAttempts
    ''';
  }
}
