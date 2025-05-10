/// Base service interface that defines common functionality for all services
abstract class BaseService {
  /// Logs a message for debugging purposes
  void log(final String message);

  /// Handles errors in a consistent way across services
  Object handleError(final Object error, final String operation);
}
