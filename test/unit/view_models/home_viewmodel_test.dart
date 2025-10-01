import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:evergreenix_flutter_task/view_models/home_viewmodel.dart';
import 'package:evergreenix_flutter_task/models/home_products.dart';
import 'package:evergreenix_flutter_task/core/network/api_exceptions.dart';
import '../../test_utils/test_helpers.dart';

void main() {
  group('HomeViewModel Tests', () {
    late MockAuthRepository mockAuthRepository;
    late MockHomeRepository mockHomeRepository;
    late HomeViewModel viewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockHomeRepository = MockHomeRepository();
      viewModel = HomeViewModel(mockAuthRepository, mockHomeRepository);
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.isLoadingProducts, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.userEmail, isNull);
        expect(viewModel.isLoggedIn, isFalse);
        expect(viewModel.products, isEmpty);
      });
    });

    group('Initialize Session', () {
      test('should initialize session successfully', () async {
        // Arrange
        final sessionData = {
          'isLoggedIn': true,
          'email': 'test@example.com',
        };
        when(mockAuthRepository.getSessionData())
            .thenAnswer((_) async => sessionData);

        // Act
        await viewModel.initializeSession();

        // Assert
        expect(viewModel.isLoggedIn, isTrue);
        expect(viewModel.userEmail, equals('test@example.com'));
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.isLoading, isFalse);
        verify(mockAuthRepository.getSessionData()).called(1);
      });

      test('should set loading state during session initialization', () async {
        // Arrange
        final sessionData = {
          'isLoggedIn': true,
          'email': 'test@example.com',
        };
        when(mockAuthRepository.getSessionData())
            .thenAnswer((_) async => sessionData);

        // Act & Assert
        expect(viewModel.isLoading, isFalse);
        final future = viewModel.initializeSession();
        expect(viewModel.isLoading, isTrue);
        await future;
        expect(viewModel.isLoading, isFalse);
      });

      test('should handle session initialization error', () async {
        // Arrange
        when(mockAuthRepository.getSessionData())
            .thenThrow(Exception('Session error'));

        // Act
        await viewModel.initializeSession();

        // Assert
        expect(viewModel.isLoggedIn, isFalse);
        expect(viewModel.errorMessage, contains('Failed to load session data'));
        expect(viewModel.isLoading, isFalse);
      });

      test('should handle null session data', () async {
        // Arrange
        final sessionData = <String, dynamic>{};
        when(mockAuthRepository.getSessionData())
            .thenAnswer((_) async => sessionData);

        // Act
        await viewModel.initializeSession();

        // Assert
        expect(viewModel.isLoggedIn, isFalse);
        expect(viewModel.userEmail, isNull);
      });
    });

    group('Get Home Products', () {
      final mockProducts = [
        Product(
          id: 1,
          title: 'Product 1',
          description: 'Description 1',
          category: 'Category 1',
          price: 99.99,
          discountPercentage: 10.0,
          thumbnail: 'image1.jpg',
        ),
        Product(
          id: 2,
          title: 'Product 2',
          description: 'Description 2',
          category: 'Category 2',
          price: 149.99,
          discountPercentage: 15.0,
          thumbnail: 'image2.jpg',
        ),
      ];

      final mockProductResponse = ProductResponse(products: mockProducts);

      test('should fetch home products successfully', () async {
        // Arrange
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenAnswer((_) async => mockProductResponse);

        // Act
        await viewModel.getHomeProducts(limit: 10);

        // Assert
        expect(viewModel.products, hasLength(2));
        expect(viewModel.products.first.title, equals('Product 1'));
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.isLoadingProducts, isFalse);
        verify(mockHomeRepository.getHomeProducts(limit: 10, skip: null)).called(1);
      });

      test('should set loading state while fetching products', () async {
        // Arrange
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenAnswer((_) async => mockProductResponse);

        // Act & Assert
        expect(viewModel.isLoadingProducts, isFalse);
        final future = viewModel.getHomeProducts(limit: 10);
        expect(viewModel.isLoadingProducts, isTrue);
        await future;
        expect(viewModel.isLoadingProducts, isFalse);
      });

      test('should handle product fetch error', () async {
        // Arrange
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenThrow(FetchDataException('Failed to fetch products'));

        // Act
        await viewModel.getHomeProducts(limit: 10);

        // Assert
        expect(viewModel.products, isEmpty);
        expect(viewModel.errorMessage, contains('Failed to fetch home products'));
        expect(viewModel.isLoadingProducts, isFalse);
      });

      test('should fetch products with pagination parameters', () async {
        // Arrange
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenAnswer((_) async => mockProductResponse);

        // Act
        await viewModel.getHomeProducts(limit: 20, skip: 10);

        // Assert
        verify(mockHomeRepository.getHomeProducts(limit: 20, skip: 10)).called(1);
      });

      test('should clear error message when fetching products', () async {
        // Arrange
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenAnswer((_) async => mockProductResponse);
        
        // Set an error first
        await viewModel.getHomeProducts(limit: 10);
        
        // Act - fetch again
        await viewModel.getHomeProducts(limit: 10);

        // Assert
        expect(viewModel.errorMessage, isNull);
      });
    });

    group('Logout', () {
      test('should logout successfully', () async {
        // Arrange
        when(mockAuthRepository.logout()).thenAnswer((_) async => {});

        // Act
        await viewModel.logout();

        // Assert
        expect(viewModel.isLoggedIn, isFalse);
        expect(viewModel.userEmail, isNull);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.isLoading, isFalse);
        verify(mockAuthRepository.logout()).called(1);
      });

      test('should set loading state during logout', () async {
        // Arrange
        when(mockAuthRepository.logout()).thenAnswer((_) async => {});

        // Act & Assert
        expect(viewModel.isLoading, isFalse);
        final future = viewModel.logout();
        expect(viewModel.isLoading, isTrue);
        await future;
        expect(viewModel.isLoading, isFalse);
      });

      test('should handle logout error', () async {
        // Arrange
        when(mockAuthRepository.logout())
            .thenThrow(Exception('Logout failed'));

        // Act
        await viewModel.logout();

        // Assert
        expect(viewModel.errorMessage, contains('Failed to logout'));
        expect(viewModel.isLoading, isFalse);
      });
    });

    group('Clear Error', () {
      test('should clear error message', () async {
        // Arrange - create an error first
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenThrow(Exception('Error'));
        await viewModel.getHomeProducts();

        // Act
        viewModel.clearError();

        // Assert
        expect(viewModel.errorMessage, isNull);
      });
    });

    group('Refresh Session', () {
      test('should refresh session data', () async {
        // Arrange
        final sessionData = {
          'isLoggedIn': true,
          'email': 'refreshed@example.com',
        };
        when(mockAuthRepository.getSessionData())
            .thenAnswer((_) async => sessionData);

        // Act
        await viewModel.refreshSession();

        // Assert
        expect(viewModel.userEmail, equals('refreshed@example.com'));
        verify(mockAuthRepository.getSessionData()).called(1);
      });
    });

    group('Clear Products', () {
      test('should clear products list', () async {
        // Arrange
        final mockProducts = [
          Product(
            id: 1,
            title: 'Product 1',
            description: 'Description',
            category: 'Category',
            price: 99.99,
            discountPercentage: 10.0,
            thumbnail: 'image.jpg',
          ),
        ];
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenAnswer((_) async => ProductResponse(products: mockProducts));
        await viewModel.getHomeProducts();

        // Act
        viewModel.clearProducts();

        // Assert
        expect(viewModel.products, isEmpty);
      });
    });

    group('Edge Cases', () {
      test('should handle empty product list', () async {
        // Arrange
        final emptyResponse = ProductResponse(products: []);
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenAnswer((_) async => emptyResponse);

        // Act
        await viewModel.getHomeProducts();

        // Assert
        expect(viewModel.products, isEmpty);
        expect(viewModel.errorMessage, isNull);
      });

      test('should handle network timeout', () async {
        // Arrange
        when(mockHomeRepository.getHomeProducts(limit: anyNamed('limit'), skip: anyNamed('skip')))
            .thenThrow(FetchDataException('Network timeout'));

        // Act
        await viewModel.getHomeProducts();

        // Assert
        expect(viewModel.errorMessage, isNotNull);
        expect(viewModel.products, isEmpty);
      });
    });
  });
}

