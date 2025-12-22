import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pharmacy_app/domain/repositories/admin_repository.dart';
import 'package:pharmacy_app/domain/repositories/auth_repository.dart';
import 'package:pharmacy_app/domain/repositories/cart_repository.dart';
import 'package:pharmacy_app/domain/repositories/category_repository.dart';
import 'package:pharmacy_app/domain/repositories/order_repository.dart';
import 'package:pharmacy_app/domain/repositories/product_repository.dart';
import 'package:pharmacy_app/domain/repositories/user_repository.dart';
import 'package:pharmacy_app/di/injection.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => getIt<AuthRepository>(),
);
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => getIt<ProductRepository>(),
);
final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => getIt<CategoryRepository>(),
);
final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => getIt<CartRepository>(),
);
final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => getIt<OrderRepository>(),
);
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => getIt<UserRepository>(),
);
final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => getIt<AdminRepository>(),
);

final authStateProvider = StateProvider<bool>((ref) => false);

final categoriesStreamProvider = StreamProvider((ref) {
  final categoryRepo = ref.watch(categoryRepositoryProvider);
  return categoryRepo.watchCategories();
});

final productsStreamProvider = StreamProvider.family((ref, int? categoryId) {
  final productRepo = ref.watch(productRepositoryProvider);
  return productRepo.watchProducts(categoryId: categoryId);
});

final searchProductsStreamProvider = StreamProvider.family((ref, String name) {
  final productRepo = ref.watch(productRepositoryProvider);
  return productRepo.searchProducts(name: name);
});

final cartItemsStreamProvider = StreamProvider.family((ref, int userId) {
  final cartRepo = ref.watch(cartRepositoryProvider);
  return cartRepo.watchCartItems(userId);
});

final orderHistoryProvider = StreamProvider.family((ref, int userId) {
  final orderRepo = ref.watch(orderRepositoryProvider);
  return orderRepo.watchOrders(userId);
});

final orderDetailProvider = FutureProvider.family((ref, int orderId) {
  final orderRepo = ref.watch(orderRepositoryProvider);
  return orderRepo.getOrderDetail(orderId);
});

final orderItemsProvider = FutureProvider.family((ref, int orderId) {
  final orderRepo = ref.watch(orderRepositoryProvider);
  return orderRepo.getOrderItems(orderId);
});

final productDetailsProvider = FutureProvider.family((ref, int productId) {
  final productRepo = ref.watch(productRepositoryProvider);
  return productRepo.getProductDetails(productId);
});

// Admin providers
final categoryListProvider = StreamProvider((ref) {
  final categoryRepo = ref.watch(categoryRepositoryProvider);
  return categoryRepo.watchCategories();
});

final orderListProvider = StreamProvider((ref) {
  final orderRepo = ref.watch(orderRepositoryProvider);
  return orderRepo.watchAllOrders();
});

final userListProvider = StreamProvider((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return userRepo.watchAllUsers();
});

// Note: productDetailProvider is defined in product_detail/product_detail_provider.dart
