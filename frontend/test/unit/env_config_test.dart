import 'package:flutter_test/flutter_test.dart';
import 'package:plantarium/config/env_config.dart';

void main() {
  group('EnvConfig Tests', () {
    test('development config has correct values', () {
      final config = EnvConfig.development();

      expect(config.environment, equals(Environment.dev));
      expect(config.enableLogging, isTrue);
      expect(config.useMockServices, isTrue);
      expect(config.apiBaseUrl, equals('http://localhost:3000'));
    });

    test('production config has correct values', () {
      final config = EnvConfig.production();

      expect(config.environment, equals(Environment.prod));
      expect(config.enableLogging, isFalse);
      expect(config.useMockServices, isFalse);
      expect(config.apiBaseUrl, equals('https://api.plantarium.app'));
    });

    test('isDev getter returns correct value', () {
      final devConfig = EnvConfig.development();
      final prodConfig = EnvConfig.production();

      expect(devConfig.isDev, isTrue);
      expect(prodConfig.isDev, isFalse);
    });

    test('isProd getter returns correct value', () {
      final devConfig = EnvConfig.development();
      final prodConfig = EnvConfig.production();

      expect(devConfig.isProd, isFalse);
      expect(prodConfig.isProd, isTrue);
    });
  });
}
