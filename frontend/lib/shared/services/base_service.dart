/// Base service interface that defines common functionality for all services
abstract class BaseService {
  /// Logs a message for debugging purposes
  void log(String message);

  /// Handles errors in a consistent way across services
  Object handleError(Object error, String operation);
}
