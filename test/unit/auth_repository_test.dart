import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:evergreenix_flutter_task/core/network/api_client.dart';
import 'package:evergreenix_flutter_task/reposatories/auth_repository.dart';
import 'package:evergreenix_flutter_task/core/network/api_exceptions.dart';
import '../test_utils/test_helpers.dart';
import '../test_utils/mock_data.dart';

void main() {
  group('AuthRepository Tests', () {
    late MockApiClient mockApiClient;
    late AuthRepository authRepository;

    setUp(() {
      mockApiClient = MockApiClient();
      authRepository = AuthRepository(mockApiClient);
      
      // Reset mocks before each test
      reset(mockApiClient);
    });

    group('SignUp Tests', () {
      test('should call API client with correct parameters for signup', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.successfulSignUpResponse);

        // Act
        await authRepository.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        verify(mockApiClient.post(
          MockData.signUpEndpoint,
          body: MockData.signUpRequest,
        )).called(1);
      });

      test('should return successful signup response', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.successfulSignUpResponse);

        // Act
        final result = await authRepository.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, equals(MockData.successfulSignUpResponse));
      });

      test('should handle signup API errors', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenThrow(BadRequestException('Email already exists'));

        // Act & Assert
        expect(
          () => authRepository.signUp(
            name: MockData.validName,
            email: MockData.validEmail,
            password: MockData.validPassword,
            phoneNumber: MockData.validPhone,
          ),
          throwsA(isA<BadRequestException>()),
        );
      });

      test('should handle network errors during signup', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => authRepository.signUp(
            name: MockData.validName,
            email: MockData.validEmail,
            password: MockData.validPassword,
            phoneNumber: MockData.validPhone,
          ),
          throwsException,
        );
      });

      test('should handle validation errors during signup', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.validationErrorResponse);

        // Act
        final result = await authRepository.signUp(
          name: MockData.validName,
          email: MockData.invalidEmail,
          password: MockData.shortPassword,
          phoneNumber: MockData.invalidPhone,
        );

        // Assert
        expect(result, equals(MockData.validationErrorResponse));
        expect(result['success'], isFalse);
        expect(result['error'], isNotNull);
      });
    });

    group('SignIn Tests', () {
      test('should call API client with correct parameters for signin', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.successfulSignInResponse);

        // Act
        await authRepository.signIn(
          email: MockData.validEmail,
          password: MockData.validPassword,
        );

        // Assert
        verify(mockApiClient.post(
          MockData.signInEndpoint,
          body: MockData.signInRequest,
        )).called(1);
      });

      test('should return successful signin response', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.successfulSignInResponse);

        // Act
        final result = await authRepository.signIn(
          email: MockData.validEmail,
          password: MockData.validPassword,
        );

        // Assert
        expect(result, equals(MockData.successfulSignInResponse));
        expect(result['success'], isTrue);
        expect(result['data']['token'], isNotNull);
      });

      test('should handle invalid credentials', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.errorResponse);

        // Act
        final result = await authRepository.signIn(
          email: MockData.validEmail,
          password: 'wrong_password',
        );

        // Assert
        expect(result, equals(MockData.errorResponse));
        expect(result['success'], isFalse);
        expect(result['error'], isNotNull);
      });

      test('should handle unauthorized errors during signin', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenThrow(UnauthorizedException('Invalid credentials'));

        // Act & Assert
        expect(
          () => authRepository.signIn(
            email: MockData.validEmail,
            password: MockData.validPassword,
          ),
          throwsA(isA<UnauthorizedException>()),
        );
      });

      test('should handle network errors during signin', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenThrow(Exception('Network timeout'));

        // Act & Assert
        expect(
          () => authRepository.signIn(
            email: MockData.validEmail,
            password: MockData.validPassword,
          ),
          throwsException,
        );
      });

      test('should handle server errors during signin', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenThrow(FetchDataException('Server error'));

        // Act & Assert
        expect(
          () => authRepository.signIn(
            email: MockData.validEmail,
            password: MockData.validPassword,
          ),
          throwsA(isA<FetchDataException>()),
        );
      });
    });

    group('Request Payload Tests', () {
      test('should format signup request payload correctly', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.successfulSignUpResponse);

        // Act
        await authRepository.signUp(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'Password123!',
          phoneNumber: '+1234567890',
        );

        // Assert
        final captured = verify(mockApiClient.post(
          MockData.signUpEndpoint,
          body: captureAny,
        )).captured;
        
        final requestBody = captured.first as Map<String, dynamic>;
        expect(requestBody['name'], equals('John Doe'));
        expect(requestBody['emailAddress'], equals('john@example.com'));
        expect(requestBody['password'], equals('Password123!'));
        expect(requestBody['phoneNumber'], equals('+1234567890'));
      });

      test('should format signin request payload correctly', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => MockData.successfulSignInResponse);

        // Act
        await authRepository.signIn(
          email: 'john@example.com',
          password: 'Password123!',
        );

        // Assert
        final captured = verify(mockApiClient.post(
          MockData.signInEndpoint,
          body: captureAny,
        )).captured;
        
        final requestBody = captured.first as Map<String, dynamic>;
        expect(requestBody['emailAddress'], equals('john@example.com'));
        expect(requestBody['password'], equals('Password123!'));
        expect(requestBody.containsKey('name'), isFalse);
        expect(requestBody.containsKey('phoneNumber'), isFalse);
      });
    });

    group('Error Handling Tests', () {
      test('should propagate API exceptions correctly', () async {
        // Arrange
        const errorMessage = 'API Error';
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenThrow(ApiExceptions(errorMessage));

        // Act & Assert
        expect(
          () => authRepository.signUp(
            name: MockData.validName,
            email: MockData.validEmail,
            password: MockData.validPassword,
            phoneNumber: MockData.validPhone,
          ),
          throwsA(predicate((e) => e is ApiExceptions && e.message == errorMessage)),
        );
      });

      test('should handle null response gracefully', () async {
        // Arrange
        when(mockApiClient.post('https://api.example.com', body: <String, dynamic>{}))
            .thenAnswer((_) async => null);

        // Act
        final result = await authRepository.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isNull);
      });
    });
  });
}
