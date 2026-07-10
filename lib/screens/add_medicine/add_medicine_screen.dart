import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/theme.dart';
import '../../models/medicine.dart';
import '../../providers/activity_log_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../screens/scan/scan_screen.dart';
import '../../services/inventory_service.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _batchNumberController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minimumStockController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _category = InventoryService.categories.first;
  DateTime? _expiryDate;
  bool _isSaving = false;

  XFile? _photoFile;

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _batchNumberController.dispose();
    _manufacturerController.dispose();
    _quantityController.dispose();
    _minimumStockController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _photoFile = picked);
    }
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 180)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _scanBarcode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanScreen(returnResult: true)),
    );

    if (result != null && mounted) {
      _barcodeController.text = result;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final medicine = Medicine(
        name: _nameController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty
            ? null
            : _barcodeController.text.trim(),
        batchNumber: _batchNumberController.text.trim().isEmpty
            ? 'N/A'
            : _batchNumberController.text.trim(),
        manufacturer: _manufacturerController.text.trim().isEmpty
            ? 'N/A'
            : _manufacturerController.text.trim(),
        category: _category,
        quantity: int.parse(_quantityController.text.trim()),
        minimumStock: int.parse(_minimumStockController.text.trim()),
        expiryDate: _expiryDate,
        purchasePrice: double.parse(_purchasePriceController.text.trim()),
        sellingPrice: double.parse(_sellingPriceController.text.trim()),
        location: _locationController.text.trim().isEmpty
            ? 'Main Shelf'
            : _locationController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        photoPath: _photoFile?.path,
      );

      await context.read<InventoryProvider>().addMedicine(medicine);

      if (!mounted) return;

      await context.read<ActivityLogProvider>().log(
            type: 'medicine_added',
            title: '${medicine.name} added',
            subtitle: '${medicine.quantity} units',
          );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save medicine: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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

  InputDecoration _pillDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade500),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppTheme.danger),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Add Medicine')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.radius),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.08),
                borderRadius: AppTheme.borderRadius,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    backgroundImage: _photoFile == null
                        ? null
                        : FileImage(File(_photoFile!.path)),
                    child: _photoFile == null
                        ? const Icon(Icons.medication,
                            color: AppTheme.primaryGreen)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Medicine Photo',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _photoFile == null
                              ? 'Tap to upload image'
                              : 'Photo selected',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: _pickPhoto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:
                          const Text('Upload', style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spaceLG),

            _fieldLabel('Medicine Name'),
            TextFormField(
              controller: _nameController,
              decoration: _pillDecoration(
                  hint: 'e.g. Amoxicillin 500mg',
                  icon: Icons.medication_outlined),
              validator: _requiredValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Barcode'),
            TextFormField(
              controller: _barcodeController,
              decoration: _pillDecoration(
                hint: 'Scan or enter barcode',
                icon: Icons.tag,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner_outlined),
                  onPressed: _scanBarcode,
                  tooltip: 'Scan barcode',
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Batch Number'),
            TextFormField(
              controller: _batchNumberController,
              decoration: _pillDecoration(
                  hint: 'e.g. AMX2024001', icon: Icons.description_outlined),
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Manufacturer'),
            TextFormField(
              controller: _manufacturerController,
              decoration: _pillDecoration(
                  hint: 'e.g. GSK Pharma', icon: Icons.apartment_outlined),
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Quantity'),
            TextFormField(
              controller: _quantityController,
              decoration:
                  _pillDecoration(hint: '0', icon: Icons.inventory_2_outlined),
              keyboardType: TextInputType.number,
              validator: _numberValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Minimum Stock'),
            TextFormField(
              controller: _minimumStockController,
              decoration:
                  _pillDecoration(hint: '0', icon: Icons.warning_amber_rounded),
              keyboardType: TextInputType.number,
              validator: _numberValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Purchase Price (₵)'),
            TextFormField(
              controller: _purchasePriceController,
              decoration:
                  _pillDecoration(hint: '0.00', icon: Icons.attach_money),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: _numberValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Selling Price (₵)'),
            TextFormField(
              controller: _sellingPriceController,
              decoration:
                  _pillDecoration(hint: '0.00', icon: Icons.attach_money),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: _numberValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Expiry Date'),
            InkWell(
              onTap: _pickExpiryDate,
              child: InputDecorator(
                decoration: _pillDecoration(
                    hint: 'YYYY-MM-DD', icon: Icons.calendar_today_outlined),
                child: Text(
                  _expiryDate == null
                      ? ''
                      : '${_expiryDate!.year}-${_expiryDate!.month.toString().padLeft(2, '0')}-${_expiryDate!.day.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Storage Location'),
            TextFormField(
              controller: _locationController,
              decoration: _pillDecoration(
                  hint: 'e.g. Shelf A-1', icon: Icons.place_outlined),
            ),
            const SizedBox(height: AppConstants.spaceMD),

            _fieldLabel('Category'),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: _pillDecoration(
                  hint: 'Select category', icon: Icons.layers_outlined),
              items: InventoryService.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: AppConstants.spaceMD),

            TextFormField(
              controller: _descriptionController,
              decoration: _pillDecoration(
                  hint: 'Description (optional)', icon: Icons.notes_outlined),
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
                        : const Icon(Icons.save_outlined, size: 18),
                    label: Text(_isSaving ? 'Saving...' : 'Save Medicine'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spaceLG),
          ],
        ),
      ),
    );
  }
}
