import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/cart_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/screens/checkout/checkout_screen.dart';
import 'package:pharmacy_app/presentation/widgets/primary_button.dart';

class CartSummary extends ConsumerWidget {
  final List<CartItem> cartItems;
  final List<Product> products;
  final int userId;

  const CartSummary({
    super.key,
    required this.cartItems,
    required this.products,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double total = 0;
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
        total += product.price * cartItem.quantity;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 16.0),
          PrimaryButton(
            text: 'Thanh toán',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
