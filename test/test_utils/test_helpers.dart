import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:evergreenix_flutter_task/core/network/api_client.dart';
import 'package:evergreenix_flutter_task/reposatories/auth_repository.dart';
import 'package:evergreenix_flutter_task/view_models/signup_viewmodel.dart';
import 'package:evergreenix_flutter_task/view_models/signin_viewmodel.dart';

/// Mock classes for testing
class MockApiClient extends Mock implements ApiClient {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockHttpClient extends Mock implements http.Client {}

/// Test helpers and utilities
class TestHelpers {
  /// Creates a mock API client with predefined responses
  static MockApiClient createMockApiClient({
    Map<String, dynamic>? signUpResponse,
    Map<String, dynamic>? signInResponse,
    Exception? exception,
  }) {
    final mockApiClient = MockApiClient();
    
    if (exception != null) {
      when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
          .thenThrow(exception);
    } else {
      when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
          .thenAnswer((_) async => signUpResponse ?? {});
    }
    
    return mockApiClient;
  }

  /// Creates a mock auth repository
  static MockAuthRepository createMockAuthRepository({
    Map<String, dynamic>? signUpResponse,
    Map<String, dynamic>? signInResponse,
    Exception? exception,
  }) {
    final mockRepository = MockAuthRepository();
    
    if (exception != null) {
      when(mockRepository.signUp(
        name: 'test',
        email: 'test@test.com',
        password: 'password',
        phoneNumber: '1234567890',
      )).thenThrow(exception);
      
      when(mockRepository.signIn(
        email: 'test@test.com',
        password: 'password',
      )).thenThrow(exception);
    } else {
      when(mockRepository.signUp(
        name: 'test',
        email: 'test@test.com',
        password: 'password',
        phoneNumber: '1234567890',
      )).thenAnswer((_) async => signUpResponse ?? {});
      
      when(mockRepository.signIn(
        email: 'test@test.com',
        password: 'password',
      )).thenAnswer((_) async => signInResponse ?? {});
    }
    
    return mockRepository;
  }

  /// Creates a signup viewmodel for testing
  static SignupViewModel createSignupViewModel(MockAuthRepository mockRepository) {
    return SignupViewModel(mockRepository);
  }

  /// Creates a signin viewmodel for testing
  static SigninViewModel createSigninViewModel(MockAuthRepository mockRepository) {
    return SigninViewModel(mockRepository);
  }

  /// Waits for async operations to complete
  static Future<void> waitForAsync() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Asserts that a viewmodel is in loading state
  static void assertLoadingState(dynamic viewModel) {
    expect(viewModel.isLoading, isTrue);
  }

  /// Asserts that a viewmodel is not in loading state
  static void assertNotLoadingState(dynamic viewModel) {
    expect(viewModel.isLoading, isFalse);
  }

  /// Asserts that a viewmodel has an error
  static void assertHasError(dynamic viewModel, String? expectedError) {
    expect(viewModel.error, isNotNull);
    if (expectedError != null) {
      expect(viewModel.error, contains(expectedError));
    }
  }

  /// Asserts that a viewmodel has no error
  static void assertNoError(dynamic viewModel) {
    expect(viewModel.error, isNull);
  }
}
