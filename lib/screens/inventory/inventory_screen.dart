import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/theme.dart';
import '../../providers/inventory_provider.dart';
import '../../services/inventory_service.dart';
import '../../widgets/confirm_delete_dialog.dart';
import '../../widgets/medicine_card.dart';
import '../edit_medicine/edit_medicine_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<InventoryProvider>().loadMedicines();
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
      context.read<InventoryProvider>().setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<InventoryProvider>();
    final filtered = inventory.filteredMedicines;

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-medicine'),
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
                hintText: 'Search medicines...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          _debounce?.cancel();
                          context.read<InventoryProvider>().setSearchQuery('');
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spaceSM),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.radius),
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: inventory.selectedCategory == null,
                  onTap: () =>
                      context.read<InventoryProvider>().setCategoryFilter(null),
                ),
                const SizedBox(width: 8),
                for (final category in InventoryService.categories) ...[
                  _CategoryChip(
                    label: category,
                    selected: inventory.selectedCategory == category,
                    onTap: () => context
                        .read<InventoryProvider>()
                        .setCategoryFilter(category),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceSM),
          Expanded(
            child: Builder(
              builder: (context) {
                if (inventory.isLoading && inventory.medicines.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (inventory.medicines.isEmpty) {
                  return Center(
                    child: Text('No medicines in stock yet.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text('No medicines match your search.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => inventory.loadMedicines(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final medicine = filtered[index];
                      return MedicineCard(
                        medicine: medicine,
                        onTap: () {},
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    EditMedicineScreen(medicine: medicine)),
                          );
                        },
                        onDelete: () async {
                          final confirmed = await confirmDelete(
                              context: context, itemName: medicine.name);
                          if (!confirmed) return;
                          if (!context.mounted) return;

                          await context
                              .read<InventoryProvider>()
                              .removeMedicine(medicine.id);
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${medicine.name} deleted')),
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

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryGreen,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppTheme.black,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: selected ? AppTheme.primaryGreen : Colors.grey.shade300),
      ),
    );
  }
}
