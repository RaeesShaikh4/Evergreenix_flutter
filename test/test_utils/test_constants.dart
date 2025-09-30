/// Test constants and configuration
class TestConstants {
  // Test timeouts
  static const Duration defaultTimeout = Duration(seconds: 5);
  static const Duration shortTimeout = Duration(seconds: 1);
  static const Duration longTimeout = Duration(seconds: 10);

  // Test delays
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 500);
  static const Duration longDelay = Duration(milliseconds: 1000);

  // Test data sizes
  static const int smallDataSize = 10;
  static const int mediumDataSize = 100;
  static const int largeDataSize = 1000;

  // API test endpoints
  static const String testBaseUrl = 'https://test-api.example.com';
  static const String testSignUpEndpoint = '/test/signup';
  static const String testSignInEndpoint = '/test/signin';

  // Test user credentials
  static const String testUserName = 'Test User';
  static const String testUserEmail = 'test@example.com';
  static const String testUserPassword = 'TestPassword123!';
  static const String testUserPhone = '+1234567890';

  // Test error messages
  static const String networkErrorMessage = 'Network error';
  static const String serverErrorMessage = 'Server error';
  static const String validationErrorMessage = 'Validation error';
  static const String unauthorizedErrorMessage = 'Unauthorized';
  static const String notFoundErrorMessage = 'Not found';

  // Test response codes
  static const int successCode = 200;
  static const int createdCode = 201;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int serverErrorCode = 500;

  // Test file paths
  static const String testAssetsPath = 'test/assets';
  static const String testFixturesPath = 'test/fixtures';
  static const String testMocksPath = 'test/mocks';

  // Test database
  static const String testDatabaseName = 'test_database.db';
  static const int testDatabaseVersion = 1;

  // Test cache
  static const String testCacheKey = 'test_cache_key';
  static const Duration testCacheExpiry = Duration(minutes: 5);

  // Test notifications
  static const String testNotificationTitle = 'Test Notification';
  static const String testNotificationBody = 'This is a test notification';
  static const String testNotificationId = 'test_notification_1';

  // Test permissions
  static const List<String> testPermissions = [
    'camera',
    'location',
    'storage',
    'microphone',
  ];

  // Test locales
  static const List<String> testLocales = [
    'en',
    'es',
    'fr',
    'de',
    'it',
    'pt',
    'ru',
    'ja',
    'ko',
    'zh',
  ];

  // Test themes
  static const List<String> testThemes = [
    'light',
    'dark',
    'system',
  ];

  // Test screen sizes
  static const Map<String, double> testScreenSizes = {
    'small': 320.0,
    'medium': 375.0,
    'large': 414.0,
    'tablet': 768.0,
    'desktop': 1024.0,
  };

  // Test network conditions
  static const List<String> testNetworkConditions = [
    'wifi',
    'cellular',
    'ethernet',
    'offline',
  ];

  // Test device types
  static const List<String> testDeviceTypes = [
    'phone',
    'tablet',
    'desktop',
    'watch',
    'tv',
  ];

  // Test platforms
  static const List<String> testPlatforms = [
    'android',
    'ios',
    'web',
    'windows',
    'macos',
    'linux',
  ];
}
