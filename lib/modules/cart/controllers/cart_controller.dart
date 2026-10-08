import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/cart_repository.dart';

class CartController extends GetxController {
  CartController(this._repository);

  final CartRepository _repository;

  final items = <CartItem>[].obs;
  final isLoading = false.obs;

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  double get tax => subtotal * 0.10;

  double get total => subtotal + tax;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  void onInit() {
    super.onInit();
    items.assignAll(_repository.loadItems());
  }

  Future<void> addProduct(ProductModel product) async {
    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      items.add(CartItem(product: product, quantity: 1));
    } else {
      final current = items[index];
      final nextQuantity = current.quantity + 1;

      if ((product.stock ?? 0) > 0 && nextQuantity > (product.stock ?? 0)) {
        return;
      }

      items[index] = current.copyWith(quantity: nextQuantity);
    }

    await _persist();
  }

  Future<void> increment(CartItem item) async {
    final index = _indexOf(item.product.id ?? 0);
    if (index == -1) return;

    if ((item.product.stock ?? 0) > 0 &&
        item.quantity >= (item.product.stock ?? 0)) {
      return;
    }

    items[index] = item.copyWith(quantity: item.quantity + 1);
    await _persist();
  }

  Future<void> decrement(CartItem item) async {
    final index = _indexOf(item.product.id ?? 0);
    if (index == -1) return;

    if (item.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(quantity: item.quantity - 1);
    }

    await _persist();
  }

  Future<void> remove(CartItem item) async {
    items.removeWhere((e) => e.product.id == item.product.id);
    await _persist();
  }

  Future<void> clearCart() async {
    items.clear();
    await _repository.clear();
  }

  int _indexOf(int id) => items.indexWhere((item) => item.product.id == id);

  Future<void> _persist() => _repository.saveItems(items.toList());
}
