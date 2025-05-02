import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

/// A cache interceptor for Dio that stores and retrieves API responses from cache.
///
/// This interceptor supports time-based cache expiration, request-specific cache
/// settings, and cache invalidation strategies.
class CacheInterceptor extends Interceptor {
  final SharedPreferences _prefs;
  final Duration _defaultMaxAge;
  final bool _debug;

  static const String _cacheKeyPrefix = 'api_cache_';
  static const String _cacheTimeKeyPrefix = 'api_cache_time_';

  /// Creates a new cache interceptor.
  ///
  /// [prefs] is the SharedPreferences instance to use for cache storage.
  /// [defaultMaxAge] is the default maximum age of a cached response.
  /// [debug] enables debug logging.
  CacheInterceptor({
    required SharedPreferences prefs,
    Duration defaultMaxAge = const Duration(minutes: 30),
    bool debug = false,
  }) : _prefs = prefs,
       _defaultMaxAge = defaultMaxAge,
       _debug = debug;

  /// Factory constructor to create a new instance with a new SharedPreferences.
  static Future<CacheInterceptor> create({
    Duration defaultMaxAge = const Duration(minutes: 30),
    bool debug = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return CacheInterceptor(
      prefs: prefs,
      defaultMaxAge: defaultMaxAge,
      debug: debug,
    );
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip cache for non-GET requests
    if (options.method != 'GET') {
      return handler.next(options);
    }

    // Skip cache if the request is explicitly set not to use cache
    final useCache = options.extra['useCache'] as bool? ?? true;
    if (!useCache) {
      _logDebug('Skipping cache for ${options.path} (useCache: false)');
      return handler.next(options);
    }

    // Get the cache key
    final cacheKey = _generateCacheKey(options);

    // Check if we have a cached response
    final cachedResponse = _getCachedResponse(cacheKey, options);
    if (cachedResponse != null) {
      _logDebug('Cache hit for ${options.path}');

      // Return the cached response
      return handler.resolve(cachedResponse);
    }

    _logDebug('Cache miss for ${options.path}');

    // Continue with the request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Skip caching non-GET requests or if the response is an error
    if (response.requestOptions.method != 'GET' ||
        response.statusCode == null ||
        response.statusCode! >= 400) {
      return handler.next(response);
    }

    // Skip caching if the request is explicitly set not to use cache
    final useCache = response.requestOptions.extra['useCache'] as bool? ?? true;
    if (!useCache) {
      return handler.next(response);
    }

    // Skip caching if the response is too large
    if (_isResponseTooLarge(response)) {
      _logDebug(
        'Response too large for ${response.requestOptions.path}, skipping cache',
      );
      return handler.next(response);
    }

    // Get the cache key
    final cacheKey = _generateCacheKey(response.requestOptions);

    // Cache the response
    _cacheResponse(cacheKey, response);

    // Continue with the response
    handler.next(response);
  }

  /// Invalidates all cached data.
  Future<void> invalidateAllCache() async {
    _logDebug('Invalidating all cache');

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

  /// Invalidates cache for a specific request.
  Future<void> invalidateCache(RequestOptions options) async {
    final cacheKey = _generateCacheKey(options);
    _logDebug('Invalidating cache for ${options.path} (key: $cacheKey)');

    await _prefs.remove('$_cacheKeyPrefix$cacheKey');
    await _prefs.remove('$_cacheTimeKeyPrefix$cacheKey');
  }

  /// Invalidates cache for requests matching a pattern.
  Future<void> invalidateCachePattern(String pattern) async {
    _logDebug('Invalidating cache matching pattern: $pattern');

    final keys =
        _prefs
            .getKeys()
            .where(
              (key) => key.startsWith(_cacheKeyPrefix) && key.contains(pattern),
            )
            .toList();

    for (final key in keys) {
      final timeKey = key.replaceFirst(_cacheKeyPrefix, _cacheTimeKeyPrefix);
      await _prefs.remove(key);
      await _prefs.remove(timeKey);
    }
  }

  /// Checks if the response is too large to cache.
  bool _isResponseTooLarge(Response response) {
    // Skip caching large responses (> 5MB)
    const maxCacheSize = 5 * 1024 * 1024; // 5MB in bytes

    try {
      final jsonString = jsonEncode(response.data);
      return jsonString.length > maxCacheSize;
    } catch (e) {
      _logDebug('Error checking response size: $e');
      return true;
    }
  }

  /// Generates a cache key for a request.
  String _generateCacheKey(RequestOptions options) {
    final keyData =
        '${options.method}:${options.uri.toString()}:${jsonEncode(options.queryParameters)}:${jsonEncode(options.headers.map((k, v) => MapEntry(k.toLowerCase(), v)))}';

    // Use MD5 hash to create a fixed-length key
    return md5.convert(utf8.encode(keyData)).toString();
  }

  /// Gets a cached response for a request.
  Response<dynamic>? _getCachedResponse(
    String cacheKey,
    RequestOptions options,
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

      // Get the max age for this request
      final maxAge = options.extra['maxAge'] as Duration? ?? _defaultMaxAge;

      // Check if the cached response is expired
      final now = DateTime.now().millisecondsSinceEpoch;
      final expirationTime = cacheTime + maxAge.inMilliseconds;

      if (now > expirationTime) {
        _logDebug('Cache expired for ${options.path}');
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
        extra: options.extra,
      );
    } catch (e) {
      _logDebug('Error getting cached response: $e');
      return null;
    }
  }

  /// Caches a response.
  Future<void> _cacheResponse(String cacheKey, Response response) async {
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

      _logDebug('Cached response for ${response.requestOptions.path}');
    } catch (e) {
      _logDebug('Error caching response: $e');
    }
  }

  /// Logs a debug message if debug is enabled.
  void _logDebug(String message) {
    if (_debug && kDebugMode) {
      print('CacheInterceptor: $message');
    }
  }
}
