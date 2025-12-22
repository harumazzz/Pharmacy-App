import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/presentation/providers/providers.dart';
import 'package:pharmacy_app/presentation/widgets/error_display.dart';
import 'package:pharmacy_app/presentation/widgets/form_helpers.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';
import 'package:pharmacy_app/utils/invoice_export_service.dart';
import 'package:pharmacy_app/utils/notification_service.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  static const List<String> _statuses = [
    'pending',
    'processing',
    'shipped',
    'delivered',
  ];

  static const Map<String, String> _statusLabels = {
    'pending': 'Chờ xử lý',
    'processing': 'Đang xử lý',
    'shipped': 'Đang giao',
    'delivered': 'Đã giao',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);

    return Scaffold(
      body: ordersAsync.when(
        data: (orders) => orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có đơn hàng',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final statusLabel =
                      _statusLabels[order.status] ?? order.status;
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.receipt,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Đơn #${order.id}'),
                      subtitle: Text(
                        'Trạng thái: $statusLabel | Giá: ${order.totalPrice.toStringAsFixed(0)} đ',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _editOrderStatus(
                                context,
                                ref,
                                order.id,
                                order.status,
                              );
                              break;
                            case 'export':
                              _exportInvoice(context, ref, order);
                              break;
                            case 'delete':
                              _deleteOrder(context, ref, order.id);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Sửa trạng thái'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'export',
                            child: ListTile(
                              leading: Icon(Icons.file_download),
                              title: Text('Xuất hóa đơn'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Xóa đơn hàng'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: LoadingSpinner()),
        error: (error, stack) => Center(
          child: ErrorDisplay(
            message: 'Lỗi tải danh sách đơn hàng',
            onRetry: () => ref.refresh(orderListProvider),
          ),
        ),
      ),
    );
  }

  void _editOrderStatus(
    BuildContext context,
    WidgetRef ref,
    int orderId,
    String currentStatus,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật trạng thái'),
        content: DropdownButton<String>(
          value: currentStatus,
          isExpanded: true,
          items: _statuses
              .map(
                (status) => DropdownMenuItem(
                  value: status,
                  child: Text(_statusLabels[status] ?? status),
                ),
              )
              .toList(),
          onChanged: (newStatus) {
            if (newStatus != null && newStatus != currentStatus) {
              _updateOrderStatus(context, ref, orderId, newStatus);
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(
    BuildContext context,
    WidgetRef ref,
    int orderId,
    String newStatus,
  ) async {
    try {
      final adminRepo = ref.read(adminRepositoryProvider);
      await adminRepo.updateOrderStatus(orderId, newStatus);
      if (context.mounted) {
        ref.invalidate(orderListProvider);
        if (newStatus == 'delivered') {
          await NotificationHelper.push(
            'Đơn hàng đã được giao',
            'Đơn hàng #$orderId của bạn đã được giao thành công.',
          );
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật trạng thái thành công')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  void _deleteOrder(BuildContext context, WidgetRef ref, int orderId) async {
    final confirmed = await showDeleteConfirmation(
      context,
      title: 'Xoá đơn hàng',
      message: 'Bạn chắc chắn muốn xoá đơn hàng #$orderId?',
    );

    if (confirmed && context.mounted) {
      try {
        final adminRepo = ref.read(adminRepositoryProvider);
        await adminRepo.softDeleteOrder(orderId);
        if (context.mounted) {
          ref.invalidate(orderListProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xoá đơn hàng thành công')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
        }
      }
    }
  }

  void _exportInvoice(BuildContext context, WidgetRef ref, order) async {
    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Đang xuất hóa đơn...'),
            ],
          ),
        ),
      );

      // Lấy chi tiết đơn hàng, items và products
      final orderRepo = ref.read(orderRepositoryProvider);
      final productRepo = ref.read(productRepositoryProvider);

      final orderItems = await orderRepo.getOrderItems(order.id);
      // Sử dụng stream và lấy snapshot đầu tiên
      final products = await productRepo.watchProducts(categoryId: null).first;

      // Xuất hóa đơn
      final filePath = await InvoiceExportService.exportOrderInvoiceToExcel(
        order,
        orderItems,
        products,
      );

      // Đóng loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (filePath != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xuất hóa đơn thành công: $filePath'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Lỗi xuất hóa đơn')));
      }
    } catch (e) {
      debugPrint('Lỗi xuất hóa đơn: $e');
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }
}
