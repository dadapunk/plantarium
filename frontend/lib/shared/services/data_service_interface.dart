import 'package:plantarium/shared/services/base_service.dart';

/// A generic interface for data services that handle CRUD operations
abstract class IDataService<T, ID> extends BaseService {
  /// Retrieves all entities
  Future<List<T>> getAll();

  /// Retrieves an entity by its ID
  Future<T> getById(final ID id);

  /// Creates a new entity
  Future<T> create(final T entity);

  /// Updates an existing entity
  Future<T> update(final ID id, final T entity);

  /// Deletes an entity by its ID
  Future<void> delete(final ID id);
}
