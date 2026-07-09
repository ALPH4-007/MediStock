import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../providers/supplier_provider.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/supplier_card.dart';
import '../add_suppliers/add_suppliers_screen.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SupplierProvider>().loadSuppliers();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDelay, () {
      context.read<SupplierProvider>().setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final supplierProvider = context.watch<SupplierProvider>();
    final filtered = supplierProvider.filteredSuppliers;

    return Scaffold(
      appBar: AppBar(title: const Text('Suppliers')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addSupplier),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppTheme.radius, AppTheme.radius, AppTheme.radius, 0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search suppliers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          _debounce?.cancel();
                          context.read<SupplierProvider>().setSearchQuery('');
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spaceSM),
          Expanded(
            child: Builder(
              builder: (context) {
                if (supplierProvider.isLoading &&
                    supplierProvider.suppliers.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (supplierProvider.suppliers.isEmpty) {
                  return Center(
                    child: Text('No suppliers added yet.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text('No suppliers match your search.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => supplierProvider.loadSuppliers(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final supplier = filtered[index];
                      return SupplierCard(
                        supplier: supplier,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    AddSupplierScreen(supplier: supplier)),
                          );
                        },
                        onDelete: () async {
                          final confirmed = await confirmDelete(
                              context: context, itemName: supplier.name);
                          if (!confirmed) return;
                          if (!context.mounted) return;

                          await context
                              .read<SupplierProvider>()
                              .removeSupplier(supplier.id);
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${supplier.name} deleted')),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
