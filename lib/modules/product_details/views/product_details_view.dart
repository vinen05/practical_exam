import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../routes/app_routes.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.cart),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Obx(() {
        final product = controller.product.value;

        if (controller.isLoading.value && product == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty && product == null) {
          return Center(
            child: FilledButton(
              onPressed: controller.loadProduct,
              child: const Text('Retry'),
            ),
          );
        }

        if (product == null) {
          return const Center(child: Text('Product not found'));
        }

        return _Details(product: product);
      }),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: product.images?.isEmpty ?? false
                  ? 1
                  : product.images?.length,
              itemBuilder: (_, index) {
                final image = product.images?.isEmpty ?? false
                    ? product.thumbnail
                    : product.images?[index];

                return Hero(
                  tag: index == 0
                      ? 'product-${product.id}'
                      : 'product-${product.id}-$index',
                  child: CachedNetworkImage(
                    imageUrl: image ?? "",
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title ?? "",
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${product.price?.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    const Icon(Icons.star, size: 20),
                    const SizedBox(width: 4),
                    Text(product.rating?.toStringAsFixed(1) ?? ""),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  product.description ?? "",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text('Category: ${product.category}'),
                Text('Stock: ${product.stock}'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      final cart = Get.find<CartController>();
                      cart.addProduct(product);
                      Get.snackbar(
                        'Added to cart',
                        '${product.title} was added to your cart.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
