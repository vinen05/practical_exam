import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  HomeController(this._repository);

  final ProductRepository _repository;

  final products = <ProductModel>[].obs;
  final categories = <String>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;

  final selectedCategory = ''.obs;
  final searchQuery = ''.obs;
  final hasMore = true.obs;

  final searchController = TextEditingController();

  static const int pageSize = 20;
  Timer? _debounce;
  int _requestToken = 0;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
    loadCategories();
  }

  Future<void> loadInitial() async {
    final token = ++_requestToken;
    isLoading.value = true;
    errorMessage.value = '';
    products.clear();
    hasMore.value = true;

    try {
      final response = await _fetchPage(skip: 0);

      if (token != _requestToken) return;

      products.assignAll(response.products);
      hasMore.value = products.length < response.total;
    } catch (e) {
      if (token == _requestToken) {
        errorMessage.value = _friendlyError(e);
      }
    } finally {
      if (token == _requestToken) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;

    try {
      final response = await _fetchPage(skip: products.length);
      final existingIds = products.map((e) => e.id).toSet();

      products.addAll(
        response.products.where((p) => !existingIds.contains(p.id)),
      );

      hasMore.value = products.length < response.total;
    } catch (e) {
      Get.snackbar(
        'Could not load more',
        _friendlyError(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshProducts() async {
    isRefreshing.value = true;
    try {
      await loadInitial();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      categories.assignAll(await _repository.getCategories());
    } catch (_) {
      // Category chips are optional; product loading remains usable.
    }
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      searchQuery.value = value.trim();
      selectedCategory.value = '';
      loadInitial();
    });
  }

  Future<void> selectCategory(String category) async {
    _debounce?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();

    searchController.clear();
    searchQuery.value = '';
    selectedCategory.value = category;

    await loadInitial();
  }

  void clearFilters() {
    _debounce?.cancel();
    searchController.clear();
    searchQuery.value = '';
    selectedCategory.value = '';
    loadInitial();
  }

  Future<dynamic> _fetchPage({required int skip}) {
    if (searchQuery.value.isNotEmpty) {
      return _repository.searchProducts(
        query: searchQuery.value,
        limit: pageSize,
        skip: skip,
      );
    }

    if (selectedCategory.value.isNotEmpty) {
      return _repository.getProductsByCategory(
        category: selectedCategory.value,
        limit: pageSize,
        skip: skip,
      );
    }

    return _repository.getProducts(
      limit: pageSize,
      skip: skip,
    );
  }

  String _friendlyError(Object error) {
    final text = error.toString();
    if (text.contains('SocketException') ||
        text.contains('connection') ||
        text.contains('Network')) {
      return 'Please check your internet connection.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
