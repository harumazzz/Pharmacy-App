import 'package:flutter/material.dart';

class ProductInfoCard extends StatelessWidget {
  final String name;
  final double price;
  final int stockQuantity;

  const ProductInfoCard({
    super.key,
    required this.name,
    required this.price,
    required this.stockQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final bool inStock = stockQuantity > 0;
    final formattedPrice = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withValues(alpha: 0.05),
              Colors.teal.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: inStock
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                inStock ? Icons.check_circle : Icons.warning,
                                size: 14,
                                color: inStock ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                inStock
                                    ? 'Còn hàng ($stockQuantity)'
                                    : 'Hết hàng',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: inStock
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Icon(
                      Icons.local_pharmacy,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[300]!,
                      Colors.grey[300]!.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giá bán',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedPrice,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 4.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'VNĐ',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
