import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/medicine.dart';
import 'expiry_badge.dart';
import 'stock_badge.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicineCard(
      {super.key,
      required this.medicine,
      this.onTap,
      this.onEdit,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: AppTheme.borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(medicine.name,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Text('₵${medicine.unitPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge),
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                      visualDensity: VisualDensity.compact,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(Icons.delete_outline,
                          size: 20, color: AppTheme.danger),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text('${medicine.category} · Qty: ${medicine.quantity}',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                StockBadge(medicine: medicine),
                ExpiryBadge(medicine: medicine),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
