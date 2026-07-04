import 'package:flutter/material.dart';

class EditMedicineScreen extends StatelessWidget {
  const EditMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Medicine')),
      body: const Center(child: Text('Edit Medicine Screen')),
    );
  }
}
