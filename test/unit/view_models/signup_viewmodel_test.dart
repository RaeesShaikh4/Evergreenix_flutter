import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:evergreenix_flutter_task/view_models/signup_viewmodel.dart';
import 'package:evergreenix_flutter_task/core/network/api_exceptions.dart';
import '../../test_utils/test_helpers.dart';
import '../../test_utils/mock_data.dart';

void main() {
  group('SignupViewModel Tests', () {
    late MockAuthRepository mockRepository;
    late SignupViewModel viewModel;

    setUp(() {
      mockRepository = TestHelpers.createMockAuthRepository();
      viewModel = TestHelpers.createSignupViewModel(mockRepository);
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.error, isNull);
      });
    });

    group('SignUp Success', () {
      test('should signup successfully with valid data', () async {
        // Arrange
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async => MockData.successfulSignUpResponse);

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isTrue);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.error, isNull);
      });

      test('should set loading state during signup', () async {
        // Arrange
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return MockData.successfulSignUpResponse;
        });

        // Act
        final future = viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert - Check loading state during operation
        expect(viewModel.isLoading, isTrue);
        expect(viewModel.error, isNull);

        // Wait for completion
        final result = await future;
        expect(result, isTrue);
        expect(viewModel.isLoading, isFalse);
      });

      test('should call repository with correct parameters', () async {
        // Arrange
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async => MockData.successfulSignUpResponse);

        // Act
        await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        verify(mockRepository.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        )).called(1);
      });
    });

    group('SignUp Errors', () {
      test('should handle API exceptions', () async {
        // Arrange
        const errorMessage = 'Email already exists';
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenThrow(BadRequestException(errorMessage));

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isFalse);
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.error, equals(errorMessage));
      });

      test('should handle unauthorized exceptions', () async {
        // Arrange
        const errorMessage = 'Invalid request';
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenThrow(UnauthorizedException(errorMessage));

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isFalse);
        expect(viewModel.error, equals(errorMessage));
      });

      test('should handle fetch data exceptions', () async {
        // Arrange
        const errorMessage = 'Server error';
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenThrow(FetchDataException(errorMessage));

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isFalse);
        expect(viewModel.error, equals(errorMessage));
      });

      test('should handle generic exceptions', () async {
        // Arrange
        const errorMessage = 'Network error';
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenThrow(Exception(errorMessage));

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isFalse);
        expect(viewModel.error, contains(errorMessage));
      });

      test('should handle API response with error field', () async {
        // Arrange
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async => MockData.errorResponse);

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isFalse);
        expect(viewModel.error, equals(MockData.errorResponse['message']));
      });

      test('should handle API response with success false', () async {
        // Arrange
        const responseWithSuccessFalse = {
          'success': false,
          'message': 'Validation failed',
        };
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async => responseWithSuccessFalse);

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isFalse);
        expect(viewModel.error, equals('Validation failed'));
      });
    });

    group('State Management', () {
      test('should clear error when starting new signup', () async {
        // Arrange - Set initial error
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenThrow(BadRequestException('Previous error'));

        await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        expect(viewModel.error, isNotNull);

        // Arrange - Setup successful response
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async => MockData.successfulSignUpResponse);

        // Act - Start new signup
        final future = viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert - Error should be cleared immediately
        expect(viewModel.error, isNull);
        expect(viewModel.isLoading, isTrue);

        // Wait for completion
        final result = await future;
        expect(result, isTrue);
        expect(viewModel.error, isNull);
      });

      test('should maintain loading state during async operation', () async {
        // Arrange
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return MockData.successfulSignUpResponse;
        });

        // Act
        final future = viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert - Should be loading
        expect(viewModel.isLoading, isTrue);

        // Wait for completion
        await future;

        // Assert - Should not be loading anymore
        expect(viewModel.isLoading, isFalse);
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () async {
        // Arrange
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async => MockData.successfulSignUpResponse);

        // Act
        final result = await viewModel.signUp(
          name: '',
          email: '',
          password: '',
          phoneNumber: '',
        );

        // Assert
        expect(result, isTrue);
        verify(mockRepository.signUp(
          name: '',
          email: '',
          password: '',
          phoneNumber: '',
        )).called(1);
      });

      test('should handle null response from repository', () async {
        // Arrange
        when(mockRepository.signUp(
          name: 'test',
          email: 'test@test.com',
          password: 'password',
          phoneNumber: '1234567890',
        )).thenAnswer((_) async => null);

        // Act
        final result = await viewModel.signUp(
          name: MockData.validName,
          email: MockData.validEmail,
          password: MockData.validPassword,
          phoneNumber: MockData.validPhone,
        );

        // Assert
        expect(result, isTrue); // null response is treated as success
        expect(viewModel.error, isNull);
      });
    });
  });
}
