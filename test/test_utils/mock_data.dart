/// Mock data for testing purposes
class MockData {
  // User data
  static const Map<String, dynamic> validUser = {
    'id': 1,
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phoneNumber': '+1234567890',
  };

  static const Map<String, dynamic> signUpRequest = {
    'name': 'John Doe',
    'emailAddress': 'john.doe@example.com',
    'password': 'Password123!',
    'phoneNumber': '+1234567890',
  };

  static const Map<String, dynamic> signInRequest = {
    'emailAddress': 'john.doe@example.com',
    'password': 'Password123!',
  };

  // API Responses
  static const Map<String, dynamic> successfulSignUpResponse = {
    'success': true,
    'message': 'User created successfully',
    'data': validUser,
  };

  static const Map<String, dynamic> successfulSignInResponse = {
    'success': true,
    'message': 'Login successful',
    'data': {
      'user': validUser,
      'token': 'mock_jwt_token_here',
    },
  };

  static const Map<String, dynamic> errorResponse = {
    'success': false,
    'error': 'Invalid credentials',
    'message': 'Authentication failed',
  };

  static const Map<String, dynamic> validationErrorResponse = {
    'success': false,
    'error': 'Validation failed',
    'message': 'Email is required',
    'errors': {
      'email': ['Email is required'],
      'password': ['Password must be at least 8 characters'],
    },
  };

  // Test credentials
  static const String validEmail = 'john.doe@example.com';
  static const String validPassword = 'Password123!';
  static const String validName = 'John Doe';
  static const String validPhone = '+1234567890';

  // Invalid test data
  static const String invalidEmail = 'invalid-email';
  static const String shortPassword = '123';
  static const String emptyString = '';
  static const String invalidPhone = '123';

  // API Endpoints
  static const String baseUrl = 'http://demo.marinecareerlink.com/api/v1/';
  static const String signUpEndpoint = 'account/signup';
  static const String signInEndpoint = 'account/signin';
}
