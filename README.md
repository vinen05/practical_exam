# Flutter Product Catalog — GetX Practical Assignment

A complete interview-practice Flutter application using:

- Flutter / Dart
- GetX for state management, routing and dependency injection
- Dio for REST APIs
- Hive for local cart persistence
- CachedNetworkImage for image caching
- Mocktail for controller/repository tests

## API

DummyJSON:
- Products: `https://dummyjson.com/products?limit=20&skip=0`
- Search: `https://dummyjson.com/products/search?q=phone`
- Categories: `https://dummyjson.com/products/categories`
- Category: `https://dummyjson.com/products/category/smartphones`
- Product: `https://dummyjson.com/products/1`

## Features

1. Product list
2. Infinite pagination
3. Search with 400ms debounce
4. Category filter
5. Product details
6. Add to cart
7. Quantity +/- controls
8. Remove cart item
9. Subtotal, 10% tax and total
10. Hive persistence
11. Loading, empty and error states
12. Pull-to-refresh
13. GetX named routing and bindings
14. Unit tests for cart calculations and product controller behavior

## Run

```bash
flutter pub get
flutter run
```

Run tests:

```bash
flutter test
```

## Architecture

View
-> GetX Controller
-> Repository
-> API Provider
-> Dio
-> DummyJSON

Cart View
-> CartController
-> CartRepository
-> Hive

The widgets intentionally contain very little business logic. Controllers own UI state and repositories own data access.

## Interview talking points

- Pagination uses `skip = current product count` and guards duplicate requests.
- Search is debounced so the API is not called on every keystroke.
- Cart is keyed by product ID, so adding the same product increments quantity.
- Hive stores only the data required to reconstruct the cart.
- UI distinguishes initial loading, loading-more, empty, success and error.
- Dio is centralized so timeouts and HTTP behavior are consistent.
- The project is structured so API/data code can be tested independently from UI.
