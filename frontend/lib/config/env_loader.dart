import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Handles loading environment-specific configuration from .env files
class EnvLoader {
  /// Load the appropriate .env file based on the environment
  static Future<void> load(final String env) async {
    final String fileName = '.env.$env';
    try {
      await dotenv.load(fileName: fileName);
      debugPrint('Environment loaded from $fileName');
    } catch (e) {
      debugPrint('Failed to load $fileName: $e');
      // Fallback to default .env
      try {
        await dotenv.load();
        debugPrint('Loaded fallback .env file');
      } catch (e) {
        debugPrint('Failed to load fallback .env file: $e');
      }
    }
  }

  /// Get a string value from the environment
  static String getString(final String key, {final String defaultValue = ''}) =>
      dotenv.env[key] ?? defaultValue;

  /// Get a boolean value from the environment
  static bool getBool(final String key, {final bool defaultValue = false}) {
    final value = dotenv.env[key]?.toLowerCase();
    if (value == null) return defaultValue;
    return value == 'true' || value == '1' || value == 'yes';
  }

  /// Get an integer value from the environment
  static int getInt(final String key, {final int defaultValue = 0}) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// Get a double value from the environment
  static double getDouble(final String key, {final double defaultValue = 0.0}) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return double.tryParse(value) ?? defaultValue;
  }

  /// Get a Duration value from the environment (in seconds)
  static Duration getDuration(
    final String key, {
    final int defaultSeconds = 30,
  }) {
    final seconds = getInt(key, defaultValue: defaultSeconds);
    return Duration(seconds: seconds);
  }
}
