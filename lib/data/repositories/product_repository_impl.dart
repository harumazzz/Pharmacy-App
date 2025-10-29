import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/product_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/product.dart' as model;

@LazySingleton(as: domain.ProductRepository)
class ProductRepositoryImpl implements domain.ProductRepository {
  final AppDatabase _db;

  const ProductRepositoryImpl(this._db);

  @override
  Stream<List<model.Product>> watchProducts({int? categoryId}) {
    final query = _db.select(_db.products);
    if (categoryId != null) {
      query.where((p) => p.categoryId.equals(categoryId));
    }
    return query.watch().map(
      (products) => products
          .map(
            (product) => model.Product(
              id: product.id,
              name: product.name,
              description: product.description,
              price: product.price,
              stockQuantity: product.stockQuantity,
              categoryId: product.categoryId,
              imageUrl: product.imageUrl,
            ),
          )
          .toList(),
    );
  }

  @override
  Stream<List<model.Product>> searchProducts({String? name}) {
    final query = _db.select(_db.products);
    if (name != null && name.isNotEmpty) {
      query.where((p) => p.name.like('%$name%'));
    }
    return query.watch().map(
      (products) => products
          .map(
            (product) => model.Product(
              id: product.id,
              name: product.name,
              description: product.description,
              price: product.price,
              stockQuantity: product.stockQuantity,
              categoryId: product.categoryId,
              imageUrl: product.imageUrl,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<model.Product> getProductDetails(int productId) async {
    final product = await (_db.select(
      _db.products,
    )..where((p) => p.id.equals(productId))).getSingle();
    return model.Product(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      stockQuantity: product.stockQuantity,
      categoryId: product.categoryId,
      imageUrl: product.imageUrl,
    );
  }
}
