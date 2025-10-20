import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';

@lazySingleton
class CartRepository {
  final AppDatabase _db;

  CartRepository(this._db);

  Future<List<CartItem>> getCartItems(int userId) {
    return (_db.select(
      _db.cartItems,
    )..where((c) => c.userId.equals(userId))).get();
  }

  /// Thêm sản phẩm vào giỏ hàng
  Future<void> addToCart(CartItem item) async {
    // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final existingItem =
        await (_db.select(_db.cartItems)..where(
              (c) =>
                  c.userId.equals(item.userId) &
                  c.productId.equals(item.productId),
            ))
            .getSingleOrNull();

    if (existingItem != null) {
      // Nếu có, cập nhật số lượng
      final newQuantity = existingItem.quantity + item.quantity;
      updateCartItemQuantity(existingItem.id, newQuantity);
    } else {
      // Nếu chưa, thêm mới
      final companion = CartItemsCompanion.insert(
        userId: item.userId,
        productId: item.productId,
        quantity: item.quantity,
      );
      _db.into(_db.cartItems).insert(companion);
    }
  }

  /// Cập nhật số lượng của một item trong giỏ
  Future<void> updateCartItemQuantity(int cartItemId, int newQuantity) {
    return (_db.update(_db.cartItems)..where((c) => c.id.equals(cartItemId)))
        .write(CartItemsCompanion(quantity: Value(newQuantity)));
  }

  /// Xóa một item khỏi giỏ hàng
  Future<int> removeFromCart(int cartItemId) {
    return (_db.delete(
      _db.cartItems,
    )..where((c) => c.id.equals(cartItemId))).go();
  }

  Future<int> clearCart(int userId) {
    return (_db.delete(
      _db.cartItems,
    )..where((c) => c.userId.equals(userId))).go();
  }
}
