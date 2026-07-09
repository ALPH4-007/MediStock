import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/theme.dart';
import '../models/order.dart';
import '../utils/currency_formatter.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final ValueChanged<OrderStatus> onStatusChange;
  final VoidCallback onDelete;

  const OrderCard({
    super.key,
    required this.order,
    required this.onStatusChange,
    required this.onDelete,
  });

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.pending:
        return AppTheme.warning;
      case OrderStatus.completed:
        return AppTheme.success;
      case OrderStatus.cancelled:
        return AppTheme.danger;
    }
  }

  String get _statusLabel {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.radius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Order from ${order.supplierName}',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                PopupMenuButton<OrderStatus?>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == null) {
                      onDelete();
                    } else {
                      onStatusChange(value);
                    }
                  },
                  itemBuilder: (context) => [
                    if (order.status != OrderStatus.completed)
                      const PopupMenuItem(
                        value: OrderStatus.completed,
                        child: Text('Mark Completed'),
                      ),
                    if (order.status != OrderStatus.cancelled)
                      const PopupMenuItem(
                        value: OrderStatus.cancelled,
                        child: Text('Cancel Order'),
                      ),
                    if (order.status != OrderStatus.pending)
                      const PopupMenuItem(
                        value: OrderStatus.pending,
                        child: Text('Mark Pending'),
                      ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: null,
                      child: Text('Delete',
                          style: TextStyle(color: AppTheme.danger)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Medicine names, comma-separated — mirrors how the mockup's
            // order list implicitly shows what's in each order.
            Text(
              order.items.map((i) => i.medicineName).join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(dateFormat.format(order.orderDate),
                style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppTheme.radius),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                        color: _statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '${order.medicineCount} medicines · ${order.totalUnits} units · ${formatCurrency(order.totalAmount)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
