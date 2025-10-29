import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';

part 'product_list_provider.g.dart';

@riverpod
Stream<List<Product>> productList(Ref ref, {int? categoryId}) {
  final productRepo = ref.watch(productRepositoryProvider);
  return productRepo.watchProducts(categoryId: categoryId);
}
