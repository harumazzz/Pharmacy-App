import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/widgets/app_grid.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/product_card.dart';

class ProductListScreen extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(
      productListProvider(categoryId: categoryId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(categoryName), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return const EmptyState(
                message: 'Không có sản phẩm trong danh mục này.',
              );
            }
            return AppGrid(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.7,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onAddToCart: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.name} đã được thêm vào giỏ hàng',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    // TODO: Call addProductToCart from CartRepository
                  },
                );
              },
            );
          },
          loading: () => const Center(child: LoadingSpinner()),
          error: (error, stackTrace) => Center(
            child: ErrorDisplay(
              message: 'Lỗi tải sản phẩm',
              onRetry: () =>
                  ref.refresh(productListProvider(categoryId: categoryId)),
            ),
          ),
        ),
      ),
    );
  }
}
