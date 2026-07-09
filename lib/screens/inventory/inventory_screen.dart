import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/order_provider.dart';
import 'inventory_list_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<InventoryProvider>().loadMedicines();
      context.read<OrderProvider>().loadOrders();
    });
  }

  void _openList(BuildContext context, {StockFilter filter = StockFilter.all}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InventoryListScreen(initialStockFilter: filter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final medicines = inventory.medicines;

    final totalMedicines = medicines.length;
    final lowStockCount =
        medicines.where((m) => m.isLowStock && m.quantity > 0).length;
    final outOfStockCount = medicines.where((m) => m.quantity == 0).length;
    final expiringSoonCount = medicines.where((m) {
      final days = m.daysUntilExpiry;
      return days != null && days >= 0 && days <= 30;
    }).length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addMedicine),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => inventory.loadMedicines(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _GreetingHeader(onSearchTap: () => _openList(context)),
            Padding(
              padding: const EdgeInsets.all(AppTheme.radius),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.7,
                    children: [
                      _StatCard(
                        icon: Icons.inventory_2_outlined,
                        iconColor: AppTheme.primaryGreen,
                        value: '$totalMedicines',
                        label: 'Total Medicines',
                        onTap: () => _openList(context),
                      ),
                      _StatCard(
                        icon: Icons.warning_amber_rounded,
                        iconColor: AppTheme.warning,
                        value: '$lowStockCount',
                        label: 'Low Stock',
                        onTap: () =>
                            _openList(context, filter: StockFilter.lowStock),
                      ),
                      _StatCard(
                        icon: Icons.access_time_rounded,
                        iconColor: Colors.deepOrange,
                        value: '$expiringSoonCount',
                        label: 'Expiring Soon',
                        onTap: () => _openList(context,
                            filter: StockFilter.expiringSoon),
                      ),
                      _StatCard(
                        icon: Icons.close_rounded,
                        iconColor: AppTheme.danger,
                        value: '$outOfStockCount',
                        label: 'Out of Stock',
                        onTap: () =>
                            _openList(context, filter: StockFilter.outOfStock),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Pending Orders — now real data from OrderProvider.
                  _PendingOrdersRow(
                    count: orderProvider.pendingCount,
                    onViewAll: () =>
                        Navigator.pushNamed(context, AppRoutes.orders),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => _openList(context),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // No activity-log data source exists yet — showing an
                  // honest empty state rather than fabricated entries.
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppTheme.borderRadius,
                    ),
                    child: Text(
                      'No recent activity yet.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const _GreetingHeader({required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.darkGreen, AppTheme.primaryGreen],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Good Morning, Pharmacist 👋',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Notification bell — no real notification system exists yet,
              // so this is a static icon, not wired to anything.
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.notifications_outlined, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    'Search medicines, suppliers...',
                    style:
                        TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.borderRadius,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppTheme.borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingOrdersRow extends StatelessWidget {
  final int count;
  final VoidCallback onViewAll;

  const _PendingOrdersRow({required this.count, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pending Orders',
                    style: Theme.of(context).textTheme.bodyMedium),
                Text('$count',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text('View All'), Icon(Icons.chevron_right, size: 18)],
            ),
          ),
        ],
      ),
    );
  }
}
