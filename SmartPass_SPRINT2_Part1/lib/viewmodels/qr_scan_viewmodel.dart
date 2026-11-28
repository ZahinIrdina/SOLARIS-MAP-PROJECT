import 'package:material_ui/material_ui.dart';

class QrScanViewModel extends ChangeNotifier {
  bool _isScanning = false;
  String? _scanResult;

  bool get isScanning => _isScanning;
  String? get scanResult => _scanResult;

  // Simulates the camera detecting a QR code
  Future<void> simulateScan() async {
    _isScanning = true;
    _scanResult = null;
    notifyListeners();

    // Simulate a 2-second delay (like waiting for the camera to focus)
    await Future.delayed(const Duration(seconds: 2));

    // MOCK DATA: In the future, this is what the QR code will return (e.g., Matric Number)
    _scanResult = "A24CS0160"; 
    _isScanning = false;
    notifyListeners();
  }

  void reset() {
    _scanResult = null;
    _isScanning = false;
    notifyListeners();
  }
}