import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../providers/inventory_provider.dart';

class ScanScreen extends StatefulWidget {
  /// When true, a successful scan pops this screen and returns the
  /// scanned barcode string to whoever pushed it (e.g. Add Medicine's
  /// barcode field). When false — the default, used as the bottom-nav
  /// Scan tab — a scan instead searches inventory for a matching medicine.
  final bool returnResult;

  const ScanScreen({super.key, this.returnResult = false});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _controller = MobileScannerController();

  // Guards against the same scan firing this callback repeatedly per
  // frame while the barcode stays in view of the camera.
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    _handled = true;

    if (widget.returnResult) {
      Navigator.pop(context, code);
      return;
    }

    _searchByBarcode(code);
  }

  void _searchByBarcode(String code) {
    final medicine = context.read<InventoryProvider>().findByBarcode(code);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(medicine == null ? 'Not Found' : medicine.name),
        content: Text(
          medicine == null
              ? 'No medicine in inventory matches barcode "$code".'
              : 'Category: ${medicine.category}\nQuantity in stock: ${medicine.quantity}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => _handled = false); // allow scanning again
            },
            child: const Text('Scan Again'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.returnResult ? 'Scan Barcode' : 'Scan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Toggle flash',
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Simple viewfinder frame — purely visual guidance for the user,
          // mobile_scanner scans the whole camera preview regardless.
          Container(
            width: 260,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryGreen, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          Positioned(
            bottom: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.returnResult
                    ? 'Point camera at the barcode'
                    : 'Scan a medicine to look it up',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}