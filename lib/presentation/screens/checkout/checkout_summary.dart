import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/cart_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/widgets/list_item.dart';

class CheckoutSummary extends ConsumerWidget {
  final List<CartItem> cartItems;
  final List<Product> products;

  const CheckoutSummary({
    super.key,
    required this.cartItems,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double total = 0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đơn hàng của bạn',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16.0),
          ...cartItems.map((cartItem) {
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

            final subtotal = product.price * cartItem.quantity;
            total += subtotal;

            return ListItem(
              title: Text(product.name),
              subtitle: Text(
                '${product.price.toStringAsFixed(2)}₫ × ${cartItem.quantity}',
              ),
              trailing: Text(
                '${subtotal.toStringAsFixed(2)}₫',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${total.toStringAsFixed(2)}₫',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
