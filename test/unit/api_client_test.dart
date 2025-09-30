import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:evergreenix_flutter_task/core/network/api_client.dart';
import 'package:evergreenix_flutter_task/core/network/api_exceptions.dart';
import '../test_utils/mock_data.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('ApiClient Tests', () {
    late MockHttpClient mockHttpClient;
    late ApiClient apiClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiClient = ApiClient(
        baseUrl: MockData.baseUrl,
        headers: {'Content-Type': 'application/json'},
      );
    });

    group('POST Requests', () {
      test('should make successful POST request and return response', () async {
        // Arrange
        const endpoint = '/test';
        const requestBody = {'key': 'value'};
        const expectedResponse = {'success': true, 'data': 'test'};
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(
          '{"success": true, "data": "test"}',
          200,
        ));

        // Act
        final result = await apiClient.post(endpoint, body: requestBody);

        // Assert
        expect(result, equals(expectedResponse));
      });

      test('should handle 400 Bad Request error', () async {
        // Arrange
        const endpoint = '/test';
        const requestBody = {'key': 'value'};
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(
          '{"error": "Bad Request", "message": "Invalid data"}',
          400,
        ));

        // Act & Assert
        expect(
          () => apiClient.post(endpoint, body: requestBody),
          throwsA(isA<BadRequestException>()),
        );
      });

      test('should handle 401 Unauthorized error', () async {
        // Arrange
        const endpoint = '/test';
        const requestBody = {'key': 'value'};
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(
          '{"error": "Unauthorized", "message": "Invalid credentials"}',
          401,
        ));

        // Act & Assert
        expect(
          () => apiClient.post(endpoint, body: requestBody),
          throwsA(isA<UnauthorizedException>()),
        );
      });

      test('should handle 403 Forbidden error', () async {
        // Arrange
        const endpoint = '/test';
        const requestBody = {'key': 'value'};
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(
          '{"error": "Forbidden", "message": "Access denied"}',
          403,
        ));

        // Act & Assert
        expect(
          () => apiClient.post(endpoint, body: requestBody),
          throwsA(isA<UnauthorizedException>()),
        );
      });

      test('should handle 500 Server Error', () async {
        // Arrange
        const endpoint = '/test';
        const requestBody = {'key': 'value'};
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(
          '{"error": "Internal Server Error"}',
          500,
        ));

        // Act & Assert
        expect(
          () => apiClient.post(endpoint, body: requestBody),
          throwsA(isA<FetchDataException>()),
        );
      });

      test('should handle network timeout', () async {
        // Arrange
        const endpoint = '/test';
        const requestBody = {'key': 'value'};
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenThrow(Exception('Network timeout'));

        // Act & Assert
        expect(
          () => apiClient.post(endpoint, body: requestBody),
          throwsException,
        );
      });
    });

    group('GET Requests', () {
      test('should make successful GET request', () async {
        // Arrange
        const endpoint = '/test';
        const queryParams = {'page': '1', 'limit': '10'};
        const expectedResponse = {'success': true, 'data': []};
        
        when(mockHttpClient.get(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
        )).thenAnswer((_) async => http.Response(
          '{"success": true, "data": []}',
          200,
        ));

        // Act
        final result = await apiClient.get(endpoint, queryParameters: queryParams);

        // Assert
        expect(result, equals(expectedResponse));
      });

      test('should handle GET request with empty query parameters', () async {
        // Arrange
        const endpoint = '/test';
        const expectedResponse = {'success': true, 'data': []};
        
        when(mockHttpClient.get(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
        )).thenAnswer((_) async => http.Response(
          '{"success": true, "data": []}',
          200,
        ));

        // Act
        final result = await apiClient.get(endpoint);

        // Assert
        expect(result, equals(expectedResponse));
      });
    });

    group('PUT Requests', () {
      test('should make successful PUT request', () async {
        // Arrange
        const endpoint = '/test/1';
        const requestBody = {'name': 'Updated Name'};
        const expectedResponse = {'success': true, 'data': 'updated'};
        
        when(mockHttpClient.put(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(
          '{"success": true, "data": "updated"}',
          200,
        ));

        // Act
        final result = await apiClient.put(endpoint, body: requestBody);

        // Assert
        expect(result, equals(expectedResponse));
      });
    });

    group('DELETE Requests', () {
      test('should make successful DELETE request', () async {
        // Arrange
        const endpoint = '/test/1';
        const expectedResponse = {'success': true, 'message': 'deleted'};
        
        when(mockHttpClient.delete(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
        )).thenAnswer((_) async => http.Response(
          '{"success": true, "message": "deleted"}',
          200,
        ));

        // Act
        final result = await apiClient.delete(endpoint);

        // Assert
        expect(result, equals(expectedResponse));
      });
    });

    group('Response Parsing', () {
      test('should parse JSON response correctly', () async {
        // Arrange
        const endpoint = '/test';
        const jsonResponse = '{"success": true, "data": {"id": 1, "name": "Test"}}';
        const expectedResponse = {
          'success': true,
          'data': {'id': 1, 'name': 'Test'}
        };
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(jsonResponse, 200));

        // Act
        final result = await apiClient.post(endpoint);

        // Assert
        expect(result, equals(expectedResponse));
      });

      test('should handle non-JSON response', () async {
        // Arrange
        const endpoint = '/test';
        const textResponse = 'Plain text response';
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response(textResponse, 200));

        // Act
        final result = await apiClient.post(endpoint);

        // Assert
        expect(result, equals(textResponse));
      });

      test('should handle empty response', () async {
        // Arrange
        const endpoint = '/test';
        
        when(mockHttpClient.post(
          Uri.parse('https://api.example.com'),
          headers: <String, String>{},
          body: '{}',
        )).thenAnswer((_) async => http.Response('', 200));

        // Act
        final result = await apiClient.post(endpoint);

        // Assert
        expect(result, equals(''));
      });
    });
  });
}
