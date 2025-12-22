import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/providers/product_detail/product_detail_provider.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/primary_button.dart';
import 'package:pharmacy_app/presentation/widgets/product_description_card.dart';
import 'package:pharmacy_app/presentation/widgets/product_image_card.dart';
import 'package:pharmacy_app/presentation/widgets/product_info_card.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Chi tiết sản phẩm',
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 20),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.share, size: 20), onPressed: () {}),
        ],
      ),
      body: productAsync.when(
        data: (product) => _ProductContent(product: product),
        loading: () => const Center(child: LoadingSpinner()),
        error: (error, stackTrace) => Center(
          child: ErrorDisplay(
            message: 'Lỗi tải chi tiết sản phẩm',
            onRetry: () => ref.refresh(productDetailProvider(productId)),
          ),
        ),
      ),
    );
  }
}

class _ProductContent extends StatelessWidget {
  final dynamic product;

  const _ProductContent({required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProductImageCard(imageUrl: product.imageUrl, productId: product.id),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductInfoCard(
                  name: product.name,
                  price: product.price,
                  stockQuantity: product.stockQuantity,
                ),
                const SizedBox(height: 16.0),
                ProductDescriptionCard(description: product.description),
                const SizedBox(height: 20.0),
                _AddToCartButton(
                  productId: product.id,
                  productName: product.name,
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends ConsumerStatefulWidget {
  final int productId;
  final String productName;

  const _AddToCartButton({required this.productId, required this.productName});

  @override
  ConsumerState<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<_AddToCartButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'Thêm vào giỏ hàng',
      icon: Icons.shopping_cart_outlined,
      isLoading: _isLoading,
      onPressed: _isLoading ? null : _handleAddToCart,
    );
  }

  Future<void> _handleAddToCart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = ref.read(authProvider).userId;
      if (userId == null) {
        debugPrint('User not logged in');
        return;
      }

      debugPrint('Adding product ${widget.productId} to cart for user $userId');

      await ref
          .read(cartRepositoryProvider)
          .addProductToCart(userId, widget.productId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.productName} đã được thêm vào giỏ hàng'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể thêm vào giỏ hàng. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
