import 'package:material_ui/material_ui.dart';
import '../services/firestore_service.dart';

class ManualCheckInViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService.instance;

  bool _isLoading = false;
  String? _error;
  String? _successStatus; // 'success', 'limit_reached', or 'not_found'

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successStatus => _successStatus;

  Future<void> submitCheckIn({
    required String examId,
    required String matric,
    required String seat,
    required bool metalDetector,
    required int maxQuota,
  }) async {
    _isLoading = true;
    _error = null;
    _successStatus = null;
    notifyListeners();

    try {
      // 1. Find the student by Matric Number
      final studentData = await _firestoreService.getStudentByMatric(matric);

      if (studentData == null) {
        _successStatus = 'not_found';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 2. Extract real name and gender from database
      final realName = studentData['name'] ?? 'Unknown Name';
      // Assuming you saved gender during registration. If not, default to Female/Male.
      final realGender = studentData['gender'] ?? 'Female'; 

      // 3. Check quota
      final isFull = await _firestoreService.isQuotaFull(examId, realGender, maxQuota);
      
      if (isFull) {
        _successStatus = 'limit_reached';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 4. Save to database using REAL data
      await _firestoreService.logManualCheckIn(
        examId: examId,
        studentId: matric,
        studentName: realName, // Using real name
        seatNumber: seat,
        gender: realGender, // Using real gender
        metalDetectorChecked: metalDetector,
      );

      _successStatus = 'success';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetStatus() {
    _successStatus = null;
    _error = null;
    notifyListeners();
  }
}