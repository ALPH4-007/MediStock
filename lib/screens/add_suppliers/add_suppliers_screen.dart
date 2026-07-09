import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/theme.dart';
import '../../models/supplier.dart';
import '../../providers/supplier_provider.dart';
import '../../widgets/confirm_delete_dialog.dart';

/// Serves both Add and Edit. Pass an existing [supplier] to edit it;
/// leave it null to create a new one. The fields are identical either
/// way, so one form avoids duplicating the same layout/validation twice.
class AddSupplierScreen extends StatefulWidget {
  final Supplier? supplier;

  const AddSupplierScreen({super.key, this.supplier});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  bool _isSaving = false;

  bool get _isEditing => widget.supplier != null;

  @override
  void initState() {
    super.initState();
    final s = widget.supplier;

    _nameController = TextEditingController(text: s?.name ?? '');
    _contactPersonController =
        TextEditingController(text: s?.contactPerson ?? '');
    _phoneController = TextEditingController(text: s?.phone ?? '');
    _emailController = TextEditingController(text: s?.email ?? '');
    _addressController = TextEditingController(text: s?.address ?? '');
    _notesController = TextEditingController(text: s?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = context.read<SupplierProvider>();

      if (_isEditing) {
        final updated = widget.supplier!.copyWith(
          name: _nameController.text.trim(),
          contactPerson: _contactPersonController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
        await provider.updateSupplier(updated);
      } else {
        final supplier = Supplier(
          name: _nameController.text.trim(),
          contactPerson: _contactPersonController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          address: _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          createdAt: DateTime.now(),
        );
        await provider.addSupplier(supplier);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save supplier: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _handleDelete() async {
    final supplier = widget.supplier;
    if (supplier == null) return;

    final confirmed =
        await confirmDelete(context: context, itemName: supplier.name);
    if (!confirmed) return;
    if (!mounted) return;

    try {
      await context.read<SupplierProvider>().removeSupplier(supplier.id);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete: $error')),
      );
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Supplier' : 'Add Supplier'),
        actions: [
          if (_isEditing)
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
              decoration: const InputDecoration(labelText: 'Supplier Name'),
              validator: _requiredValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _contactPersonController,
              decoration: const InputDecoration(labelText: 'Contact Person'),
              validator: _requiredValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: _requiredValidator,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email (optional)'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _addressController,
              decoration:
                  const InputDecoration(labelText: 'Address (optional)'),
              maxLines: 2,
            ),
            const SizedBox(height: AppConstants.spaceMD),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
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
                  : Text(_isEditing ? 'Save Changes' : 'Save Supplier'),
            ),
          ],
        ),
      ),
    );
  }
}
