import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:pharmacy_app/presentation/widgets/app_grid.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/product_card.dart';

class ProductListScreen extends ConsumerWidget {
  final int? categoryId;
  final String title;

  const ProductListScreen({
    super.key,
    this.categoryId,
    this.title = 'Sản phẩm',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(
      productListProvider(categoryId: categoryId),
    );

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const EmptyState(message: 'Không có sản phẩm');
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppGrid(
              minItemWidth: 170.0,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const LoadingSpinner(),
        error: (error, stackTrace) => ErrorDisplay(
          message: 'Lỗi tải sản phẩm',
          onRetry: () =>
              ref.refresh(productListProvider(categoryId: categoryId)),
        ),
      ),
    );
  }
}
