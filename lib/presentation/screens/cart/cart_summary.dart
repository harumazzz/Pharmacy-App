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
    int totalItems = 0;

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
        totalItems += cartItem.quantity;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary Stats
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số lượng sản phẩm:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '$totalItems',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tạm tính:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(0)}₫',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 24, color: Colors.grey[300]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng cộng:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(0)}₫',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              PrimaryButton(
                text: 'Tiến hành thanh toán',
                icon: Icons.payment,
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
        ),
      ),
    );
  }
}
