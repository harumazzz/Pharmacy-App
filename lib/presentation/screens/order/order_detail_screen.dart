import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/custom_app_bar.dart';
import 'package:pharmacy_app/presentation/widgets/empty_state.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/presentation/widgets/order_header_card.dart';
import 'package:pharmacy_app/presentation/widgets/order_item_card.dart';
import 'package:pharmacy_app/presentation/widgets/order_timeline.dart';
import 'package:pharmacy_app/presentation/widgets/order_total_card.dart';

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
                OrderHeaderCard(
                  orderId: order.id,
                  status: order.status,
                  formattedDate: formattedDate,
                  shippingAddress: order.shippingAddress,
                ),
                // Order Timeline
                OrderTimeline(status: order.status),
                // Order Items Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    'Chi tiết sản phẩm',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _OrderItemsSection(orderId: orderId),
                // Total Card
                OrderTotalCard(totalPrice: order.totalPrice),
                const SizedBox(height: 16.0),
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

    return productAsync.when(
      data: (product) {
        return OrderItemCard(
          title: product.name,
          quantity: orderItem.quantity,
          price: orderItem.price,
          subtitle: 'Số lượng: ${orderItem.quantity}',
        );
      },
      loading: () => OrderItemCard(
        title: 'Đang tải...',
        quantity: orderItem.quantity,
        price: orderItem.price,
        isLoading: true,
      ),
      error: (error, stackTrace) => OrderItemCard(
        title: 'Sản phẩm #${orderItem.productId}',
        quantity: orderItem.quantity,
        price: orderItem.price,
      ),
    );
  }
}
