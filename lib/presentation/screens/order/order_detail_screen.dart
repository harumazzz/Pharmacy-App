import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/list_item.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';

class OrderDetailScreen extends ConsumerWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Chi tiết đơn hàng'),
      body: orderAsync.when(
        data: (order) {
          final formattedDate = DateFormat(
            'dd/MM/yyyy HH:mm',
          ).format(order.createdAt);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đơn hàng #${order.id}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            _StatusBadge(status: order.status),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Ngày đặt: $formattedDate',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Địa chỉ: ${order.shippingAddress}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                // Order Items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Chi tiết sản phẩm',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _OrderItemsSection(orderId: orderId),
                // Total
                Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng cộng:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${order.totalPrice.toStringAsFixed(0)}₫',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: LoadingSpinner()),
        error: (error, stackTrace) => Center(
          child: ErrorDisplay(
            message: 'Lỗi tải chi tiết đơn hàng',
            onRetry: () => ref.refresh(orderDetailProvider(orderId)),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final text = _getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
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

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xử lý';
      case 'processing':
        return 'Đang xử lý';
      case 'shipped':
        return 'Đang giao';
      case 'delivered':
        return 'Đã giao';
      default:
        return status;
    }
  }
}

class _OrderItemsSection extends ConsumerWidget {
  final int orderId;

  const _OrderItemsSection({required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(orderItemsProvider(orderId));

    return itemsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: EmptyState(message: 'Không có sản phẩm'),
          );
        }
        return ListView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          itemBuilder: (context, index) {
            final item = items[index];
            return _OrderItemCard(orderItem: item);
          },
        );
      },
      loading: () =>
          const Padding(padding: EdgeInsets.all(16.0), child: LoadingSpinner()),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ErrorDisplay(
          message: 'Lỗi tải danh sách sản phẩm',
          onRetry: () => ref.refresh(orderItemsProvider(orderId)),
        ),
      ),
    );
  }
}

class _OrderItemCard extends ConsumerWidget {
  final dynamic orderItem;

  const _OrderItemCard({required this.orderItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(orderItem.productId));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: productAsync.when(
        data: (product) {
          return ListItem(
            title: Text(product.name),
            subtitle: Text('Số lượng: ${orderItem.quantity}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${orderItem.price.toStringAsFixed(0)}₫',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'x${orderItem.quantity}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
        loading: () => ListItem(
          title: const Text('Đang tải...'),
          subtitle: Text('Số lượng: ${orderItem.quantity}'),
          trailing: Text('${orderItem.price.toStringAsFixed(0)}₫'),
        ),
        error: (error, stackTrace) => ListItem(
          title: Text('Sản phẩm #${orderItem.productId}'),
          subtitle: Text('Số lượng: ${orderItem.quantity}'),
          trailing: Text('${orderItem.price.toStringAsFixed(0)}₫'),
        ),
      ),
    );
  }
}
