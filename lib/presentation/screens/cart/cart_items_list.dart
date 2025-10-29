import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/cart_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/screens/cart/cart_item_tile.dart';

class CartItemsList extends ConsumerWidget {
  final List<CartItem> cartItems;
  final List<Product> products;

  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartItems[index];
        final product = products.firstWhere(
          (p) => p.id == cartItem.productId,
          orElse: () => const Product(
            id: -1,
            name: 'Unknown',
            description: '',
            price: 0,
            stockQuantity: 0,
            categoryId: 0,
          ),
        );

        if (product.id == -1) {
          return const SizedBox.shrink();
        }

        return CartItemTile(cartItem: cartItem, product: product);
      },
    );
  }
}
