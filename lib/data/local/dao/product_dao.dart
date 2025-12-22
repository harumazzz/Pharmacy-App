import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/products_table.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  final AppDatabase db;

  ProductDao(this.db) : super(db);

  Future<List<Product>> getAllProducts() =>
      (select(products)..where((p) => p.deletedAt.isNull())).get();

  Future<List<Product>> getProductsByCategory(int categoryId) {
    return (select(
          products,
        )..where((p) => p.categoryId.equals(categoryId) & p.deletedAt.isNull()))
        .get();
  }

  Future<List<Product>> searchProducts(String query) {
    return (select(
      products,
    )..where((p) => p.name.like('%$query%') & p.deletedAt.isNull())).get();
  }

  Future<void> addProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Future<bool> updateProduct(ProductsCompanion product) =>
      update(products).replace(product);

  Future<int> softDeleteProduct(int id) =>
      (update(products)..where((p) => p.id.equals(id))).write(
        ProductsCompanion(deletedAt: Value(DateTime.now())),
      );

  Future<int> permanentlyDeleteProduct(int id) =>
      (delete(products)..where((p) => p.id.equals(id))).go();

  Future<int> restoreProduct(int id) =>
      (update(products)..where((p) => p.id.equals(id))).write(
        const ProductsCompanion(deletedAt: Value(null)),
      );

  Future<List<Product>> getDeletedProducts() =>
      (select(products)..where((p) => p.deletedAt.isNotNull())).get();

  Stream<List<Product>> getAllProductsStream() =>
      (select(products)..where((p) => p.deletedAt.isNull())).watch();

  Stream<List<Product>> getDeletedProductsStream() =>
      (select(products)..where((p) => p.deletedAt.isNotNull())).watch();

  Stream<List<Product>> getProductsByCategoryStream(int categoryId) {
    return (select(
          products,
        )..where((p) => p.categoryId.equals(categoryId) & p.deletedAt.isNull()))
        .watch();
  }
}
