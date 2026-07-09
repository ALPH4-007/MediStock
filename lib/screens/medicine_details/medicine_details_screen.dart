import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme.dart';
import '../../models/medicine.dart';
import '../../utils/currency_formatter.dart';

class MedicineDetailsScreen extends StatelessWidget {
  final Medicine medicine;

  const MedicineDetailsScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.radius),
        children: [
          // Decorative header illustration — light green gradient panel
          // with a medication icon and a stock-status chip, mirroring
          // the mockup's visual banner at the top of the screen.
          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryGreen.withValues(alpha: 0.25),
                  AppTheme.primaryGreen.withValues(alpha: 0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppTheme.borderRadius,
            ),
            child: Stack(
              children: [
                Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.deepOrange, Colors.pinkAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.medication,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _StockStatusChip(medicine: medicine),
                ),
              ],
            ),
          ),

          // Name + category/manufacturer subtitle, restored from the
          // original header now that the illustration sits above it.
          Text(
            medicine.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 2),
          Text(
            '${medicine.category} · ${medicine.manufacturer}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Big stats header — In Stock / Days to Expiry, mirroring the
          // mockup's headline numbers instead of the old badge row.
          Row(
            children: [
              Expanded(
                child: _StatColumn(
                  value: '${medicine.quantity}',
                  label: 'In Stock',
                  sublabel: 'Min: ${medicine.minimumStock}',
                  valueColor: AppTheme.primaryGreen,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  value: medicine.daysUntilExpiry == null
                      ? '—'
                      : '${medicine.daysUntilExpiry}',
                  label: 'Days to Expiry',
                  sublabel: medicine.expiryDate == null
                      ? 'Not recorded'
                      : dateFormat.format(medicine.expiryDate!),
                  valueColor: AppTheme.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppTheme.borderRadius,
            ),
            child: Column(
              children: [
                _IconInfoRow(
                  icon: Icons.tag,
                  label: 'Barcode',
                  value: medicine.barcode ?? 'Not recorded',
                ),
                _IconInfoRow(
                  icon: Icons.description_outlined,
                  label: 'Batch No.',
                  value: medicine.batchNumber,
                ),
                _IconInfoRow(
                  icon: Icons.apartment_outlined,
                  label: 'Manufacturer',
                  value: medicine.manufacturer,
                ),
                _IconInfoRow(
                  icon: Icons.local_shipping_outlined,
                  label: 'Supplier',
                  value: '${medicine.supplierId}',
                ),
                _IconInfoRow(
                  icon: Icons.place_outlined,
                  label: 'Location',
                  value: medicine.location,
                ),
                _IconInfoRow(
                  icon: Icons.attach_money,
                  label: 'Purchase Price',
                  value: formatCurrency(medicine.purchasePrice),
                ),
                _IconInfoRow(
                  icon: Icons.attach_money,
                  label: 'Selling Price',
                  value: formatCurrency(medicine.sellingPrice),
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Small pill-shaped chip showing stock status — Healthy, Low Stock, or
/// Out of Stock — colored to match, mirroring the mockup's "Healthy" tag.
class _StockStatusChip extends StatelessWidget {
  final Medicine medicine;

  const _StockStatusChip({required this.medicine});

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;

    if (medicine.quantity == 0) {
      label = 'Out of Stock';
      color = AppTheme.danger;
    } else if (medicine.isLowStock) {
      label = 'Low Stock';
      color = AppTheme.warning;
    } else {
      label = 'Healthy';
      color = AppTheme.primaryGreen;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

/// One big stat number with a label and sublabel underneath — used for
/// the In Stock / Days to Expiry pair at the top of the screen.
class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final String sublabel;
  final Color valueColor;

  const _StatColumn({
    required this.value,
    required this.label,
    required this.sublabel,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          sublabel,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ],
    );
  }
}

/// One row in the icon-badge info card — a circular icon, a small gray
/// label, and a bold value beneath it, with a divider unless [isLast].
class _IconInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _IconInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, size: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
