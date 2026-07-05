import 'package:flutter/material.dart';
import '../app/theme.dart';

Future<bool> confirmDelete(
    {required BuildContext context, required String itemName}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Delete Medicine?'),
      content: Text(
          'Are you sure you want to delete "$itemName"? This cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel')),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  return result ?? false;
}
