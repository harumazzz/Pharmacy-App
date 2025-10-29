import 'package:drift/drift.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/data/local/table/cart_items_table.dart';

part 'cart_item_dao.g.dart';

@DriftAccessor(tables: [CartItems])
class CartItemDao extends DatabaseAccessor<AppDatabase> with _$CartItemDaoMixin {
  final AppDatabase db;

  CartItemDao(this.db) : super(db);

  Future<List<CartItem>> getCartItems(int userId) {
    return (select(cartItems)..where((c) => c.userId.equals(userId))).get();
  }

  Future<CartItem?> getCartItem(int userId, int productId) {
    return (select(cartItems)
          ..where(
              (c) => c.userId.equals(userId) & c.productId.equals(productId)))
        .getSingleOrNull();
  }

  Future<void> insertCartItem(CartItemsCompanion cartItem) =>
      into(cartItems).insert(cartItem);

  Future<void> updateCartItemQuantity(int cartItemId, int newQuantity) {
    return (update(cartItems)..where((c) => c.id.equals(cartItemId)))
        .write(CartItemsCompanion(quantity: Value(newQuantity)));
  }

  Future<int> removeCartItem(int cartItemId) =>
      (delete(cartItems)..where((c) => c.id.equals(cartItemId))).go();

  Future<int> clearCart(int userId) =>
      (delete(cartItems)..where((c) => c.userId.equals(userId))).go();
}
