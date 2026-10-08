import 'package:flutter_test/flutter_test.dart';
import 'package:practical_exam/data/models/product_model.dart';
import 'package:practical_exam/data/models/product_response.dart';
import 'package:practical_exam/data/repositories/product_repository.dart';
import 'package:practical_exam/modules/home/controllers/home_controller.dart';

class FakeProductRepository extends ProductRepository {
  FakeProductRepository()
    : super(throw UnsupportedError('API provider is not used in this test'));

  @override
  Future<ProductResponse> getProducts({int limit = 20, int skip = 0}) async {
    return ProductResponse(
      products: [
        ProductModel(
          id: 1,
          title: 'Phone',
          description: 'Test',
          category: 'smartphones',
          price: 100,
          rating: 4,
          stock: 10,
          thumbnail: 'image',
          images: const [],
        ),
      ],
      total: 1,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<List<String>> getCategories() async => ['smartphones'];
}

void main() {
  test('HomeController loads products', () async {
    final controller = HomeController(FakeProductRepository());

    await controller.loadInitial();

    expect(controller.products.length, 1);
    expect(controller.products.first.title, 'Phone');
    expect(controller.hasMore.value, false);

    controller.onClose();
  });
}
