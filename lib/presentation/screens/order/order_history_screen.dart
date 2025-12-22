import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_provider.dart';
import 'package:pharmacy_app/presentation/providers/auth/auth_state.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/screens/order/order_detail_screen.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/list_item.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/order_status_badge.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userId = authState.userId;

    if (userId == null) {
      return const Center(
        child: EmptyState(
          message: 'Vui lòng đăng nhập để xem lịch sử đơn hàng',
        ),
      );
    }

    final ordersAsync = ref.watch(orderHistoryProvider(userId));

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const EmptyState(message: 'Bạn chưa có đơn hàng nào');
        }
        return ListView.builder(
          itemCount: orders.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, index) {
            final order = orders[index];
            return _OrderHistoryItem(
              order: order,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetailScreen(orderId: order.id),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: LoadingSpinner()),
      error: (error, stackTrace) => Center(
        child: ErrorDisplay(
          message: 'Lỗi tải lịch sử đơn hàng',
          onRetry: () => ref.refresh(orderHistoryProvider(userId)),
        ),
      ),
    );
  }
}

class _OrderHistoryItem extends StatelessWidget {
  final dynamic order;
  final VoidCallback? onTap;

  const _OrderHistoryItem({required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(order.createdAt);

    return ListItem(
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _getStatusColor(order.status).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          _getStatusIcon(order.status),
          color: _getStatusColor(order.status),
          size: 20,
        ),
      ),
      title: Text(
        'Đơn hàng #${order.id}',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4.0),
          OrderStatusBadge(status: order.status),
        ],
      ),
      trailing: Text(
        '${order.totalPrice.toStringAsFixed(0)}₫',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      onTap: onTap,
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'processing':
        return Icons.autorenew;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
