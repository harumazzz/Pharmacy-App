import '../../data/models/product.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchProducts({int? categoryId});
  Stream<List<Product>> searchProducts({String name});
  Future<Product> getProductDetails(int productId);
}
