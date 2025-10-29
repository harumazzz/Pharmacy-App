import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/data/models/cart_item.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';

part 'cart_items_provider.g.dart';

@riverpod
Stream<List<CartItem>> cartItems(Ref ref, int userId) {
  final cartRepo = ref.watch(cartRepositoryProvider);
  return cartRepo.watchCartItems(userId);
}
