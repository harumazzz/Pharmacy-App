import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/screens/admin/product_form_screen.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/form_helpers.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider(categoryId: null));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        label: const Text('Thêm sản phẩm'),
        icon: const Icon(Icons.add),
      ),
      body: productsAsync.when(
        data: (products) => products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('Chưa có sản phẩm',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return CrudListTile(
                    title: product.name,
                    subtitle: 'Giá: ${product.price.toStringAsFixed(0)} đ',
                    onEdit: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductFormScreen(product: product),
                      ),
                    ),
                    onDelete: () => _deleteProduct(
                      context,
                      ref,
                      product.id,
                      product.name,
                    ),
                  );
                },
              ),
        loading: () => const Center(child: LoadingSpinner()),
        error: (error, stack) => Center(
          child: ErrorDisplay(
            message: 'Lỗi tải danh sách sản phẩm',
            onRetry: () => ref.refresh(productListProvider(categoryId: null)),
          ),
        ),
      ),
    );
  }

  void _deleteProduct(
    BuildContext context,
    WidgetRef ref,
    int productId,
    String productName,
  ) async {
    final confirmed = await showDeleteConfirmation(
      context,
      title: 'Xoá sản phẩm',
      message: 'Bạn chắc chắn muốn xoá "$productName"?',
    );

    if (confirmed && context.mounted) {
      try {
        final adminRepo = ref.read(adminRepositoryProvider);
        await adminRepo.softDeleteProduct(productId);
        if (context.mounted) {
          ref.invalidate(productListProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xoá sản phẩm thành công')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }
}
