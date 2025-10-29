import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/cart/cart_items_provider.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/screens/cart/cart_items_list.dart';
import 'package:pharmacy_app/presentation/screens/cart/cart_summary.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';

class CartScreen extends ConsumerWidget {
  final int userId;

  const CartScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider(userId));
    final productsAsync = ref.watch(productListProvider(categoryId: null));

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng'), centerTitle: true),
      body: cartItemsAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const EmptyState(
              message: 'Giỏ hàng trống',
              icon: Icons.shopping_cart_outlined,
            );
          }

          return productsAsync.when(
            data: (products) {
              return Column(
                children: [
                  Expanded(
                    child: CartItemsList(
                      cartItems: cartItems,
                      products: products,
                    ),
                  ),
                  CartSummary(
                    cartItems: cartItems,
                    products: products,
                    userId: userId,
                  ),
                ],
              );
            },
            loading: () => const LoadingSpinner(),
            error: (error, stackTrace) => ErrorDisplay(
              message: 'Có lỗi tải sản phẩm: $error',
              onRetry: () => ref.refresh(productListProvider(categoryId: null)),
            ),
          );
        },
        loading: () => const LoadingSpinner(),
        error: (error, stackTrace) => ErrorDisplay(
          message: 'Có lỗi tải giỏ hàng: $error',
          onRetry: () => ref.refresh(cartItemsProvider(userId)),
        ),
      ),
    );
  }
}
