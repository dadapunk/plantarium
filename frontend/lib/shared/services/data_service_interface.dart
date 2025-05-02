import 'package:plantarium/shared/services/base_service.dart';

/// A generic interface for data services that handle CRUD operations
abstract class IDataService<T, ID> extends BaseService {
  /// Retrieves all entities
  Future<List<T>> getAll();

  /// Retrieves an entity by its ID
  Future<T> getById(ID id);

  /// Creates a new entity
  Future<T> create(T entity);

  /// Updates an existing entity
  Future<T> update(ID id, T entity);

  /// Deletes an entity by its ID
  Future<void> delete(ID id);
}
