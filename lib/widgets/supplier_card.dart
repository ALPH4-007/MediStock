import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/supplier.dart';

class SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SupplierCard({
    super.key,
    required this.supplier,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: AppTheme.borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.radius),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping_outlined,
                    color: AppTheme.primaryGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplier.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(supplier.contactPerson,
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(supplier.phone,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
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
        ),
      ),
    );
  }
}
