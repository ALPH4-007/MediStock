import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/medicine.dart';

class ExpiryBadge extends StatelessWidget {
  final Medicine medicine;

  const ExpiryBadge({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final days = medicine.daysUntilExpiry;
    if (days == null) return const SizedBox.shrink();

    final bool expired = days < 0;
    final bool expiringSoon = !expired && days <= 30;

    final Color color = expired
        ? AppTheme.danger
        : expiringSoon
            ? AppTheme.warning
            : AppTheme.grey;
    final String label = expired ? 'Expired' : 'Expires in $days days';

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
