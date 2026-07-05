import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/theme.dart';
import '../../models/medicine.dart';
import '../../providers/inventory_provider.dart';
import '../../services/inventory_service.dart';
import '../../widgets/confirm_delete_dialog.dart';

class EditMedicineScreen extends StatefulWidget {
  final Medicine medicine;

  const EditMedicineScreen({super.key, required this.medicine});

  @override
  State<EditMedicineScreen> createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _quantityController;
  late final TextEditingController _minimumStockController;
  late final TextEditingController _unitPriceController;
  late final TextEditingController _descriptionController;

  late String _category;
  DateTime? _expiryDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.medicine;

    _nameController = TextEditingController(text: m.name);
    _barcodeController = TextEditingController(text: m.barcode ?? '');
    _quantityController = TextEditingController(text: m.quantity.toString());
    _minimumStockController =
        TextEditingController(text: m.minimumStock.toString());
    _unitPriceController = TextEditingController(text: m.unitPrice.toString());
    _descriptionController = TextEditingController(text: m.description ?? '');

    _category = m.category;
    _expiryDate = m.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _quantityController.dispose();
    _minimumStockController.dispose();
    _unitPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 180)),
      firstDate: DateTime.now().subtract(const Duration(days: 3650)),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updated = widget.medicine.copyWith(
      name: _nameController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      category: _category,
      quantity: int.parse(_quantityController.text.trim()),
      minimumStock: int.parse(_minimumStockController.text.trim()),
      expiryDate: _expiryDate,
      sellingPrice: double.parse(_unitPriceController.text.trim()),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    await context.read<InventoryProvider>().updateMedicine(updated);

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _handleDelete() async {
    final confirmed =
        await confirmDelete(context: context, itemName: widget.medicine.name);
    if (!confirmed) return;
    if (!mounted) return;

    await context.read<InventoryProvider>().removeMedicine(widget.medicine.id);
    if (!mounted) return;

    Navigator.pop(context);
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (double.tryParse(value.trim()) == null) return 'Enter a valid number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Medicine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: _isSaving ? null : _handleDelete,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.radius),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Medicine Name'),
              validator: _requiredValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _barcodeController,
              decoration:
                  const InputDecoration(labelText: 'Barcode (optional)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: InventoryService.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: AppConstants.spaceMD),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: _numberValidator,
                  ),
                ),
                const SizedBox(width: AppConstants.spaceMD),
                Expanded(
                  child: TextFormField(
                    controller: _minimumStockController,
                    decoration:
                        const InputDecoration(labelText: 'Minimum Stock'),
                    keyboardType: TextInputType.number,
                    validator: _numberValidator,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _unitPriceController,
              decoration: const InputDecoration(labelText: 'Unit Price (₵)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: _numberValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            InkWell(
              onTap: _pickExpiryDate,
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Expiry Date'),
                child: Text(
                  _expiryDate == null
                      ? 'Select a date'
                      : '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Description (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: AppConstants.spaceLG),
            ElevatedButton(
              onPressed: _isSaving ? null : _handleSave,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
