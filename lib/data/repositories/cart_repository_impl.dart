import 'package:injectable/injectable.dart';
import 'package:pharmacy_app/data/local/app_database.dart';
import 'package:pharmacy_app/domain/repositories/cart_repository.dart'
    as domain;
import 'package:pharmacy_app/data/models/cart_item.dart' as model;

@LazySingleton(as: domain.CartRepository)
class CartRepositoryImpl implements domain.CartRepository {
  final AppDatabase _db;

  const CartRepositoryImpl(this._db);

  @override
  Stream<List<model.CartItem>> watchCartItems(int userId) {
    return (_db.select(
      _db.cartItems,
    )..where((c) => c.userId.equals(userId))).watch().map(
      (cartItems) => cartItems
          .map(
            (item) => model.CartItem(
              id: item.id,
              userId: item.userId,
              productId: item.productId,
              quantity: item.quantity,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> addProductToCart(int userId, int productId) async {
    final existingItem = await _db.cartItemDao.getCartItem(userId, productId);
    if (existingItem != null) {
      final newQuantity = existingItem.quantity + 1;
      await _db.cartItemDao.updateCartItemQuantity(
        existingItem.id,
        newQuantity,
      );
    } else {
      final companion = CartItemsCompanion.insert(
        userId: userId,
        productId: productId,
        quantity: 1,
      );
      await _db.cartItemDao.insertCartItem(companion);
    }
  }

  @override
  Future<void> updateCartItem(int cartItemId, int quantity) {
    if (quantity <= 0) {
      return _db.cartItemDao.removeCartItem(cartItemId).then((_) {});
    }
    return _db.cartItemDao.updateCartItemQuantity(cartItemId, quantity);
  }

  @override
  Future<void> removeProductFromCart(int cartItemId) {
    return _db.cartItemDao.removeCartItem(cartItemId).then((_) {});
  }

  @override
  Future<void> clearCart(int userId) {
    return _db.cartItemDao.clearCart(userId).then((_) {});
  }
}
