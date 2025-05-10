import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Enum representing different environment types
enum Environment { development, staging, production }

/// Configuration class for environment-specific settings
class AppConfig {
  const AppConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.timeoutDuration,
    required this.maxRetries,
  });
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final Duration timeoutDuration;
  final int maxRetries;

  /// Current active configuration
  static late final AppConfig current;

  /// Initialize the configuration for the specified environment
  static Future<void> init(final Environment env) async {
    // Load the appropriate .env file from assets
    final String assetPath = 'assets/env/.env.${env.name}';
    try {
      await dotenv.load(fileName: assetPath);
      debugPrint('Environment loaded from $assetPath');
    } catch (e) {
      debugPrint('Failed to load environment file: $e');
      // Proceed with default values
    }

    // Create the configuration using values from .env
    current = AppConfig._(
      environment: env,
      apiBaseUrl: _getString(
        'API_BASE_URL',
        defaultValue: _getDefaultApiUrl(env),
      ),
      enableLogging: _getBool(
        'ENABLE_LOGGING',
        defaultValue: env != Environment.production,
      ),
      timeoutDuration: Duration(
        seconds: _getInt(
          'TIMEOUT_DURATION',
          defaultValue: _getDefaultTimeout(env),
        ),
      ),
      maxRetries: _getInt('MAX_RETRIES', defaultValue: _getDefaultRetries(env)),
    );

    debugPrint('AppConfig initialized for ${env.name} environment');
  }

  /// Get string value from environment
  static String _getString(
    final String key, {
    required final String defaultValue,
  }) => dotenv.env[key] ?? defaultValue;

  /// Get boolean value from environment
  static bool _getBool(final String key, {required final bool defaultValue}) {
    final value = dotenv.env[key]?.toLowerCase();
    if (value == null) return defaultValue;
    return value == 'true' || value == '1' || value == 'yes';
  }

  /// Get integer value from environment
  static int _getInt(final String key, {required final int defaultValue}) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// Get default API URL based on environment
  static String _getDefaultApiUrl(final Environment env) => switch (env) {
    Environment.development => 'http://localhost:3002',
    Environment.staging => 'https://staging-api.plantarium.app',
    Environment.production => 'https://api.plantarium.app',
  };

  /// Get default timeout based on environment
  static int _getDefaultTimeout(final Environment env) => switch (env) {
    Environment.development => 30,
    Environment.staging => 30,
    Environment.production => 20,
  };

  /// Get default retries based on environment
  static int _getDefaultRetries(final Environment env) => switch (env) {
    Environment.development => 3,
    Environment.staging => 2,
    Environment.production => 1,
  };

  /// Check if the app is running in development mode
  bool get isDevelopment => environment == Environment.development;

  /// Check if the app is running in staging mode
  bool get isStaging => environment == Environment.staging;

  /// Check if the app is running in production mode
  bool get isProduction => environment == Environment.production;
}
