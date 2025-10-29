import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/providers/product_detail/product_detail_provider.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/primary_button.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(centerTitle: true),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(imageUrl: product.imageUrl),
          _ProductDetails(product: product),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.grey[200],
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
            )
          : const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(child: Icon(Icons.image, size: 80, color: Colors.grey[400]));
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
          _ProductName(name: product.name),
          const SizedBox(height: 8.0),
          _ProductPrice(price: product.price),
          const SizedBox(height: 16.0),
          _DescriptionSection(description: product.description),
          const SizedBox(height: 24.0),
          _AddToCartButton(productId: product.id, productName: product.name),
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
    return Text(name, style: Theme.of(context).textTheme.headlineSmall);
  }
}

class _ProductPrice extends StatelessWidget {
  final double price;

  const _ProductPrice({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${price.toStringAsFixed(0)} đ',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
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
        Text('Mô tả', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8.0),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _AddToCartButton extends ConsumerWidget {
  final int productId;
  final String productName;

  const _AddToCartButton({required this.productId, required this.productName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: 'Thêm vào giỏ hàng',
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$productName đã được thêm vào giỏ hàng'),
              duration: const Duration(seconds: 2),
            ),
          );
          final userId = ref.read(authProvider).userId;
          if (userId == null) {
            return;
          }
          await ref
              .read(cartRepositoryProvider)
              .addProductToCart(userId, productId);
        },
      ),
    );
  }
}
