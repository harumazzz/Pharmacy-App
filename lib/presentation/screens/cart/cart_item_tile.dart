import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/models/cart_item.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';

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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Icon(
                Icons.medical_services,
                size: 40,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 16.0),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(0)}₫',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Tổng: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        '${subtotal.toStringAsFixed(0)}₫',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Quantity Controls
            QuantityControls(cartItem: cartItem),
          ],
        ),
      ),
    );
  }
}

class QuantityControls extends ConsumerWidget {
  final CartItem cartItem;

  const QuantityControls({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartRepo = ref.read(cartRepositoryProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quantity Selector
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuantityButton(
                icon: Icons.remove,
                onPressed: cartItem.quantity > 1
                    ? () {
                        cartRepo.updateCartItem(
                          cartItem.id,
                          cartItem.quantity - 1,
                        );
                      }
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildQuantityButton(
                icon: Icons.add,
                onPressed: () {
                  cartRepo.updateCartItem(cartItem.id, cartItem.quantity + 1);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Delete Button
        InkWell(
          onTap: () {
            _showDeleteConfirmation(context, ref, cartRepo);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.delete_outline, size: 20, color: Colors.red[400]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null ? Colors.black87 : Colors.grey[400],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    dynamic cartRepo,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xóa sản phẩm',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              cartRepo.removeProductFromCart(cartItem.id);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
