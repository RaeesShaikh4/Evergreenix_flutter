import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exceptions.dart';
import '../models/home_products.dart';

class HomeRepository {
  final ApiClient apiClient;
  HomeRepository(this.apiClient);

  Future<ProductResponse> getHomeProducts({
    int? limit,
    int? skip,
  }) async {
    try {
      final Map<String, String> queryParams = {};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (skip != null) queryParams['skip'] = skip.toString();

      final response = await apiClient.getHomeProducts(
        ApiEndpoints.homeProducts,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      return ProductResponse.fromJson(response as Map<String, dynamic>);
    } on ApiExceptions {
      rethrow;
    } catch (e) {
      throw FetchDataException('Failed to fetch home products: $e');
    }
  }
}