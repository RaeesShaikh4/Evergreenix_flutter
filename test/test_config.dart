import 'package:flutter_test/flutter_test.dart';
import 'package:evergreenix_flutter_task/core/network/api_logger_config.dart';

/// Global test configuration
void configureTests() {
  // Disable API logging during tests
  ApiLoggerConfig.configure(
    enabled: false,
    logToConsole: false,
    logToDebug: false,
    logRequestBody: false,
    logResponseBody: false,
    logHeaders: false,
    logQueryParameters: false,
    logDuration: false,
    logTimestamp: false,
  );

  // Set default test timeout
  TestWidgetsFlutterBinding.ensureInitialized();
}

/// Test environment setup
void setupTestEnvironment() {
  // Configure logging
  configureTests();
  
  // Set up any global test state
  print('🧪 Test environment configured');
}

/// Test environment cleanup
void cleanupTestEnvironment() {
  // Reset API logger to defaults
  ApiLoggerConfig.resetToDefaults();
  
  // Clean up any global test state
  print('🧹 Test environment cleaned up');
}
