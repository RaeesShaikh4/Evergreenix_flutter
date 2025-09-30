class ApiLoggerConfig {
  static bool _isEnabled = true;
  static bool _logToConsole = true;
  static bool _logToDebug = true;
  static bool _logRequestBody = true;
  static bool _logResponseBody = true;
  static bool _logHeaders = true;
  static bool _logQueryParameters = true;
  static bool _logDuration = true;
  static bool _logTimestamp = true;
  static int _maxBodyLength = 1000; // Maximum characters to log for body content

  /// Enable or disable API logging completely
  static bool get isEnabled => _isEnabled;
  static void setEnabled(bool enabled) => _isEnabled = enabled;

  /// Configure console logging
  static bool get logToConsole => _logToConsole;
  static void setLogToConsole(bool enabled) => _logToConsole = enabled;

  /// Configure debug logging (dart:developer)
  static bool get logToDebug => _logToDebug;
  static void setLogToDebug(bool enabled) => _logToDebug = enabled;

  /// Configure request body logging
  static bool get logRequestBody => _logRequestBody;
  static void setLogRequestBody(bool enabled) => _logRequestBody = enabled;

  /// Configure response body logging
  static bool get logResponseBody => _logResponseBody;
  static void setLogResponseBody(bool enabled) => _logResponseBody = enabled;

  /// Configure headers logging
  static bool get logHeaders => _logHeaders;
  static void setLogHeaders(bool enabled) => _logHeaders = enabled;

  /// Configure query parameters logging
  static bool get logQueryParameters => _logQueryParameters;
  static void setLogQueryParameters(bool enabled) => _logQueryParameters = enabled;

  /// Configure duration logging
  static bool get logDuration => _logDuration;
  static void setLogDuration(bool enabled) => _logDuration = enabled;

  /// Configure timestamp logging
  static bool get logTimestamp => _logTimestamp;
  static void setLogTimestamp(bool enabled) => _logTimestamp = enabled;

  /// Maximum length for body content logging
  static int get maxBodyLength => _maxBodyLength;
  static void setMaxBodyLength(int length) => _maxBodyLength = length;

  /// Configure all logging settings at once
  static void configure({
    bool? enabled,
    bool? logToConsole,
    bool? logToDebug,
    bool? logRequestBody,
    bool? logResponseBody,
    bool? logHeaders,
    bool? logQueryParameters,
    bool? logDuration,
    bool? logTimestamp,
    int? maxBodyLength,
  }) {
    if (enabled != null) _isEnabled = enabled;
    if (logToConsole != null) _logToConsole = logToConsole;
    if (logToDebug != null) _logToDebug = logToDebug;
    if (logRequestBody != null) _logRequestBody = logRequestBody;
    if (logResponseBody != null) _logResponseBody = logResponseBody;
    if (logHeaders != null) _logHeaders = logHeaders;
    if (logQueryParameters != null) _logQueryParameters = logQueryParameters;
    if (logDuration != null) _logDuration = logDuration;
    if (logTimestamp != null) _logTimestamp = logTimestamp;
    if (maxBodyLength != null) _maxBodyLength = maxBodyLength;
  }

  /// Reset to default configuration
  static void resetToDefaults() {
    _isEnabled = true;
    _logToConsole = true;
    _logToDebug = true;
    _logRequestBody = true;
    _logResponseBody = true;
    _logHeaders = true;
    _logQueryParameters = true;
    _logDuration = true;
    _logTimestamp = true;
    _maxBodyLength = 1000;
  }

  /// Get current configuration as a map
  static Map<String, dynamic> getCurrentConfig() {
    return {
      'enabled': _isEnabled,
      'logToConsole': _logToConsole,
      'logToDebug': _logToDebug,
      'logRequestBody': _logRequestBody,
      'logResponseBody': _logResponseBody,
      'logHeaders': _logHeaders,
      'logQueryParameters': _logQueryParameters,
      'logDuration': _logDuration,
      'logTimestamp': _logTimestamp,
      'maxBodyLength': _maxBodyLength,
    };
  }
}
