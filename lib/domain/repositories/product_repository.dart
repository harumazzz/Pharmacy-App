import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/models/product.dart';

@lazySingleton
class ProductRepository {
  final AppDatabase _db;

  const ProductRepository(this._db);

  Future<List<Product>> getAllProducts() {
    return _db.select(_db.products).get();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) {
    return (_db.select(
      _db.products,
    )..where((p) => p.categoryId.equals(categoryId))).get();
  }

  Future<List<Product>> searchProducts(String query) {
    return (_db.select(
      _db.products,
    )..where((p) => p.name.like('%$query%'))).get();
  }

  Future<void> addProduct(Product product) {
    final companion = ProductsCompanion.insert(
      name: product.name,
      description: product.description,
      price: product.price,
      stockQuantity: Value(product.stockQuantity),
      categoryId: product.categoryId,
      imageUrl: Value(product.imageUrl),
    );
    return _db.into(_db.products).insert(companion);
  }

  /// Cập nhật sản phẩm (cho Admin)
  Future<bool> updateProduct(Product product) {
    final companion = ProductsCompanion(
      id: Value(product.id),
      name: Value(product.name),
      description: Value(product.description),
      price: Value(product.price),
      stockQuantity: Value(product.stockQuantity),
      categoryId: Value(product.categoryId),
      imageUrl: Value(product.imageUrl),
    );
    return _db.update(_db.products).replace(companion);
  }

  Future<int> deleteProduct(int id) {
    return (_db.delete(_db.products)..where((p) => p.id.equals(id))).go();
  }
}
