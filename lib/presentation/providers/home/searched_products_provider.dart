import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';

part 'searched_products_provider.g.dart';

@riverpod
Stream<List<Product>> searchedProducts(Ref ref, String query) {
  if (query.isEmpty) {
    return Stream.value([]);
  }
  final productRepo = ref.watch(productRepositoryProvider);
  return productRepo.searchProducts(name: query);
}
