import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/admin_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/product.dart' as model;
import 'package:pharmacy_app/data/models/user.dart' as user_model;

@LazySingleton(as: domain.AdminRepository)
class AdminRepositoryImpl implements domain.AdminRepository {
  final AppDatabase _db;

  const AdminRepositoryImpl(this._db);

  // Product Management
  @override
  Future<void> addProduct(model.Product product) {
    final companion = ProductsCompanion.insert(
      name: product.name,
      description: product.description,
      price: product.price,
      stockQuantity: product.stockQuantity,
      categoryId: product.categoryId,
      imageUrl: product.imageUrl ?? '',
    );
    return _db.productDao.addProduct(companion);
  }

  @override
  Future<void> updateProduct(model.Product product) {
    final companion = ProductsCompanion(
      id: Value(product.id),
      name: Value(product.name),
      description: Value(product.description),
      price: Value(product.price),
      stockQuantity: Value(product.stockQuantity),
      categoryId: Value(product.categoryId),
      imageUrl: Value(product.imageUrl ?? ''),
    );
    return _db.productDao.updateProduct(companion);
  }

  @override
  Future<void> softDeleteProduct(int productId) =>
      _db.productDao.softDeleteProduct(productId).then((_) {});

  @override
  Future<void> restoreProduct(int productId) =>
      _db.productDao.restoreProduct(productId).then((_) {});

  @override
  Future<void> permanentlyDeleteProduct(int productId) =>
      _db.productDao.permanentlyDeleteProduct(productId).then((_) {});

  // Category Management
  @override
  Future<void> addCategory(String name, String description) {
    final companion = CategoriesCompanion.insert(
      name: name,
      description: description,
    );
    return _db.categoryDao.addCategory(companion);
  }

  @override
  Future<void> updateCategory(int id, String name, String description) {
    final companion = CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
    );
    return _db.categoryDao.updateCategory(companion);
  }

  @override
  Future<void> softDeleteCategory(int categoryId) =>
      _db.categoryDao.softDeleteCategory(categoryId).then((_) {});

  @override
  Future<void> restoreCategory(int categoryId) =>
      _db.categoryDao.restoreCategory(categoryId).then((_) {});

  @override
  Future<void> permanentlyDeleteCategory(int categoryId) =>
      _db.categoryDao.permanentlyDeleteCategory(categoryId).then((_) {});

  // User Management
  @override
  Future<List<user_model.User>> getAllUsers() async {
    final users = await _db.userDao.getAllUsers();
    return users
        .map(
          (user) => user_model.User(
            id: user.id,
            username: user.username,
            password: user.password,
            fullName: user.fullName,
            role: user.role,
          ),
        )
        .toList();
  }

  @override
  Future<void> softDeleteUser(int userId) =>
      _db.userDao.softDeleteUser(userId).then((_) {});

  @override
  Future<void> restoreUser(int userId) =>
      _db.userDao.restoreUser(userId).then((_) {});

  @override
  Future<void> permanentlyDeleteUser(int userId) =>
      _db.userDao.permanentlyDeleteUser(userId).then((_) {});

  // Order Management
  @override
  Future<void> updateOrderStatus(int orderId, String status) =>
      _db.orderDao.updateOrderStatus(orderId, status);

  @override
  Future<void> softDeleteOrder(int orderId) =>
      _db.orderDao.softDeleteOrder(orderId).then((_) {});

  @override
  Future<void> restoreOrder(int orderId) =>
      _db.orderDao.restoreOrder(orderId).then((_) {});

  @override
  Future<void> permanentlyDeleteOrder(int orderId) =>
      _db.orderDao.permanentlyDeleteOrder(orderId).then((_) {});
}
