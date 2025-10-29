import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/products_table.dart';

part 'product_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  final AppDatabase db;

  ProductDao(this.db) : super(db);

  Future<List<Product>> getAllProducts() => select(products).get();

  Future<List<Product>> getProductsByCategory(int categoryId) {
    return (select(products)..where((p) => p.categoryId.equals(categoryId)))
        .get();
  }

  Future<List<Product>> searchProducts(String query) {
    return (select(products)..where((p) => p.name.like('%$query%'))).get();
  }

  Future<void> addProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Future<bool> updateProduct(ProductsCompanion product) =>
      update(products).replace(product);

  Future<int> deleteProduct(int id) =>
      (delete(products)..where((p) => p.id.equals(id))).go();
}
