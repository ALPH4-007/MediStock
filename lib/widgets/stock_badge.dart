import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/medicine.dart';

class StockBadge extends StatelessWidget {
  final Medicine medicine;

  const StockBadge({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final bool isOut = medicine.quantity == 0;
    final bool isLow = medicine.isLowStock && !isOut;

    final Color color = isOut
        ? AppTheme.danger
        : isLow
            ? AppTheme.warning
            : AppTheme.success;

    final String label = isOut
        ? 'Out of stock'
        : isLow
            ? 'Low stock'
            : 'In stock';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
