import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/theme.dart';
import '../../models/medicine.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import '../../models/supplier.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/supplier_provider.dart';
import '../../utils/currency_formatter.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _notesController = TextEditingController();

  Supplier? _selectedSupplier;
  final List<OrderItem> _items = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Suppliers/medicines should already be loaded from their own tabs,
    // but load defensively in case this screen is reached first.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SupplierProvider>().loadSuppliers();
      context.read<InventoryProvider>().loadMedicines();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _totalAmount =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);

  int get _totalUnits => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> _openAddItemDialog() async {
    final medicines = context.read<InventoryProvider>().medicines;
    if (medicines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No medicines yet — add one first from Inventory.')),
      );
      return;
    }

    Medicine? pickedMedicine;
    final quantityController = TextEditingController(text: '1');

    final result = await showDialog<OrderItem>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Add Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Medicine>(
                    initialValue: pickedMedicine,
                    decoration: const InputDecoration(labelText: 'Medicine'),
                    items: medicines
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child:
                                  Text(m.name, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => pickedMedicine = value),
                  ),
                  const SizedBox(height: AppConstants.spaceMD),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final medicine = pickedMedicine;
                    final qty = int.tryParse(quantityController.text.trim());

                    if (medicine == null || qty == null || qty <= 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Select a medicine and a valid quantity.')),
                      );
                      return;
                    }

                    Navigator.pop(
                      dialogContext,
                      OrderItem(
                        medicineId: medicine.id,
                        medicineName: medicine.name,
                        quantity: qty,
                        unitPrice: medicine.unitPrice,
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) return;

    setState(() {
      // If this medicine is already in the list, merge quantities instead
      // of adding a duplicate row.
      final existingIndex =
          _items.indexWhere((i) => i.medicineId == result.medicineId);
      if (existingIndex != -1) {
        _items[existingIndex] = _items[existingIndex].copyWith(
          quantity: _items[existingIndex].quantity + result.quantity,
        );
      } else {
        _items.add(result);
      }
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _items[index] =
          _items[index].copyWith(quantity: _items[index].quantity + 1);
    });
  }

  void _decrementQuantity(int index) {
    if (_items[index].quantity <= 1) return;
    setState(() {
      _items[index] =
          _items[index].copyWith(quantity: _items[index].quantity - 1);
    });
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  Future<void> _handleSave() async {
    if (_selectedSupplier == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a supplier.')),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one item.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final order = Order(
        supplierId: _selectedSupplier!.id,
        supplierName: _selectedSupplier!.name,
        items: _items,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await context.read<OrderProvider>().addOrder(order);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save order: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = context.watch<SupplierProvider>().suppliers;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Create Order')),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.radius),
        children: [
          const Text('Supplier',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 6),
          if (suppliers.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'No suppliers yet — add one first from the Suppliers tab.',
                style: TextStyle(color: AppTheme.danger),
              ),
            ),
          DropdownButtonFormField<Supplier>(
            initialValue: _selectedSupplier,
            decoration: InputDecoration(
              hintText: 'Select a supplier',
              prefixIcon: Icon(Icons.local_shipping_outlined,
                  color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            items: suppliers
                .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                .toList(),
            onChanged: (value) => setState(() => _selectedSupplier = value),
          ),
          const SizedBox(height: AppConstants.spaceLG),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Order Items',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              TextButton.icon(
                onPressed: _openAddItemDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Item'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_items.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.borderRadius,
              ),
              child: Text(
                'No items yet — tap "Add Item" to get started.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            ..._items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppTheme.borderRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.medicineName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close,
                              size: 18, color: AppTheme.danger),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Qty',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _QtyButton(
                                    icon: Icons.remove,
                                    onTap: () => _decrementQuantity(index),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text('${item.quantity}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  _QtyButton(
                                    icon: Icons.add,
                                    onTap: () => _incrementQuantity(index),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Unit Price',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(formatCurrency(item.unitPrice)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total',
                                  style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(
                                formatCurrency(item.subtotal),
                                style: const TextStyle(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          if (_items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: AppTheme.borderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Total',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(
                          '${_items.length} medicines · $_totalUnits units total',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                  Text(
                    formatCurrency(_totalAmount),
                    style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppConstants.spaceMD),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: 'Notes (optional)',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: AppConstants.spaceLG),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.grey.shade200,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.black87)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_outlined, size: 18),
                  label: Text(_isSaving ? 'Submitting...' : 'Submit Order'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceLG),
        ],
      ),
    );
  }
}

/// Small circular +/- button used in the quantity stepper.
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 16, color: Colors.grey.shade700),
      ),
    );
  }
}
