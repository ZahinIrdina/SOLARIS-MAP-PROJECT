import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../viewmodels/qr_scan_viewmodel.dart';

class QrScanView extends StatelessWidget {
  const QrScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QrScanViewModel>();
    const maroon = Color(0xFF990000);

    return Scaffold(
      backgroundColor: Colors.black, // Dark background is standard for cameras
      appBar: AppBar(
        backgroundColor: maroon,
        foregroundColor: Colors.white,
        title: const Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- CAMERA PREVIEW PLACEHOLDER ---
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: maroon, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: viewModel.isScanning
                  ? const Center(
                      child: CircularProgressIndicator(color: maroon),
                    )
                  : const Center(
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 100,
                        color: Colors.white54,
                      ),
                    ),
            ),
            const SizedBox(height: 40),
            
            // --- STATUS TEXT ---
            if (!viewModel.isScanning && viewModel.scanResult == null)
              const Text(
                'Align QR code within the frame',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            
            if (viewModel.isScanning)
              const Text(
                'Scanning...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

            // --- SUCCESS RESULT ---
            if (viewModel.scanResult != null) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 10),
              const Text(
                'Scan Successful!',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Matric No: ${viewModel.scanResult}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],

            const SizedBox(height: 40),

            // --- MOCK BUTTONS ---
            if (!viewModel.isScanning && viewModel.scanResult == null)
              ElevatedButton(
                onPressed: () => viewModel.simulateScan(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: maroon,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Simulate Camera Scan', style: TextStyle(color: Colors.white)),
              ),

            if (viewModel.scanResult != null)
              ElevatedButton(
                onPressed: () {
                  viewModel.reset();
                  Navigator.pop(context); // Go back to dashboard after success
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: maroon,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text('Return to Dashboard', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}