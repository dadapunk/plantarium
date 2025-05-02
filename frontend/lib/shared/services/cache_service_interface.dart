import 'package:plantarium/shared/services/base_service.dart';

/// A generic interface for cache services
abstract class ICacheService<T> extends BaseService {
  /// Caches a list of entities
  Future<void> cacheItems(List<T> items);

  /// Retrieves all cached entities
  Future<List<T>> getCachedItems();

  /// Clears the cache
  Future<void> clearCache();

  /// Gets a single item from cache by ID
  Future<T?> getCachedItemById(dynamic id);

  /// Caches a single item
  Future<void> cacheItem(T item);

  /// Removes a single item from cache
  Future<void> removeCachedItem(dynamic id);
}
