import 'package:evergreenix_flutter_task/core/network/api_client.dart';
import 'package:evergreenix_flutter_task/core/network/api_logger_config.dart';

/// Example usage of the API Logger
class ApiLoggerExample {
  static void demonstrateApiLogging() {
    // Configure the logger
    ApiLoggerConfig.configure(
      enabled: true,
      logToConsole: true,
      logToDebug: true,
      logRequestBody: true,
      logResponseBody: true,
      logHeaders: true,
      logQueryParameters: true,
      logDuration: true,
      logTimestamp: true,
      maxBodyLength: 1000,
    );

    // Create API client
    final apiClient = ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your-token-here',
      },
    );

    // Example GET request
    _performGetRequest(apiClient);

    // Example POST request
    _performPostRequest(apiClient);

    // Example PUT request
    _performPutRequest(apiClient);

    // Example DELETE request
    _performDeleteRequest(apiClient);
  }

  static Future<void> _performGetRequest(ApiClient apiClient) async {
    try {
      print('\n=== Performing GET Request ===');
      final response = await apiClient.get('/posts', queryParameters: {
        'userId': '1',
        'limit': '5',
      });
      print('GET Response: $response');
    } catch (e) {
      print('GET Error: $e');
    }
  }

  static Future<void> _performPostRequest(ApiClient apiClient) async {
    try {
      print('\n=== Performing POST Request ===');
      final response = await apiClient.post('/posts', body: {
        'title': 'Test Post',
        'body': 'This is a test post body',
        'userId': 1,
      });
      print('POST Response: $response');
    } catch (e) {
      print('POST Error: $e');
    }
  }

  static Future<void> _performPutRequest(ApiClient apiClient) async {
    try {
      print('\n=== Performing PUT Request ===');
      final response = await apiClient.put('/posts/1', body: {
        'id': 1,
        'title': 'Updated Post',
        'body': 'This is an updated post body',
        'userId': 1,
      });
      print('PUT Response: $response');
    } catch (e) {
      print('PUT Error: $e');
    }
  }

  static Future<void> _performDeleteRequest(ApiClient apiClient) async {
    try {
      print('\n=== Performing DELETE Request ===');
      final response = await apiClient.delete('/posts/1');
      print('DELETE Response: $response');
    } catch (e) {
      print('DELETE Error: $e');
    }
  }

  /// Configure logger for different environments
  static void configureForDevelopment() {
    ApiLoggerConfig.configure(
      enabled: true,
      logToConsole: true,
      logToDebug: true,
      logRequestBody: true,
      logResponseBody: true,
      logHeaders: true,
      logQueryParameters: true,
      logDuration: true,
      logTimestamp: true,
      maxBodyLength: 2000,
    );
  }

  static void configureForProduction() {
    ApiLoggerConfig.configure(
      enabled: false, // Disable logging in production
      logToConsole: false,
      logToDebug: false,
    );
  }

  static void configureForTesting() {
    ApiLoggerConfig.configure(
      enabled: true,
      logToConsole: false, // Don't clutter test output
      logToDebug: true,
      logRequestBody: false, // Don't log sensitive data in tests
      logResponseBody: false,
      logHeaders: false,
      logQueryParameters: true,
      logDuration: true,
      logTimestamp: false,
      maxBodyLength: 500,
    );
  }
}
