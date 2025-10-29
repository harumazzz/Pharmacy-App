import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/cart_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/list_item.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem cartItem;
  final Product product;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = product.price * cartItem.quantity;

    return ListItem(
      leading: CircleAvatar(child: Text('${cartItem.quantity}')),
      title: Text(product.name),
      subtitle: Text(
        '${product.price.toStringAsFixed(2)}₫ × ${cartItem.quantity} = ${subtotal.toStringAsFixed(2)}₫',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: QuantityControls(cartItem: cartItem),
    );
  }
}

class QuantityControls extends ConsumerWidget {
  final CartItem cartItem;

  const QuantityControls({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartRepo = ref.read(cartRepositoryProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: cartItem.quantity > 1
              ? () {
                  cartRepo.updateCartItem(cartItem.id, cartItem.quantity - 1);
                }
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            cartRepo.updateCartItem(cartItem.id, cartItem.quantity + 1);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            cartRepo.removeProductFromCart(cartItem.id);
          },
        ),
      ],
    );
  }
}
