import 'package:flutter/material.dart';

class OrderTimeline extends StatelessWidget {
  final String status;

  const OrderTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final stages = [
      ('pending', 'Chờ xử lý', Icons.hourglass_empty),
      ('processing', 'Đang xử lý', Icons.autorenew),
      ('shipped', 'Đang giao', Icons.local_shipping),
      ('delivered', 'Đã giao', Icons.check_circle),
    ];

    int currentStage = _getCurrentStage(status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trạng thái đơn hàng',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: List.generate(stages.length * 2 - 1, (index) {
              if (index.isEven) {
                final stageIndex = index ~/ 2;
                final (stageKey, stageName, icon) = stages[stageIndex];
                final isCompleted = currentStage > stageIndex;
                final isCurrent = currentStage == stageIndex;

                return Expanded(
                  child: _TimelineStage(
                    icon: icon,
                    label: stageName,
                    isCompleted: isCompleted,
                    isCurrent: isCurrent,
                  ),
                );
              } else {
                final isCompleted = currentStage > index ~/ 2;
                return SizedBox(
                  width: 4,
                  height: 3,
                  child: Container(
                    color: isCompleted ? Colors.green : Colors.grey[300],
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: _getStatusColor(status).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  color: _getStatusColor(status),
                  size: 20,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    _getStatusDescription(status),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getCurrentStage(String status) {
    switch (status) {
      case 'pending':
        return 0;
      case 'processing':
        return 1;
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
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

  String _getStatusDescription(String status) {
    switch (status) {
      case 'pending':
        return 'Đơn hàng đang chờ xử lý';
      case 'processing':
        return 'Chúng tôi đang chuẩn bị hàng cho bạn';
      case 'shipped':
        return 'Đơn hàng đang trên đường tới bạn';
      case 'delivered':
        return 'Bạn đã nhận được đơn hàng';
      default:
        return '';
    }
  }
}

class _TimelineStage extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isCompleted;
  final bool isCurrent;

  const _TimelineStage({
    required this.icon,
    required this.label,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey[400]!;
    if (isCompleted) {
      color = Colors.green;
    } else if (isCurrent) {
      color = Colors.blue;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
