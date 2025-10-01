import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:evergreenix_flutter_task/view_models/product_detail_viewmodel.dart';
import 'package:evergreenix_flutter_task/models/product_detail.dart';
import 'package:evergreenix_flutter_task/core/network/api_exceptions.dart';
import '../../test_utils/test_helpers.dart';

void main() {
  group('ProductDetailViewModel Tests', () {
    late MockProductRepository mockProductRepository;
    late ProductDetailViewModel viewModel;

    setUp(() {
      mockProductRepository = MockProductRepository();
      viewModel = ProductDetailViewModel(mockProductRepository);
    });

    final mockProduct = ProductDetail(
      id: 1,
      title: 'Test Product',
      description: 'Test Description',
      category: 'Electronics',
      price: 999.99,
      discountPercentage: 15.0,
      rating: 4.5,
      stock: 50,
      tags: ['featured', 'bestseller'],
      brand: 'TestBrand',
      sku: 'TEST-SKU-001',
      weight: 1.5,
      warrantyInformation: '1 Year Warranty',
      shippingInformation: 'Free Shipping',
      availabilityStatus: 'In Stock',
      images: ['image1.jpg', 'image2.jpg', 'image3.jpg'],
      thumbnail: 'thumbnail.jpg',
    );

    group('Initial State', () {
      test('should have correct initial state', () {
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.product, isNull);
        expect(viewModel.selectedImageIndex, equals(0));
      });
    });

    group('Fetch Product Detail', () {
      test('should fetch product detail successfully', () async {
        // Arrange
        const productId = 1;
        when(mockProductRepository.getProductDetail(productId))
            .thenAnswer((_) async => mockProduct);

        // Act
        await viewModel.fetchProductDetail(productId);

        // Assert
        expect(viewModel.product, isNotNull);
        expect(viewModel.product?.id, equals(1));
        expect(viewModel.product?.title, equals('Test Product'));
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.isLoading, isFalse);
        verify(mockProductRepository.getProductDetail(productId)).called(1);
      });

      test('should set loading state while fetching product', () async {
        // Arrange
        const productId = 1;
        when(mockProductRepository.getProductDetail(productId))
            .thenAnswer((_) async => mockProduct);

        // Act & Assert
        expect(viewModel.isLoading, isFalse);
        final future = viewModel.fetchProductDetail(productId);
        expect(viewModel.isLoading, isTrue);
        await future;
        expect(viewModel.isLoading, isFalse);
      });

      test('should handle fetch product error', () async {
        // Arrange
        const productId = 1;
        when(mockProductRepository.getProductDetail(productId))
            .thenThrow(FetchDataException('Product not found'));

        // Act
        await viewModel.fetchProductDetail(productId);

        // Assert
        expect(viewModel.product, isNull);
        expect(viewModel.errorMessage, contains('Failed to load product details'));
        expect(viewModel.isLoading, isFalse);
      });

      test('should clear error message when fetching new product', () async {
        // Arrange
        const productId = 1;
        when(mockProductRepository.getProductDetail(productId))
            .thenAnswer((_) async => mockProduct);

        // First fetch with error
        when(mockProductRepository.getProductDetail(2))
            .thenThrow(Exception('Error'));
        await viewModel.fetchProductDetail(2);
        expect(viewModel.errorMessage, isNotNull);

        // Act - fetch successfully
        await viewModel.fetchProductDetail(productId);

        // Assert
        expect(viewModel.errorMessage, isNull);
      });

      test('should handle API exceptions', () async {
        // Arrange
        const productId = 999;
        when(mockProductRepository.getProductDetail(productId))
            .thenThrow(BadRequestException('Invalid product ID'));

        // Act
        await viewModel.fetchProductDetail(productId);

        // Assert
        expect(viewModel.product, isNull);
        expect(viewModel.errorMessage, isNotNull);
      });

      test('should handle unauthorized exceptions', () async {
        // Arrange
        const productId = 1;
        when(mockProductRepository.getProductDetail(productId))
            .thenThrow(UnauthorizedException('Unauthorized access'));

        // Act
        await viewModel.fetchProductDetail(productId);

        // Assert
        expect(viewModel.product, isNull);
        expect(viewModel.errorMessage, contains('Failed to load product details'));
      });
    });

    group('Select Image', () {
      test('should select image at given index', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);
        await viewModel.fetchProductDetail(1);

        // Act
        viewModel.selectImage(2);

        // Assert
        expect(viewModel.selectedImageIndex, equals(2));
      });

      test('should notify listeners when image is selected', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);
        await viewModel.fetchProductDetail(1);
        
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.selectImage(1);

        // Assert
        expect(notified, isTrue);
      });

      test('should handle selecting first image', () {
        // Act
        viewModel.selectImage(0);

        // Assert
        expect(viewModel.selectedImageIndex, equals(0));
      });

      test('should handle selecting last image', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);
        await viewModel.fetchProductDetail(1);

        // Act - select last image (index 2 for 3 images)
        viewModel.selectImage(2);

        // Assert
        expect(viewModel.selectedImageIndex, equals(2));
      });
    });

    group('Clear Error', () {
      test('should clear error message', () async {
        // Arrange - create an error first
        when(mockProductRepository.getProductDetail(1))
            .thenThrow(Exception('Error'));
        await viewModel.fetchProductDetail(1);
        expect(viewModel.errorMessage, isNotNull);

        // Act
        viewModel.clearError();

        // Assert
        expect(viewModel.errorMessage, isNull);
      });

      test('should notify listeners when clearing error', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenThrow(Exception('Error'));
        await viewModel.fetchProductDetail(1);
        
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.clearError();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('Reset', () {
      test('should reset all state to initial values', () async {
        // Arrange - set some state
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);
        await viewModel.fetchProductDetail(1);
        viewModel.selectImage(2);

        // Act
        viewModel.reset();

        // Assert
        expect(viewModel.isLoading, isFalse);
        expect(viewModel.errorMessage, isNull);
        expect(viewModel.product, isNull);
        expect(viewModel.selectedImageIndex, equals(0));
      });

      test('should notify listeners when reset', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);
        await viewModel.fetchProductDetail(1);
        
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.reset();

        // Assert
        expect(notified, isTrue);
      });
    });

    group('Edge Cases', () {
      test('should handle product with empty images array', () async {
        // Arrange
        final productWithNoImages = ProductDetail(
          id: 1,
          title: 'Test Product',
          description: 'Test Description',
          category: 'Electronics',
          price: 999.99,
          discountPercentage: 15.0,
          rating: 4.5,
          stock: 50,
          tags: [],
          brand: 'TestBrand',
          sku: 'TEST-SKU-001',
          weight: 1.5,
          warrantyInformation: '1 Year Warranty',
          shippingInformation: 'Free Shipping',
          availabilityStatus: 'In Stock',
          images: [],
          thumbnail: 'thumbnail.jpg',
        );
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => productWithNoImages);

        // Act
        await viewModel.fetchProductDetail(1);

        // Assert
        expect(viewModel.product, isNotNull);
        expect(viewModel.product?.images, isEmpty);
      });

      test('should handle product with zero stock', () async {
        // Arrange
        final outOfStockProduct = ProductDetail(
          id: 1,
          title: 'Out of Stock Product',
          description: 'Test Description',
          category: 'Electronics',
          price: 999.99,
          discountPercentage: 15.0,
          rating: 4.5,
          stock: 0,
          tags: [],
          brand: 'TestBrand',
          sku: 'TEST-SKU-001',
          weight: 1.5,
          warrantyInformation: '1 Year Warranty',
          shippingInformation: 'Free Shipping',
          availabilityStatus: 'Out of Stock',
          images: ['image.jpg'],
          thumbnail: 'thumbnail.jpg',
        );
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => outOfStockProduct);

        // Act
        await viewModel.fetchProductDetail(1);

        // Assert
        expect(viewModel.product?.stock, equals(0));
        expect(viewModel.product?.availabilityStatus, equals('Out of Stock'));
      });

      test('should handle network timeout', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenThrow(FetchDataException('Network timeout'));

        // Act
        await viewModel.fetchProductDetail(1);

        // Assert
        expect(viewModel.errorMessage, isNotNull);
        expect(viewModel.product, isNull);
      });

      test('should handle selecting image when no product loaded', () {
        // Act
        viewModel.selectImage(5);

        // Assert - should not crash
        expect(viewModel.selectedImageIndex, equals(5));
      });

      test('should handle multiple consecutive fetches', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);
        when(mockProductRepository.getProductDetail(2))
            .thenAnswer((_) async => mockProduct);
        when(mockProductRepository.getProductDetail(3))
            .thenAnswer((_) async => mockProduct);

        // Act
        await viewModel.fetchProductDetail(1);
        await viewModel.fetchProductDetail(2);
        await viewModel.fetchProductDetail(3);

        // Assert
        expect(viewModel.product, isNotNull);
        verify(mockProductRepository.getProductDetail(1)).called(1);
        verify(mockProductRepository.getProductDetail(2)).called(1);
        verify(mockProductRepository.getProductDetail(3)).called(1);
      });
    });

    group('State Management', () {
      test('should maintain state between operations', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);

        // Act
        await viewModel.fetchProductDetail(1);
        viewModel.selectImage(1);

        // Assert
        expect(viewModel.product, isNotNull);
        expect(viewModel.selectedImageIndex, equals(1));
        expect(viewModel.errorMessage, isNull);
      });

      test('should clear product when fetch fails', () async {
        // Arrange
        when(mockProductRepository.getProductDetail(1))
            .thenAnswer((_) async => mockProduct);
        await viewModel.fetchProductDetail(1);
        expect(viewModel.product, isNotNull);

        // Act - fetch fails
        when(mockProductRepository.getProductDetail(2))
            .thenThrow(Exception('Error'));
        await viewModel.fetchProductDetail(2);

        // Assert
        expect(viewModel.product, isNull);
      });
    });
  });
}

