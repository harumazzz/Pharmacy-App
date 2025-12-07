import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/providers/product_detail/product_detail_provider.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/primary_button.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';

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
          _ProductImage(imageUrl: product.imageUrl, productId: product.id),
          _ProductDetails(product: product),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;
  final int productId;

  const _ProductImage({required this.imageUrl, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Hero(
        tag: 'product_$productId',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                )
              : const _ImagePlaceholder(),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Không có hình ảnh',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final dynamic product;

  const _ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Info Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductName(name: product.name),
                  const SizedBox(height: 12),
                  _ProductPrice(price: product.price),
                  const SizedBox(height: 12),
                  _StockInfo(stockQuantity: product.stockQuantity),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Description Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _DescriptionSection(description: product.description),
            ),
          ),
          const SizedBox(height: 16),
          // Add to Cart Button
          _AddToCartButton(productId: product.id, productName: product.name),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ProductName extends StatelessWidget {
  final String name;

  const _ProductName({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }
}

class _ProductPrice extends StatelessWidget {
  final double price;

  const _ProductPrice({required this.price});

  @override
  Widget build(BuildContext context) {
    final formattedPrice = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    return Text(
      '$formattedPrice VNĐ',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.green[600],
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _StockInfo extends StatelessWidget {
  final int stockQuantity;

  const _StockInfo({required this.stockQuantity});

  @override
  Widget build(BuildContext context) {
    final bool inStock = stockQuantity > 0;

    return Row(
      children: [
        Icon(
          inStock ? Icons.check_circle : Icons.warning,
          color: inStock ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          inStock ? 'Còn $stockQuantity sản phẩm' : 'Hết hàng',
          style: TextStyle(
            color: inStock ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String description;

  const _DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả sản phẩm',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          description.isNotEmpty
              ? description
              : 'Chưa có mô tả cho sản phẩm này.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: Colors.grey[600],
          ),
        ),
      ],
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
        return;
      }

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
