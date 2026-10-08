import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsController(this._repository);

  final ProductRepository _repository;

  final product = Rxn<ProductModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int get productId {
    final argument = Get.arguments;
    if (argument is ProductModel) return argument.id ?? 0;
    if (argument is int) return argument;
    return 0;
  }

  @override
  void onInit() {
    super.onInit();
    final argument = Get.arguments;

    if (argument is ProductModel) {
      product.value = argument;
    } else {
      loadProduct();
    }
  }

  Future<void> loadProduct() async {
    if (productId <= 0) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      product.value = await _repository.getProduct(productId);
    } catch (_) {
      errorMessage.value = 'Unable to load product details.';
    } finally {
      isLoading.value = false;
    }
  }
}
