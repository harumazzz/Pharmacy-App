import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/data/models/order.dart';
import 'package:pharmacy_app/data/models/order_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/providers/cart/cart_items_provider.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';

part 'checkout_provider.freezed.dart';
part 'checkout_provider.g.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial() = _Initial;
  const factory CheckoutState.loading() = _Loading;
  const factory CheckoutState.success() = _Success;
  const factory CheckoutState.error(String message) = _Error;
}

@riverpod
class Checkout extends _$Checkout {
  @override
  CheckoutState build() {
    return const CheckoutState.initial();
  }

  Future<void> placeOrder({
    required int userId,
    required String shippingAddress,
  }) async {
    state = const CheckoutState.loading();
    try {
      final cartItems = await ref.read(cartItemsProvider(userId).future);
      final products = await ref.read(
        productListProvider(categoryId: null).future,
      );

      if (cartItems.isEmpty) {
        state = const CheckoutState.error('Giỏ hàng trống');
        return;
      }

      double totalPrice = 0;
      final orderItems = <OrderItem>[];

      for (final cartItem in cartItems) {
        final product = products.firstWhere(
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
          final itemTotal = product.price * cartItem.quantity;
          totalPrice += itemTotal;
          orderItems.add(
            OrderItem(
              id: 0,
              orderId: 0,
              productId: cartItem.productId,
              quantity: cartItem.quantity,
              price: product.price,
            ),
          );
        }
      }

      final order = Order(
        id: 0,
        userId: userId,
        totalPrice: totalPrice,
        status: 'pending',
        shippingAddress: shippingAddress,
        createdAt: DateTime.now(),
      );

      final orderRepo = ref.read(orderRepositoryProvider);
      await orderRepo.createOrder(order, orderItems);

      state = const CheckoutState.success();
    } catch (e) {
      state = CheckoutState.error('Có lỗi xảy ra: ${e.toString()}');
    }
  }

  void reset() {
    state = const CheckoutState.initial();
  }
}
