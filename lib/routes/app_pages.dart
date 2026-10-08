import 'package:get/get.dart';

import '../modules/cart/controllers/cart_controller.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/home/views/home_view.dart';
import '../modules/product_details/controllers/product_details_controller.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../data/repositories/cart_repository.dart';
import '../data/repositories/product_repository.dart';
import '../data/providers/product_api_provider.dart';
import '../core/network/api_client.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: Routes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
  ];
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    _registerDataLayer();
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<ProductRepository>()),
    );
    Get.lazyPut<CartController>(
      () => CartController(Get.find<CartRepository>()),
      fenix: true,
    );
  }
}

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    _registerDataLayer();
    Get.lazyPut<ProductDetailsController>(
      () => ProductDetailsController(Get.find<ProductRepository>()),
    );
    Get.lazyPut<CartController>(
      () => CartController(Get.find<CartRepository>()),
      fenix: true,
    );
  }
}

class CartBinding extends Bindings {
  @override
  void dependencies() {
    _registerDataLayer();
    Get.lazyPut<CartController>(
      () => CartController(Get.find<CartRepository>()),
    );
  }
}

void _registerDataLayer() {
  if (!Get.isRegistered<ApiClient>()) {
    Get.put<ApiClient>(ApiClient(), permanent: true);
  }

  if (!Get.isRegistered<ProductApiProvider>()) {
    Get.lazyPut<ProductApiProvider>(
      () => ProductApiProvider(Get.find<ApiClient>()),
      fenix: true,
    );
  }

  if (!Get.isRegistered<ProductRepository>()) {
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(Get.find<ProductApiProvider>()),
      fenix: true,
    );
  }

  if (!Get.isRegistered<CartRepository>()) {
    Get.lazyPut<CartRepository>(CartRepository.new, fenix: true);
  }
}
