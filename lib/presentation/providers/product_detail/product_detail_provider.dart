import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';

part 'product_detail_provider.g.dart';

@riverpod
Future<Product> productDetail(Ref ref, int productId) {
  final productRepo = ref.watch(productRepositoryProvider);
  return productRepo.getProductDetails(productId);
}
