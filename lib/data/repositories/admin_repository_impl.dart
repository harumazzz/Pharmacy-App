import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/admin_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/product.dart' as model;

@LazySingleton(as: domain.AdminRepository)
class AdminRepositoryImpl implements domain.AdminRepository {
  final AppDatabase _db;

  const AdminRepositoryImpl(this._db);

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
  Future<void> deleteProduct(int productId) {
    return _db.productDao.deleteProduct(productId);
  }
}
