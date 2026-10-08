// ignore_for_file: dead_code

import 'package:hive/hive.dart';

import '../../core/storage/local_storage.dart';
import '../models/product_model.dart';

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final ProductModel product;
  final int quantity;

  double get lineTotal => (product.price ?? 0) * (quantity);

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}

class CartRepository {
  Box<Map> get _box => LocalStorage.cartBox;

  List<CartItem> loadItems() {
    return _box.values.map((raw) {
      final map = Map<String, dynamic>.from(raw);
      final product = ProductModel(
        id: (map['id'] as num).toInt(),
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        category: map['category'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        rating: 0,
        stock: (map['stock'] as num?)?.toInt() ?? 0,
        thumbnail: map['thumbnail'] as String? ?? '',
        images: const [],
      );

      return CartItem(
        product: product,
        quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      );
    }).toList();
  }

  Future<void> saveItems(List<CartItem> items) async {
    await _box.clear();

    for (final item in items) {
      await _box.put(item.product.id, {
        'id': item.product.id,
        'title': item.product.title,
        'description': item.product.description,
        'category': item.product.category,
        'price': item.product.price,
        'stock': item.product.stock,
        'thumbnail': item.product.thumbnail,
        'quantity': item.quantity,
      });
    }
  }

  Future<void> clear() => _box.clear();
}
