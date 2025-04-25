import 'package:flutter/foundation.dart';

/// Enum representing different environment types
enum Environment {
  development,
  staging,
  production,
}

/// Configuration class for environment-specific settings
class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final Duration timeoutDuration;
  final int maxRetries;

  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.timeoutDuration,
    required this.maxRetries,
  });

  /// Development environment configuration
  static final development = AppConfig._(
    environment: Environment.development,
    apiBaseUrl: 'http://localhost:3000',
    enableLogging: true,
    timeoutDuration: const Duration(seconds: 30),
    maxRetries: 3,
  );

  /// Staging environment configuration
  static final staging = AppConfig._(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.plantarium.app',
    enableLogging: true,
    timeoutDuration: const Duration(seconds: 30),
    maxRetries: 2,
  );

  /// Production environment configuration
  static final production = AppConfig._(
    environment: Environment.production,
    apiBaseUrl: 'https://api.plantarium.app',
    enableLogging: false,
    timeoutDuration: const Duration(seconds: 20),
    maxRetries: 1,
  );

  /// Current active configuration
  static late final AppConfig current;

  /// Initialize the configuration for the specified environment
  static void init(Environment env) {
    current = switch (env) {
      Environment.development => development,
      Environment.staging => staging,
      Environment.production => production,
    };

    debugPrint('AppConfig initialized for ${env.name} environment');
  }

  /// Check if the app is running in development mode
  bool get isDevelopment => environment == Environment.development;

  /// Check if the app is running in staging mode
  bool get isStaging => environment == Environment.staging;

  /// Check if the app is running in production mode
  bool get isProduction => environment == Environment.production;
}
