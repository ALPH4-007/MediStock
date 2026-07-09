import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../providers/inventory_provider.dart';
import '../medicine_details/medicine_details_screen.dart';

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

    if (medicine != null) {
      // Match found — go straight to the full Medicine Details screen,
      // which is the actual business value of the scan.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicineDetailsScreen(medicine: medicine),
        ),
      ).then((_) {
        // Re-arm scanning once the user comes back from Details.
        setState(() => _handled = false);
      });
      return;
    }

    // No match — nothing to navigate to, so a short dialog is still right.
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Not Found'),
        content: Text('No medicine in inventory matches barcode "$code".'),
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

          // Corner-bracket viewfinder — four L-shaped corners instead of a
          // full border, purely visual guidance for the user (mobile_scanner
          // still scans the whole camera preview regardless of this frame).
          SizedBox(
            width: 260,
            height: 180,
            child: Stack(
              children: const [
                _ScannerCorner(alignment: Alignment.topLeft),
                _ScannerCorner(alignment: Alignment.topRight),
                _ScannerCorner(alignment: Alignment.bottomLeft),
                _ScannerCorner(alignment: Alignment.bottomRight),
              ],
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

/// One L-shaped corner bracket for the scan viewfinder. Four of these,
/// one per corner via [alignment], make up the full frame.
class _ScannerCorner extends StatelessWidget {
  final Alignment alignment;

  const _ScannerCorner({required this.alignment});

  @override
  Widget build(BuildContext context) {
    const double size = 28;
    const double thickness = 4;
    const color = AppTheme.primaryGreen;

    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? const BorderSide(color: color, width: thickness)
                : BorderSide.none,
            bottom: !isTop
                ? const BorderSide(color: color, width: thickness)
                : BorderSide.none,
            left: isLeft
                ? const BorderSide(color: color, width: thickness)
                : BorderSide.none,
            right: !isLeft
                ? const BorderSide(color: color, width: thickness)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
