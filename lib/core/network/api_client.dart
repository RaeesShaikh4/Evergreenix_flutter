import 'dart:convert';

import 'package:evergreenix_flutter_task/core/network/api_exceptions.dart';
import 'package:evergreenix_flutter_task/core/network/api_logger.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    Map<String, String>? headers,
  }) : defaultHeaders =
            headers ?? {'Content-Type': 'application/json', 'AuthKey': 'test'};

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final startTime = DateTime.now();
    
    // Log request
    ApiLogger.logRequest(
      method: 'POST',
      url: uri.toString(),
      headers: defaultHeaders,
      body: body,
    );
    
    try {
      final response = await http.post(uri,
          body: body != null ? jsonEncode(body) : null, headers: defaultHeaders);
      
      final duration = DateTime.now().difference(startTime);
      
      // Log response
      response.logResponse(
        method: 'POST',
        url: uri.toString(),
        duration: duration,
      );
      
      return _handleResponse(response);
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      
      // Log error
      ApiLogger.logError(
        method: 'POST',
        url: uri.toString(),
        error: e,
        headers: defaultHeaders,
        body: body,
        duration: duration,
      );
      
      rethrow;
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParameters,
    );
    final startTime = DateTime.now();
    
    // Log request
    ApiLogger.logRequest(
      method: 'GET',
      url: uri.toString(),
      headers: defaultHeaders,
      queryParameters: queryParameters,
    );
    
    try {
      final response = await http.get(uri, headers: defaultHeaders);
      
      final duration = DateTime.now().difference(startTime);
      
      // Log response
      response.logResponse(
        method: 'GET',
        url: uri.toString(),
        duration: duration,
      );
      
      return _handleResponse(response);
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      
      // Log error
      ApiLogger.logError(
        method: 'GET',
        url: uri.toString(),
        error: e,
        headers: defaultHeaders,
        duration: duration,
      );
      
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final startTime = DateTime.now();
    
    // Log request
    ApiLogger.logRequest(
      method: 'PUT',
      url: uri.toString(),
      headers: defaultHeaders,
      body: body,
    );
    
    try {
      final response = await http.put(uri,
          body: body != null ? jsonEncode(body) : null, headers: defaultHeaders);
      
      final duration = DateTime.now().difference(startTime);
      
      // Log response
      response.logResponse(
        method: 'PUT',
        url: uri.toString(),
        duration: duration,
      );
      
      return _handleResponse(response);
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      
      // Log error
      ApiLogger.logError(
        method: 'PUT',
        url: uri.toString(),
        error: e,
        headers: defaultHeaders,
        body: body,
        duration: duration,
      );
      
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final startTime = DateTime.now();
    
    // Log request
    ApiLogger.logRequest(
      method: 'DELETE',
      url: uri.toString(),
      headers: defaultHeaders,
    );
    
    try {
      final response = await http.delete(uri, headers: defaultHeaders);
      
      final duration = DateTime.now().difference(startTime);
      
      // Log response
      response.logResponse(
        method: 'DELETE',
        url: uri.toString(),
        duration: duration,
      );
      
      return _handleResponse(response);
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      
      // Log error
      ApiLogger.logError(
        method: 'DELETE',
        url: uri.toString(),
        error: e,
        headers: defaultHeaders,
        duration: duration,
      );
      
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response) {
    final int status = response.statusCode;
    final String responseBody = response.body.isNotEmpty ? response.body : '';
    dynamic json;

    try {
      json = jsonDecode(responseBody);
    } catch (e) {
      json = responseBody;
    }

    if (status == 200 || status == 201) {
      return json;
    } else if (status == 400) {
      final message = json is Map && json['message'] != null
          ? json['message'].toString()
          : 'Bad Request';
      throw BadRequestException(message);
    } else if (status == 401 || status == 403) {
      throw UnauthorizedException(json['message']);
    } else {
      throw FetchDataException(
          'Error occurred [StatusCode: $status] - ${response.reasonPhrase}');
    }
  }
}
