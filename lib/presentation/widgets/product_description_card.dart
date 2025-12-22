import 'package:flutter/material.dart';

class ProductDescriptionCard extends StatelessWidget {
  final String description;

  const ProductDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
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
              Colors.orange.withValues(alpha: 0.05),
              Colors.amber.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.orange,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    'Mô tả sản phẩm',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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
              const SizedBox(height: 14.0),
              Text(
                description.isNotEmpty
                    ? description
                    : 'Chưa có mô tả cho sản phẩm này.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: description.isEmpty
                      ? Colors.grey[500]
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
