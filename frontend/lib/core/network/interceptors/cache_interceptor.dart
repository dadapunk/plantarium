import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

/// A simplified cache interceptor for Dio that enables basic offline access
class CacheInterceptor extends Interceptor {
  /// Creates a new cache interceptor
  ///
  /// [prefs] is the SharedPreferences instance to use for storage
  CacheInterceptor({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;
  static const String _cacheKeyPrefix = 'api_cache_';
  static const String _cacheTimeKeyPrefix = 'api_cache_time_';
  static const Duration _defaultMaxAge = Duration(
    hours: 24,
  ); // 24 hours for MVP

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method != 'GET') {
      return handler.next(options);
    }

    // Generate cache key and try to get cached response
    final cacheKey = _generateCacheKey(options);
    final cachedResponse = _getCachedResponse(cacheKey, options);

    if (cachedResponse != null) {
      if (kDebugMode) {
        print('🎯 Cache hit for ${options.path}');
      }
      return handler.resolve(cachedResponse);
    }

    if (kDebugMode) {
      print('💥 Cache miss for ${options.path}');
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    final Response response,
    final ResponseInterceptorHandler handler,
  ) async {
    // Only cache successful GET responses
    if (response.requestOptions.method != 'GET' ||
        response.statusCode == null ||
        response.statusCode! >= 400) {
      return handler.next(response);
    }

    // Cache the successful response
    final cacheKey = _generateCacheKey(response.requestOptions);
    _cacheResponse(cacheKey, response);

    // Continue with the response
    handler.next(response);
  }

  /// Invalidates all cached data
  Future<void> invalidateAllCache() async {
    if (kDebugMode) {
      print('🧹 Invalidating all cache');
    }

    final keys =
        _prefs
            .getKeys()
            .where(
              (key) =>
                  key.startsWith(_cacheKeyPrefix) ||
                  key.startsWith(_cacheTimeKeyPrefix),
            )
            .toList();

    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  /// Generates a cache key for a request
  String _generateCacheKey(final RequestOptions options) {
    final keyData = '${options.method}:${options.uri.toString()}';
    return md5.convert(utf8.encode(keyData)).toString();
  }

  /// Gets a cached response for a request
  Response<dynamic>? _getCachedResponse(
    final String cacheKey,
    final RequestOptions options,
  ) {
    try {
      // Check if we have a cached response
      final cacheDataString = _prefs.getString('$_cacheKeyPrefix$cacheKey');
      if (cacheDataString == null) {
        return null;
      }

      // Check if the cached response is expired
      final cacheTime = _prefs.getInt('$_cacheTimeKeyPrefix$cacheKey');
      if (cacheTime == null) {
        return null;
      }

      // Check expiration
      final now = DateTime.now().millisecondsSinceEpoch;
      final expirationTime = cacheTime + _defaultMaxAge.inMilliseconds;

      if (now > expirationTime) {
        return null;
      }

      // Decode the cached response
      final cacheData = jsonDecode(cacheDataString) as Map<String, dynamic>;

      // Create a response object
      return Response(
        requestOptions: options,
        data: cacheData['data'],
        headers: Headers.fromMap(
          Map<String, List<String>>.from(
            (cacheData['headers'] as Map).map(
              (k, v) => MapEntry(k as String, (v as List).cast<String>()),
            ),
          ),
        ),
        statusCode: cacheData['statusCode'] as int,
        statusMessage: cacheData['statusMessage'] as String?,
        isRedirect: cacheData['isRedirect'] as bool? ?? false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error getting cached response: $e');
      }
      return null;
    }
  }

  /// Caches a response
  Future<void> _cacheResponse(
    final String cacheKey,
    final Response response,
  ) async {
    try {
      // Prepare the cache data
      final cacheData = {
        'data': response.data,
        'headers': response.headers.map,
        'statusCode': response.statusCode,
        'statusMessage': response.statusMessage,
        'isRedirect': response.isRedirect,
      };

      // Cache the response data
      final cacheDataString = jsonEncode(cacheData);
      await _prefs.setString('$_cacheKeyPrefix$cacheKey', cacheDataString);

      // Cache the response time
      final now = DateTime.now().millisecondsSinceEpoch;
      await _prefs.setInt('$_cacheTimeKeyPrefix$cacheKey', now);

      if (kDebugMode) {
        print('💾 Cached response for ${response.requestOptions.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error caching response: $e');
      }
    }
  }
}
