import 'package:flutter/material.dart';
import 'package:pharmacy_app/data/models/product.dart';
import 'package:pharmacy_app/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:pharmacy_app/presentation/widgets/product_card.dart';

class HorizontalProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product)? onAddToCart;
  final double itemWidth;
  final double? height;

  const HorizontalProductList({
    super.key,
    required this.products,
    this.onAddToCart,
    this.itemWidth = 160.0,
    this.height = 280.0,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Container(
            width: itemWidth,
            margin: EdgeInsets.only(
              right: index < products.length - 1 ? 12.0 : 0,
            ),
            child: ProductCard(
              product: product,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetailScreen(productId: product.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
