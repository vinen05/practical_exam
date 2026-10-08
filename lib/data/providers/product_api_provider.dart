import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/product_model.dart';
import '../models/product_response.dart';

class ProductApiProvider {
  ProductApiProvider(this._client);

  final ApiClient _client;

  Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) async {
    final response = await _client.dio.get(
      ApiEndpoints.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );

    return ProductResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<ProductResponse> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await _client.dio.get(
      ApiEndpoints.searchProducts,
      queryParameters: {'q': query, 'limit': limit, 'skip': skip},
    );

    return ProductResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<List<String>> getCategories() async {
    final response = await _client.dio.get(ApiEndpoints.categories);
    final data = response.data;

    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    return [];
  }

  Future<ProductResponse> getProductsByCategory({
    required String category,
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await _client.dio.get(
      '${ApiEndpoints.categoryProducts}/$category',
      queryParameters: {'limit': limit, 'skip': skip},
    );

    return ProductResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<ProductModel> getProduct(int id) async {
    final response = await _client.dio.get('${ApiEndpoints.productById}/$id');

    return ProductModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
