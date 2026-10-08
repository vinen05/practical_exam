import 'package:flutter_test/flutter_test.dart';
import 'package:practical_exam/data/models/product_model.dart';

void main() {
  test('ProductModel parses API JSON safely', () {
    final product = ProductModel.fromJson({
      'id': 1,
      'title': 'Test Phone',
      'description': 'Description',
      'category': 'smartphones',
      'price': 99.99,
      'rating': 4.5,
      'stock': 8,
      'thumbnail': 'https://example.com/a.jpg',
      'images': ['https://example.com/a.jpg'],
    });

    expect(product.id, 1);
    expect(product.title, 'Test Phone');
    expect(product.price, 99.99);
    expect(product.images?.length ?? 0, 1);
  });
}
