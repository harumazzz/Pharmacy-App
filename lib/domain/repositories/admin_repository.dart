import '../../data/models/product.dart';
import '../../data/models/user.dart';

abstract class AdminRepository {
  // Product Management
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> softDeleteProduct(int productId);
  Future<void> restoreProduct(int productId);
  Future<void> permanentlyDeleteProduct(int productId);

  // Category Management
  Future<void> addCategory(String name, String description);
  Future<void> updateCategory(int id, String name, String description);
  Future<void> softDeleteCategory(int categoryId);
  Future<void> restoreCategory(int categoryId);
  Future<void> permanentlyDeleteCategory(int categoryId);

  // User Management
  Future<List<User>> getAllUsers();
  Future<void> softDeleteUser(int userId);
  Future<void> restoreUser(int userId);
  Future<void> permanentlyDeleteUser(int userId);

  // Order Management
  Future<void> updateOrderStatus(int orderId, String status);
  Future<void> softDeleteOrder(int orderId);
  Future<void> restoreOrder(int orderId);
  Future<void> permanentlyDeleteOrder(int orderId);
}
