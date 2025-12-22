import 'package:flutter/material.dart';
import 'package:pharmacy_app/presentation/widgets/order_status_badge.dart';

class OrderHeaderCard extends StatelessWidget {
  final int orderId;
  final String status;
  final String formattedDate;
  final String shippingAddress;

  const OrderHeaderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.formattedDate,
    required this.shippingAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
              Theme.of(context).primaryColor.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with decorative icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đơn hàng #$orderId',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Chi tiết đơn hàng của bạn',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Status Badge
              OrderStatusBadge(status: status),
              const SizedBox(height: 16.0),
              // Divider
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
              // Info Rows
              _InfoRow(
                icon: Icons.calendar_today,
                label: 'Ngày đặt',
                value: formattedDate,
                context: context,
              ),
              const SizedBox(height: 14.0),
              _InfoRow(
                icon: Icons.location_on,
                label: 'Địa chỉ giao hàng',
                value: shippingAddress,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final BuildContext context;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
