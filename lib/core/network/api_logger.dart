import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:evergreenix_flutter_task/core/network/api_logger_config.dart';

class ApiLogger {
  static const String _logTag = 'API_LOGGER';

  /// Log API request details
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
  }) {
    if (!ApiLoggerConfig.isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final logData = {
      'timestamp': timestamp,
      'type': 'REQUEST',
      'method': method.toUpperCase(),
      'url': url,
      'headers': headers ?? {},
      'body': body,
      'queryParameters': queryParameters,
    };

    _logMessage('🚀 API REQUEST', logData);
  }

  /// Log API response details
  static void logResponse({
    required String method,
    required String url,
    required int statusCode,
    required String statusMessage,
    Map<String, String>? headers,
    dynamic body,
    required Duration duration,
  }) {
    if (!ApiLoggerConfig.isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final logData = {
      'timestamp': timestamp,
      'type': 'RESPONSE',
      'method': method.toUpperCase(),
      'url': url,
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'headers': headers ?? {},
      'body': body,
      'duration': '${duration.inMilliseconds}ms',
    };

    final emoji = _getStatusEmoji(statusCode);
    _logMessage('$emoji API RESPONSE', logData);
  }

  /// Log API error details
  static void logError({
    required String method,
    required String url,
    required dynamic error,
    Map<String, String>? headers,
    dynamic body,
    Duration? duration,
  }) {
    if (!ApiLoggerConfig.isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final logData = {
      'timestamp': timestamp,
      'type': 'ERROR',
      'method': method.toUpperCase(),
      'url': url,
      'error': error.toString(),
      'headers': headers ?? {},
      'body': body,
      'duration': duration != null ? '${duration.inMilliseconds}ms' : null,
    };

    _logMessage('❌ API ERROR', logData);
  }

  /// Internal method to handle logging output
  static void _logMessage(String title, Map<String, dynamic> data) {
    final formattedMessage = _formatLogMessage(title, data);
    
    if (ApiLoggerConfig.logToConsole) {
      developer.log(formattedMessage);
    }
    
    if (ApiLoggerConfig.logToDebug) {
      developer.log(
        formattedMessage,
        name: _logTag,
        time: DateTime.now(),
      );
    }
  }

  /// Format log message for better readability
  static String _formatLogMessage(String title, Map<String, dynamic> data) {
    final buffer = StringBuffer();
    buffer.writeln('=' * 80);
    
    // Title with timestamp
    if (ApiLoggerConfig.logTimestamp) {
      buffer.writeln('$title - ${data['timestamp']}');
    } else {
      buffer.writeln(title);
    }
    buffer.writeln('=' * 80);
    
    // Method and URL
    buffer.writeln('${data['method']} ${data['url']}');
    
    // Status code and message (for responses)
    if (data['statusCode'] != null) {
      buffer.writeln('Status: ${data['statusCode']} ${data['statusMessage']}');
    }
    
    // Duration (for responses/errors)
    if (ApiLoggerConfig.logDuration && data['duration'] != null) {
      buffer.writeln('Duration: ${data['duration']}');
    }
    
    // Headers
    if (ApiLoggerConfig.logHeaders && data['headers'] != null && data['headers'].isNotEmpty) {
      buffer.writeln('\nHeaders:');
      data['headers'].forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }
    
    // Body
    if (data['body'] != null) {
      final shouldLogBody = (data['type'] == 'REQUEST' && ApiLoggerConfig.logRequestBody) ||
                           (data['type'] == 'RESPONSE' && ApiLoggerConfig.logResponseBody);
      
      if (shouldLogBody) {
        buffer.writeln('\nBody:');
        final bodyStr = data['body'] is String 
            ? data['body'] 
            : const JsonEncoder.withIndent('  ').convert(data['body']);
        
        // Truncate body if it's too long
        final truncatedBody = bodyStr.length > ApiLoggerConfig.maxBodyLength
            ? '${bodyStr.substring(0, ApiLoggerConfig.maxBodyLength)}... [truncated]'
            : bodyStr;
        
        buffer.writeln(truncatedBody);
      }
    }
    
    // Query parameters (for requests)
    if (ApiLoggerConfig.logQueryParameters && 
        data['queryParameters'] != null && 
        data['queryParameters'].isNotEmpty) {
      buffer.writeln('\nQuery Parameters:');
      data['queryParameters'].forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }
    
    // Error (for errors)
    if (data['error'] != null) {
      buffer.writeln('\nError:');
      buffer.writeln(data['error']);
    }
    
    buffer.writeln('=' * 80);
    return buffer.toString();
  }

  /// Get emoji based on status code
  static String _getStatusEmoji(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return '✅';
    } else if (statusCode >= 300 && statusCode < 400) {
      return '🔄';
    } else if (statusCode >= 400 && statusCode < 500) {
      return '⚠️';
    } else if (statusCode >= 500) {
      return '❌';
    } else {
      return '❓';
    }
  }
}

/// Extension to add logging capabilities to http.Response
extension ResponseLogging on http.Response {
  void logResponse({
    required String method,
    required String url,
    required Duration duration,
  }) {
    ApiLogger.logResponse(
      method: method,
      url: url,
      statusCode: statusCode,
      statusMessage: reasonPhrase ?? 'Unknown',
      headers: headers,
      body: body,
      duration: duration,
    );
  }
}
