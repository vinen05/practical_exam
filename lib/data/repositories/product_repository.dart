import '../models/product_model.dart';
import '../models/product_response.dart';
import '../providers/product_api_provider.dart';

class ProductRepository {
  ProductRepository(this._provider);

  final ProductApiProvider _provider;

  Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) {
    return _provider.getProducts(limit: limit, skip: skip);
  }

  Future<ProductResponse> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
  }) {
    return _provider.searchProducts(query: query, limit: limit, skip: skip);
  }

  Future<List<String>> getCategories() {
    return _provider.getCategories();
  }

  Future<ProductResponse> getProductsByCategory({
    required String category,
    int limit = 20,
    int skip = 0,
  }) {
    return _provider.getProductsByCategory(
      category: category,
      limit: limit,
      skip: skip,
    );
  }

  Future<ProductModel> getProduct(int id) {
    return _provider.getProduct(id);
  }
}
