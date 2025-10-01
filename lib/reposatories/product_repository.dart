import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/product_detail.dart';

class ProductRepository {
  final ApiClient apiClient;
  
  ProductRepository(this.apiClient);

  /// Fetches product detail by ID from the API
  /// 
  /// Parameters:
  /// - [productId]: The ID of the product to fetch
  /// 
  /// Returns [ProductDetail] containing detailed product information
  /// Throws [ApiExceptions] on error
  Future<ProductDetail> getProductDetail(int productId) async {
    try {
      final response = await apiClient.getProductDetail(
        ApiEndpoints.productDetail(productId),
      );

      return ProductDetail.fromJson(response as Map<String, dynamic>);
    } on ApiExceptions {
      rethrow;
    } catch (e) {
      throw FetchDataException('Failed to fetch product detail: $e');
    }
  }
}

