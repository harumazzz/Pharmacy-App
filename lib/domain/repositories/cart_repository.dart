import '../../data/models/cart_item.dart';

abstract class CartRepository {
  Stream<List<CartItem>> watchCartItems(int userId);
  Future<void> addProductToCart(int userId, int productId);
  Future<void> updateCartItem(int cartItemId, int quantity);
  Future<void> removeProductFromCart(int cartItemId);
  Future<void> clearCart(int userId);
}
