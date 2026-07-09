import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final filtered = orderProvider.filteredOrders;

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addOrder),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: AppConstants.spaceSM),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.radius),
              children: [
                _StatusChip(
                  label: 'All',
                  selected: orderProvider.statusFilter == null,
                  onTap: () =>
                      context.read<OrderProvider>().setStatusFilter(null),
                ),
                const SizedBox(width: 8),
                for (final status in OrderStatus.values) ...[
                  _StatusChip(
                    label: _statusLabel(status),
                    selected: orderProvider.statusFilter == status,
                    onTap: () =>
                        context.read<OrderProvider>().setStatusFilter(status),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceSM),
          Expanded(
            child: Builder(
              builder: (context) {
                if (orderProvider.isLoading && orderProvider.orders.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (orderProvider.orders.isEmpty) {
                  return Center(
                    child: Text('No orders yet.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text('No orders match this filter.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => orderProvider.loadOrders(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      return OrderCard(
                        order: order,
                        onStatusChange: (status) {
                          context
                              .read<OrderProvider>()
                              .updateOrderStatus(order, status);
                        },
                        onDelete: () async {
                          await context
                              .read<OrderProvider>()
                              .removeOrder(order.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order deleted')),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryGreen,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppTheme.black,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: selected ? AppTheme.primaryGreen : Colors.grey.shade300),
      ),
    );
  }
}
