import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:practical_exam/data/models/product_model.dart';
import 'package:practical_exam/data/repositories/cart_repository.dart';
import 'package:practical_exam/modules/cart/controllers/cart_controller.dart';

class FakeCartRepository extends CartRepository {
  final List<CartItem> stored = [];

  @override
  List<CartItem> loadItems() => List<CartItem>.from(stored);

  @override
  Future<void> saveItems(List<CartItem> items) async {
    stored
      ..clear()
      ..addAll(items);
  }

  @override
  Future<void> clear() async => stored.clear();
}

void main() {
  late CartController controller;
  late FakeCartRepository repository;

  final product = ProductModel(
    id: 1,
    title: 'Phone',
    description: 'Test',
    category: 'smartphones',
    price: 100,
    rating: 4.5,
    stock: 10,
    thumbnail: 'https://example.com/image.jpg',
    images: const [],
  );

  setUp(() {
    repository = FakeCartRepository();
    controller = CartController(repository);
    controller.onInit();
  });

  test('adds product and calculates subtotal/tax/total', () async {
    await controller.addProduct(product);

    expect(controller.itemCount, 1);
    expect(controller.subtotal, 100);
    expect(controller.tax, 10);
    expect(controller.total, 110);
  });

  test('adding same product increments quantity', () async {
    await controller.addProduct(product);
    await controller.addProduct(product);

    expect(controller.itemCount, 2);
    expect(controller.items.single.quantity, 2);
    expect(controller.subtotal, 200);
  });

  test('decrement removes item when quantity reaches zero', () async {
    await controller.addProduct(product);
    final item = controller.items.single;

    await controller.decrement(item);

    expect(controller.items, isEmpty);
  });

  test('clear cart removes all items', () async {
    await controller.addProduct(product);
    await controller.clearCart();

    expect(controller.items, isEmpty);
    expect(controller.total, 0);
  });
}
