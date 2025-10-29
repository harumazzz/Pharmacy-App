import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/cart/cart_items_provider.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';

part 'cart_total_provider.g.dart';

@riverpod
Future<double> cartTotal(Ref ref, int userId) async {
  final cartItemsAsync = await ref.watch(cartItemsProvider(userId).future);
  final productsAsync = await ref.watch(
    productListProvider(categoryId: null).future,
  );

  double total = 0;
  for (final cartItem in cartItemsAsync) {
    final product = productsAsync.firstWhere(
      (p) => p.id == cartItem.productId,
      orElse: () => const Product(
        id: -1,
        name: '',
        description: '',
        price: 0,
        stockQuantity: 0,
        categoryId: 0,
      ),
    );
    if (product.id != -1) {
      total += product.price * cartItem.quantity;
    }
  }
  return total;
}
